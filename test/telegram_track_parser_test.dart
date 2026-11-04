import 'package:bitwave/src/core/telegram/telegram_track_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const parser = TelegramTrackParser();

  test('parses audio metadata from a normalized TDLib audio message', () {
    final track = parser.parse({
      'id': 42,
      'chatId': -100123,
      'content': {
        'audio': {
          'title': 'Night Drive',
          'performer': 'Example Artist',
          'album': 'After Hours',
          'duration': 215,
          'fileName': 'night-drive.flac',
          'mimeType': 'audio/flac',
          'audio': {'size': 12000000, 'remote': {'id': 987}},
        },
      },
    });

    expect(track, isNotNull);
    expect(track!.id, '-100123:42');
    expect(track.title, 'Night Drive');
    expect(track.artist, 'Example Artist');
    expect(track.album, 'After Hours');
    expect(track.container.name, 'flac');
    expect(track.fileSize, 12000000);
    expect(track.remoteFileId, 987);
  });

  test('rejects non-audio documents', () {
    expect(
      parser.parse({
        'id': 9,
        'chatId': 1,
        'content': {
          'document': {
            'fileName': 'archive.zip',
            'mimeType': 'application/zip',
          },
        },
      }),
      isNull,
    );
  });

  test('rejects messages without stable Telegram identifiers', () {
    expect(
      parser.parse({
        'content': {
          'audio': {'fileName': 'track.mp3'},
        },
      }),
      isNull,
    );
  });

  test('supports audio documents by MIME type', () {
    final track = parser.parse({
      'id': 1,
      'chat_id': 2,
      'content': {
        'document': {
          'file_name': 'recording.bin',
          'mime_type': 'audio/mpeg',
          'document': {'size': 100},
        },
      },
    });

    expect(track, isNotNull);
    expect(track!.container.name, 'unknown');
  });
}
