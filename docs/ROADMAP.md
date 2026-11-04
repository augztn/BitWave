# BitWave MVP roadmap

## MVP acceptance criteria

- [ ] Android and Linux launch from the same Flutter application.
- [ ] Telegram sign-in supports phone, code and two-step verification flows exposed by TDLib.
- [ ] User can select accessible chats/channels and persist the selection locally.
- [ ] Search finds audio messages and supported music documents in selected chats.
- [ ] Track details include title, artist, album, duration, format, size, chat and message identity when available.
- [ ] Playback starts without requiring a complete permanent library download; buffering and seek behavior are explicit and tested.
- [ ] Play/pause, queue, next/previous, seek, repeat and shuffle work.
- [ ] Android background playback survives screen lock and exposes system media controls.
- [ ] Linux playback works with common codecs available through the selected media backend.
- [ ] Cache can be bounded and cleared without deleting the active playback file.
- [ ] Sign-out reliably closes TDLib and revokes the local session; no secrets appear in logs.
- [ ] CI builds Android and Linux artifacts and runs Dart/domain/native adapter tests.

## Milestones

### M0 — Foundation

Project skeleton, application shell, theme, navigation, typed models, repository interfaces, dependency injection and CI checks.

### M1 — Telegram connection

TDLib Android/Linux packaging, API credential storage, authorization UI/state machine, secure session persistence and logout.

### M2 — Telegram library

Chat listing and selection, search across selected chats, metadata extraction, local SQLite index and rate-limit handling.

### M3 — Audio playback

Media engine selection, cache/download pipeline, seek, queue, Android media session and Linux desktop controls.

### M4 — Daily-use features

Playlists, favorites, album art, search filters, duplicate detection, backup/export and cache management.

### M5 — Release

Build signing, Linux packaging, Android APK/AAB, CI artifacts, crash-safe shutdown, privacy/security review and documentation.

## Current implementation status (2026-11-04)

- M0 foundation: Flutter app shell, domain models, gateway contract, Dart-side TDLib channel boundary and CI workflow are present.
- M1 in progress: secure credential storage and authentication validation are present; Android and Linux native TDLib adapters are not yet implemented or packaged.
- Authentication validation tests have been added, but have not yet been executed in this environment. Do not treat the channel bridge as a working Telegram connection until native TDLib is integrated and device-tested.

## Explicit risks

- TDLib native binaries and build flags must be pinned and verified for every target ABI. Avoid opaque, unverified binaries.
- TDLib-managed download may need adaptation for responsive seeking on large files; profile this on real accounts and networks.
- Telegram search and file operations are subject to rate limits and account access rights.
- Flutter desktop playback packages differ in codec and media-key support. Validate before committing to a backend.
- Telegram can change limits and API behavior; do not advertise guaranteed unlimited file storage or bandwidth.
