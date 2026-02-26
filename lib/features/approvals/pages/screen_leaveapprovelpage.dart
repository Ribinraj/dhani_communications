import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/widgets/date_filter_dialog.dart';
import 'package:dhani_communications/features/approvals/bloc/fetch_approvel_leave_bloc/fetch_approvel_leave_bloc.dart';
import 'package:dhani_communications/features/approvals/bloc/update_approvel_leave/update_approvel_leave_bloc.dart';
import 'package:dhani_communications/features/approvals/models/approvels_leavemodel.dart';
import 'package:dhani_communications/widgets/custom_snackbar.dart';
import 'package:dhani_communications/widgets/rejection_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenLeaveApprovalPage extends StatefulWidget {
  const ScreenLeaveApprovalPage({super.key});

  @override
  State<ScreenLeaveApprovalPage> createState() =>
      _ScreenLeaveApprovalPageState();
}

class _ScreenLeaveApprovalPageState extends State<ScreenLeaveApprovalPage> {
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    context.read<FetchApprovelLeaveBloc>().add(
      FetchApprovelleavesInitialEvent(),
    );
  }

  //  Filter Dialog 
  void _showFilterDialog() {
    DateFilterDialog.show(
      context: context,
      title: 'Filter Leaves',
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

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  // ------------------ LEAVE TYPE COLOR LOGIC ------------------

  Color _leaveColor(String type) {
    final lowerType = type.toLowerCase();
    if (lowerType.contains('casual')) return Colors.blue;
    if (lowerType.contains('sick')) return Colors.orange;
    if (lowerType.contains('privilege')) return Colors.purple;
    if (lowerType.contains('earned')) return Colors.teal;
    return Appcolors.kprimarycolor;
  }

  IconData _leaveIcon(String type) {
    final lowerType = type.toLowerCase();
    if (lowerType.contains('casual')) return Icons.event_available;
    if (lowerType.contains('sick')) return Icons.sick;
    if (lowerType.contains('privilege')) return Icons.stars;
    if (lowerType.contains('earned')) return Icons.workspace_premium;
    return Icons.event;
  }

  // â”€â”€â”€ Approve action â”€â”€â”€
  void _showApproveConfirmation(BuildContext context, ApproveLeaveModel leave) {
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextStyles.headline(
                          text: 'Approve Leave',
                          weight: FontWeight.bold,
                          color: Appcolors.kblackcolor,
                        ),
                        ResponsiveSizedBox.height5,
                        TextStyles.caption(
                          text: leave.employeeName,
                          color: Appcolors.kgreyColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ResponsiveSizedBox.height15,
              TextStyles.body(
                text: 'Are you sure you want to approve this leave request?',
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
                        context.read<UpdateApprovelLeaveBloc>().add(
                          ApproveLeaveEvent(leaveId: leave.leaveId),
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

  // â”€â”€â”€ Reject action â”€â”€â”€
  void _showRejectConfirmation(BuildContext context, ApproveLeaveModel leave) {
    RejectionBottomSheet.show(
      context: context,
      title: 'Reject Leave',
      subtitle:
          'Please provide a reason for rejecting ${leave.employeeName}\'s leave request.',
      onReject: (remarks) {
        context.read<UpdateApprovelLeaveBloc>().add(
          RejectLeaveEvent(leaveId: leave.leaveId, approverRemarks: remarks),
        );
      },
    );
  }

  // ------------------ MAIN UI ------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.kwhitecolor,
      appBar: AppBar(
        backgroundColor: Appcolors.kwhitecolor,
        elevation: 2,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Appcolors.kprimarycolor,
          ),
        ),
        title: TextStyles.subheadline(
          text: "Approve Leaves",
          weight: FontWeight.bold,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _showFilterDialog,
            icon: Stack(
              children: [
                Icon(Icons.filter_list_rounded, color: Appcolors.kprimarycolor),
                if (_fromDate != null || _toDate != null)
                  Positioned(
                    right: 0,
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

      // ---------------- BODY ----------------
      body: BlocListener<UpdateApprovelLeaveBloc, UpdateApprovelLeaveState>(
        listener: (context, updateState) {
          if (updateState is UpdateApprovelLeaveLoadingState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) =>
                  const Center(child: CircularProgressIndicator()),
            );
          } else if (updateState is UpdateApprovelLeaveSuccessState) {
            Navigator.of(context, rootNavigator: true).pop();
            CustomSnackbar.show(
              context: context,
              message: updateState.message,
              type: SnackBarType.success,
            );
            context.read<FetchApprovelLeaveBloc>().add(
              FetchApprovelleavesInitialEvent(),
            );
          } else if (updateState is UpdateApprovelLeaveErrorState) {
            Navigator.of(context, rootNavigator: true).pop();
            CustomSnackbar.show(
              context: context,
              message: updateState.message,
              type: SnackBarType.error,
            );
          }
        },
        child: BlocBuilder<FetchApprovelLeaveBloc, FetchApprovelLeaveState>(
          builder: (context, state) {
            if (state is FetchApprovelLeaveLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is FetchApprovelLeavesErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: ResponsiveUtils.sp(12),
                      color: Colors.red.shade300,
                    ),
                    ResponsiveSizedBox.height15,
                    TextStyles.body(
                      text: state.message,
                      color: Appcolors.kgreyColor,
                    ),
                    ResponsiveSizedBox.height15,
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<FetchApprovelLeaveBloc>().add(
                          FetchApprovelleavesInitialEvent(),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolors.kprimarycolor,
                        foregroundColor: Appcolors.kwhitecolor,
                      ),
                    ),
                  ],
                ),
              );
            }
            if (state is FetchApprovelLeaveSuccessState) {
              final leavesList = state.leaves;
              if (leavesList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: ResponsiveUtils.sp(15),
                        color: Appcolors.kgreyColor.withOpacity(0.4),
                      ),
                      ResponsiveSizedBox.height15,
                      TextStyles.body(
                        text: 'No leave requests found',
                        color: Appcolors.kgreyColor,
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<FetchApprovelLeaveBloc>().add(
                    FetchApprovelleavesInitialEvent(),
                  );
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                  itemCount: leavesList.length,
                  itemBuilder: (context, index) {
                    final leave = leavesList[index];
                    final isPending =
                        leave.status.toUpperCase() != 'APPROVED' &&
                        leave.status.toUpperCase() != 'REJECTED';

                    return Slidable(
                      key: ValueKey(leave.leaveId),
                      enabled: isPending,
                      startActionPane: isPending
                          ? ActionPane(
                              extentRatio: 0.25,
                              motion: const StretchMotion(),
                              children: [
                                CustomSlidableAction(
                                  onPressed: (_) {
                                    _showApproveConfirmation(context, leave);
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
                                        text: "Approve",
                                        color: Colors.white,
                                        weight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : null,
                      endActionPane: isPending
                          ? ActionPane(
                              extentRatio: 0.25,
                              motion: const StretchMotion(),
                              children: [
                                CustomSlidableAction(
                                  onPressed: (_) {
                                    _showRejectConfirmation(context, leave);
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
                                        text: "Reject",
                                        color: Colors.white,
                                        weight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : null,
                      child: GestureDetector(
                        onTap: () => context.push(
                          '/leaveapproveldetailpage',
                          extra: leave,
                        ),
                        child: _buildLeaveCard(leave),
                      ),
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // ------------------ CARD UI ------------------

  Widget _buildLeaveCard(ApproveLeaveModel leave) {
    final type = leave.leaveCategoryName;
    final leaveColor = _leaveColor(type);

    final statusStr = leave.status.toUpperCase();
    String statusDisplay;
    Color statusColor;
    IconData statusIcon;

    if (statusStr == 'APPROVED') {
      statusDisplay = 'Approved';
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (statusStr == 'REJECTED') {
      statusDisplay = 'Rejected';
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
    } else {
      statusDisplay = 'Pending';
      statusColor = Colors.orange;
      statusIcon = Icons.pending;
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
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
        child: Row(
          children: [
            /// LEFT ICON
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
              decoration: BoxDecoration(
                color: leaveColor.withOpacity(0.1),
                borderRadius: BorderRadiusStyles.kradius10(),
              ),
              child: Icon(
                _leaveIcon(type),
                color: leaveColor,
                size: ResponsiveUtils.sp(7),
              ),
            ),

            ResponsiveSizedBox.width(3),

            /// MIDDLE DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Employee Name
                  TextStyles.medium(
                    text: leave.employeeName,
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                  ),
                  ResponsiveSizedBox.height5,

                  /// LEAVE TYPE LABEL
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.wp(2.5),
                      vertical: ResponsiveUtils.hp(0.5),
                    ),
                    decoration: BoxDecoration(
                      color: leaveColor.withOpacity(0.1),
                      borderRadius: BorderRadiusStyles.kradius5(),
                    ),
                    child: TextStyles.caption(
                      text: type,
                      color: leaveColor,
                      weight: FontWeight.bold,
                    ),
                  ),

                  ResponsiveSizedBox.height10,

                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text: "From: ${_formatDate(leave.fromDate)}",
                      ),
                    ],
                  ),

                  ResponsiveSizedBox.height5,

                  Row(
                    children: [
                      Icon(
                        Icons.event,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text: "To: ${_formatDate(leave.toDate)}",
                      ),
                    ],
                  ),

                  ResponsiveSizedBox.height5,

                  Row(
                    children: [
                      Icon(
                        Icons.timelapse_rounded,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(text: "${leave.total} Day(s)"),
                    ],
                  ),
                ],
              ),
            ),

            ResponsiveSizedBox.width(2),

            // STATUS RIGHT SIDE
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: statusColor.withOpacity(0.1),
                  ),
                  child: Icon(
                    statusIcon,
                    size: ResponsiveUtils.sp(6),
                    color: statusColor,
                  ),
                ),
                ResponsiveSizedBox.height5,
                TextStyles.caption(
                  text: statusDisplay,
                  color: statusColor,
                  weight: FontWeight.bold,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
