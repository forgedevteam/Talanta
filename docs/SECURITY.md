# Security

How Talanta protects accounts and data, what was tested, and what to do
before launch. Report a vulnerability privately to the team, never in a
public issue.

## Accounts and sessions

| Threat                                                                         | Protection                                                                                              | Tested |
| ------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------- | ------ |
| Guessing a sign-in code                                                        | 6-digit codes, 5 guesses per code, 5-minute life; only an HMAC of the code is stored                    | yes    |
| Guessing codes across many numbers from one place                              | 100 verify attempts per IP per hour (`OTP_MAX_VERIFY_PER_IP_PER_HOUR`)                                  | yes    |
| SMS bombing / SMS-pumping fraud                                                | 60 s between codes, 5 per number per hour, 30 per IP per hour, launch countries only, mobile lines only | yes    |
| Stolen refresh token                                                           | Single-use rotating tokens; reuse after 20 s revokes the whole session family                           | yes    |
| Suspended, deleted or demoted user keeps acting until the access token expires | Every request re-reads the account; status and role come from the database, not the token               | yes    |
| Admin routes being discovered                                                  | Non-admins get `404`, same as a route that does not exist                                               | yes    |
| Account takeover through a recycled phone number                               | Deleting an account frees the number; the old data is anonymised, not reassigned                        | yes    |

## Data access

| Threat                                            | Protection                                                                                                                                         | Tested |
| ------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| Reading another organiser's applicants (IDOR)     | Applicant lists and decisions check the poster; others get `404`                                                                                   | yes    |
| Deleting someone else's portfolio piece           | Deletes are scoped to the owner; others get `404`                                                                                                  | yes    |
| Attaching another person's work to an application | The portfolio piece must belong to the applicant                                                                                                   | yes    |
| Mass assignment (sending `role: admin` etc.)      | Global validation rejects any field a DTO does not declare                                                                                         | yes    |
| SQL injection                                     | All queries are parameterised (Drizzle); LIKE wildcards in search are escaped                                                                      | yes    |
| Leaking phone numbers or dates of birth           | Public profiles and cards never include them                                                                                                       | yes    |
| Oversized payloads                                | 64 KB request body limit                                                                                                                           | yes    |
| Floods from one account or address                | 240 requests/min per signed-in user, 120/min per IP when signed out; daily limits on posting (5), applying (30), reporting (20), following (200/h) | yes    |

## Photos and videos

| Threat                                                        | Protection                                                                                                            | Tested |
| ------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- | ------ |
| A script or web page uploaded as a "photo"                    | The type comes from the file's first bytes, never its name or claimed type; only JPEG, PNG, WebP and MP4/MOV pass     | yes    |
| Hidden payloads and location data inside photos               | Every photo is decoded and re-encoded; nothing of the original but the picture survives, GPS and device tags included | yes    |
| Decompression bombs                                           | Photos over 50 megapixels are refused before decoding; 12 MB per photo, 60 MB per video                               | yes    |
| Reading files outside the media folder                        | Storage keys are generated ids, checked against a strict pattern; the file server refuses `..`                        | yes    |
| A media file opened as a page in a browser                    | Served with `nosniff` and `Content-Security-Policy: sandbox`                                                          | yes    |
| Using someone else's upload in a post or as a profile picture | Files can only be attached by their owner, and to one post                                                            | yes    |
| Upload floods                                                 | 150 uploads per person per day; 30 posts, 200 comments, 600 likes per hour                                            | yes    |
| A closed account's photos staying online                      | Closing an account deletes its files, not just its posts                                                              | yes    |

Media URLs are public but unguessable. Videos are stored as uploaded: there
is no server-side transcoding yet, so a video is only checked for its type
and size.

## Content and safety

- **Minors.** A date of birth is required and fixed once set. Under 13
  cannot join. Under 18 cannot post or apply to Open Calls, which closes
  the most common route for fake "castings" aimed at children.
- **Posts and comments.** People can report posts and comments; admins
  take posts down. A suspended account's posts and comments disappear at
  once. Authors can delete their posts, and anyone can delete a comment on
  their own post.
- **Scams.** Paid calls must state an amount. Every call shows "Talanta
  never asks you to pay to apply". People can report calls, people and
  work; admins review the queue, remove calls and suspend accounts
  (which signs them out everywhere at once).
- **Links.** Portfolio and sponsor links must be `https://`; no embedded
  credentials, no bare IP addresses or local hosts, no `javascript:`. The
  server never fetches them, so they cannot be used to reach internal
  systems.

## Transport and storage

- The API sends HSTS, CSP, `nosniff`, frame and referrer headers (Helmet)
  and hides `X-Powered-By`.
- Release builds of the app only use HTTPS; cleartext is allowed in debug
  builds alone.
- Tokens are stored in the Android Keystore / iOS Keychain. Android backups
  are disabled, so app data cannot be copied off the phone with backup tools.
- Production refuses to start without Redis, with the console SMS provider,
  or with a fixed sign-in code.

## Test accounts

`OTP_TEST_NUMBERS` and `OTP_TEST_CODE` let listed numbers sign in with a
known code and no SMS, for QA and app-store review. Anyone who knows the
code can sign in as those numbers, so:

- use numbers the team owns,
- keep the code secret and change it after each review,
- remove the variables when review is done.

## Before launch

- Run a third-party penetration test against staging.
- Put the API behind Cloudflare (DDoS protection, WAF) and set
  `TRUST_PROXY_HOPS` to match, so per-IP limits see real addresses.
- Use long random `JWT_ACCESS_SECRET` and `OTP_SECRET`, different for staging
  and production, stored in the host's secret manager.
- Turn on database backups and point-in-time recovery.
- Build releases with `--obfuscate --split-debug-info=build/symbols`.
- `pnpm audit` and `flutter pub outdated` monthly; both are clean today.
