class NotificationEntity {
  final String id;
  final String? title;
  final String? body;
  final Map<String, dynamic> data;
  NotificationEntity({
    required this.id,
    this.title,
    this.body,
    required this.data,
  });

  String? get targetScreen => data['screen'] as String?;
}
