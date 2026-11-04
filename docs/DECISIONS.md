# Architecture decisions

## ADR-001: Flutter for shared application UI

**Decision:** Use Flutter/Dart as the shared application shell for Android and Linux.

**Reason:** The product is primarily a media library/player UI, and Flutter provides one UI implementation across both targets. Platform-specific Telegram and playback integration remains native behind repository interfaces.

**Trade-off:** Flutter does not remove the need to package and test TDLib and platform audio services separately.

## ADR-002: TDLib client session, not a bot backend

**Decision:** Integrate TDLib as a normal Telegram client signed in by the user.

**Reason:** The product needs to enumerate accessible chats, query audio/documents, and retrieve original media. Bot API limitations and token ownership do not suit this personal-library workflow.

**Trade-off:** A normal Telegram session is powerful account access, so security, session transparency and revocation are mandatory.

## ADR-003: Telegram-managed download plus local cache first

**Decision:** Start with TDLib's download manager and progressive local-file availability rather than building a custom range-streaming HTTP bridge in the first milestone.

**Reason:** It keeps cancellation, offsets, download lifecycle and file identity within TDLib; it reduces fragile cross-process streaming code.

**Trade-off:** Large-track startup/seek latency must be measured. If it is poor, add a bounded streaming adapter later, keeping TDLib rate limits and file access rules intact.

## ADR-004: Separate domain models from TDLib types

**Decision:** Convert TDLib messages into stable BitWave models in native adapter / parser boundaries.

**Reason:** UI, tests and persistence should not couple to generated TDLib API types.
