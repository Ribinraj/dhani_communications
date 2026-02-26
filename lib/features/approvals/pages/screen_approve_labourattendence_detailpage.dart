import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/features/approvals/bloc/update_labour_approvel_attendence/update_labour_approvel_attendence_bloc.dart';
import 'package:dhani_communications/features/approvals/bloc/fetch_labour_approvelattendence_bloc/fetch_labour_approvelattendence_bloc.dart';
import 'package:dhani_communications/widgets/custom_snackbar.dart';
import 'package:dhani_communications/widgets/rejection_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dhani_communications/features/approvals/models/approvels_labourattendencemodel.dart';

class ScreenApproveLabourAttendanceDetailPage extends StatelessWidget {
  final ApprovelsLabourattendencemodel attendance;

  const ScreenApproveLabourAttendanceDetailPage({
    super.key,
    required this.attendance,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPending = attendance.status == 'PENDING';

    return Scaffold(
      backgroundColor: Appcolors.kwhitecolor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Appcolors.kprimarycolor,
            size: ResponsiveUtils.sp(5),
          ),
        ),
        title: TextStyles.title(
          text: 'Labour Attendance Details',
          weight: FontWeight.bold,
          color: Appcolors.kblackcolor,
        ),
        centerTitle: true,
      ),
      body:
          BlocListener<
            UpdateLabourApprovelAttendenceBloc,
            UpdateLabourApprovelAttendenceState
          >(
            listener: (context, state) {
              if (state is UpdateLabourApprovelAttendenceLoadingState) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) =>
                      const Center(child: CircularProgressIndicator()),
                );
              } else if (state is UpdateLabourApprovelAttendenceSuccessState) {
                Navigator.of(context, rootNavigator: true).pop();
                CustomSnackbar.show(
                  context: context,
                  message: state.message,
                  type: SnackBarType.success,
                );
                // Refresh list before popping
                context.read<FetchLabourApprovelattendenceBloc>().add(
                  FetchLabourApprovelattendenceInitialFetchingEvent(),
                );
                context.pop();
              } else if (state is UpdateLabourApprovelAttendenceErrorState) {
                Navigator.of(context, rootNavigator: true).pop();
                CustomSnackbar.show(
                  context: context,
                  message: state.message,
                  type: SnackBarType.error,
                );
              }
            },
            child: SingleChildScrollView(
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
                          backgroundColor: Appcolors.kwhitecolor.withOpacity(
                            0.2,
                          ),
                          backgroundImage: attendance.picture.isNotEmpty
                              ? NetworkImage(attendance.picture)
                              : null,
                          child: attendance.picture.isEmpty
                              ? Icon(
                                  Icons.person,
                                  size: ResponsiveUtils.sp(10),
                                  color: Appcolors.kwhitecolor,
                                )
                              : null,
                        ),
                        ResponsiveSizedBox.width(4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextStyles.subheadline(
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
                                      : attendance.status == 'APPROVED'
                                      ? Colors.green.withOpacity(0.2)
                                      : Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadiusStyles.kradius10(),
                                  border: Border.all(
                                    color: isPending
                                        ? Colors.orange.shade300
                                        : attendance.status == 'APPROVED'
                                        ? Colors.green.shade300
                                        : Colors.red.shade300,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isPending
                                          ? Icons.pending_outlined
                                          : attendance.status == 'APPROVED'
                                          ? Icons.check_circle_outline
                                          : Icons.cancel_outlined,
                                      size: ResponsiveUtils.sp(3.5),
                                      color: isPending
                                          ? Colors.orange.shade200
                                          : attendance.status == 'APPROVED'
                                          ? Colors.green.shade200
                                          : Colors.red.shade200,
                                    ),
                                    ResponsiveSizedBox.width(1.5),
                                    TextStyles.caption(
                                      text: attendance.status,
                                      weight: FontWeight.w600,
                                      color: isPending
                                          ? Colors.orange.shade200
                                          : attendance.status == 'APPROVED'
                                          ? Colors.green.shade200
                                          : Colors.red.shade200,
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
                    TextStyles.title(
                      text: 'Attendance Photo',
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
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
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
                                      text: 'Image not available',
                                      color: Appcolors.kgreyColor,
                                    ),
                                  ],
                                ),
                              ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
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

                  // Punch Out Photo
                  if (attendance.punchOutPicture != null &&
                      attendance.punchOutPicture!.isNotEmpty) ...[
                    TextStyles.title(
                      text: 'Punch Out Photo',
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
                          attendance.punchOutPicture!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
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
                                      text: 'Image not available',
                                      color: Appcolors.kgreyColor,
                                    ),
                                  ],
                                ),
                              ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
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

                  // Labour Info Section
                  TextStyles.title(
                    text: 'Labour Info',
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
                          icon: Icons.category_rounded,
                          label: 'Labour Type',
                          value: attendance.laborType,
                          isFirst: true,
                        ),
                        _buildDivider(),
                        _buildInfoRow(
                          icon: Icons.groups_rounded,
                          label: 'Total Labours',
                          value: attendance.totalLabours,
                        ),
                        _buildDivider(),
                        _buildInfoRow(
                          icon: Icons.calendar_today_rounded,
                          label: 'Hire Date',
                          value: attendance.hireDate,
                        ),
                        _buildDivider(),
                        if (attendance.laborName != null &&
                            attendance.laborName!.isNotEmpty) ...[
                          _buildInfoRow(
                            icon: Icons.person_outline_rounded,
                            label: 'Labour Name',
                            value: attendance.laborName!,
                          ),
                          _buildDivider(),
                        ],
                        if (attendance.laborMobile != null &&
                            attendance.laborMobile!.isNotEmpty) ...[
                          _buildInfoRow(
                            icon: Icons.phone_rounded,
                            label: 'Labour Mobile',
                            value: attendance.laborMobile!,
                          ),
                          _buildDivider(),
                        ],
                        if (attendance.contcatorName != null &&
                            attendance.contcatorName!.isNotEmpty) ...[
                          _buildInfoRow(
                            icon: Icons.engineering_rounded,
                            label: 'Contractor Name',
                            value: attendance.contcatorName!,
                          ),
                          _buildDivider(),
                        ],
                        if (attendance.wages != null &&
                            attendance.wages!.isNotEmpty) ...[
                          _buildInfoRow(
                            icon: Icons.currency_rupee_rounded,
                            label: 'Wages',
                            value: '₹${attendance.wages}',
                            valueColor: Colors.green.shade700,
                          ),
                          _buildDivider(),
                        ],
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

                  // Punch In / Punch Out Section
                  TextStyles.title(
                    text: 'Punch Details',
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
                          icon: Icons.login_rounded,
                          label: 'Punch In',
                          value: attendance.punchIn,
                          valueColor: Colors.green.shade700,
                          isFirst: true,
                        ),
                        _buildDivider(),
                        _buildInfoRow(
                          icon: Icons.logout_rounded,
                          label: 'Punch Out',
                          value: attendance.punchOut ?? 'Not yet',
                          valueColor: attendance.punchOut != null
                              ? Colors.red.shade700
                              : Appcolors.kgreyColor,
                        ),
                        _buildDivider(),
                        _buildInfoRow(
                          icon: Icons.timer_rounded,
                          label: 'Total Hours',
                          value: attendance.totalHours ?? 'N/A',
                          isLast: true,
                        ),
                      ],
                    ),
                  ),

                  ResponsiveSizedBox.height20,

                  // Location Section
                  TextStyles.title(
                    text: 'Location Details',
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
                  TextStyles.title(
                    text: 'Remarks',
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
                          value:
                              (attendance.userRemarks != null &&
                                  attendance.userRemarks!.isNotEmpty)
                              ? attendance.userRemarks!
                              : 'No remarks',
                          isFirst: true,
                        ),
                        _buildDivider(),
                        _buildInfoRow(
                          icon: Icons.supervisor_account_rounded,
                          label: 'Approver Remarks',
                          value:
                              attendance.approverRemarks ?? 'Not yet provided',
                          valueColor: attendance.approverRemarks == null
                              ? Appcolors.kgreyColor
                              : null,
                        ),
                        _buildDivider(),
                        _buildInfoRow(
                          icon: Icons.business_rounded,
                          label: 'HQ Remarks',
                          value:
                              attendance.headquarterRemarks ??
                              'Not yet provided',
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
                  // TextStyles.title(
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
                              _showRejectBottomSheet(context);
                            },
                            icon: const Icon(
                              Icons.cancel_outlined,
                              color: Colors.red,
                            ),
                            label: TextStyles.medium(
                              text: 'Reject',
                              weight: FontWeight.w600,
                              color: Colors.red,
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: ResponsiveUtils.hp(1.8),
                              ),
                              side: const BorderSide(
                                color: Colors.red,
                                width: 1.5,
                              ),
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
                              _showApproveBottomSheet(context);
                            },
                            icon: const Icon(
                              Icons.check_circle_outline,
                              color: Colors.white,
                            ),
                            label: TextStyles.medium(
                              text: 'Approve',
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
          top: isFirst ? const Radius.circular(15) : Radius.zero,
          bottom: isLast ? const Radius.circular(15) : Radius.zero,
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

  void _showApproveBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: Appcolors.kwhitecolor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(ResponsiveUtils.wp(6)),
              topRight: Radius.circular(ResponsiveUtils.wp(6)),
            ),
          ),
          padding: EdgeInsets.all(ResponsiveUtils.wp(6)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: ResponsiveUtils.wp(12),
                  height: ResponsiveUtils.hp(0.5),
                  decoration: BoxDecoration(
                    color: Appcolors.kgreyColor.withOpacity(0.3),
                    borderRadius: BorderRadiusStyles.kradius10(),
                  ),
                ),
              ),
              ResponsiveSizedBox.height20,
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(ResponsiveUtils.wp(2.5)),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadiusStyles.kradius10(),
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: ResponsiveUtils.sp(6),
                    ),
                  ),
                  ResponsiveSizedBox.width(3),
                  TextStyles.headline(
                    text: 'Approve Attendance',
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                  ),
                ],
              ),
              ResponsiveSizedBox.height15,
              TextStyles.body(
                text:
                    'Are you sure you want to approve this labour attendance?',
                color: Appcolors.kgreyColor,
              ),
              ResponsiveSizedBox.height30,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveUtils.hp(1.5),
                        ),
                        side: BorderSide(
                          color: Appcolors.kgreyColor,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusStyles.kradius10(),
                        ),
                      ),
                      child: TextStyles.medium(
                        text: 'Cancel',
                        weight: FontWeight.w600,
                        color: Appcolors.kgreyColor,
                      ),
                    ),
                  ),
                  ResponsiveSizedBox.width(3),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        context.read<UpdateLabourApprovelAttendenceBloc>().add(
                          ApproveLabourAttendanceEvent(
                            attendanceId: attendance.attendanceId,
                          ),
                        );
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
                        text: 'Approve',
                        weight: FontWeight.w600,
                        color: Appcolors.kwhitecolor,
                      ),
                    ),
                  ),
                ],
              ),
              ResponsiveSizedBox.height10,
            ],
          ),
        );
      },
    );
  }

  void _showRejectBottomSheet(BuildContext context) {
    RejectionBottomSheet.show(
      context: context,
      title: 'Reject Labour Attendance',
      subtitle: 'Please provide a reason for rejecting this attendance record.',
      onReject: (remarks) {
        context.read<UpdateLabourApprovelAttendenceBloc>().add(
          RejectLabourAttendanceEvent(
            attendanceId: attendance.attendanceId,
            approverRemarks: remarks,
          ),
        );
      },
    );
  }
}
