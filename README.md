# BitWave

A cross-platform, personal music player powered by Telegram cloud chats.

> Status: early development. The Flutter foundation and Dart-side TDLib channel contract are in place. Native TDLib adapters, playback, and installable builds are not implemented yet.

## Targets

- Android
- Linux desktop

## Product model

BitWave is designed for a dedicated Telegram account used as a personal music library. The account can read music from channels and groups it has joined, and use a private "BitWave Music" channel as its own collection.

Telegram is the remote media store. BitWave provides the library, search, playback, playlists and local cache. No BitWave-hosted music server is required for the core design.

## Architecture

- Flutter/Dart shared UI and domain layer.
- TDLib normal-client session through platform adapters.
- Android native TDLib integration and Linux libtdjson integration behind the same Dart method/event channel.
- SQLite metadata index and app-private media cache.
- OS secure storage for Telegram API credentials and TDLib database key.
- Platform media backend for background Android playback and Linux desktop controls.

See [architecture](docs/ARCHITECTURE.md), [TDLib channel contract](docs/TDLIB_CHANNEL_CONTRACT.md), [dedicated account setup](docs/DEDICATED_ACCOUNT_SETUP.md), and [roadmap](docs/ROADMAP.md).

## Telegram setup

Create a dedicated Telegram account, enable two-step verification, create a private music channel, invite the account to other source channels, and create an API application at https://my.telegram.org/apps. Credentials are entered locally in BitWave, never shared in chat or committed to source control.

## Current implementation

- Flutter application shell and dark UI.
- Typed track/chat models and normalized audio-message parser.
- Search input policy and unit-test foundation.
- Dart Telegram gateway abstraction and MethodChannel/EventChannel adapter contract.
- Secure credential store and auth-flow validation service.
- Dedicated-account setup and native integration contract documentation.

The MethodChannel adapter currently expects native implementations. It is not yet connected to TDLib, so Telegram login, chat listing, channel creation, search and downloads are not operational yet.

## Important limits

Telegram is not guaranteed unlimited storage or bandwidth. File-size limits, account eligibility, API limits, flood waits, network conditions and Telegram policies apply. BitWave must only access chats available to the signed-in account and must not bypass protected content or access controls. Users must have rights to the audio they store and play.

## Development

Install Flutter stable and the Android/Linux platform prerequisites. See [platform setup](docs/PLATFORM_SETUP.md).

```bash
flutter pub get
flutter run -d linux
flutter run -d <android-device-id>
```

## Security

Never commit Telegram API hashes, login codes, two-step verification passwords, TDLib session data, or database keys. Keep TDLib databases in app-private directories. Redact all sensitive values from logs. Revoke a lost device session in Telegram Settings → Devices.
