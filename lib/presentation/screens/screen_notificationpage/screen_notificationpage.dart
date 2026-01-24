import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:dhani_communications/data/models/notification_model.dart';
import 'package:dhani_communications/presentation/blocs/notifications_bloc/notifications_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    // Fetch notifications when page loads
    context.read<NotificationsBloc>().add(FetchNotificationsEvent());
  }

  void _markAsRead(int notificationId) {
    context.read<NotificationsBloc>().add(
          MarkNotificationReadEvent(notificationId: notificationId),
        );
  }

  @override
  Widget build(BuildContext context) {
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
      body: BlocConsumer<NotificationsBloc, NotificationsState>(
        listener: (context, state) {
          if (state is MarkNotificationReadErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Appcolors.kredcolor,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is NotificationsLoadingState) {
            return _buildLoadingState();
          } else if (state is NotificationsErrorState) {
            return _buildErrorState(state.message);
          } else if (state is NotificationsSuccessState) {
            return _buildNotificationsList(state.notifications);
          } else if (state is MarkNotificationReadLoadingState) {
            return _buildNotificationsList(
              state.notifications,
              loadingNotificationId: state.notificationId,
            );
          } else if (state is MarkNotificationReadSuccessState) {
            return _buildNotificationsList(state.notifications);
          } else if (state is MarkNotificationReadErrorState) {
            return _buildNotificationsList(state.notifications);
          }
          return _buildLoadingState();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        color: Appcolors.kprimarycolor,
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: ResponsiveUtils.sp(15),
            color: Appcolors.kgreyColor,
          ),
          ResponsiveSizedBox.height20,
          TextStyles.headline(
            text: 'Failed to load notifications',
            color: Appcolors.kgreyColor,
          ),
          ResponsiveSizedBox.height10,
          TextStyles.body(
            text: message,
            color: Appcolors.kgreyColor,
            textAlign: TextAlign.center,
          ),
          ResponsiveSizedBox.height20,
          TextButton(
            onPressed: () {
              context.read<NotificationsBloc>().add(FetchNotificationsEvent());
            },
            child: TextStyles.body(
              text: 'Retry',
              color: Appcolors.kprimarycolor,
              weight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(
    List<NotificationModel> notifications, {
    int? loadingNotificationId,
  }) {
    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    final unreadCount = notifications.where((n) => !n.isRead).length;

    return Column(
      children: [
        if (unreadCount > 0) _buildUnreadBanner(unreadCount),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<NotificationsBloc>().add(FetchNotificationsEvent());
            },
            color: Appcolors.kprimarycolor,
            child: ListView.builder(
              padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return _buildNotificationCard(
                  notifications[index],
                  isLoading: loadingNotificationId ==
                      notifications[index].notificationId,
                );
              },
            ),
          ),
        ),
      ],
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

  Widget _buildNotificationCard(
    NotificationModel notification, {
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (!notification.isRead && !isLoading) {
          _markAsRead(notification.notificationId);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: ResponsiveUtils.hp(1.5)),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Appcolors.kwhitecolor
              : Appcolors.kprimarycolor.withOpacity(0.05),
          borderRadius: BorderRadiusStyles.kradius10(),
          border: Border.all(
            color: notification.isRead
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
              _buildNotificationIcon(),
              ResponsiveSizedBox.width10,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextStyles.subheadline(
                            text: notification.title,
                            color: Appcolors.kblackcolor,
                          ),
                        ),
                        if (isLoading)
                          SizedBox(
                            width: ResponsiveUtils.wp(4),
                            height: ResponsiveUtils.wp(4),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Appcolors.kprimarycolor,
                            ),
                          )
                        else if (!notification.isRead)
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
                      text: notification.message,
                      color: Appcolors.kgreyColor,
                      maxLines: 2,
                    ),
                    ResponsiveSizedBox.height5,
                    TextStyles.caption(
                      text: notification.formattedTime,
                      color: Appcolors.kgreyColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return Container(
      width: ResponsiveUtils.wp(12),
      height: ResponsiveUtils.wp(12),
      decoration: BoxDecoration(
        color: Appcolors.kprimarycolor.withOpacity(0.1),
        borderRadius: BorderRadiusStyles.kradius10(),
      ),
      child: Icon(
        Icons.notifications,
        color: Appcolors.kprimarycolor,
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
