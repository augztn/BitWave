# TDLib platform-channel contract

Dart channel names:
- Method channel: `bitwave/tdlib`
- Event channel: `bitwave/tdlib/events`

Native adapter methods:
- `initialize({apiId: int, apiHash: String})`
- `submitPhoneNumber({phoneNumber: String})`
- `submitCode({code: String})`
- `submitPassword({password: String})`
- `listChats({query: String?}) -> List<Chat>`
- `setSelectedChats({chatIds: List<int>})`
- `searchMusic({query: String, limit: int}) -> List<Track>`
- `ensureDownloaded({chatId: int, messageId: int, remoteFileId: int?}) -> String localPath`
- `logout()`
- `close()`

Authorization events use:
```json
{"type":"authorization","state":"waitingForPhoneNumber"}
```

Allowed state strings are the Dart `TelegramAuthState` enum names. Optional `message` must be safe for display and must not contain login codes, passwords, API hashes, session paths or raw TDLib error payloads.

Chat map:
```json
{"id":-100123,"title":"BitWave Music","type":"channel","username":null}
```

Track map:
```json
{
  "id":"-100123:42",
  "title":"Night Drive",
  "artist":"Example Artist",
  "album":"After Hours",
  "durationSeconds":215,
  "chatId":-100123,
  "messageId":42,
  "fileName":"night-drive.flac",
  "mimeType":"audio/flac",
  "fileSize":12000000,
  "remoteFileId":987,
  "localPath":null
}
```

Native implementation requirements:
- marshal TDLib callbacks onto the platform channel's supported thread;
- serialize TDLib client requests and correlate responses;
- expose authorization updates through a single event stream;
- validate IDs, query lengths and result limits again on native side;
- cap concurrent searches and downloads;
- implement cancellation and clean close;
- handle TDLib flood waits without retry storms;
- do not log secret parameters or full TDLib responses;
- return app-private downloaded paths, not temporary or externally shared paths;
- never fabricate an available local path before the download completes.
