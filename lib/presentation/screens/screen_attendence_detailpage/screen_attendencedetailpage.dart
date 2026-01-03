import 'package:dhani_communications/core/constants.dart';
import 'package:flutter/material.dart';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';

class ScreenAttendanceDetailsPage extends StatelessWidget {
  const ScreenAttendanceDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample attendance data
    final Map<String, dynamic> attendanceData = {
      'employeeName': 'John Doe',
      'date': '03 Jan 2026',
      'session': 'Morning',
      'km': '345 km',
      'status': 'Present',
      'approved': true,
      'id': '123',
    };

    final bool isPresent = attendanceData['status'] == 'Present';
    final bool isApproved = attendanceData['approved'] == true;
    final String attendanceId = attendanceData['id'] ?? '123';

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
              padding: EdgeInsets.symmetric(vertical:  ResponsiveUtils.wp(5), horizontal: ResponsiveUtils.wp(20)),
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
                  // Profile Image
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
                      child: Icon(
                        Icons.person,
                        size: ResponsiveUtils.sp(15),
                        color: Appcolors.kprimarycolor,
                      ),
                    ),
                  ),
                  ResponsiveSizedBox.height20,
                  // Employee Name
                  TextStyles.subheadline(
                    text: attendanceData['employeeName'] ?? 'N/A',
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                  ),
                  ResponsiveSizedBox.height5,
                  // Attendance ID
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
                      text: 'Attendance #$attendanceId',
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
                    value: attendanceData['date'] ?? 'N/A',
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
                    value: attendanceData['session'] ?? 'N/A',
                    iconColor: attendanceData['session'] == 'Morning'
                        ? Colors.orange.shade700
                        : Colors.blue.shade700,
                    valueWidget: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.wp(3),
                        vertical: ResponsiveUtils.hp(0.5),
                      ),
                      decoration: BoxDecoration(
                        color: attendanceData['session'] == 'Morning'
                            ? Colors.orange.withOpacity(0.1)
                            : Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadiusStyles.kradius5(),
                      ),
                      child: TextStyles.medium(
                        text: attendanceData['session'] ?? 'N/A',
                        weight: FontWeight.w600,
                        color: attendanceData['session'] == 'Morning'
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
                  // Distance from HQ
                  _buildDetailRow(
                    icon: Icons.location_on_rounded,
                    label: 'Distance from HQ',
                    value: attendanceData['km'] ?? 'N/A',
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
                    value: attendanceData['status'] ?? 'N/A',
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
                        text: attendanceData['status'] ?? 'N/A',
                        weight: FontWeight.w600,
                        color: isPresent
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ResponsiveSizedBox.height20,
            // Locate on Map Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to map or show map
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening location on map...'),
                      duration: Duration(milliseconds: 1500),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Appcolors.kprimarycolor,
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
          child: Icon(
            icon,
            color: iconColor,
            size: ResponsiveUtils.sp(5),
          ),
        ),
        ResponsiveSizedBox.width(3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextStyles.caption(
                text: label,
                color: Appcolors.kgreyColor,
              ),
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