class TelegramChat {
  const TelegramChat({
    required this.id,
    required this.title,
    required this.type,
    this.username,
    this.isSelected = false,
  });

  final int id;
  final String title;
  final String type;
  final String? username;
  final bool isSelected;
}
