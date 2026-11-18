# Talanta — working guide

Talanta is a social platform for African talent and culture. This file is the
short version of how the code is organised and the rules it follows. The
product blueprint is in [docs/BLUEPRINT.md](docs/BLUEPRINT.md); decisions and
deviations from it are in [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Layout

| Path                     | What                                    | Stack                                            |
| ------------------------ | --------------------------------------- | ------------------------------------------------ |
| `apps/api`               | Backend, modular monolith               | NestJS 12 (ESM), Drizzle, PostgreSQL 16, Redis 7 |
| `apps/mobile`            | Android and iOS app                     | Flutter 3.41, Riverpod 3, go_router, Dio         |
| `apps/web`               | Web app (landing page for now)          | Next.js 16 App Router, Tailwind v4               |
| `packages/design-tokens` | `tokens.json` → Dart, CSS, Tailwind     | Node script                                      |
| `packages/api-contract`  | `openapi.json` → TS client, Dart client | openapi-typescript, swagger_parser               |

pnpm workspaces for JavaScript, a Dart pub workspace (root `pubspec.yaml`,
Melos scripts) for Dart.

## Commands

```bash
pnpm install && dart pub get         # once
pnpm dev:db                          # PostgreSQL 16 without Docker (or: docker compose up -d)
pnpm --filter @talanta/api db:migrate
pnpm dev:api                         # http://localhost:3000, docs at /docs
pnpm dev:web                         # http://localhost:3001
pnpm --filter @talanta/api test      # Vitest, in-process Postgres
pnpm lint && pnpm typecheck
pnpm tokens                          # after editing tokens.json
pnpm contract                        # after changing an endpoint or DTO
cd apps/mobile && flutter test && flutter analyze
cd apps/mobile && flutter test integration_test --dart-define=OTP_CODE=<code>  # real app vs running API
# Screenshot every onboarding screen into apps/mobile/build/screenshots (add --dart-define=LOCALE=fr for French)
cd apps/mobile && flutter drive --driver=test_driver/integration_test.dart --target=integration_test/walkthrough_test.dart --dart-define=OTP_CODE=<code>
```

The local OTP code is whatever `OTP_DEV_FIXED_CODE` is in `apps/api/.env`;
codes are printed to the API log by the console SMS provider.

## Architecture rules

- **API modules own their tables.** `auth` owns `refresh_tokens`, `users` owns
  `users`, `profiles` owns `profiles`, `talents` owns `talent_categories` and
  `user_talents`. Other modules call the owner's exported service, never its
  table.
- **Routes are private by default.** The access-token guard is global; mark
  public routes with `@Public()`.
- **One error shape.** Throw `AppError(status, code, message)`. Codes live in
  `ERROR_CODES` and are part of the public contract: clients switch on them.
  Add, never rename.
- **Ports at the edges.** SMS, key-value store, clock and identity
  providers are interfaces with swappable adapters. Tests use fakes.
- **The contract is generated.** Change a controller or DTO, run
  `pnpm contract`, commit `openapi.json` and both clients. Never hand-edit
  generated files.
- **Mobile follows the server.** `GET /v1/me` returns `onboardingStep`; the
  router redirects from session state. Screens move forward explicitly after
  a successful save.
- **Feature-first Flutter.** `features/<name>/{domain,application,presentation}`;
  shared pieces in `core/`. Use the widget library in `core/widgets`, not
  raw Material widgets.

## Coding standards

- Strict typing both sides: no `any` in TypeScript, no `dynamic` in Dart.
- Every table has a UUIDv7 `id` (or a composite key), `created_at` and
  `updated_at`.
- New endpoints come with tests that go through HTTP. New screens come with
  widget tests.
- Copy is short, warm and specific. No placeholder text. All user-facing
  strings go through `lib/l10n/app_en.arb`.
- Conventional commits (`feat(api): …`, `fix(mobile): …`).
- Comments explain why, not what.

## Colour tokens

Dark is the default theme. Source of truth: `packages/design-tokens/tokens.json`.

| Role                    | Hex       |
| ----------------------- | --------- |
| Primary (Sunset Orange) | `#FF6B2C` |
| Secondary (Deep Violet) | `#6C2BD9` |
| Gold                    | `#F5B700` |
| Background              | `#0E0B14` |
| Surface                 | `#1A1622` |
| Text                    | `#F7F5FA` |
| Muted text              | `#A59FB3` |
| Success                 | `#2ECC71` |

Radii 12 and 20, spacing on a scale of 4. The orange-to-violet gradient is
only for the logo, splash and record button. Text on orange is dark
(`#0E0B14`) for contrast.

## Review and release

Every pull request is reviewed by a person, with extra care on auth, payments
and anything security related. Changes reach production only through
staging.
