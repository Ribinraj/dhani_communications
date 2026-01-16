import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationItem> notifications = [
    NotificationItem(
      title: 'New Message',
      description: 'You have received a new message from John Doe',
      time: '2 min ago',
      isRead: false,
      type: NotificationType.message,
    ),
    NotificationItem(
      title: 'Payment Successful',
      description: 'Your payment of ₹1,500 has been processed successfully',
      time: '1 hour ago',
      isRead: false,
      type: NotificationType.success,
    ),
    NotificationItem(
      title: 'System Update',
      description: 'A new update is available for your application',
      time: '3 hours ago',
      isRead: true,
      type: NotificationType.info,
    ),
    NotificationItem(
      title: 'Account Alert',
      description: 'Your account password will expire in 7 days',
      time: '1 day ago',
      isRead: true,
      type: NotificationType.warning,
    ),
    NotificationItem(
      title: 'Welcome!',
      description: 'Thank you for joining our platform',
      time: '2 days ago',
      isRead: true,
      type: NotificationType.message,
    ),
  ];

  void _markAsRead(int index) {
    setState(() {
      notifications[index].isRead = true;
    });
  }



  void _deleteNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = notifications.where((n) => !n.isRead).length;

    return Scaffold(
    
      appBar: AppBar(
        backgroundColor: Appcolors.kwhitecolor,
        elevation: 2,
        shadowColor: Appcolors.kgreyColor.withOpacity(0.1),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Appcolors.kprimarycolor,
            size: ResponsiveUtils.sp(5),
          ),
        ),
        title: TextStyles.subheadline(
          text: 'Notifications',
          weight: FontWeight.bold,
          color: Appcolors.kblackcolor,
        ),
        centerTitle: true,
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                if (unreadCount > 0) _buildUnreadBanner(unreadCount),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return _buildNotificationCard(
                        notifications[index],
                        index,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildUnreadBanner(int count) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.wp(4),
        vertical: ResponsiveUtils.hp(1.5),
      ),
      color: Appcolors.kprimarycolor.withOpacity(0.1),
      child: Row(
        children: [
          Icon(
            Icons.notifications_active,
            color: Appcolors.kprimarycolor,
            size: ResponsiveUtils.sp(5),
          ),
          ResponsiveSizedBox.width10,
          TextStyles.body(
            text: 'You have $count unread notification${count > 1 ? 's' : ''}',
            weight: FontWeight.w600,
            color: Appcolors.kprimarycolor,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem item, int index) {
    return Dismissible(
      key: Key(item.title + index.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => _deleteNotification(index),
      background: Container(
        margin: EdgeInsets.only(bottom: ResponsiveUtils.hp(1.5)),
        decoration: BoxDecoration(
          color: Appcolors.kredcolor,
          borderRadius: BorderRadiusStyles.kradius10(),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: ResponsiveUtils.wp(5)),
        child: Icon(
          Icons.delete,
          color: Appcolors.kwhitecolor,
          size: ResponsiveUtils.sp(6),
        ),
      ),
      child: GestureDetector(
        onTap: () => _markAsRead(index),
        child: Container(
          margin: EdgeInsets.only(bottom: ResponsiveUtils.hp(1.5)),
          decoration: BoxDecoration(
            color: item.isRead
                ? Appcolors.kwhitecolor
                : Appcolors.kprimarycolor.withOpacity(0.05),
            borderRadius: BorderRadiusStyles.kradius10(),
            border: Border.all(
              color: item.isRead
                  ? Appcolors.kgreyColor.withOpacity(0.2)
                  : Appcolors.kbordercolor.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Appcolors.kblackcolor.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNotificationIcon(item.type),
                ResponsiveSizedBox.width10,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextStyles.subheadline(
                              text: item.title,
                              color: Appcolors.kblackcolor,
                            ),
                          ),
                          if (!item.isRead)
                            Container(
                              width: ResponsiveUtils.wp(2),
                              height: ResponsiveUtils.wp(2),
                              decoration: const BoxDecoration(
                                color: Appcolors.kprimarycolor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      ResponsiveSizedBox.height5,
                      TextStyles.body(
                        text: item.description,
                        color: Appcolors.kgreyColor,
                        maxLines: 2,
                      ),
                      ResponsiveSizedBox.height5,
                      TextStyles.caption(
                        text: item.time,
                        color: Appcolors.kgreyColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(NotificationType type) {
    IconData icon;
    Color bgColor;

    switch (type) {
      case NotificationType.message:
        icon = Icons.message;
        bgColor = Appcolors.kprimarycolor;
        break;
      case NotificationType.success:
        icon = Icons.check_circle;
        bgColor = Appcolors.ksecondarycolor;
        break;
      case NotificationType.warning:
        icon = Icons.warning;
        bgColor = Colors.orange;
        break;
      case NotificationType.info:
        icon = Icons.info;
        bgColor = Appcolors.kbordercolor;
        break;
    }

    return Container(
      width: ResponsiveUtils.wp(12),
      height: ResponsiveUtils.wp(12),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.1),
        borderRadius: BorderRadiusStyles.kradius10(),
      ),
      child: Icon(
        icon,
        color: bgColor,
        size: ResponsiveUtils.sp(6),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: ResponsiveUtils.sp(20),
            color: Appcolors.kgreyColor,
          ),
          ResponsiveSizedBox.height20,
          TextStyles.headline(
            text: 'No Notifications',
            color: Appcolors.kgreyColor,
          ),
          ResponsiveSizedBox.height10,
          TextStyles.body(
            text: 'You\'re all caught up!',
            color: Appcolors.kgreyColor,
          ),
        ],
      ),
    );
  }
}

// Data Models
enum NotificationType {
  message,
  success,
  warning,
  info,
}

class NotificationItem {
  final String title;
  final String description;
  final String time;
  bool isRead;
  final NotificationType type;

  NotificationItem({
    required this.title,
    required this.description,
    required this.time,
    required this.isRead,
    required this.type,
  });
}
