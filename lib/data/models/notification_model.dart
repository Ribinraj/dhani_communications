/// Model for user notification from API
class NotificationModel {
  final int notificationId;
  final String recipientId;
  final String notification;
  final String status;
  final bool isRead;
  final DateTime createdAt;
  final String? modifiedAt;
  final String created;

  NotificationModel({
    required this.notificationId,
    required this.recipientId,
    required this.notification,
    required this.status,
    required this.isRead,
    required this.createdAt,
    this.modifiedAt,
    required this.created,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // Parse created_at object
    DateTime parsedDate = DateTime.now();
    if (json['created_at'] != null) {
      if (json['created_at'] is Map) {
        // Handle object format: {"date": "2025-06-11 11:00:01.000000", ...}
        final dateStr = json['created_at']['date'];
        if (dateStr != null) {
          parsedDate = DateTime.tryParse(dateStr) ?? DateTime.now();
        }
      } else if (json['created_at'] is String) {
        parsedDate = DateTime.tryParse(json['created_at']) ?? DateTime.now();
      }
    }

    return NotificationModel(
      notificationId: json['notificationId'] is int
          ? json['notificationId']
          : int.tryParse(json['notificationId']?.toString() ?? '0') ?? 0,
      recipientId: json['recipientId']?.toString() ?? '',
      notification: json['notification'] ?? '',
      status: json['status']?.toString() ?? '0',
      isRead: json['read']?.toString() == '1',
      createdAt: parsedDate,
      modifiedAt: json['modified_at']?.toString(),
      created: json['created']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'recipientId': recipientId,
      'notification': notification,
      'status': status,
      'read': isRead ? '1' : '0',
      'created_at': createdAt.toIso8601String(),
      'modified_at': modifiedAt,
      'created': created,
    };
  }

  /// Create a copy with updated isRead status
  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      notificationId: notificationId,
      recipientId: recipientId,
      notification: notification,
      status: status,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      created: created,
    );
  }

  /// Get the notification message (alias for convenience)
  String get message => notification;

  /// Get formatted time string (e.g., "2 min ago", "1 hour ago")
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else {
      return created; // Use the pre-formatted "created" field from API
    }
  }
}
