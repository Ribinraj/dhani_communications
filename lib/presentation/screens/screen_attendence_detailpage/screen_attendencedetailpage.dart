import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/data/models/attendance_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';

class ScreenAttendanceDetailsPage extends StatelessWidget {
  final AttendanceModel? attendance;

  const ScreenAttendanceDetailsPage({super.key, this.attendance});

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

  String _getStatusFromAttendance(double attendance) {
    if (attendance >= 1.0) return 'Present';
    if (attendance >= 0.5) return 'Half Day';
    return 'Absent';
  }

  String _getSession(String attendanceType) {
    // Use attendanceType from API: MORNING, AFTERNOON, etc.
    if (attendanceType.toUpperCase() == 'MORNING') return 'Morning';
    if (attendanceType.toUpperCase() == 'AFTERNOON') return 'Afternoon';
    return attendanceType.isNotEmpty ? attendanceType : 'Morning';
  }

  Future<void> _openGoogleMaps(
    BuildContext context,
    double lat,
    double lng,
  ) async {
    // Try to open in Google Maps app first, fallback to browser
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );

    final googleMapsAppUrl = Uri.parse('geo:$lat,$lng?q=$lat,$lng');

    try {
      // Try to open in Google Maps app (Android)
      if (await canLaunchUrl(googleMapsAppUrl)) {
        await launchUrl(googleMapsAppUrl);
      }
      // Fallback to browser
      else if (await canLaunchUrl(googleMapsUrl)) {
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
    // Use provided attendance or fallback to sample data
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
            text: 'Attendance Details',
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

    final status = _getStatusFromAttendance(attendanceData.attendance);
    final bool isPresent = status == 'Present' || status == 'Half Day';
    final bool isApproved = attendanceData.status.toLowerCase() == 'approved';
    final session = _getSession(attendanceData.attendanceType);
    final attendanceId = attendanceData.attendanceId.toString();

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
          text: 'Attendance Details',
          weight: FontWeight.bold,
          color: Appcolors.kblackcolor,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
        child: Column(
          children: [
            // Profile Card
            Container(
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveUtils.wp(5),
                horizontal: ResponsiveUtils.wp(20),
              ),
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
                children: [
                  // Profile Image or Picture
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isPresent
                            ? Colors.green.withOpacity(0.5)
                            : Colors.red.withOpacity(0.5),
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: ResponsiveUtils.wp(13),
                      backgroundColor: Appcolors.kgreyColor.withOpacity(0.2),
                      backgroundImage: attendanceData.picture.isNotEmpty
                          ? NetworkImage(attendanceData.picture)
                          : null,
                      child: attendanceData.picture.isEmpty
                          ? Icon(
                              Icons.person,
                              size: ResponsiveUtils.sp(15),
                              color: Appcolors.kprimarycolor,
                            )
                          : null,
                    ),
                  ),
                  ResponsiveSizedBox.height20,
                  // Attendance ID
                  TextStyles.subheadline(
                    text: 'Attendance Record',
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                  ),
                  ResponsiveSizedBox.height5,
                  // Attendance ID Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.wp(3),
                      vertical: ResponsiveUtils.hp(0.5),
                    ),
                    decoration: BoxDecoration(
                      color: Appcolors.kprimarycolor.withOpacity(0.1),
                      borderRadius: BorderRadiusStyles.kradius10(),
                    ),
                    child: TextStyles.medium(
                      text: 'ID #$attendanceId',
                      weight: FontWeight.w600,
                      color: Appcolors.kprimarycolor,
                    ),
                  ),
                  ResponsiveSizedBox.height20,
                  // Approval Status Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.wp(4),
                      vertical: ResponsiveUtils.hp(1),
                    ),
                    decoration: BoxDecoration(
                      color: isApproved
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadiusStyles.kradius10(),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isApproved ? Icons.check_circle : Icons.pending,
                          color: isApproved ? Colors.green : Colors.orange,
                          size: ResponsiveUtils.sp(5),
                        ),
                        ResponsiveSizedBox.width(2),
                        TextStyles.medium(
                          text: isApproved ? 'Approved' : 'Pending Approval',
                          weight: FontWeight.w600,
                          color: isApproved
                              ? Colors.green.shade700
                              : Colors.orange.shade700,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ResponsiveSizedBox.height20,
            // Details Card
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
                  // Date
                  _buildDetailRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Date',
                    value: _formatDate(attendanceData.attendanceDate),
                    iconColor: Appcolors.kprimarycolor,
                  ),
                  ResponsiveSizedBox.height15,
                  Divider(
                    color: Appcolors.kgreyColor.withOpacity(0.2),
                    height: 1,
                  ),
                  ResponsiveSizedBox.height15,
                  // Session Type
                  _buildDetailRow(
                    icon: Icons.access_time_rounded,
                    label: 'Session Type',
                    value: session,
                    iconColor: session == 'Morning'
                        ? Colors.orange.shade700
                        : Colors.blue.shade700,
                    valueWidget: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.wp(3),
                        vertical: ResponsiveUtils.hp(0.5),
                      ),
                      decoration: BoxDecoration(
                        color: session == 'Morning'
                            ? Colors.orange.withOpacity(0.1)
                            : Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadiusStyles.kradius5(),
                      ),
                      child: TextStyles.medium(
                        text: session,
                        weight: FontWeight.w600,
                        color: session == 'Morning'
                            ? Colors.orange.shade700
                            : Colors.blue.shade700,
                      ),
                    ),
                  ),
                  ResponsiveSizedBox.height15,
                  Divider(
                    color: Appcolors.kgreyColor.withOpacity(0.2),
                    height: 1,
                  ),
                  ResponsiveSizedBox.height15,
                  // Attendance Value
                  _buildDetailRow(
                    icon: Icons.timelapse_rounded,
                    label: 'Attendance Value',
                    value: attendanceData.attendance.toStringAsFixed(1),
                    iconColor: Appcolors.kprimarycolor,
                  ),

                  ResponsiveSizedBox.height15,
                  Divider(
                    color: Appcolors.kgreyColor.withOpacity(0.2),
                    height: 1,
                  ),
                  ResponsiveSizedBox.height15,
                  // Distance from HQ
                  _buildDetailRow(
                    icon: Icons.social_distance_rounded,
                    label: 'Distance from HQ',
                    value:
                        '${(attendanceData.distanceFromHQ / 1000).toStringAsFixed(2)} km',
                    iconColor: Appcolors.kprimarycolor,
                  ),
                  ResponsiveSizedBox.height15,
                  Divider(
                    color: Appcolors.kgreyColor.withOpacity(0.2),
                    height: 1,
                  ),
                  ResponsiveSizedBox.height15,
                  // Attendance Status
                  _buildDetailRow(
                    icon: isPresent
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded,
                    label: 'Attendance Status',
                    value: status,
                    iconColor: isPresent ? Colors.green : Colors.red,
                    valueWidget: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.wp(3),
                        vertical: ResponsiveUtils.hp(0.5),
                      ),
                      decoration: BoxDecoration(
                        color: isPresent
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadiusStyles.kradius5(),
                      ),
                      child: TextStyles.medium(
                        text: status,
                        weight: FontWeight.w600,
                        color: isPresent
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                    ),
                  ),
                  if (attendanceData.userRemarks.isNotEmpty) ...[
                    ResponsiveSizedBox.height15,
                    Divider(
                      color: Appcolors.kgreyColor.withOpacity(0.2),
                      height: 1,
                    ),
                    ResponsiveSizedBox.height15,
                    // User Remarks
                    _buildDetailRow(
                      icon: Icons.notes_rounded,
                      label: 'Remarks',
                      value: attendanceData.userRemarks,
                      iconColor: Appcolors.kprimarycolor,
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
}
