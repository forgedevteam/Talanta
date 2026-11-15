# Talanta — Architecture & Brand Blueprint

_Your gift is gold._ Africa's home for talent, culture and community.

This document is the source of truth for product scope, architecture and brand.
Decisions that refine or deviate from it are recorded in [ARCHITECTURE.md](ARCHITECTURE.md).

## 1. Brand and Visual Identity

**Name meaning:** Talanta is Swahili for talent. It comes from the Greek _talanton_, a unit of
gold. The message is that your gift is your gold.

**Design principles (Gen Z first):** dark mode by default, full-screen video, bold type,
rounded shapes, playful micro-animations, and very little clutter.

| Role                      | Colour                     | Hex       |
| ------------------------- | -------------------------- | --------- |
| Primary (Sunset Orange)   | Buttons, highlights, brand | `#FF6B2C` |
| Secondary (Deep Violet)   | Gradients, accents, tabs   | `#6C2BD9` |
| Gold (Sponsor / Verified) | Badges, premium, offers    | `#F5B700` |
| Background (Night)        | App background             | `#0E0B14` |
| Surface                   | Cards, sheets              | `#1A1622` |
| Text Primary              | Main text                  | `#F7F5FA` |
| Text Muted                | Secondary text             | `#A59FB3` |
| Success                   | Confirmations              | `#2ECC71` |

**Signature gradient:** Sunset Orange to Deep Violet, used for the logo, splash screen and
the record button.

**Typography:** a bold, rounded display font for headings (for example Clash Display or
Satoshi) and Inter for body text.

**Light mode:** offered, but secondary.

## 2. Product Scope (Core Features)

1. **Accounts:** one sign-up for everyone, using phone number + OTP (essential in Africa)
   plus Google and Apple sign-in.
2. **Profiles:** talent categories (music, acting, crafts, art, speaking, dance, comedy, fashion
   and more), a portfolio and a location.
3. **Home feed:** a Facebook-style scrolling feed of posts, photos and videos.
4. **Reels:** TikTok-style full-screen vertical video.
5. **Communities / Groups:** public or private, with admins and moderators.
6. **Chat:** 1-to-1 and group messaging, with media and read receipts.
7. **Verified Sponsors:** an identity-verified upgrade that unlocks talent search, shortlists
   and formal sponsorship offers.
8. **Notifications:** push, in-app and SMS fallback.
9. **Search and Discover:** by talent, location, hashtag and community.
10. **Safety:** reporting, moderation queue, blocking, and age protections for minors.

## 3. High-Level Architecture

**Key decision:** the app and the website share **one backend, one set of APIs and one
database layer**. Only the front-ends differ.

**Front-ends**

- Mobile: Flutter (Dart) for Android and iOS. Android-first, because it dominates in
  Africa. Flutter's own rendering engine gives smooth 60 fps reels and rich animation on
  low-end phones.
- Web: Next.js, chosen over Flutter Web because public profiles, Talent Passports and
  posts must load fast, rank on Google and show rich link previews when shared. The
  app and the website use one API contract (OpenAPI), with clients generated for Dart
  and TypeScript.

**Edge layer**

- Cloudflare for CDN, DDoS protection, WAF and edge caching close to users in Lagos,
  Nairobi, Johannesburg and Accra.

**API layer**

- An API Gateway handling auth checks, rate limiting and routing.
- Backend in TypeScript (NestJS), built as a **modular monolith first** and split into
  services as load demands.

**Core modules (future microservices)**

- Auth and Identity
- Users and Profiles
- Posts and Media
- Feed and Recommendations
- Reels
- Communities
- Chat (WebSocket service)
- Notifications
- Search
- Sponsorship and Payments
- Moderation

**Async backbone**

- An event bus (start with Redis Streams or AWS SQS, then move to Kafka at scale) for
  likes, views, follows and uploads. These events feed the algorithm, notifications and
  analytics.

```
Mobile app (Flutter)            Website (Next.js)
        │                              │
        └──────────────┬───────────────┘
                       ▼
   Cloudflare edge · CDN, firewall, DDoS protection, caching
                       ▼
       API gateway · auth checks, rate limiting, routing
                       ▼
   Talanta backend · modular monolith (NestJS)
     Auth and identity · Users and profiles · Posts and media
     Feed and algorithm · Reels · Communities · Chat (WebSockets)
     Notifications · Search · Sponsorship and payments · Moderation
                       ▼
   Event bus · likes, views, follows, uploads (Redis Streams, later Kafka)
                       ▼
   Video transcoding (HLS) · Feed ranking · Notifications and push
                       ▼
   Data layer: PostgreSQL · Redis · Cloudflare R2 · Search index · Analytics
```

Both front-ends go through the same edge, gateway and backend. The backend reads and
writes the data layer directly, while slow work such as video transcoding and feed ranking
runs through the event bus.

## 4. Data Layer

| Data                                        | Store                                                    | Why                                       |
| ------------------------------------------- | -------------------------------------------------------- | ----------------------------------------- |
| Users, profiles, posts, groups, sponsorships | PostgreSQL (managed, with read replicas)                 | Relational, reliable, strong consistency  |
| Cache, sessions, feed timelines, counters   | Redis                                                    | Very fast reads for feeds and like counts |
| Chat messages                               | PostgreSQL at first, then ScyllaDB or Cassandra at scale | Massive write volume                      |
| Search                                      | OpenSearch or Meilisearch                                | Talent and hashtag search                 |
| Images and video                            | Object storage (S3 or Cloudflare R2) + CDN               | Cheap, durable, global delivery           |
| Analytics / events                          | ClickHouse or BigQuery                                   | Algorithm training and dashboards         |

## 5. Video Pipeline (the most expensive part)

1. The app compresses video on the device before upload, saving users' data.
2. Uploads go directly to object storage through signed URLs, bypassing the API servers.
3. A transcoding worker (or a managed service such as Mux or Cloudflare Stream)
   creates HLS streams at 240p, 480p, 720p and 1080p.
4. Adaptive bitrate playback gives users on slow networks a lower quality automatically.
5. A **Data Saver mode** defaults to low quality and stops autoplay on mobile data.
6. Thumbnails and preview clips are generated automatically.

## 6. The Talanta Algorithm (v1)

**Stage 1 — Candidate generation:** pull roughly 500 possible posts from accounts you
follow, your communities, your preferred talent categories, local trending content and
similar creators.

**Stage 2 — Scoring.** Each post gets a score from weighted signals:

- Watch completion and rewatches (strongest)
- Shares and saves
- Comments
- Likes
- Follow-after-view
- Negative signals: skips under 2 seconds, "not interested", reports

**Stage 3 — Adjustments:**

- Freshness decay, so new posts rank higher
- Diversity, so the feed isn't the same creator or category repeatedly
- **Rising Talent boost:** every new creator's video is shown to a small test audience, and
  good performance widens the audience. This is core to the mission of being discovered.

**Phase 2:** replace hand-tuned weights with a machine-learning ranking model trained on
the event data.

## 7. Scaling to 10 Million Users

**Assumptions:** 10M registered users, about 2–3M daily active, peaks of roughly 100–200k
concurrent.

- Stateless API servers in auto-scaling containers (Kubernetes or AWS ECS).
- PostgreSQL with read replicas, connection pooling (PgBouncer), and later sharding by user ID.
- Precomputed feeds stored in Redis, with a hybrid push/pull model for popular creators.
- Chat on dedicated WebSocket nodes using Redis pub/sub.
- Most bandwidth served from the CDN, not our servers.
- Primary cloud region: AWS Cape Town (af-south-1), with Cloudflare edge across Africa.
- Observability: Grafana, Prometheus, Sentry and uptime alerts from day one.

## 8. Africa-Specific Engineering

- Phone-number sign-up with SMS OTP (Termii or Africa's Talking).
- Payments: Paystack, Flutterwave and M-Pesa for sponsorships and tips.
- Runs smoothly on low-end Android phones with 2–3 GB of RAM.
- Offline-friendly: cached feed, queued uploads and retry on weak networks.
- Small app download size (target under 40 MB).

## 9. Build Plan

A solid MVP takes about **12–14 weeks**, and a full launch about **5–6 months**. Testing,
app store review, design decisions and real-device QA still take human time.

| Phase                   | Weeks | What gets built                                                                              |
| ----------------------- | ----- | -------------------------------------------------------------------------------------------- |
| 0. Foundations          | 1–2   | Monorepo, CI/CD, design system in Talanta colours, database schema, auth with phone OTP      |
| 1. Core social          | 3–5   | Profiles, talent categories, posts, photo upload, follows, likes, comments, home feed v1     |
| 2. Video and Reels      | 6–8   | Upload pipeline, HLS transcoding, reels player, data-saver mode                              |
| 3. Communities and Chat | 9–10  | Groups, admins, real-time 1-to-1 and group chat, push notifications                          |
| 4. Sponsors and Safety  | 11–12 | Sponsor verification, talent search, offers, reporting, moderation tools                     |
| 5. Beta                 | 13–14 | Closed beta with about 500 creators, bug fixing, performance tuning                          |
| 6. Web + Launch         | 15–24 | Next.js website, algorithm v1 tuning, payments, public launch                                |

**Working rules:**

- Build one module at a time, with tests written alongside each feature.
- Review every pull request, especially auth, payments and security code.
- Use a staging environment and never deploy straight to production.

## 10. Hosting and Running Costs (approximate)

All figures are rough monthly estimates in US dollars and will vary with usage. Video
storage and delivery are the biggest cost drivers.

| Stage        | Users     | Monthly cost (USD) | Main costs                                            |
| ------------ | --------- | ------------------ | ----------------------------------------------------- |
| MVP / Beta   | Under 10k | $150–$500          | Small servers, managed Postgres, Cloudflare, SMS OTP  |
| Early growth | 100k      | $2,000–$6,000      | Video transcoding and CDN, database replicas          |
| Scale        | 1M        | $15,000–$40,000    | Video bandwidth, chat servers, search cluster         |
| Target       | 10M       | $100,000–$300,000  | Multi-node clusters, Kafka, ML ranking, 24/7 ops      |

**One-off and fixed costs:**

- Apple Developer account: $99 per year
- Google Play account: $25 one time
- Domain (for example talanta.app or talanta.africa): $20–$100 per year
- Company registration, trademark search for "Talanta" and legal (terms, privacy policy,
  child safety): budget $1,500–$5,000

**Cost-saving levers:** Cloudflare R2 (no bandwidth fees), client-side video compression,
sensible upload limits, and only transcoding videos that get views beyond the first 240p
version.

## 11. Launch and Publicity Plan

**Goal:** 50,000 users in the first 90 days, starting with 2–3 cities (for example Lagos, Nairobi
and Accra).

1. **Founding Creators programme:** hand-pick 200–500 talented creators before launch,
   give them a gold "Founding Talent" badge and early features.
2. **Talanta Challenges:** weekly themed challenges (best street performance, best
   handmade piece) with cash or sponsor prizes.
3. **Campus ambassadors:** students at major universities who recruit and host local showcases.
4. **Influencer partnerships:** micro-influencers on TikTok and Instagram who post "found
   on Talanta" content.
5. **Live events:** street showcases filmed and posted on the app, building real-world buzz.
6. **Sponsor partnerships:** sign 5–10 brands, record labels, NGOs or creative hubs as
   launch sponsors to prove the discovery promise.

**Marketing budget (approximate):** $5,000–$20,000 for the first 3 months covers prizes,
ambassadors, influencer posts and events.

## 12. What Makes Talanta Different (Features the Big Platforms Miss)

Facebook, TikTok and Instagram reward virality, not discovery, and almost none of their
money reaches African talent. These features turn Talanta from a social app into a launchpad.

1. **Open Calls (auditions and briefs):** sponsors, labels, brands and NGOs post a brief,
   such as "We need a jingle singer in Accra" or "Looking for 10 tailors for a fashion week".
   Talent applies with a video in one tap. Sponsors get a ranked shortlist.
2. **Fan Backing (micro-patronage with mobile money):** fans back a talent with as little as
   $0.50 through M-Pesa, Paystack or Flutterwave. Sponsors can _match_ fan backing,
   which shows them real community demand before they invest.
3. **Talent Passport:** a verified, living CV for every creator, covering skills, endorsements
   from other creators, challenge wins, views and audience growth. Sponsors trust the
   data, and creators can share it as a link anywhere.
4. **Collab Finder:** "looking for" matching, such as a singer finding a producer, a tailor
   finding a model, or a writer finding actors. Matching is by skill, city and style.
5. **Fair Discovery guarantee:** every new creator's first posts are guaranteed a test
   audience, and creators see _why_ a post was shown or not. Transparency is a selling point.
6. **Local languages and auto-captions:** the app is available in English, French, Swahili,
   Pidgin, Yoruba, Hausa, Amharic and Zulu, with auto-captions and translation on videos
   so a Nairobi singer can reach a Lagos fan.
7. **Sponsor Impact Dashboard:** sponsors see the reach, engagement and growth of the
   talent they backed. This proves return on investment and keeps them spending.
8. **Mentorship Rooms:** paid or free live audio and video sessions where established
   artists coach rising talent. Talanta takes a small fee.
9. **Ultra-low-data mode:** the app works well on 2G/3G with text-first feeds, tap-to-load
   video and offline downloads. This is a true edge in Africa.

**Revenue model this unlocks:** a 5–10% fee on backing and sponsorship deals, paid sponsor
subscriptions (search, Open Calls, dashboards), promoted posts, and mentorship session fees.

## 13. Database Design (Core Schema v1)

PostgreSQL is the main database. All IDs are UUIDv7 (time-sortable). Every table has
`created_at` and `updated_at`. Counters (likes, views) live in Redis and are flushed to
Postgres in batches.

**Identity and profiles**

| Table             | Key columns                                                                           | Notes                           |
| ----------------- | ------------------------------------------------------------------------------------- | ------------------------------- |
| users             | id, phone, email, password_hash, status, role, date_of_birth, country, language       | role = member / sponsor / admin |
| profiles          | user_id, username, display_name, bio, avatar_url, city, is_verified                   | One per user                    |
| talent_categories | id, name, slug, icon                                                                  | Music, acting, crafts, art and more |
| user_talents      | user_id, category_id, level, is_primary                                               | Many-to-many                    |
| sponsor_profiles  | user_id, org_name, org_type, verification_status, kyc_ref                             | Verified sponsors only          |
| follows           | follower_id, followee_id                                                              | Composite primary key           |
| blocks            | blocker_id, blocked_id                                                                | Safety                          |

**Content**

| Table                    | Key columns                                                                    | Notes                                              |
| ------------------------ | ------------------------------------------------------------------------------ | -------------------------------------------------- |
| posts                    | id, author_id, type, caption, visibility, community_id, status                 | type = text / photo / video / reel                 |
| media                    | id, post_id, kind, storage_key, hls_url, duration, width, height, processing_status | One post can have several media items         |
| hashtags / post_hashtags | id, tag / post_id, hashtag_id                                                  | Discovery                                          |
| comments                 | id, post_id, author_id, parent_id, body                                        | parent_id gives threaded replies                   |
| reactions                | user_id, post_id, type                                                         | Composite key, so one reaction per user per post   |
| saves                    | user_id, post_id                                                               | Bookmarks                                          |

**Communities and chat**

| Table                | Key columns                                                    | Notes                                                 |
| -------------------- | -------------------------------------------------------------- | ----------------------------------------------------- |
| communities          | id, name, slug, description, privacy, owner_id, category_id    | Public or private                                     |
| community_members    | community_id, user_id, role, joined_at                         | role = owner / admin / member                         |
| conversations        | id, type, title                                                | Direct or group                                       |
| conversation_members | conversation_id, user_id, last_read_message_id                 | Read receipts                                         |
| messages             | id, conversation_id, sender_id, body, media_id, created_at     | Moves to ScyllaDB at scale, partitioned by conversation |

**Talent economy**

| Table                  | Key columns                                                                      | Notes                            |
| ---------------------- | -------------------------------------------------------------------------------- | -------------------------------- |
| open_calls             | id, sponsor_id, title, brief, category_id, location, budget, deadline, status    | Auditions and briefs             |
| applications           | id, open_call_id, talent_id, post_id, status                                     | Video application                |
| sponsorship_offers     | id, sponsor_id, talent_id, amount, currency, terms, status                       | Offer, accepted, paid, completed |
| backings               | id, backer_id, talent_id, amount, currency, provider, provider_ref, status       | Fan micro-patronage              |
| wallets / transactions | user_id, balance / id, wallet_id, type, amount, status                           | Double-entry ledger for money    |
| endorsements           | from_user_id, to_user_id, category_id, note                                      | Talent Passport                  |
| collab_requests        | id, author_id, looking_for_category_id, city, description, status                | Collab Finder                    |

**Safety and system**

| Table              | Key columns                                                  | Notes                                         |
| ------------------ | ------------------------------------------------------------ | --------------------------------------------- |
| reports            | id, reporter_id, target_type, target_id, reason, status      | Moderation queue                              |
| notifications      | id, user_id, type, payload, read_at                          | Partitioned by month                          |
| interaction_events | user_id, post_id, event_type, watch_ms, created_at           | Streams to ClickHouse to train the algorithm  |

**Key indexes:** posts(author_id, created_at), posts(community_id, created_at),
follows(followee_id), comments(post_id, created_at), messages(conversation_id,
created_at), and open_calls(category_id, status, deadline).

**Scaling path:** shard the large tables (posts, comments, reactions, messages,
notifications) by user ID or conversation ID once Postgres passes about 2–3 TB or write
load demands it.

**Money safety:** all payments use idempotency keys, a double-entry ledger, provider
webhooks verified by signature, and escrow for sponsorship offers until the work is delivered.

**Child safety:** users under 18 get private-by-default accounts, no direct messages from
unknown adults, and sponsor offers to minors require guardian consent.

## 14. Cost Minimisation Strategy

The rule is to launch lean, pay only for what users actually use, and upgrade a component
only when real load forces it. Following this, the MVP can run for roughly **$50–$200 per
month** (approximate).

**1. Lean MVP stack (replaces the heavier stack until about 100k users)**

| Need               | Lean choice                                                  | Upgrade later to                            |
| ------------------ | ------------------------------------------------------------ | ------------------------------------------- |
| Backend hosting    | One modular monolith on Fly.io, Railway or a Hetzner VPS     | Kubernetes / ECS cluster                    |
| Database           | Managed Postgres (Supabase or Neon)                          | Aurora / self-managed cluster with replicas |
| Cache and queues   | One small Redis instance (Upstash pay-per-use)               | Redis cluster + Kafka                       |
| Search             | Postgres full-text search                                    | Meilisearch / OpenSearch                    |
| Chat storage       | Postgres                                                     | ScyllaDB                                    |
| Algorithm          | SQL scoring queries + Redis                                  | ML ranking service                          |
| Analytics          | PostHog free tier                                            | ClickHouse                                  |
| Monitoring         | Sentry + Grafana Cloud free tiers                            | Paid tiers                                  |
| Mobile builds      | Codemagic or GitHub Actions free tier                        | Paid tier                                   |
| Push notifications | Firebase Cloud Messaging (free)                              | Same                                        |

**2. Video costs (the biggest risk)**

- Store media on Cloudflare R2, which charges no bandwidth (egress) fees.
- Compress video on the phone before upload.
- Cap MVP videos at 3 minutes and 720p.
- Create only two versions (240p and 720p) at upload, and generate more only once a
  video becomes popular.
- Delete original uploads after transcoding, and move old, rarely watched videos to cheaper storage.
- Never autoplay on mobile data by default.

**3. Sign-up and messaging costs**

- Make Google sign-in, Apple sign-in and WhatsApp OTP the defaults, and use SMS only
  as a fallback, since SMS is a large per-user cost.
- Use African SMS providers (Termii, Africa's Talking) rather than global ones for better local rates.

**4. Free credits for startups.** Apply early to cloud startup programmes, which can cover
most of the first year's hosting: AWS Activate, Google for Startups Cloud Program (has
Africa-focused tracks), Microsoft for Startups Founders Hub, Cloudflare for Startups.
Credit amounts and eligibility change, so confirm the current terms when applying.

**5. Engineering habits that save money**

- Cache aggressively at Cloudflare's edge (profiles, thumbnails, public posts).
- Paginate everything and load images lazily.
- Set cloud budget alerts from day one.
- Review the cloud bill weekly and tag every resource by feature.

**6. Revenue to offset costs early.** Turn on sponsor subscriptions, Open Call fees and the
backing fee from launch, so running costs are partly covered as usage grows.

## 15. Design Direction: Crafted, Not Generic

Talanta must look like a design studio made it. Its identity comes from African craft and
street culture, not from a template.

**Avoid:**

- Purple-blue gradients everywhere. Keep the orange-to-violet gradient for the logo and
  record button only.
- Centred hero + three feature cards + emoji icons.
- Default component-library styling (stock shadcn or Material look), and identical rounded
  cards on every screen.
- Stock illustrations of faceless people and filler copy like "Unlock your potential".

**Do instead:**

- **Pattern language:** a subtle custom texture system inspired by Adinkra symbols, kente
  weave and mudcloth lines, used in headers, empty states, badges and loading screens.
  Commission an African illustrator or pattern designer for it.
- **Real faces:** real creators' photos and video stills everywhere, never stock imagery.
- **Editorial typography:** big, confident display headings (Clash Display or a commissioned
  African-inspired display face), tight spacing, mixed sizes.
- **Custom icon set:** about 40 icons drawn in one consistent style, with rounded ends and a
  slight hand-made quality.
- **Motion with meaning:** a gold shimmer when someone is backed, a drum-beat haptic on
  the first like, and a smooth reel swipe at 60 fps on low-end phones.
- **Voice:** warm, proud and playful, with a little Pidgin, Swahili or Sheng in microcopy. For
  example, "Show them what you've got" or "Your gift is gold".
- **Hire a human designer:** one strong African product designer for 4–6 weeks to own
  Figma, the logo and the pattern system.

## 16. Engineering Standards

- Consistent code style: `very_good_analysis` lints in the Flutter app; ESLint, Prettier and
  strict TypeScript on the backend and web, so the codebase reads as one team's work.
- Review and rewrite comments, README text and copy in the team's own voice before release.
- Strict typing on both sides: no `dynamic`, no `any`.
- No lorem ipsum; write real, warm, short copy.
- Conventional commit messages, one commit per working step.

## 17. Sprint 0 Scope

A running monorepo with the design tokens, the database and the first onboarding screens.

- `apps/mobile`: Flutter (latest stable), feature-first folders, Riverpod, go_router, Dio with
  interceptors for tokens and retries, freezed + json_serializable, flutter_secure_storage.
- `apps/api`: NestJS modular monolith, Drizzle ORM with migrations, PostgreSQL 16, Redis 7.
- `apps/web`: Next.js (App Router, TypeScript), scaffold only for now.
- `packages/design-tokens`: one `tokens.json` that generates a Dart theme file and a
  CSS/Tailwind theme.
- `packages/api-contract`: OpenAPI spec generated from NestJS, with a generated Dart client
  for the app and a TypeScript client for the web.
- pnpm workspaces for the JS side and Melos for the Dart side.

**Design tokens (dark mode default):** primary `#FF6B2C`, secondary `#6C2BD9`, gold `#F5B700`,
background `#0E0B14`, surface `#1A1622`, text `#F7F5FA`, muted `#A59FB3`, success `#2ECC71`,
radius 12/20, spacing scale of 4. Custom `ThemeData` and our own widget library (buttons,
inputs, chips, cards) — no default Material look. Purposeful motion: smooth page
transitions, subtle haptics, no gimmicks.

**First tables:** users, profiles, talent_categories, user_talents, follows.

**Auth:** phone number + OTP with a pluggable SMS provider interface (stub provider for
local dev), Google sign-in planned in the interface, JWT access tokens + rotating refresh
tokens, rate limiting on OTP requests.

**Flutter screens:**

1. Splash with a text-based Talanta wordmark placeholder (the real logo comes later)
2. Phone number entry with country picker (Nigeria, Kenya, Ghana, South Africa first)
3. OTP entry with auto-fill on Android
4. Pick your talents (multi-select grid of categories)
5. Create profile (name, username, photo, city)

**Tests:** the auth module (API) and widget tests for the onboarding screens.

**Founder checklist:**

- [ ] Create the GitHub repository (private)
- [ ] Get Postgres and Redis running with docker-compose
- [ ] Run the Flutter app on an Android phone with `flutter run`
- [ ] Complete a fake OTP login end to end
- [ ] Secure the domain names (talanta.app, talanta.africa or similar) and the social handles
- [ ] Run a trademark search on "Talanta" in the target countries
