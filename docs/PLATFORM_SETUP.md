# Platform setup

## Flutter

Use the current stable Flutter SDK and pin the exact CI toolchain once the first builds are green. Flutter supports Linux desktop and Android from the same project; see https://docs.flutter.dev/install and https://docs.flutter.dev/platform-integration/linux/building.

## Android

Enable Android support in Flutter and install Android Studio / Android SDK command-line tools. Generate the Android runner project with `flutter create --platforms=android .` when initializing the local working copy. The TDLib adapter needs native `libtdjson` (or TDLib Java binding) packaged per supported ABI, plus any transitive native dependencies. Do not bundle arbitrary prebuilt `.so` libraries without verifying provenance, ABI, hashes, licenses and build flags.

## Linux

Install Flutter's Linux desktop prerequisites (Clang, CMake, Ninja, pkg-config, GTK development headers and related build tools). Generate the Linux runner with `flutter create --platforms=linux .`. Package TDLib as a Linux native shared library for each target architecture. Runtime library lookup must be tested in the packaged app, not only on a developer machine.

## Audio playback

The current manifest evaluates `just_audio` with the `just_audio_media_kit` Linux backend and `audio_service` for system media integration. Confirm Android playback uses the native backend, Linux codecs are available in clean environments, and Linux MPRIS integration is configured. For Android, implement a foreground media service / notification, audio focus, interruption handling and lock-screen controls. Don't call this production ready until tested on real Android hardware and a clean Linux install.

## Telegram TDLib

Official sources:
- https://core.telegram.org/tdlib
- https://core.telegram.org/tdlib/getting-started
- https://github.com/tdlib/td/tree/master/example/android

TDLib can be built for Linux and Android, but it is a native C++ library with per-platform packaging work. Keep the Dart gateway stable and maintain separate native implementations. Store `api_hash` and TDLib database key with the OS secure storage service; don't store them in SQLite or logs.
