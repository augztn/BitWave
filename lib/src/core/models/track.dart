enum AudioContainer { mp3, flac, wav, m4a, aac, ogg, opus, alac, aiff, unknown }

class Track {
  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    required this.telegramChatId,
    required this.telegramMessageId,
    this.album,
    this.fileName,
    this.mimeType,
    this.fileSize,
    this.container = AudioContainer.unknown,
    this.localPath,
    this.remoteFileId,
  });

  final String id;
  final String title;
  final String artist;
  final String? album;
  final Duration duration;
  final int telegramChatId;
  final int telegramMessageId;
  final String? fileName;
  final String? mimeType;
  final int? fileSize;
  final AudioContainer container;
  final String? localPath;
  final int? remoteFileId;

  Track withLocalPath(String path) => Track(
        id: id,
        title: title,
        artist: artist,
        album: album,
        duration: duration,
        telegramChatId: telegramChatId,
        telegramMessageId: telegramMessageId,
        fileName: fileName,
        mimeType: mimeType,
        fileSize: fileSize,
        container: container,
        localPath: path,
        remoteFileId: remoteFileId,
      );
}
