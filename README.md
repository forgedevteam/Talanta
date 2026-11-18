# Talanta

Africa's home for talent, culture and community: short videos, monthly
challenges and real opportunities for singers, dancers, actors, comedians,
makers and the people who love what they do.

This repository holds the whole product: the API, the mobile app, the web app
and the packages they share.

## What works today

- **Open Calls**: organisers post paid gigs and castings; talent applies in a
  minute and follows each application from sent to hired
- **Portfolios** linking to work on YouTube, TikTok, Audiomack and more
- **Discover** creators by talent and city; follow them and see their new work
- **Activity**: new applicants, decisions and followers
- Featured calls and labelled sponsored cards (the revenue model)
- Reporting, an admin review queue, account deletion
- Phone sign-in with one-time codes, rotating sessions and sign-out
- Onboarding: pick your talents, create your profile, date of birth with a minimum age of 13
- Mobile app for Android and iOS covering splash, phone, code, talents,
  profile and a home placeholder
- Web landing page on the same design system

## Getting started

You need Node 24 (LTS), pnpm 12, Flutter 3.41 and either Docker or nothing
else (see below).

```bash
pnpm install
dart pub get

# Database: either
docker compose up -d          # PostgreSQL 16 + Redis 7
# or, without Docker
pnpm dev:db                   # PostgreSQL 16 from node_modules, keep it running

cp apps/api/.env.example apps/api/.env   # then fill in the two secrets
pnpm --filter @talanta/api db:migrate
pnpm --filter @talanta/api db:seed-demo   # optional: demo creators, calls and test accounts
pnpm dev:api                  # http://localhost:3000, API docs at /docs
```

Run the app against your local API:

```bash
cd apps/mobile
adb reverse tcp:3000 tcp:3000   # phone over USB
flutter run
# emulator: flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000
```

Sign in with any Cameroonian, Nigerian, Kenyan, Ghanaian or South African mobile number.
The code is printed in the API log, or is `OTP_DEV_FIXED_CODE` if you set it.

## Tests

```bash
pnpm --filter @talanta/api test   # API, against an in-process Postgres
cd apps/mobile && flutter test    # widgets and unit tests
pnpm lint && pnpm typecheck
```

## Documentation

- [CLAUDE.md](CLAUDE.md): layout, commands, rules and colour tokens
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md): decisions and why
- [docs/BLUEPRINT.md](docs/BLUEPRINT.md): the product blueprint
- [docs/RELEASING.md](docs/RELEASING.md): accounts you need, signing and building the app
- [docs/SECURITY.md](docs/SECURITY.md): threat model, protections and launch checklist
