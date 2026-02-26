class NotificationModel {
  final int id;
  final String title;
  final String shortDesc;
  final String longDesc;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;
  final List<String> action;
  final List<String> type;
  final String module;
  final int moduleId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.shortDesc,
    required this.longDesc,
    required this.isRead,
    required this.createdAt,
    required this.readAt,
    required this.action,
    required this.type,
    required this.module,
    required this.moduleId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      shortDesc: json['shortDesc'] ?? '',
      longDesc: json['longDesc'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      readAt: json['readAt'] != null ? DateTime.tryParse(json['readAt']) : null,
      action: json['action'] != null ? List<String>.from(json['action']) : [],
      type: json['type'] != null ? List<String>.from(json['type']) : [],
      module: json['module'] ?? '',
      moduleId: json['moduleId'] ?? 0,
    );
  }
}
