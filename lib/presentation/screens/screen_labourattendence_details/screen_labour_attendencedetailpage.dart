import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/data/models/labor_attendance_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';

class ScreenLabourAttendanceDetailsPage extends StatelessWidget {
  final LaborAttendanceModel? attendance;

  const ScreenLabourAttendanceDetailsPage({super.key, this.attendance});

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
              content: Text('Could not open maps'),
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
            content: Text('Error opening maps: $e'),
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

  @override
  Widget build(BuildContext context) {
    final attendanceData = attendance;

    if (attendanceData == null) {
      return Scaffold(
        backgroundColor: Appcolors.kwhitecolor,
        appBar: AppBar(
          backgroundColor: Appcolors.kwhitecolor,
          elevation: 2,
          shadowColor: Appcolors.kgreyColor.withOpacity(0.1),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Appcolors.kprimarycolor,
              size: ResponsiveUtils.sp(5),
            ),
          ),
          title: TextStyles.subheadline(
            text: 'Attendance Detail',
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
              TextStyles.subheadline(
                text: 'No attendance data available',
                color: Appcolors.kgreyColor,
              ),
            ],
          ),
        ),
      );
    }

    final String status = _getStatusDisplay(attendanceData.status);
    final bool isApproved = _isApproved(attendanceData.status);
    final bool isRejected = _isRejected(attendanceData.status);
    final bool isContract =
        attendanceData.laborType.toUpperCase() == 'CONTRACT';
    final String displayName = isContract
        ? (attendanceData.contractorName.isNotEmpty
              ? attendanceData.contractorName
              : 'Contractor')
        : (attendanceData.laborName.isNotEmpty
              ? attendanceData.laborName
              : 'Casual Labour');

    return Scaffold(
      backgroundColor: Appcolors.kwhitecolor,
      appBar: AppBar(
        backgroundColor: Appcolors.kwhitecolor,
        elevation: 2,
        shadowColor: Appcolors.kgreyColor.withOpacity(0.1),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Appcolors.kprimarycolor,
            size: ResponsiveUtils.sp(5),
          ),
        ),
        title: TextStyles.subheadline(
          text: 'Attendance Detail',
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
            // Login and Logout Images
            Container(
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
                  TextStyles.subheadline(
                    text: 'Attendance Images',
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                  ),
                  ResponsiveSizedBox.height15,
                  Row(
                    children: [
                      // Login Image
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              height: ResponsiveUtils.hp(20),
                              decoration: BoxDecoration(
                                color: Appcolors.kgreyColor.withOpacity(0.1),
                                borderRadius: BorderRadiusStyles.kradius10(),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadiusStyles.kradius10(),
                                child: Stack(
                                  children: [
                                    attendanceData.picture.isNotEmpty
                                        ? Image.network(
                                            attendanceData.picture,
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Center(
                                                      child: Icon(
                                                        Icons.image,
                                                        size:
                                                            ResponsiveUtils.sp(
                                                              15,
                                                            ),
                                                        color: Appcolors
                                                            .kgreyColor
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                          )
                                        : Center(
                                            child: Icon(
                                              Icons.image,
                                              size: ResponsiveUtils.sp(15),
                                              color: Appcolors.kgreyColor
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                    Positioned(
                                      top: ResponsiveUtils.hp(1),
                                      left: ResponsiveUtils.wp(2),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: ResponsiveUtils.wp(2),
                                          vertical: ResponsiveUtils.hp(0.5),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadiusStyles.kradius5(),
                                        ),
                                        child: TextStyles.caption(
                                          text: 'LOGIN',
                                          weight: FontWeight.bold,
                                          color: Appcolors.kwhitecolor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ResponsiveSizedBox.height10,
                            TextStyles.medium(
                              text: attendanceData.punchIn.isNotEmpty
                                  ? attendanceData.punchIn
                                  : 'N/A',
                              weight: FontWeight.w600,
                              color: Colors.green.shade700,
                            ),
                          ],
                        ),
                      ),
                      ResponsiveSizedBox.width(3),
                      // Logout Image
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              height: ResponsiveUtils.hp(20),
                              decoration: BoxDecoration(
                                color: Appcolors.kgreyColor.withOpacity(0.1),
                                borderRadius: BorderRadiusStyles.kradius10(),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadiusStyles.kradius10(),
                                child: Stack(
                                  children: [
                                    attendanceData.punchOutPicture.isNotEmpty
                                        ? Image.network(
                                            attendanceData.punchOutPicture,
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Center(
                                                      child: Icon(
                                                        Icons.image,
                                                        size:
                                                            ResponsiveUtils.sp(
                                                              15,
                                                            ),
                                                        color: Appcolors
                                                            .kgreyColor
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                          )
                                        : Center(
                                            child: Icon(
                                              Icons.image,
                                              size: ResponsiveUtils.sp(15),
                                              color: Appcolors.kgreyColor
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                    Positioned(
                                      top: ResponsiveUtils.hp(1),
                                      left: ResponsiveUtils.wp(2),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: ResponsiveUtils.wp(2),
                                          vertical: ResponsiveUtils.hp(0.5),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadiusStyles.kradius5(),
                                        ),
                                        child: TextStyles.caption(
                                          text: 'LOGOUT',
                                          weight: FontWeight.bold,
                                          color: Appcolors.kwhitecolor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ResponsiveSizedBox.height10,
                            TextStyles.medium(
                              text: attendanceData.punchOut.isNotEmpty
                                  ? attendanceData.punchOut
                                  : 'N/A',
                              weight: FontWeight.w600,
                              color: Colors.red.shade700,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ResponsiveSizedBox.height20,

            // Attendance Details Card
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.wp(5)),
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
                  TextStyles.subheadline(
                    text: 'Attendance Information',
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                  ),
                  ResponsiveSizedBox.height20,

                  // Attendance ID
                  _buildDetailRow(
                    icon: Icons.badge_rounded,
                    label: 'Attendance ID',
                    value: '#${attendanceData.attendanceId}',
                    iconColor: Appcolors.kprimarycolor,
                  ),
                  ResponsiveSizedBox.height15,
                  _buildDivider(),
                  ResponsiveSizedBox.height15,

                  // Type
                  _buildDetailRow(
                    icon: Icons.work_rounded,
                    label: 'Type',
                    value: isContract ? 'Contract' : 'Casual',
                    iconColor: isContract
                        ? Colors.purple.shade700
                        : Colors.teal.shade700,
                    valueWidget: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.wp(3),
                        vertical: ResponsiveUtils.hp(0.5),
                      ),
                      decoration: BoxDecoration(
                        color: isContract
                            ? Colors.purple.withOpacity(0.1)
                            : Colors.teal.withOpacity(0.1),
                        borderRadius: BorderRadiusStyles.kradius5(),
                      ),
                      child: TextStyles.medium(
                        text: isContract ? 'Contract' : 'Casual',
                        weight: FontWeight.w600,
                        color: isContract
                            ? Colors.purple.shade700
                            : Colors.teal.shade700,
                      ),
                    ),
                  ),
                  ResponsiveSizedBox.height15,
                  _buildDivider(),
                  ResponsiveSizedBox.height15,

                  // Name (Contractor or Labour)
                  _buildDetailRow(
                    icon: isContract
                        ? Icons.business_rounded
                        : Icons.person_rounded,
                    label: isContract ? 'Contractor Name' : 'Labour Name',
                    value: displayName,
                    iconColor: Colors.blue.shade700,
                  ),
                  if (!isContract && attendanceData.laborMobile.isNotEmpty) ...[
                    ResponsiveSizedBox.height15,
                    _buildDivider(),
                    ResponsiveSizedBox.height15,
                    _buildDetailRow(
                      icon: Icons.phone_rounded,
                      label: 'Mobile',
                      value: attendanceData.laborMobile,
                      iconColor: Colors.green.shade700,
                    ),
                  ],
                  if (isContract) ...[
                    ResponsiveSizedBox.height15,
                    _buildDivider(),
                    ResponsiveSizedBox.height15,
                    // Total Labours
                    _buildDetailRow(
                      icon: Icons.groups_rounded,
                      label: 'Total Labours',
                      value: attendanceData.totalLabours.toString(),
                      iconColor: Colors.orange.shade700,
                    ),
                  ],
                  ResponsiveSizedBox.height15,
                  _buildDivider(),
                  ResponsiveSizedBox.height15,

                  // Hire Date
                  _buildDetailRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Hire Date',
                    value: _formatDate(attendanceData.hireDate),
                    iconColor: Appcolors.kprimarycolor,
                  ),
                  ResponsiveSizedBox.height15,
                  _buildDivider(),
                  ResponsiveSizedBox.height15,

                  // Punch In & Punch Out
                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailRow(
                          icon: Icons.login_rounded,
                          label: 'Punch In',
                          value: attendanceData.punchIn.isNotEmpty
                              ? attendanceData.punchIn
                              : 'N/A',
                          iconColor: Colors.green,
                        ),
                      ),
                      ResponsiveSizedBox.width(2),
                      Expanded(
                        child: _buildDetailRow(
                          icon: Icons.logout_rounded,
                          label: 'Punch Out',
                          value: attendanceData.punchOut.isNotEmpty
                              ? attendanceData.punchOut
                              : 'N/A',
                          iconColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height15,
                  _buildDivider(),
                  ResponsiveSizedBox.height15,

                  // Total Hours
                  _buildDetailRow(
                    icon: Icons.access_time_rounded,
                    label: 'Total Hours',
                    value: attendanceData.totalHours.isNotEmpty
                        ? attendanceData.totalHours
                        : 'N/A',
                    iconColor: Colors.indigo.shade700,
                  ),
                  ResponsiveSizedBox.height15,
                  _buildDivider(),
                  ResponsiveSizedBox.height15,

                  // Total Wages
                  _buildDetailRow(
                    icon: Icons.currency_rupee_rounded,
                    label: 'Wages',
                    value: '₹${attendanceData.wages.toStringAsFixed(2)}',
                    iconColor: Colors.green.shade700,
                    valueWidget: TextStyles.medium(
                      text: '₹${attendanceData.wages.toStringAsFixed(2)}',
                      weight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  ResponsiveSizedBox.height15,
                  _buildDivider(),
                  ResponsiveSizedBox.height15,

                  // Distance from HQ
                  _buildDetailRow(
                    icon: Icons.directions_walk_rounded,
                    label: 'Distance from HQ',
                    value:
                        '${(attendanceData.distanceFromHQ / 1000).toStringAsFixed(2)} km',
                    iconColor: Appcolors.kprimarycolor,
                  ),
                  ResponsiveSizedBox.height15,
                  _buildDivider(),
                  ResponsiveSizedBox.height15,

                  // Status
                  _buildDetailRow(
                    icon: isApproved
                        ? Icons.check_circle_rounded
                        : isRejected
                        ? Icons.cancel_rounded
                        : Icons.pending_rounded,
                    label: 'Status',
                    value: status,
                    iconColor: isApproved
                        ? Colors.green
                        : isRejected
                        ? Colors.red
                        : Colors.orange,
                    valueWidget: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.wp(3),
                        vertical: ResponsiveUtils.hp(0.5),
                      ),
                      decoration: BoxDecoration(
                        color: isApproved
                            ? Colors.green.withOpacity(0.1)
                            : isRejected
                            ? Colors.red.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadiusStyles.kradius5(),
                      ),
                      child: TextStyles.medium(
                        text: status,
                        weight: FontWeight.w600,
                        color: isApproved
                            ? Colors.green.shade700
                            : isRejected
                            ? Colors.red.shade700
                            : Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ResponsiveSizedBox.height20,

            // Remarks Section
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.wp(5)),
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
                  TextStyles.subheadline(
                    text: 'Remarks',
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                  ),
                  ResponsiveSizedBox.height20,

                  // User Remarks
                  _buildRemarksBox(
                    icon: Icons.person_rounded,
                    label: 'User Remarks',
                    remarks: attendanceData.userRemarks.isNotEmpty
                        ? attendanceData.userRemarks
                        : 'No remarks',
                    iconColor: Colors.blue.shade700,
                  ),
                  if (attendanceData.approverRemarks != null &&
                      attendanceData.approverRemarks!.isNotEmpty) ...[
                    ResponsiveSizedBox.height15,
                    // Approver Remarks
                    _buildRemarksBox(
                      icon: Icons.verified_user_rounded,
                      label: 'Approver Remarks',
                      remarks: attendanceData.approverRemarks!,
                      iconColor: Colors.green.shade700,
                    ),
                  ],
                ],
              ),
            ),
            ResponsiveSizedBox.height20,

            // Locate on Map Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _openGoogleMaps(
                    context,
                    attendanceData.attendanceLatt,
                    attendanceData.attendanceLong,
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
                      text: 'Locate on Map',
                      weight: FontWeight.bold,
                      color: Appcolors.kwhitecolor,
                    ),
                  ],
                ),
              ),
            ),
            ResponsiveSizedBox.height20,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    Widget? valueWidget,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(ResponsiveUtils.wp(2.5)),
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
              valueWidget ??
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

  Widget _buildRemarksBox({
    required IconData icon,
    required String label,
    required String remarks,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.05),
        borderRadius: BorderRadiusStyles.kradius10(),
        border: Border.all(color: iconColor.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: ResponsiveUtils.sp(4.5)),
              ResponsiveSizedBox.width(2),
              TextStyles.medium(
                text: label,
                weight: FontWeight.bold,
                color: iconColor,
              ),
            ],
          ),
          ResponsiveSizedBox.height10,
          TextStyles.medium(text: remarks, color: Appcolors.kblackcolor),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Appcolors.kgreyColor.withOpacity(0.2), height: 1);
  }
}
