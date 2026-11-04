# BitWave

A cross-platform, personal music player powered by Telegram cloud chats.

> Status: foundation / early development. Telegram integration and playback are not yet implemented.

## Targets

- Android 8.0+
- Linux desktop

## Architecture

BitWave uses Flutter for its shared UI and application layer. Telegram access is designed around TDLib, with platform-specific native integration behind a small Dart service boundary. Playback uses a platform media backend rather than treating Telegram as a public HTTP file host.

## Planned features

- Sign in with a Telegram account using your own Telegram API ID and API hash.
- Select private channels and chats that the signed-in account can access.
- Browse and search supported audio messages and uploaded music documents.
- Play and seek audio while TDLib downloads/cache-fills the file.
- Local metadata index, playlists, queue, favorites and configurable cache.
- Android background playback and Linux desktop playback.

## Important limits

Telegram is cloud storage, not guaranteed unlimited storage or bandwidth. Telegram applies upload-size, account, and API limits. Each user must have permission to access the source chats and rights to the audio they play. Protected or secret media is out of scope.

## Development

Flutter SDK is required. Android builds require Android SDK tooling; Linux builds require the Flutter Linux desktop prerequisites.

```bash
flutter pub get
flutter run -d linux
flutter run -d <android-device-id>
```

## Security

Never commit Telegram API hashes, login codes, two-step verification passwords, TDLib session data, or local database keys. The app must store credentials in platform-secure storage and keep TDLib databases in app-private directories.

## Reference

The Telegram music workflow is informed by the public BitChord Morphe patch project: https://github.com/Hexclyde/bitchord-morphe-patches. BitWave is an independent implementation, not a fork of that patch set.
