# Telegram reference analysis

Reviewed public repository: https://github.com/Hexclyde/bitchord-morphe-patches

## Reusable product ideas

- TDLib session using the user's own Telegram account and API ID/hash.
- Explicit selection of accessible music chats and channels.
- Search across audio messages and supported music documents.
- Preserve original uploaded media quality and metadata.
- Local index and local audio cache.
- Playlists generated from channel content.
- Track metadata from audio tags and filenames.
- Respect Telegram flood waits and keep background indexing from competing with foreground playback searches.

## Important implementation notes

The reference extension is written as Java code injected into BitChord 1.8.1 through Morphe patches. It is not a standalone Telegram SDK or a desktop application. It also declares itself experimental and reports only limited real-device validation in its README. BitWave should use a standalone Flutter application architecture and independently integrate TDLib.

The reference repository is GPL-3.0-or-later and contains third-party/native components with separate notices. BitWave does not copy its Java classes, patch bytecode hooks, vendor bindings, native binaries, or patch bundle. This note records design observations only. Before any future code reuse, check file-level copyright/license obligations and component provenance.

Relevant implementation design to validate independently:
- Authorization state lifecycle and clean logout.
- Typed TDLib message to Track mapping.
- Bounded parallel search across selected chat IDs.
- TDLib search filters for audio and document messages.
- TDLib-managed downloads with cancellation and cache controls.
- Platform-specific media pipeline.

## Security and privacy lessons

A user-selected chat list is a UI filter, not a reduced Telegram authorization scope. A Telegram session is a normal account session. Store secrets in OS secure storage, keep TDLib database/session files app-private, redact logs, document data requests, and allow session revocation from Telegram's device settings.
