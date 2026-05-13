import 'package:dhani_communications/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';
import 'package:dhani_communications/features/approvals/models/approvels_attendencemodel.dart';
import 'package:dhani_communications/core/localization/app_localization.dart';

class ScreenApproveAttendanceDetailPage extends StatelessWidget {
  final ApprovelsAttendencemodel attendance;

  const ScreenApproveAttendanceDetailPage({
    super.key,
    required this.attendance,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPending = attendance.status == 'PENDING';
    final bool isMorning = attendance.attendanceType == 'MORNING';

    return Scaffold(
      backgroundColor: Appcolors.kwhitecolor,
      appBar: AppBar(
        backgroundColor: Appcolors.kwhitecolor,
        elevation: 2,
        shadowColor: Appcolors.kgreyColor.withOpacity(0.1),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Appcolors.kprimarycolor,
            size: ResponsiveUtils.sp(5),
          ),
        ),
        title: TextStyles.subheadline(
          text: context.tr('attendance_details'),
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
            // Employee Header Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(ResponsiveUtils.wp(5)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Appcolors.kprimarycolor,
                    Appcolors.kprimarycolor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadiusStyles.kradius15(),
                boxShadow: [
                  BoxShadow(
                    color: Appcolors.kprimarycolor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: ResponsiveUtils.wp(10),
                    backgroundColor: Appcolors.kwhitecolor.withOpacity(0.2),
                    child: Icon(
                      Icons.person,
                      size: ResponsiveUtils.sp(10),
                      color: Appcolors.kwhitecolor,
                    ),
                  ),
                  ResponsiveSizedBox.width(4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextStyles.headline(
                          text: attendance.employeeName,
                          weight: FontWeight.bold,
                          color: Appcolors.kwhitecolor,
                          overflow: TextOverflow.ellipsis,
                        ),
                        ResponsiveSizedBox.height5,
                        TextStyles.caption(
                          text: attendance.projectName,
                          color: Appcolors.kwhitecolor.withOpacity(0.8),
                        ),
                        ResponsiveSizedBox.height10,
                        // Status Chip
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUtils.wp(3),
                            vertical: ResponsiveUtils.hp(0.5),
                          ),
                          decoration: BoxDecoration(
                            color: isPending
                                ? Colors.orange.withOpacity(0.2)
                                : Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadiusStyles.kradius10(),
                            border: Border.all(
                              color: isPending
                                  ? Colors.orange.shade300
                                  : Colors.green.shade300,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isPending
                                    ? Icons.pending_outlined
                                    : Icons.check_circle_outline,
                                size: ResponsiveUtils.sp(3.5),
                                color: isPending
                                    ? Colors.orange.shade200
                                    : Colors.green.shade200,
                              ),
                              ResponsiveSizedBox.width(1.5),
                              TextStyles.caption(
                                text: attendance.status,
                                weight: FontWeight.w600,
                                color: isPending
                                    ? Colors.orange.shade200
                                    : Colors.green.shade200,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            ResponsiveSizedBox.height20,

            // Attendance Photo
            if (attendance.picture.isNotEmpty) ...[
              TextStyles.subheadline(
                text: context.tr('attendance_photo'),
                weight: FontWeight.bold,
                color: Appcolors.kblackcolor,
              ),
              ResponsiveSizedBox.height10,
              Container(
                width: double.infinity,
                height: ResponsiveUtils.hp(25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusStyles.kradius15(),
                  boxShadow: [
                    BoxShadow(
                      color: Appcolors.kgreyColor.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadiusStyles.kradius15(),
                  child: Image.network(
                    attendance.picture,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Appcolors.kgreyColor.withOpacity(0.1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image_outlined,
                            size: ResponsiveUtils.sp(12),
                            color: Appcolors.kgreyColor,
                          ),
                          ResponsiveSizedBox.height10,
                          TextStyles.caption(
                            text: context.tr('image_not_available'),
                            color: Appcolors.kgreyColor,
                          ),
                        ],
                      ),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                          color: Appcolors.kprimarycolor,
                        ),
                      );
                    },
                  ),
                ),
              ),
              ResponsiveSizedBox.height20,
            ],

            // Attendance Info Section
            TextStyles.subheadline(
              text: context.tr('attendance_info'),
              weight: FontWeight.bold,
              color: Appcolors.kblackcolor,
            ),
            ResponsiveSizedBox.height10,
            Container(
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
                  _buildInfoRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Date',
                    value: attendance.date,
                    isFirst: true,
                  ),
                  _buildDivider(),
                  _buildInfoRow(
                    icon: isMorning
                        ? Icons.wb_sunny_rounded
                        : Icons.nights_stay_rounded,
                    label: 'Session',
                    value: attendance.attendanceType,
                    valueColor: isMorning
                        ? Colors.orange.shade700
                        : Colors.blue.shade700,
                  ),
                  _buildDivider(),
                  _buildInfoRow(
                    icon: Icons.bar_chart_rounded,
                    label: 'Attendance Value',
                    value: attendance.attendance,
                  ),
                  _buildDivider(),
                  _buildInfoRow(
                    icon: Icons.location_on_rounded,
                    label: 'Distance from HQ',
                    value: '${attendance.distanceFromHQ} KM',
                    valueColor: Appcolors.kprimarycolor,
                    isLast: true,
                  ),
                ],
              ),
            ),

            ResponsiveSizedBox.height20,

            // Location Section
            TextStyles.subheadline(
              text: context.tr('location_details'),
              weight: FontWeight.bold,
              color: Appcolors.kblackcolor,
            ),
            ResponsiveSizedBox.height10,
            Container(
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
                  _buildInfoRow(
                    icon: Icons.my_location_rounded,
                    label: 'Latitude',
                    value: attendance.attendanceLatt,
                    isFirst: true,
                  ),
                  _buildDivider(),
                  _buildInfoRow(
                    icon: Icons.my_location_rounded,
                    label: 'Longitude',
                    value: attendance.attendanceLong,
                    isLast: true,
                  ),
                ],
              ),
            ),

            ResponsiveSizedBox.height20,

            // Remarks Section
            TextStyles.subheadline(
              text: context.tr('remarks'),
              weight: FontWeight.bold,
              color: Appcolors.kblackcolor,
            ),
            ResponsiveSizedBox.height10,
            Container(
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
                  _buildInfoRow(
                    icon: Icons.person_outline_rounded,
                    label: 'Employee Remarks',
                    value: attendance.userRemarks.isNotEmpty
                        ? attendance.userRemarks
                        : 'No remarks',
                    isFirst: true,
                  ),
                  _buildDivider(),
                  _buildInfoRow(
                    icon: Icons.supervisor_account_rounded,
                    label: 'Approver Remarks',
                    value: attendance.approverRemarks ?? 'Not yet provided',
                    valueColor: attendance.approverRemarks == null
                        ? Appcolors.kgreyColor
                        : null,
                  ),
                  _buildDivider(),
                  _buildInfoRow(
                    icon: Icons.business_rounded,
                    label: 'HQ Remarks',
                    value: attendance.headquarterRemarks ?? 'Not yet provided',
                    valueColor: attendance.headquarterRemarks == null
                        ? Appcolors.kgreyColor
                        : null,
                    isLast: true,
                  ),
                ],
              ),
            ),

            // ResponsiveSizedBox.height20,

            // // Timestamps Section
            // TextStyles.subheadline(
            //   text: 'Timestamps',
            //   weight: FontWeight.bold,
            //   color: Appcolors.kblackcolor,
            // ),
            // ResponsiveSizedBox.height10,
            // Container(
            //   decoration: BoxDecoration(
            //     color: Appcolors.kwhitecolor,
            //     borderRadius: BorderRadiusStyles.kradius15(),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Appcolors.kgreyColor.withOpacity(0.15),
            //         blurRadius: 10,
            //         offset: const Offset(0, 4),
            //       ),
            //     ],
            //   ),
            //   child: Column(
            //     children: [
            //       _buildInfoRow(
            //         icon: Icons.access_time_rounded,
            //         label: 'Created',
            //         value: attendance.createdDate,
            //         isFirst: true,
            //       ),
            //       _buildDivider(),
            //       _buildInfoRow(
            //         icon: Icons.update_rounded,
            //         label: 'Last Modified',
            //         value: attendance.lastModifiedDate,
            //         isLast: true,
            //       ),
            //     ],
            //   ),
            // ),
            ResponsiveSizedBox.height30,

            // Action Buttons (only show if pending)
            if (isPending) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showRejectDialog(context);
                      },
                      icon: const Icon(
                        Icons.cancel_outlined,
                        color: Colors.red,
                      ),
                      label: TextStyles.medium(
                        text: context.tr('reject'),
                        weight: FontWeight.w600,
                        color: Colors.red,
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveUtils.hp(1.8),
                        ),
                        side: const BorderSide(color: Colors.red, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusStyles.kradius10(),
                        ),
                      ),
                    ),
                  ),
                  ResponsiveSizedBox.width(3),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showApproveDialog(context);
                      },
                      icon: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                      ),
                      label: TextStyles.medium(
                        text: context.tr('approve'),
                        weight: FontWeight.w600,
                        color: Appcolors.kwhitecolor,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveUtils.hp(1.8),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusStyles.kradius10(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ResponsiveSizedBox.height20,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.wp(4),
        vertical: ResponsiveUtils.hp(1.8),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: isFirst ? Radius.circular(15) : Radius.zero,
          bottom: isLast ? Radius.circular(15) : Radius.zero,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
            decoration: BoxDecoration(
              color: Appcolors.kprimarycolor.withOpacity(0.08),
              borderRadius: BorderRadiusStyles.kradius10(),
            ),
            child: Icon(
              icon,
              size: ResponsiveUtils.sp(4.5),
              color: Appcolors.kprimarycolor,
            ),
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
                  color: valueColor ?? Appcolors.kblackcolor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Appcolors.kgreyColor.withOpacity(0.1),
      indent: ResponsiveUtils.wp(4),
      endIndent: ResponsiveUtils.wp(4),
    );
  }

  void _showApproveDialog(BuildContext context) {
    final remarksController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusStyles.kradius20(),
        ),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveUtils.wp(6)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: ResponsiveUtils.sp(10),
                ),
              ),
              ResponsiveSizedBox.height10,
              TextStyles.headline(
                text: context.tr('approve_attendance'),
                weight: FontWeight.bold,
                color: Appcolors.kblackcolor,
              ),
              ResponsiveSizedBox.height5,
              TextStyles.caption(
                text: context.tr('add_remarks_before_approving_optional'),
                color: Appcolors.kgreyColor,
              ),
              ResponsiveSizedBox.height20,
              TextField(
                controller: remarksController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: context.tr('enter_remarks'),
                  hintStyle: TextStyle(color: Appcolors.kgreyColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadiusStyles.kradius10(),
                    borderSide: BorderSide(
                      color: Appcolors.kgreyColor.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadiusStyles.kradius10(),
                    borderSide: BorderSide(color: Appcolors.kprimarycolor),
                  ),
                ),
              ),
              ResponsiveSizedBox.height20,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveUtils.hp(1.5),
                        ),
                        side: BorderSide(color: Appcolors.kgreyColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusStyles.kradius10(),
                        ),
                      ),
                      child: TextStyles.medium(
                        text: context.tr('cancel'),
                        weight: FontWeight.w600,
                        color: Appcolors.kgreyColor,
                      ),
                    ),
                  ),
                  ResponsiveSizedBox.width(3),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Call approve API with attendance.attendanceId
                        // and remarksController.text
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.tr('attendance_approved_successfully'),
                            ),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
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
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveUtils.hp(1.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusStyles.kradius10(),
                        ),
                      ),
                      child: TextStyles.medium(
                        text: context.tr('approve'),
                        weight: FontWeight.w600,
                        color: Appcolors.kwhitecolor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRejectDialog(BuildContext context) {
    final remarksController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusStyles.kradius20(),
        ),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveUtils.wp(6)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cancel_outlined,
                  color: Colors.red,
                  size: ResponsiveUtils.sp(10),
                ),
              ),
              ResponsiveSizedBox.height10,
              TextStyles.headline(
                text: context.tr('reject_attendance'),
                weight: FontWeight.bold,
                color: Appcolors.kblackcolor,
              ),
              ResponsiveSizedBox.height5,
              TextStyles.caption(
                text: context.tr('please_provide_a_reason_for_rejection'),
                color: Appcolors.kgreyColor,
              ),
              ResponsiveSizedBox.height20,
              TextField(
                controller: remarksController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: context.tr('enter_reason_for_rejection'),
                  hintStyle: TextStyle(color: Appcolors.kgreyColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadiusStyles.kradius10(),
                    borderSide: BorderSide(
                      color: Appcolors.kgreyColor.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadiusStyles.kradius10(),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
              ResponsiveSizedBox.height20,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveUtils.hp(1.5),
                        ),
                        side: BorderSide(color: Appcolors.kgreyColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusStyles.kradius10(),
                        ),
                      ),
                      child: TextStyles.medium(
                        text: context.tr('cancel'),
                        weight: FontWeight.w600,
                        color: Appcolors.kgreyColor,
                      ),
                    ),
                  ),
                  ResponsiveSizedBox.width(3),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Call reject API with attendance.attendanceId
                        // and remarksController.text
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.tr('attendance_rejected')),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
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
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveUtils.hp(1.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusStyles.kradius10(),
                        ),
                      ),
                      child: TextStyles.medium(
                        text: context.tr('reject'),
                        weight: FontWeight.w600,
                        color: Appcolors.kwhitecolor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
