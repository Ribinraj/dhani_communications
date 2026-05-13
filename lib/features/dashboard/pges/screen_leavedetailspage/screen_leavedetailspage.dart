import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/features/dashboard/models/leave_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';
import 'package:dhani_communications/core/localization/app_localization.dart';

class ScreenLeaveDetailPage extends StatelessWidget {
  final LeaveModel? leave;

  const ScreenLeaveDetailPage({super.key, this.leave});

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  String _getStatusDisplay(String status) {
    if (status.toUpperCase() == 'APPROVED') return 'Approved';
    if (status.toUpperCase() == 'REJECTED') return 'Rejected';
    return 'Pending';
  }

  bool _isApproved(String status) => status.toUpperCase() == 'APPROVED';
  bool _isRejected(String status) => status.toUpperCase() == 'REJECTED';

  Color _getLeaveTypeColor(String leaveType) {
    final type = leaveType.toLowerCase();
    if (type.contains('casual')) return Colors.blue;
    if (type.contains('sick')) return Colors.orange;
    if (type.contains('privilege')) return Colors.purple;
    if (type.contains('earned')) return Colors.teal;
    if (type.contains('maternity')) return Colors.pink;
    if (type.contains('paternity')) return Colors.indigo;
    return Appcolors.kprimarycolor;
  }

  IconData _getLeaveTypeIcon(String leaveType) {
    final type = leaveType.toLowerCase();
    if (type.contains('casual')) return Icons.event_available;
    if (type.contains('sick')) return Icons.sick;
    if (type.contains('privilege')) return Icons.stars;
    if (type.contains('earned')) return Icons.card_giftcard;
    if (type.contains('maternity')) return Icons.child_care;
    if (type.contains('paternity')) return Icons.family_restroom;
    return Icons.event_note;
  }

  Future<void> _openGoogleMaps(
    BuildContext context,
    double lat,
    double lng,
  ) async {
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );

    final googleMapsAppUrl = Uri.parse('geo:$lat,$lng?q=$lat,$lng');

    try {
      if (await canLaunchUrl(googleMapsAppUrl)) {
        await launchUrl(googleMapsAppUrl);
      } else if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.tr('could_not_open_maps')),
              duration: Duration(milliseconds: 1500),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              margin: EdgeInsets.only(
                bottom: ResponsiveUtils.hp(2),
                left: ResponsiveUtils.wp(4),
                right: ResponsiveUtils.wp(4),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusStyles.kradius10(),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.trParams('error_opening_maps', {'error': e}),
            ),
            duration: Duration(milliseconds: 1500),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            margin: EdgeInsets.only(
              bottom: ResponsiveUtils.hp(2),
              left: ResponsiveUtils.wp(4),
              right: ResponsiveUtils.wp(4),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusStyles.kradius10(),
            ),
          ),
        );
      }
    }
  }

  Future<void> _openDocument(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.tr('could_not_open_document')),
              duration: Duration(milliseconds: 1500),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              margin: EdgeInsets.only(
                bottom: ResponsiveUtils.hp(2),
                left: ResponsiveUtils.wp(4),
                right: ResponsiveUtils.wp(4),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusStyles.kradius10(),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.trParams('error_opening_document', {'error': e}),
            ),
            duration: Duration(milliseconds: 1500),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            margin: EdgeInsets.only(
              bottom: ResponsiveUtils.hp(2),
              left: ResponsiveUtils.wp(4),
              right: ResponsiveUtils.wp(4),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusStyles.kradius10(),
            ),
          ),
        );
      }
    }
  }

  String _getDocumentType(String url) {
    final lowerUrl = url.toLowerCase();
    if (lowerUrl.contains('.pdf')) return 'pdf';
    if (lowerUrl.contains('.jpg') ||
        lowerUrl.contains('.jpeg') ||
        lowerUrl.contains('.png')) {
      return 'image';
    }
    if (lowerUrl.contains('.doc') || lowerUrl.contains('.docx')) return 'doc';
    return 'file';
  }

  IconData _getDocumentIcon(String type) {
    switch (type) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'image':
        return Icons.image;
      case 'doc':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getDocumentColor(String type) {
    switch (type) {
      case 'pdf':
        return Colors.red;
      case 'image':
        return Colors.blue;
      case 'doc':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final leaveData = leave;

    if (leaveData == null) {
      return Scaffold(
        backgroundColor: Appcolors.kwhitecolor,
        appBar: AppBar(
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
          title: TextStyles.title(
            text: context.tr('leave_details'),
            weight: FontWeight.bold,
            color: Appcolors.kblackcolor,
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: ResponsiveUtils.sp(20),
                color: Appcolors.kgreyColor.withOpacity(0.5),
              ),
              ResponsiveSizedBox.height20,
              TextStyles.title(
                text: context.tr('no_leave_data_available'),
                color: Appcolors.kgreyColor,
              ),
            ],
          ),
        ),
      );
    }

    final String status = _getStatusDisplay(leaveData.status);
    final bool isApproved = _isApproved(leaveData.status);
    final bool isRejected = _isRejected(leaveData.status);
    final Color leaveTypeColor = _getLeaveTypeColor(
      leaveData.leaveCategoryName,
    );

    Color statusColor;
    IconData statusIcon;
    if (isApproved) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (isRejected) {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
    } else {
      statusColor = Colors.orange;
      statusIcon = Icons.pending;
    }

    return Scaffold(
      backgroundColor: Appcolors.kwhitecolor,
      appBar: AppBar(

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
        title: TextStyles.title(
          text: context.tr('leave_details'),
          weight: FontWeight.bold,
          color: Appcolors.kblackcolor,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leave Type Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(ResponsiveUtils.wp(6)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [leaveTypeColor, leaveTypeColor.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadiusStyles.kradius15(),
                boxShadow: [
                  BoxShadow(
                    color: leaveTypeColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    _getLeaveTypeIcon(leaveData.leaveCategoryName),
                    color: Appcolors.kwhitecolor,
                    size: ResponsiveUtils.sp(12),
                  ),
                  ResponsiveSizedBox.height10,
                  Text(
                    leaveData.leaveCategoryName.isNotEmpty
                        ? leaveData.leaveCategoryName
                        : 'Leave',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(6),
                      fontWeight: FontWeight.bold,
                      color: Appcolors.kwhitecolor,
                    ),
                  ),
                  ResponsiveSizedBox.height5,
                  Text(
                    '${leaveData.total} day${leaveData.total > 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(5),
                      fontWeight: FontWeight.w600,
                      color: Appcolors.kwhitecolor.withOpacity(0.9),
                    ),
                  ),
                  ResponsiveSizedBox.height10,
                  // Status Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.wp(4),
                      vertical: ResponsiveUtils.hp(0.8),
                    ),
                    decoration: BoxDecoration(
                      color: Appcolors.kwhitecolor,
                      borderRadius: BorderRadiusStyles.kradius20(),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          statusIcon,
                          color: statusColor,
                          size: ResponsiveUtils.sp(4.5),
                        ),
                        ResponsiveSizedBox.width(1.5),
                        TextStyles.medium(
                          text: status,
                          weight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ResponsiveSizedBox.height(3),

            // Date Details Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
              decoration: BoxDecoration(
                color: Appcolors.kwhitecolor,
                borderRadius: BorderRadiusStyles.kradius15(),
                boxShadow: [
                  BoxShadow(
                    color: Appcolors.kgreyColor.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextStyles.title(
                    text: context.tr('leave_period'),
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                  ),
                  ResponsiveSizedBox.height20,
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateCard(
                          label: 'From',
                          date: _formatDate(leaveData.fromDate),
                          icon: Icons.login_rounded,
                          color: Colors.green,
                        ),
                      ),
                      ResponsiveSizedBox.width(3),
                      Expanded(
                        child: _buildDateCard(
                          label: 'To',
                          date: _formatDate(leaveData.toDate),
                          icon: Icons.logout_rounded,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ResponsiveSizedBox.height(3),

            // Details Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
              decoration: BoxDecoration(
                color: Appcolors.kwhitecolor,
                borderRadius: BorderRadiusStyles.kradius15(),
                boxShadow: [
                  BoxShadow(
                    color: Appcolors.kgreyColor.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextStyles.title(
                    text: context.tr('leave_information'),
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                  ),
                  ResponsiveSizedBox.height20,

                  // Leave ID
                  _buildDetailRow(
                    icon: Icons.badge_rounded,
                    iconColor: Appcolors.kprimarycolor,
                    label: 'Leave ID',
                    value: '#${leaveData.leaveId}',
                  ),
                  ResponsiveSizedBox.height20,

                  // Approver
                  if (leaveData.approver.isNotEmpty) ...[
                    _buildDetailRow(
                      icon: Icons.person_outline,
                      iconColor: Colors.teal,
                      label: 'Approver',
                      value: leaveData.approver,
                    ),
                    ResponsiveSizedBox.height20,
                  ],

                  // Distance from HQ
                  _buildDetailRow(
                    icon: Icons.directions_walk_rounded,
                    iconColor: Appcolors.kprimarycolor,
                    label: 'Distance from HQ',
                    value:
                        '${(leaveData.distanceFromHQ / 1000).toStringAsFixed(2)} km',
                  ),
                  ResponsiveSizedBox.height20,

                  // Created Date
                  _buildDetailRow(
                    icon: Icons.access_time_rounded,
                    iconColor: Colors.indigo,
                    label: 'Created',
                    value: _formatDate(leaveData.createdDate),
                  ),
                ],
              ),
            ),

            // User Remarks Card
            if (leaveData.userRemarks.isNotEmpty) ...[
              ResponsiveSizedBox.height(3),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                decoration: BoxDecoration(
                  color: Appcolors.kwhitecolor,
                  borderRadius: BorderRadiusStyles.kradius15(),
                  boxShadow: [
                    BoxShadow(
                      color: Appcolors.kgreyColor.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadiusStyles.kradius10(),
                          ),
                          child: Icon(
                            Icons.comment,
                            color: Colors.amber.shade700,
                            size: ResponsiveUtils.sp(5),
                          ),
                        ),
                        ResponsiveSizedBox.width(2),
                        TextStyles.title(
                          text: context.tr('user_remarks'),
                          weight: FontWeight.bold,
                          color: Appcolors.kblackcolor,
                        ),
                      ],
                    ),
                    ResponsiveSizedBox.height15,
                    TextStyles.medium(
                      text: leaveData.userRemarks,
                      color: Appcolors.kgreyColor,
                    ),
                  ],
                ),
              ),
            ],

            // Approver Remarks Card (if available)
            if (leaveData.approverRemarks != null &&
                leaveData.approverRemarks!.isNotEmpty) ...[
              ResponsiveSizedBox.height(3),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                decoration: BoxDecoration(
                  color: Appcolors.kwhitecolor,
                  borderRadius: BorderRadiusStyles.kradius15(),
                  boxShadow: [
                    BoxShadow(
                      color: Appcolors.kgreyColor.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadiusStyles.kradius10(),
                          ),
                          child: Icon(
                            Icons.verified_user_rounded,
                            color: Colors.green.shade700,
                            size: ResponsiveUtils.sp(5),
                          ),
                        ),
                        ResponsiveSizedBox.width(2),
                        TextStyles.title(
                          text: context.tr('approver_remarks'),
                          weight: FontWeight.bold,
                          color: Appcolors.kblackcolor,
                        ),
                      ],
                    ),
                    ResponsiveSizedBox.height15,
                    TextStyles.medium(
                      text: leaveData.approverRemarks!,
                      color: Appcolors.kgreyColor,
                    ),
                  ],
                ),
              ),
            ],

            // Documents Card
            if (leaveData.leaveDocuments.isNotEmpty) ...[
              ResponsiveSizedBox.height(3),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                decoration: BoxDecoration(
                  color: Appcolors.kwhitecolor,
                  borderRadius: BorderRadiusStyles.kradius15(),
                  boxShadow: [
                    BoxShadow(
                      color: Appcolors.kgreyColor.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadiusStyles.kradius10(),
                          ),
                          child: Icon(
                            Icons.attachment,
                            color: Colors.blue,
                            size: ResponsiveUtils.sp(5),
                          ),
                        ),
                        ResponsiveSizedBox.width(2),
                        TextStyles.title(
                          text: context.tr('documents'),
                          weight: FontWeight.bold,
                          color: Appcolors.kblackcolor,
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUtils.wp(2.5),
                            vertical: ResponsiveUtils.hp(0.5),
                          ),
                          decoration: BoxDecoration(
                            color: Appcolors.kprimarycolor.withOpacity(0.1),
                            borderRadius: BorderRadiusStyles.kradius20(),
                          ),
                          child: TextStyles.caption(
                            text: '${leaveData.leaveDocuments.length} files',
                            weight: FontWeight.w600,
                            color: Appcolors.kprimarycolor,
                          ),
                        ),
                      ],
                    ),
                    ResponsiveSizedBox.height15,
                    // Documents List
                    ...List.generate(leaveData.leaveDocuments.length, (index) {
                      final document = leaveData.leaveDocuments[index];
                      return _buildDocumentItem(
                        context,
                        document,
                        index,
                        leaveData.leaveDocuments.length,
                      );
                    }),
                  ],
                ),
              ),
            ],

            ResponsiveSizedBox.height(3),

            // Locate on Map Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _openGoogleMaps(
                    context,
                    leaveData.leavesLatt,
                    leaveData.leavesLong,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Appcolors.kprimarycolor,
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveUtils.hp(2),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusStyles.kradius15(),
                  ),
                  elevation: 5,
                  shadowColor: Appcolors.kprimarycolor.withOpacity(0.4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map_rounded,
                      color: Appcolors.kwhitecolor,
                      size: ResponsiveUtils.sp(5),
                    ),
                    ResponsiveSizedBox.width(2),
                    TextStyles.body(
                      text: context.tr('locate_on_map'),
                      weight: FontWeight.bold,
                      color: Appcolors.kwhitecolor,
                    ),
                  ],
                ),
              ),
            ),
            ResponsiveSizedBox.height(3),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard({
    required String label,
    required String date,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadiusStyles.kradius10(),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: ResponsiveUtils.sp(6)),
          ResponsiveSizedBox.height10,
          TextStyles.caption(text: label, color: Appcolors.kgreyColor),
          ResponsiveSizedBox.height5,
          TextStyles.medium(
            text: date,
            weight: FontWeight.bold,
            color: Appcolors.kblackcolor,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadiusStyles.kradius10(),
          ),
          child: Icon(icon, color: iconColor, size: ResponsiveUtils.sp(5)),
        ),
        ResponsiveSizedBox.width(3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextStyles.caption(text: label, color: Appcolors.kgreyColor),
              ResponsiveSizedBox.height5,
              TextStyles.medium(
                text: value,
                weight: FontWeight.w600,
                color: Appcolors.kblackcolor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentItem(
    BuildContext context,
    LeaveDocument document,
    int index,
    int totalCount,
  ) {
    final docType = _getDocumentType(document.documentUrl);
    final docColor = _getDocumentColor(docType);
    final fileName = document.documentUrl.split('/').last;

    return Container(
      margin: EdgeInsets.only(
        bottom: index < totalCount - 1 ? ResponsiveUtils.hp(1.5) : 0,
      ),
      padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
      decoration: BoxDecoration(
        color: docColor.withOpacity(0.05),
        borderRadius: BorderRadiusStyles.kradius10(),
        border: Border.all(color: docColor.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.wp(2.5)),
            decoration: BoxDecoration(
              color: docColor.withOpacity(0.1),
              borderRadius: BorderRadiusStyles.kradius10(),
            ),
            child: Icon(
              _getDocumentIcon(docType),
              color: docColor,
              size: ResponsiveUtils.sp(6),
            ),
          ),
          ResponsiveSizedBox.width(3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextStyles.medium(
                  text: fileName,
                  weight: FontWeight.w600,
                  color: Appcolors.kblackcolor,
                  overflow: TextOverflow.ellipsis,
                ),
                ResponsiveSizedBox.height5,
                TextStyles.caption(
                  text: docType.toUpperCase(),
                  color: Appcolors.kgreyColor,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              _openDocument(context, document.documentUrl);
            },
            icon: Icon(
              Icons.download_rounded,
              color: docColor,
              size: ResponsiveUtils.sp(5.5),
            ),
          ),
        ],
      ),
    );
  }
}
