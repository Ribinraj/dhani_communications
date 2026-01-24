/// Model for user notification from API
class NotificationModel {
  final int notificationId;
  final String title;
  final String message;
  final DateTime createdDate;
  final bool isRead;

  NotificationModel({
    required this.notificationId,
    required this.title,
    required this.message,
    required this.createdDate,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notificationId'] ?? 0,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : DateTime.now(),
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'title': title,
      'message': message,
      'createdDate': createdDate.toIso8601String(),
      'isRead': isRead,
    };
  }

  /// Create a copy with updated isRead status
  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      notificationId: notificationId,
      title: title,
      message: message,
      createdDate: createdDate,
      isRead: isRead ?? this.isRead,
    );
  }

  /// Get formatted time string (e.g., "2 min ago", "1 hour ago")
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(createdDate);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else {
      return '${createdDate.day}/${createdDate.month}/${createdDate.year}';
    }
  }
}
