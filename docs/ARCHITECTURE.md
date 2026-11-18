# Architecture decisions

Decisions taken while building Sprint 0, with the reasoning, and every place
the code departs from the blueprint. Newest entries go at the bottom.

## 1. Modular monolith on NestJS 12, ESM

NestJS 12 ships as ES modules only, so the API is ESM throughout: NodeNext
module resolution, `.js` suffixes on relative imports, `import.meta.url`
instead of `__dirname`. Tests run on Vitest with SWC (for decorator metadata)
rather than Jest, which handles ESM poorly.

TypeScript is pinned to 6.x. TypeScript 7 (the native compiler) is out, but
typescript-eslint and `@nestjs/swagger` do not support it yet.

## 2. Drizzle with hand-checked SQL migrations

`drizzle-kit generate` writes SQL into `apps/api/drizzle/`; the files are
committed and reviewed like code. `src/database/migrate.ts` applies them and
then upserts reference data (talent categories). Production runs
`node dist/database/migrate.js` before starting a release.

UUIDv7 ids are generated in the application (`common/ids/uuidv7.ts`) so they
work on PostgreSQL 16 without extensions and sort by creation time.

## 3. Phone sign-in

- Numbers are parsed with libphonenumber's full metadata, normalised to E.164
  and must be a mobile line in a launch country (`SMS_ALLOWED_COUNTRIES`).
  Landlines and premium numbers are refused: they cannot receive a code and
  are a common route for SMS-pumping fraud.
- Codes are six digits from a CSPRNG, stored only as
  `HMAC-SHA256(OTP_SECRET, phone:code)` with a five-minute TTL.
- Limits: 60 s between sends to a number, 5 sends per number per hour,
  30 per IP per hour, 5 guesses per code (then the code is burnt).
- The SMS gateway is a port (`SmsProvider`). Only the console stub exists;
  production config refuses to start with it.

## 4. Sessions: short JWTs, rotating refresh tokens

Access tokens are HS256 JWTs valid for 15 minutes with issuer and audience
checked. Refresh tokens are opaque (`<row id>.<secret>`), stored as SHA-256
hashes, single use and grouped in a family per sign-in.

Presenting a spent refresh token revokes the whole family, since it means the
token leaked. A spent token is still honoured for 20 seconds
(`REFRESH_REUSE_LEEWAY_SECONDS`): on weak mobile connections the response to
a refresh is often lost and the app retries, and treating that retry as theft
would sign people out at random. The rotation runs in a transaction with
`SELECT … FOR UPDATE` and returns its outcome rather than throwing, so a
family revocation is committed.

## 5. Docker-free local development

Docker is the standard path (`docker compose up -d`). For machines without
it, `pnpm dev:db` starts a real PostgreSQL 16 from the `embedded-postgres`
package with the same credentials and port, and the API falls back to an
in-memory key-value store when `REDIS_URL` is unset (refused in production).
Tests use PGlite, PostgreSQL compiled to WebAssembly, in-process.

## 6. API contract

`@nestjs/swagger` produces `packages/api-contract/openapi.json`; operation ids
are the controller method names. From it:

- TypeScript: `openapi-typescript` types and an `openapi-fetch` client.
- Dart: `swagger_parser` generates retrofit clients and freezed models in the
  `talanta_api` package, with unknown enum values mapped to `$unknown` so an
  older app survives a newer server.

CI fails if `openapi.json` is out of date with the controllers.

## 7. Mobile

- Riverpod 3 without code generation, to keep the build fast and the code
  readable for new contributors.
- `go_router` redirects come from one pure function, `redirectFor`, driven by
  session state; the server's `onboardingStep` decides where people land.
- One Dio instance. A `QueuedInterceptor` attaches the token and refreshes
  once for a burst of 401s; a retry interceptor retries GETs on network
  errors and 5xx with backoff. Refresh and replay go through a separate bare
  Dio so a failing refresh can never recurse.
- Haptics are fire-and-forget: the UI never waits on them.
- Time-dependent UI reads `clock.now()` so tests control time.

## Deviations from the blueprint

| Blueprint                                    | Built                                                                                                       | Why                                                                                                              |
| -------------------------------------------- | ----------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| Flutter "latest stable" with latest packages | Flutter 3.41 (Dart 3.11); go_router 17, Riverpod 3.3, freezed 3, swagger_parser 1.46, very_good_analysis 10 | The newest releases of these packages need Dart 3.12/3.13. Upgrade together with Flutter.                        |
| Separate Dart and TS client generation       | Same, but the Dart client is `swagger_parser` (pure Dart) instead of openapi-generator                      | openapi-generator needs Java; swagger_parser output is idiomatic (freezed + retrofit).                           |
| Profile photo on the create-profile screen   | Picked and previewed on the device, not uploaded                                                            | Uploads belong with the Phase 1 media pipeline (signed uploads, resizing, moderation). The screen says so.       |
| —                                            | Light theme values, plus `surfaceRaised`, `outline`, `danger` and `onPrimary` roles                         | Needed for a complete theme. Provisional until the brand designer signs off.                                     |
| Clash Display                                | Bundled from Fontshare under the ITF Free Font License                                                      | Licence permits embedding in apps and self-hosting on the web. Keep `ClashDisplay-LICENSE.txt` next to the font. |

## 8. Age gate

The first profile save needs a date of birth, sent as `YYYY-MM-DD`. Under
`MIN_SIGNUP_AGE` (13) the request fails with `age_below_minimum` and nothing
is stored. Once set, the date cannot be changed through the API, so a minor
cannot opt out of protections later; changes go through support. `/v1/me`
exposes `isMinor` (under 18) for the safety features in Phase 1, such as
default-private accounts and limits on direct messages from adults.

## 9. Testing levels

- API: Vitest through HTTP against PGlite, with a fake SMS gateway and a
  clock the test moves.
- Mobile widgets: `flutter test` over an in-memory fake of the API.
- End to end: `integration_test/` runs the real app on a device or emulator
  against a running API. Not in CI (needs an emulator); run it before every
  release. See [RELEASING.md](RELEASING.md).

## 10. Languages and launch markets

Cameroon is the first market and the default country, followed by Nigeria,
Kenya, Ghana and South Africa (`SMS_ALLOWED_COUNTRIES`). The app ships in
English and French and follows the phone's language. Talent category names
are translated in the app by their stable `slug`, so the server stays
language-neutral; an unknown slug falls back to the server's name. The API
returns `displayPhone`, the number grouped the way it is written locally.

## 11. Product core: Open Calls

The problem Talanta solves first: in Cameroon, paid creative work is found
through WhatsApp groups and personal contacts. Organisers cannot find
reliable talent, talent cannot find the work, and fake castings prey on
both. Open Calls make that market visible and safer.

- **Open Calls** (`opportunities` module, owns `opportunities` and
  `applications`): organisers post briefs; adults with a profile apply with
  a message and a portfolio piece; posters shortlist, decline or hire.
- **Portfolio** (`portfolio`): links to work on YouTube, TikTok, Audiomack
  and the rest. Talanta indexes work where it already lives instead of
  hosting video, which keeps costs near zero until video hosting is worth it.
- **Discover and follow** (`creators`, `social`): search by name, talent and
  city; a stream of new work from people you follow.
- **Activity** (`notifications` stores references; `activity` turns them
  into text-ready items): new applicants, decisions, new followers.

Why people return: new paid calls every week, the status of their
applications, and new work from creators they follow.

## 12. Revenue: native ads

- **Featured calls**: organisers pay to pin a call in the Featured row for a
  number of days (`featured_until`, set by an admin after payment; it
  expires on its own).
- **Sponsored cards** (`promotions`): one labelled card after the third call
  in the feed, linking to a sponsor page or to a screen in the app.

Both are relevant to the reader and always labelled. Payment collection
(MTN MoMo, Orange Money) comes next; until then, featuring is done by an
admin after payment is received.

## 13. Security

See [SECURITY.md](SECURITY.md) for the threat model, what is tested, and
the launch checklist.

## Before launch

- Accounts and decisions listed in [RELEASING.md](RELEASING.md): SMS
  provider, hosting, domain, legal documents, logo, Android app id.
- Android SMS Retriever, so codes fill in without a tap. It needs the
  release signing key to compute the app hash, so it comes after the upload
  key exists.
- Send the sign-in SMS in the person's language (it is English today).
- Confirm SMS delivery to Cameroon with the chosen provider before launch.
