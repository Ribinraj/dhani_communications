import 'package:dhani_communications/core/appconstants.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/widgets/custom_nondatawidget.dart';
import 'package:dhani_communications/widgets/customshimmer_widget.dart';
import 'package:dhani_communications/widgets/date_filter_dialog.dart';
import 'package:dhani_communications/features/approvals/bloc/fetch_approvel_attendence/fetch_approvelattendence_bloc.dart';
import 'package:dhani_communications/features/approvals/bloc/update_approvel_attendence/update_approvel_attendence_bloc.dart';
import 'package:dhani_communications/widgets/custom_snackbar.dart';
import 'package:dhani_communications/widgets/rejection_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dhani_communications/features/approvals/models/approvels_attendencemodel.dart';

class ScreenApproveEmployeesAttendancePage extends StatefulWidget {
  const ScreenApproveEmployeesAttendancePage({super.key});

  @override
  State<ScreenApproveEmployeesAttendancePage> createState() =>
      _ScreenApproveEmployeesAttendancePageState();
}

class _ScreenApproveEmployeesAttendancePageState
    extends State<ScreenApproveEmployeesAttendancePage> {
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    context.read<FetchApprovelattendenceBloc>().add(
      FetchApprovelAttendenceInitialFetchingEvent(),
    );
  }

  // â”€â”€â”€ Approve Handler â”€â”€â”€
  void _approveAttendance(String attendanceId) {
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
              // Title Row
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
                text: 'Are you sure you want to approve this attendance?',
                color: Appcolors.kgreyColor,
              ),
              ResponsiveSizedBox.height30,
              // Buttons
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
                        context.read<UpdateApprovelAttendenceBloc>().add(
                          ApproveAttendanceEvent(attendanceId: attendanceId),
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

  // â”€â”€â”€ Reject Handler (Common Bottom Sheet) â”€â”€â”€
  void _rejectAttendance(String attendanceId) {
    RejectionBottomSheet.show(
      context: context,
      title: 'Reject Attendance',
      subtitle: 'Please provide a reason for rejecting this attendance record.',
      onReject: (remarks) {
        context.read<UpdateApprovelAttendenceBloc>().add(
          RejectAttendanceEvent(
            attendanceId: attendanceId,
            approverRemarks: remarks,
          ),
        );
      },
    );
  }

  // Filter Dialog
  void _showFilterDialog() {
    DateFilterDialog.show(
      context: context,
      title: 'Filter Attendance',
      initialFromDate: _fromDate,
      initialToDate: _toDate,
      onApply: (fromDate, toDate) {
        setState(() {
          _fromDate = fromDate;
          _toDate = toDate;
        });
      },
      onClear: () {
        setState(() {
          _fromDate = null;
          _toDate = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
          text: 'Approve Attendance',
          weight: FontWeight.bold,
          color: Appcolors.kblackcolor,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _showFilterDialog,
            icon: Stack(
              children: [
                Icon(
                  Icons.filter_list_rounded,
                  color: Appcolors.kprimarycolor,
                  size: ResponsiveUtils.sp(6),
                ),
                if (_fromDate != null || _toDate != null)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: ResponsiveUtils.wp(2),
                      height: ResponsiveUtils.wp(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body:
          BlocListener<
            UpdateApprovelAttendenceBloc,
            UpdateApprovelAttendenceState
          >(
            listener: (context, updateState) {
              if (updateState is UpdateApprovelAttendenceLoadingState) {
                // Show loading overlay
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) =>
                      const Center(child: CircularProgressIndicator()),
                );
              } else if (updateState is UpdateApprovelAttendenceSuccessState) {
                // Dismiss loading
                Navigator.of(context, rootNavigator: true).pop();
                CustomSnackbar.show(
                  context: context,
                  message: updateState.message,
                  type: SnackBarType.success,
                );
                // Refresh list
                context.read<FetchApprovelattendenceBloc>().add(
                  FetchApprovelAttendenceInitialFetchingEvent(),
                );
              } else if (updateState is UpdateApprovelAttendenceErrorState) {
                // Dismiss loading
                Navigator.of(context, rootNavigator: true).pop();
                CustomSnackbar.show(
                  context: context,
                  message: updateState.message,
                  type: SnackBarType.error,
                );
              }
            },
            child:
                BlocBuilder<
                  FetchApprovelattendenceBloc,
                  FetchApprovelattendenceState
                >(
                  builder: (context, state) {
                    if (state is FetchApprovelAttendenceLoadingState) {
                      return CustomListShimmer();
                    } else if (state is FetchApproveAttendenceErrorState) {
                      return NoDataWidget(title: state.message, assetIcon: Appconstants.attenedence);
                    } else if (state is FetchApprovelAttendenceSuccessState) {
                      final list = state.attendence;
                      if (list.isEmpty) {
                        return  NoDataWidget(title:"No Attendence Record found", assetIcon: Appconstants.attenedence);
                      }
                      return ListView.builder(
                        padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final attendance = list[index];
                          return Slidable(
                            key: ValueKey(attendance.attendanceId),
                            startActionPane: ActionPane(
                              motion: const StretchMotion(),
                              extentRatio: 0.25,
                              children: [
                                CustomSlidableAction(
                                  onPressed: (context) {
                                    _approveAttendance(attendance.attendanceId);
                                  },
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  borderRadius: BorderRadiusStyles.kradius15(),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        size: ResponsiveUtils.sp(8),
                                      ),
                                      ResponsiveSizedBox.height5,
                                      TextStyles.caption(
                                        text: 'Approve',
                                        weight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              extentRatio: 0.25,
                              children: [
                                CustomSlidableAction(
                                  onPressed: (context) {
                                    _rejectAttendance(attendance.attendanceId);
                                  },
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  borderRadius: BorderRadiusStyles.kradius15(),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.cancel,
                                        size: ResponsiveUtils.sp(8),
                                      ),
                                      ResponsiveSizedBox.height5,
                                      TextStyles.caption(
                                        text: 'Reject',
                                        weight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                context.push(
                                  '/approvelattendencedetailspage',
                                  extra: attendance,
                                );
                              },
                              child: _buildAttendanceCard(attendance),
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
          ),
    );
  }

  Widget _buildAttendanceCard(ApprovelsAttendencemodel attendance) {
    final bool isApproved = attendance.status == 'APPROVED';
    final bool isRejected = attendance.status == 'REJECTED';
    final bool isMorning = attendance.attendanceType == 'MORNING';

    Color statusColor;
    IconData statusIcon;
    String statusText;
    if (isApproved) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
      statusText = 'Approved';
    } else if (isRejected) {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
      statusText = 'Rejected';
    } else {
      statusColor = Colors.orange;
      statusIcon = Icons.pending;
      statusText = 'Pending';
    }

    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.hp(2)),
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
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
        child: Row(
          children: [
            // Profile Image / Avatar
            CircleAvatar(
              radius: ResponsiveUtils.wp(8),
              backgroundColor: Appcolors.kgreyColor.withOpacity(0.2),
              backgroundImage: attendance.picture.isNotEmpty
                  ? NetworkImage(attendance.picture)
                  : null,
              child: attendance.picture.isEmpty
                  ? Icon(
                      Icons.person,
                      size: ResponsiveUtils.sp(8),
                      color: Appcolors.kprimarycolor,
                    )
                  : null,
            ),
            ResponsiveSizedBox.width(3),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Employee Name
                  TextStyles.subheadline(
                    text: attendance.employeeName,
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                    overflow: TextOverflow.ellipsis,
                  ),
                  ResponsiveSizedBox.height5,
                  // Project Name
                  TextStyles.caption(
                    text: attendance.projectName,
                    color: Appcolors.kgreyColor,
                  ),
                  ResponsiveSizedBox.height5,
                  // Date and Session
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text: attendance.date,
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(2),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.wp(2),
                          vertical: ResponsiveUtils.hp(0.3),
                        ),
                        decoration: BoxDecoration(
                          color: isMorning
                              ? Colors.orange.withOpacity(0.1)
                              : Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadiusStyles.kradius5(),
                        ),
                        child: TextStyles.caption(
                          text: attendance.attendanceType,
                          weight: FontWeight.w600,
                          color: isMorning
                              ? Colors.orange.shade700
                              : Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height5,
                  // Distance from HQ
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kprimarycolor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text: '${attendance.distanceFromHQ} KM from HQ',
                        weight: FontWeight.w600,
                        color: Appcolors.kprimarycolor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Approval Status Badge
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    statusIcon,
                    color: statusColor,
                    size: ResponsiveUtils.sp(6),
                  ),
                ),
                ResponsiveSizedBox.height5,
                TextStyles.caption(
                  text: statusText,
                  weight: FontWeight.w600,
                  color: statusColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
