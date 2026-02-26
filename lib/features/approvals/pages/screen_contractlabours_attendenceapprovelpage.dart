import 'package:dhani_communications/core/appconstants.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/widgets/custom_nondatawidget.dart';
import 'package:dhani_communications/widgets/customshimmer_widget.dart';
import 'package:dhani_communications/widgets/date_filter_dialog.dart';
import 'package:dhani_communications/features/approvals/bloc/fetch_labour_approvelattendence_bloc/fetch_labour_approvelattendence_bloc.dart';
import 'package:dhani_communications/features/approvals/bloc/update_labour_approvel_attendence/update_labour_approvel_attendence_bloc.dart';
import 'package:dhani_communications/features/approvals/models/approvels_labourattendencemodel.dart';
import 'package:dhani_communications/widgets/custom_snackbar.dart';
import 'package:dhani_communications/widgets/rejection_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenContractlaboursAttendenceapprovelpage extends StatefulWidget {
  const ScreenContractlaboursAttendenceapprovelpage({super.key});

  @override
  State<ScreenContractlaboursAttendenceapprovelpage> createState() =>
      _ScreenContractlaboursAttendenceapprovelpageState();
}

class _ScreenContractlaboursAttendenceapprovelpageState
    extends State<ScreenContractlaboursAttendenceapprovelpage> {
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    context.read<FetchLabourApprovelattendenceBloc>().add(
      FetchLabourApprovelattendenceInitialFetchingEvent(),
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
                    color: Appcolors.kgreyColor.withValues(alpha: 0.3),
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
                      color: Appcolors.kgreencolor.withValues(alpha: 0.1),
                      borderRadius: BorderRadiusStyles.kradius10(),
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Appcolors.kgreencolor,
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
                        context.read<UpdateLabourApprovelAttendenceBloc>().add(
                          ApproveLabourAttendanceEvent(
                            attendanceId: attendanceId,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolors.kgreencolor,
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
      title: 'Reject Labour Attendance',
      subtitle: 'Please provide a reason for rejecting this attendance record.',
      onReject: (remarks) {
        context.read<UpdateLabourApprovelAttendenceBloc>().add(
          RejectLabourAttendanceEvent(
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
          text: 'Approve Labours Attendance',
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
                        color: Appcolors.kredcolor,
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
            UpdateLabourApprovelAttendenceBloc,
            UpdateLabourApprovelAttendenceState
          >(
            listener: (context, updateState) {
              if (updateState is UpdateLabourApprovelAttendenceLoadingState) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) =>
                      const Center(child: CircularProgressIndicator()),
                );
              } else if (updateState
                  is UpdateLabourApprovelAttendenceSuccessState) {
                Navigator.of(context, rootNavigator: true).pop();
                CustomSnackbar.show(
                  context: context,
                  message: updateState.message,
                  type: SnackBarType.success,
                );
                // Refresh list
                context.read<FetchLabourApprovelattendenceBloc>().add(
                  FetchLabourApprovelattendenceInitialFetchingEvent(),
                );
              } else if (updateState
                  is UpdateLabourApprovelAttendenceErrorState) {
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
                  FetchLabourApprovelattendenceBloc,
                  FetchLabourApprovelattendenceState
                >(
                  builder: (context, state) {
                    if (state is FetchLabourApprovelAttendenceLoadingState) {
                      return CustomListShimmer();
                    } else if (state
                        is FetchLabourApprovelAttendenceErrorState) {
                      return NoDataWidget(
                        title: state.message,
                        assetIcon: Appconstants.assets,
                      );
                    } else if (state
                        is FetchLabourApprovelAttendenceSuccessState) {
                      final list = state.attendence;
                      if (list.isEmpty) {
                        return NoDataWidget(
                          title: "No attendence data found",
                          assetIcon: Appconstants.attenedence,
                        );
                      }
                      return ListView.builder(
                        padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final attendance = list[index];
                          return Slidable(
                            key: ValueKey(attendance.attendanceId),
                            // Swipe right to approve
                            startActionPane: ActionPane(
                              motion: const StretchMotion(),
                              extentRatio: 0.25,
                              children: [
                                CustomSlidableAction(
                                  onPressed: (context) {
                                    _approveAttendance(attendance.attendanceId);
                                  },
                                  backgroundColor: Appcolors.kgreencolor,
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
                            // Swipe left to reject
                            endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              extentRatio: 0.25,
                              children: [
                                CustomSlidableAction(
                                  onPressed: (context) {
                                    _rejectAttendance(attendance.attendanceId);
                                  },
                                  backgroundColor: Appcolors.kredcolor,
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
                                  '/approvelabourattendencedetailspage',
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

  Widget _buildAttendanceCard(ApprovelsLabourattendencemodel attendance) {
    final bool isApproved = attendance.status == 'APPROVED';
    final bool isRejected = attendance.status == 'REJECTED';

    Color statusColor;
    IconData statusIcon;
    String statusText;
    if (isApproved) {
      statusColor = Appcolors.kgreencolor;
      statusIcon = Icons.check_circle;
      statusText = 'Approved';
    } else if (isRejected) {
      statusColor = Appcolors.kredcolor;
      statusIcon = Icons.cancel;
      statusText = 'Rejected';
    } else {
      statusColor = Appcolors.korangecolor;
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
            color: Appcolors.kgreyColor.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
        child: Row(
          children: [
            // Profile Image
            CircleAvatar(
              radius: ResponsiveUtils.wp(8),
              backgroundColor: Appcolors.kgreyColor.withValues(alpha: 0.2),
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
                  TextStyles.title(
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
                  // Date and Labour Type
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text: attendance.hireDate,
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(2),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.wp(2),
                          vertical: ResponsiveUtils.hp(0.3),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple.withValues(alpha: 0.1),
                          borderRadius: BorderRadiusStyles.kradius5(),
                        ),
                        child: TextStyles.caption(
                          text: attendance.laborType,
                          weight: FontWeight.w600,
                          color: Colors.purple.shade700,
                        ),
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height5,
                  // Total Labours & Distance
                  Row(
                    children: [
                      Icon(
                        Icons.groups,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kprimarycolor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text: '${attendance.totalLabours} labours',
                        weight: FontWeight.w600,
                        color: Appcolors.kprimarycolor,
                      ),
                      ResponsiveSizedBox.width(3),
                      Icon(
                        Icons.location_on,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(1),
                      TextStyles.caption(
                        text: '${attendance.distanceFromHQ} KM',
                        weight: FontWeight.w600,
                        color: Appcolors.kgreyColor,
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
                    color: statusColor.withValues(alpha: 0.1),
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
