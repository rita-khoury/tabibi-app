class NotificationsModel {
  final int id;
  final int userId;
  final String title;
  final String body;
  final String? messageKey;
  final Map<String, dynamic>? arguments;
  final String type;
  final String priority;
  final String? targetType;
  final int? targetId;
  final String? actionUrl;
  final String status;
  final String? readAt;
  final String createdAt;

  NotificationsModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.messageKey,
    this.arguments,
    required this.type,
    required this.priority,
    this.targetType,
    this.targetId,
    this.actionUrl,
    required this.status,
    this.readAt,
    required this.createdAt,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
      id: int.parse(json['id'].toString()),
      userId: int.parse(json['userId'].toString()),
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      messageKey: json['messageKey'],
      arguments: json['arguments'] != null
          ? Map<String, dynamic>.from(json['arguments'])
          : null,
      type: json['type'] ?? '',
      priority: json['priority'] ?? '',
      targetType: json['targetType'],
      targetId: json['targetId'] != null
          ? int.tryParse(json['targetId'].toString())
          : null,
      actionUrl: json['actionUrl'],
      status: json['status'] ?? '',
      readAt: json['readAt'],
      createdAt: json['created_at'] ?? json['createdAt'] ?? '',
    );
  }

  bool get isRead => readAt != null;
}
