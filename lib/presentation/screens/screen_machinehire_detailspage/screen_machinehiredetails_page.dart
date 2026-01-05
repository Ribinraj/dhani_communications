import 'package:dhani_communications/core/constants.dart';
import 'package:flutter/material.dart';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';

class ScreenMachineHireDetailPage extends StatefulWidget {
  const ScreenMachineHireDetailPage({super.key});

  @override
  State<ScreenMachineHireDetailPage> createState() =>
      _ScreenMachineHireDetailPageState();
}

class _ScreenMachineHireDetailPageState extends State<ScreenMachineHireDetailPage> {
  // Sample machine hire detail data
  final Map<String, dynamic> machineHireDetail = {
    'hire': 'MH-2026-001',
    'projectName': 'Construction Project - Tower B',
    'machine': 'JCB Excavator 3DX',
    'hireDate': '03 Jan 2026',
    'fromTime': '09:00 AM',
    'toTime': '06:00 PM',
    'totalHours': '9 hours',
    'amountPaid': '₹15,000',
    'remarks': 'Machine required for excavation work at site. Operator included with machine hire. Fuel charges extra as per actual consumption.',
    'approver': 'Rajesh Kumar',
    'approverRemarks': 'Approved for urgent excavation work. Please ensure safety protocols are followed.',
    'requestCreated': '02 Jan 2026, 03:30 PM',
    'status': 'Rejected',
  };

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'Pending':
        return Colors.orange;
      default:
        return Appcolors.kgreyColor;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Approved':
        return Icons.check_circle;
      case 'Rejected':
        return Icons.cancel;
      case 'Pending':
        return Icons.pending;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String status = machineHireDetail['status'];
    final Color statusColor = _getStatusColor(status);
    final IconData statusIcon = _getStatusIcon(status);

    return Scaffold(
      backgroundColor: Appcolors.kwhitecolor,
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
          text: 'Machine Hire Details',
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
            // Hire Information Card
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
                  TextStyles.subheadline(
                    text: 'Hire Information',
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                  ),
                  ResponsiveSizedBox.height20,

                  // Hire ID
                  _buildDetailRow(
                    icon: Icons.tag,
                    iconColor: Appcolors.kprimarycolor,
                    label: 'Hire ID',
                    value: machineHireDetail['hire'],
                  ),
                  ResponsiveSizedBox.height20,

                  // Project Name
                  _buildDetailRow(
                    icon: Icons.work_outline,
                    iconColor: Colors.purple,
                    label: 'Project Name',
                    value: machineHireDetail['projectName'],
                  ),
                  ResponsiveSizedBox.height20,

                  // Machine
                  _buildDetailRow(
                    icon: Icons.construction,
                    iconColor: Colors.orange,
                    label: 'Machine',
                    value: machineHireDetail['machine'],
                  ),
                  ResponsiveSizedBox.height20,

                  // Hire Date
                  _buildDetailRow(
                    icon: Icons.calendar_today,
                    iconColor: Colors.blue,
                    label: 'Hire Date',
                    value: machineHireDetail['hireDate'],
                  ),
                  ResponsiveSizedBox.height20,

                  // Time Details Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailRow(
                          icon: Icons.access_time,
                          iconColor: Colors.teal,
                          label: 'From Time',
                          value: machineHireDetail['fromTime'],
                        ),
                      ),
                      ResponsiveSizedBox.width(2),
                      Expanded(
                        child: _buildDetailRow(
                          icon: Icons.access_time_filled,
                          iconColor: Colors.indigo,
                          label: 'To Time',
                          value: machineHireDetail['toTime'],
                        ),
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height20,

                  // Total Hours
                  _buildDetailRow(
                    icon: Icons.timer,
                    iconColor: Colors.deepOrange,
                    label: 'Total Hours',
                    value: machineHireDetail['totalHours'],
                  ),
                  ResponsiveSizedBox.height20,

                  // Amount Paid
                  _buildDetailRow(
                    icon: Icons.currency_rupee,
                    iconColor: Colors.green,
                    label: 'Amount Paid',
                    value: machineHireDetail['amountPaid'],
                  ),
                  ResponsiveSizedBox.height20,

                  // Status
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadiusStyles.kradius10(),
                        ),
                        child: Icon(
                          statusIcon,
                          color: statusColor,
                          size: ResponsiveUtils.sp(5),
                        ),
                      ),
                      ResponsiveSizedBox.width(3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextStyles.caption(
                              text: 'Status',
                              color: Appcolors.kgreyColor,
                            ),
                            ResponsiveSizedBox.height5,
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveUtils.wp(3),
                                vertical: ResponsiveUtils.hp(0.6),
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadiusStyles.kradius5(),
                              ),
                              child: TextStyles.medium(
                                text: status,
                                weight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height20,

                  // Request Created
                  _buildDetailRow(
                    icon: Icons.schedule,
                    iconColor: Colors.brown,
                    label: 'Request Created',
                    value: machineHireDetail['requestCreated'],
                  ),
                ],
              ),
            ),
            ResponsiveSizedBox.height(3),

            // User Remarks Card
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
                      TextStyles.subheadline(
                        text: 'Remarks',
                        weight: FontWeight.bold,
                        color: Appcolors.kblackcolor,
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height15,
                  TextStyles.medium(
                    text: machineHireDetail['remarks'],
                    color: Appcolors.kgreyColor,
                  ),
                ],
              ),
            ),
            ResponsiveSizedBox.height(3),

            // Approver Information Card
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
                  TextStyles.subheadline(
                    text: 'Approver Information',
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                  ),
                  ResponsiveSizedBox.height20,

                  // Approver
                  _buildDetailRow(
                    icon: Icons.person_outline,
                    iconColor: Colors.teal,
                    label: 'Approver',
                    value: machineHireDetail['approver'],
                  ),
                  ResponsiveSizedBox.height20,

                  // Approver Remarks
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
                        decoration: BoxDecoration(
                          color: Colors.pink.withOpacity(0.1),
                          borderRadius: BorderRadiusStyles.kradius10(),
                        ),
                        child: Icon(
                          Icons.rate_review,
                          color: Colors.pink,
                          size: ResponsiveUtils.sp(5),
                        ),
                      ),
                      ResponsiveSizedBox.width(3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextStyles.caption(
                              text: 'Approver Remarks',
                              color: Appcolors.kgreyColor,
                            ),
                            ResponsiveSizedBox.height5,
                            TextStyles.medium(
                              text: machineHireDetail['approverRemarks'],
                              color: Appcolors.kblackcolor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ResponsiveSizedBox.height(3),
          ],
        ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
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