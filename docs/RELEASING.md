# Getting Talanta onto phones

What you need to get, in order, and how to build the app once you have it.

## 1. Before anyone outside the team installs it

These need accounts, money or a decision that only you can make.

| What                                | Why                                                                                                                                                                   | Where                                                                                                                                                                                                                                                                                                   |
| ----------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| SMS provider account                | Sign-in codes go to real phones. Code is ready (`SMS_PROVIDER=africastalking`).                                                                                       | [Africa's Talking](https://account.africastalking.com/auth/register): create an app, top up, copy the API key. Test first with the username `sandbox` and their [simulator](https://simulator.africastalking.com). Apply for a sender ID per country if you want "TALANTA" to show instead of a number. |
| A server for the API                | A phone cannot reach `localhost`. The API needs a public HTTPS address.                                                                                               | Any Node host works. Simple options: [Render](https://render.com), [Railway](https://railway.com) or [Fly.io](https://fly.io).                                                                                                                                                                          |
| Managed PostgreSQL 16               | The database.                                                                                                                                                         | [Neon](https://neon.tech) or [Supabase](https://supabase.com) (both have free tiers).                                                                                                                                                                                                                   |
| Managed Redis                       | Rate limits and sign-in codes across servers. Required in production.                                                                                                 | [Upstash](https://upstash.com) (free tier).                                                                                                                                                                                                                                                             |
| A domain                            | For `api.yourdomain` and the website.                                                                                                                                 | [Cloudflare Registrar](https://www.cloudflare.com/products/registrar/) sells at cost and gives you DNS and CDN in one place.                                                                                                                                                                            |
| Terms of Service and Privacy Policy | The sign-in screen already refers to them, and Google Play requires a privacy policy URL. You collect phone numbers and dates of birth from people in five countries. | A lawyer familiar with Cameroon's 2024 personal data protection law, Nigeria's NDPA 2023, Kenya's Data Protection Act 2019, Ghana's Data Protection Act 2012 and South Africa's POPIA.                                                                                                                  |
| Logo                                | The app icon is a placeholder "T" on the brand gradient (`docs/icon-preview.png`).                                                                                    | A designer. Send the final mark as an SVG and we regenerate every icon size.                                                                                                                                                                                                                            |
| Android app ID                      | `com.talanta.talanta` today. It can never change after the first Play Store upload.                                                                                   | Decide, e.g. `app.talanta` if you own `talanta.app`.                                                                                                                                                                                                                                                    |
| Google Play developer account       | To publish on Android. One-time USD 25.                                                                                                                               | [Play Console](https://play.google.com/console/signup)                                                                                                                                                                                                                                                  |
| Apple developer account             | Only when you are ready for iPhone. USD 99 a year, and iOS builds need a Mac.                                                                                         | [Apple Developer Program](https://developer.apple.com/programs/enroll/)                                                                                                                                                                                                                                 |

## 2. Check the app works (no accounts needed)

```bash
pnpm dev:db                                  # terminal 1, leave running
pnpm --filter @talanta/api db:migrate
pnpm dev:api                                 # terminal 2, leave running

pnpm --filter @talanta/api test              # API: 80 tests
cd apps/mobile
flutter test                                 # app widgets: 36 tests

# Full sign-up on an emulator or a phone over USB, against the API above.
adb reverse tcp:3000 tcp:3000
flutter test integration_test --dart-define=OTP_CODE=<OTP_DEV_FIXED_CODE from apps/api/.env>
```

## Test on your own phone by USB (no hosting needed)

1. On the phone: Settings, About phone, Software information, tap **Build
   number** seven times. Then Developer options, turn on **USB debugging**.
2. On the PC, start the server (two terminals, leave both running):

   ```bash
   pnpm dev:db
   pnpm dev:api
   ```

3. Plug the phone in, accept the "Allow USB debugging" prompt, then:

   ```bash
   cd apps/mobile
   flutter build apk --profile --split-per-abi     # once per app change
   adb install -r build/app/outputs/flutter-apk/app-arm64-v8a-profile.apk
   adb reverse tcp:3000 tcp:3000                  # every time you plug in
   ```

Profile builds may use plain HTTP to this PC through the cable only; store
releases are HTTPS-only. Demo accounts come from `db:seed-demo` and sign in
with `OTP_TEST_CODE`.

## 3. Create the upload key (once)

The key proves future updates come from you. Keep the file and both passwords
in a password manager. If you lose them, Play App Signing lets you reset the
upload key, but it takes days.

```powershell
& "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -genkey -v `
  -keystore "$env:USERPROFILE\keys\talanta-upload.jks" `
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Then copy `apps/mobile/android/key.properties.example` to `key.properties` in
the same folder and fill it in. Both files are ignored by git. Never commit
them.

## 4. Build

```bash
cd apps/mobile

# APKs to share directly (one per phone type; most phones need arm64-v8a)
flutter build apk --release --split-per-abi --dart-define=API_BASE_URL=https://api.yourdomain

# App bundle for Google Play
flutter build appbundle --release --dart-define=API_BASE_URL=https://api.yourdomain
```

Release builds only talk HTTPS. Pointing one at `http://localhost` will fail
on purpose; use a debug build (`flutter run`) for local work.

Outputs land in `apps/mobile/build/app/outputs/`. Each APK is about 16 to 19 MB.

## 5. API in production

Required environment (see `apps/api/.env.example` for every option):

```
NODE_ENV=production
DATABASE_URL=...            # from Neon or Supabase
REDIS_URL=...               # from Upstash
JWT_ACCESS_SECRET=...       # 48 random bytes, different from staging
OTP_SECRET=...              # 48 random bytes, different from staging
SMS_PROVIDER=africastalking
AFRICASTALKING_USERNAME=...
AFRICASTALKING_API_KEY=...
TRUST_PROXY_HOPS=1          # number of proxies in front of the API
CORS_ORIGINS=https://yourdomain
```

The API refuses to start in production without Redis, with the console SMS
provider, or with a fixed sign-in code. Run `node dist/database/migrate.js`
before each release, then `node dist/main.js`. Deploy to staging first; only
promote to production what has been tested there.
