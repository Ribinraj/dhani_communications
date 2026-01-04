import 'package:dhani_communications/core/constants.dart';
import 'package:flutter/material.dart';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';

class ScreenLabourAttendanceDetailsPage extends StatelessWidget {
  const ScreenLabourAttendanceDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample labour attendance data
    final Map<String, dynamic> labourAttendanceData = {
      'attendance': 'ATT-2026-001',
      'type': 'Contract',
      'contractorName': 'ABC Contractors Pvt Ltd',
      'totalLabours': '25',
      'hireDate': '15 Dec 2025',
      'punchIn': '09:00 AM',
      'punchOut': '06:00 PM',
      'totalHours': '9 hours',
      'totalWages': '₹22,500',
      'distanceFromHQ': '12.5 km',
      'status': 'Approved', // Can be: Approved, Rejected, Pending
      'userRemarks': 'All labours present and worked full shift',
      'approverRemarks': 'Verified and approved for payment',
      'loginImageUrl': 'https://via.placeholder.com/400x300', // Replace with actual image
      'logoutImageUrl': 'https://via.placeholder.com/400x300', // Replace with actual image
    };

    final String status = labourAttendanceData['status'] ?? 'Pending';
    final bool isApproved = status == 'Approved';
    final bool isRejected = status == 'Rejected';

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
                                    // Replace with actual network image
                                    Center(
                                      child: Icon(
                                        Icons.image,
                                        size: ResponsiveUtils.sp(15),
                                        color: Appcolors.kgreyColor.withOpacity(0.5),
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
                                          borderRadius: BorderRadiusStyles.kradius5(),
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
                              text: labourAttendanceData['punchIn'] ?? 'N/A',
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
                                    // Replace with actual network image
                                    Center(
                                      child: Icon(
                                        Icons.image,
                                        size: ResponsiveUtils.sp(15),
                                        color: Appcolors.kgreyColor.withOpacity(0.5),
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
                                          borderRadius: BorderRadiusStyles.kradius5(),
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
                              text: labourAttendanceData['punchOut'] ?? 'N/A',
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
                    label: 'Attendance',
                    value: labourAttendanceData['attendance'] ?? 'N/A',
                    iconColor: Appcolors.kprimarycolor,
                  ),
                  ResponsiveSizedBox.height15,
                  _buildDivider(),
                  ResponsiveSizedBox.height15,

                  // Type
                  _buildDetailRow(
                    icon: Icons.work_rounded,
                    label: 'Type',
                    value: labourAttendanceData['type'] ?? 'N/A',
                    iconColor: Colors.purple.shade700,
                    valueWidget: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.wp(3),
                        vertical: ResponsiveUtils.hp(0.5),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadiusStyles.kradius5(),
                      ),
                      child: TextStyles.medium(
                        text: labourAttendanceData['type'] ?? 'N/A',
                        weight: FontWeight.w600,
                        color: Colors.purple.shade700,
                      ),
                    ),
                  ),
                  ResponsiveSizedBox.height15,
                  _buildDivider(),
                  ResponsiveSizedBox.height15,

                  // Contractor Name
                  _buildDetailRow(
                    icon: Icons.business_rounded,
                    label: 'Contractor Name',
                    value: labourAttendanceData['contractorName'] ?? 'N/A',
                    iconColor: Colors.blue.shade700,
                  ),
                  ResponsiveSizedBox.height15,
                  _buildDivider(),
                  ResponsiveSizedBox.height15,

                  // Total Labours
                  _buildDetailRow(
                    icon: Icons.groups_rounded,
                    label: 'Total Labours',
                    value: labourAttendanceData['totalLabours'] ?? 'N/A',
                    iconColor: Colors.orange.shade700,
                  ),
                  ResponsiveSizedBox.height15,
                  _buildDivider(),
                  ResponsiveSizedBox.height15,

                  // Hire Date
                  _buildDetailRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Hire Date',
                    value: labourAttendanceData['hireDate'] ?? 'N/A',
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
                          value: labourAttendanceData['punchIn'] ?? 'N/A',
                          iconColor: Colors.green,
                        ),
                      ),
                      ResponsiveSizedBox.width(2),
                      Expanded(
                        child: _buildDetailRow(
                          icon: Icons.logout_rounded,
                          label: 'Punch Out',
                          value: labourAttendanceData['punchOut'] ?? 'N/A',
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
                    value: labourAttendanceData['totalHours'] ?? 'N/A',
                    iconColor: Colors.indigo.shade700,
                  ),
                  ResponsiveSizedBox.height15,
                  _buildDivider(),
                  ResponsiveSizedBox.height15,

                  // Total Wages
                  _buildDetailRow(
                    icon: Icons.currency_rupee_rounded,
                    label: 'Total Wages',
                    value: labourAttendanceData['totalWages'] ?? 'N/A',
                    iconColor: Colors.green.shade700,
                    valueWidget: TextStyles.medium(
                      text: labourAttendanceData['totalWages'] ?? 'N/A',
                      weight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  ResponsiveSizedBox.height15,
                  _buildDivider(),
                  ResponsiveSizedBox.height15,

                  // Distance from HQ
                  _buildDetailRow(
                    icon: Icons.location_on_rounded,
                    label: 'Distance from HQ',
                    value: labourAttendanceData['distanceFromHQ'] ?? 'N/A',
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
                    remarks: labourAttendanceData['userRemarks'] ?? 'No remarks',
                    iconColor: Colors.blue.shade700,
                  ),
                  ResponsiveSizedBox.height15,

                  // Approver Remarks
                  _buildRemarksBox(
                    icon: Icons.verified_user_rounded,
                    label: 'Approver Remarks',
                    remarks: labourAttendanceData['approverRemarks'] ?? 'No remarks',
                    iconColor: Colors.green.shade700,
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
        border: Border.all(
          color: iconColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: ResponsiveUtils.sp(4.5),
              ),
              ResponsiveSizedBox.width(2),
              TextStyles.medium(
                text: label,
                weight: FontWeight.bold,
                color: iconColor,
              ),
            ],
          ),
          ResponsiveSizedBox.height10,
          TextStyles.medium(
            text: remarks,
            color: Appcolors.kblackcolor,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Appcolors.kgreyColor.withOpacity(0.2),
      height: 1,
    );
  }
}