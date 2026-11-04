# BitWave architecture

## Goals

One Flutter application for Android and Linux, with a shared domain model and platform-specific media/Telegram adapters. The first release focuses on a user's own Telegram chats; it does not provide hosted music, public channel scraping, or access to protected media.

## Layers

```text
Flutter UI
  ├── Library / Search / Queue / Player / Settings
  └── Application state and use cases
       ├── TelegramRepository
       │    └── TdLibGateway (platform channel / native TDLib)
       ├── PlaybackRepository
       │    └── Platform media engine
       ├── LibraryRepository (SQLite)
       └── SecureSettingsRepository (OS secure storage)
```

### Flutter UI and domain

The UI must not know TDLib JSON types or native platform-channel details. Domain models represent chats, tracks, albums, and playback state. Repositories expose typed, cancellable operations and streams.

### Telegram adapter

Use TDLib as a normal Telegram client logged in by the user. It owns Telegram networking and its private local database. The adapter must:

- expose authorization state explicitly;
- list only chats available to the signed-in account;
- validate selected chat IDs and cap expensive search fan-out;
- search audio messages and supported document uploads;
- return stable message identity and file metadata;
- request downloads through TDLib and expose local playable paths only after the file is available, or use a bounded streaming bridge when the media engine supports it;
- respect Telegram flood waits and cancellation;
- never emit login codes, passwords, API hashes, session keys, or private file URLs into logs.

For the first implementation, prefer TDLib-managed download plus progressive local-file playback. Directly bridging arbitrary TDLib byte ranges into Flutter's media engine adds lifecycle and seek complexity and should only be added after this works reliably.

### Playback

Playback is a single domain service shared by all screens. It supports queueing, play/pause, seek, next/previous, repeat/shuffle, playback position, and error state. On Android it must integrate with the OS media session/notification, audio focus, headset and Bluetooth controls, and background service lifecycle. Linux must support desktop media keys where the chosen backend provides them.

### Persistence and cache

SQLite stores track metadata and user organization, never Telegram authentication secrets. TDLib owns its own encrypted/local database and downloaded files. BitWave's cache policy must have a user-visible size target and cleanup that never deletes actively playing files. Cache entries can be re-downloaded from a still-accessible message.

### Credentials and privacy

API ID/hash are app configuration and must be stored in OS-backed secure storage where possible. TDLib database encryption key and session data remain under app-private storage. Sign-out must stop playback, close TDLib cleanly, remove session state, and explain which downloaded/exported audio remains. No application server is required for the core design.

## Platform implementation strategy

Flutter UI is shared. TDLib is a native library and must be integrated separately for Android and Linux (JNI/native Android packaging and Linux shared-library packaging). Keep the Dart interface stable while platform implementations evolve. Do not assume a plugin with a similarly named package provides TDLib support on both targets.

Playback should also be hidden behind a repository interface. Select and validate one cross-platform engine before adding player UI features; Android background playback and Linux codecs/media keys are release acceptance criteria.

## Delivery phases

1. Foundation: project skeleton, typed domain models, tests, dependency boundaries, theme and navigation.
2. Telegram auth: native TDLib loading, API credentials, phone/code/password flow, session persistence, logout.
3. Library: chat picker, channel selection, audio/document search, metadata parsing and local index.
4. Playback: progressive download/cache, seek, queue, Android media session, Linux controls.
5. Library quality: playlists, favorites, album art, duplicate handling, cache controls and backup/export.
6. Release engineering: CI for Android APK/AAB and Linux bundle/AppImage, reproducible dependency pinning, privacy/security review.

## Out of scope for initial release

- Server-side user accounts, cloud sync operated by BitWave, public catalog, recommendations, analytics.
- Circumventing protected content, paywalls, Telegram limits, or channel access controls.
- Importing or embedding proprietary code from third-party applications or patch bundles.
