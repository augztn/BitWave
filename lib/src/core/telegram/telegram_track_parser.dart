import '../models/track.dart';

/// A deliberately small adapter for normalized TDLib message payloads.
/// The native adapter should map TdApi objects to this shape; TDLib types
/// must not leak into the Flutter domain layer.
class TelegramTrackParser {
  static const supportedExtensions = <String>{
    'mp3', 'flac', 'wav', 'm4a', 'aac', 'ogg', 'opus', 'alac', 'aiff',
  };

  const TelegramTrackParser();

  Track? parse(Map<String, Object?> message) {
    final content = _map(message['content']);
    final audio = _map(content['audio']);
    final document = _map(content['document']);
    final file = audio.isNotEmpty ? audio : document;
    if (file.isEmpty) return null;

    final fileName = _string(_map(file['fileName'])['text']) ??
        _string(file['file_name']) ??
        _string(file['fileName']);
    final mimeType = _string(file['mimeType']) ?? _string(file['mime_type']);
    final extension = _extension(fileName);
    if (!_isSupported(extension, mimeType)) return null;

    final fileInfo = _map(file['audio'] ?? file['document'] ?? file);
    final remote = _map(fileInfo['remote']);
    final id = _integer(message['id']);
    final chatId = _integer(message['chatId'] ?? message['chat_id']);
    if (id == null || chatId == null) return null;

    final title = _string(file['title']) ??
        _string(file['file_name']) ??
        _withoutExtension(fileName ?? 'Unknown track');
    final artist = _string(file['performer']) ?? 'Unknown artist';
    final durationSeconds = _integer(file['duration']) ?? 0;
    final fileSize = _integer(fileInfo['size']) ?? _integer(fileInfo['expectedSize']);
    final remoteId = _integer(remote['id']);

    return Track(
      id: '$chatId:$id',
      title: title.trim().isEmpty ? 'Unknown track' : title.trim(),
      artist: artist.trim().isEmpty ? 'Unknown artist' : artist.trim(),
      album: _string(file['album']),
      duration: Duration(seconds: durationSeconds.clamp(0, 86400)),
      telegramChatId: chatId,
      telegramMessageId: id,
      fileName: fileName,
      mimeType: mimeType,
      fileSize: fileSize,
      container: _container(extension),
      remoteFileId: remoteId,
    );
  }

  static Map<String, Object?> _map(Object? value) {
    if (value is Map<String, Object?>) return value;
    if (value is Map) {
      return value.map((key, value) => MapEntry(key.toString(), value));
    }
    return const {};
  }

  static String? _string(Object? value) =>
      value is String && value.trim().isNotEmpty ? value.trim() : null;

  static int? _integer(Object? value) {
    if (value is int) return value;
    if (value is num && value.isFinite) return value.toInt();
    return null;
  }

  static String? _extension(String? name) {
    if (name == null) return null;
    final dot = name.lastIndexOf('.');
    if (dot < 0 || dot == name.length - 1) return null;
    return name.substring(dot + 1).toLowerCase();
  }

  static String _withoutExtension(String? name) {
    if (name == null) return 'Unknown track';
    final dot = name.lastIndexOf('.');
    return dot > 0 ? name.substring(0, dot) : name;
  }

  static bool _isSupported(String? extension, String? mimeType) {
    if (extension != null && supportedExtensions.contains(extension)) return true;
    return mimeType != null && (
      mimeType.startsWith('audio/') ||
      mimeType == 'application/ogg'
    );
  }

  static AudioContainer _container(String? extension) => switch (extension) {
    'mp3' => AudioContainer.mp3,
    'flac' => AudioContainer.flac,
    'wav' => AudioContainer.wav,
    'm4a' => AudioContainer.m4a,
    'aac' => AudioContainer.aac,
    'ogg' => AudioContainer.ogg,
    'opus' => AudioContainer.opus,
    'alac' => AudioContainer.alac,
    'aiff' || 'aif' => AudioContainer.aiff,
    _ => AudioContainer.unknown,
  };
}
