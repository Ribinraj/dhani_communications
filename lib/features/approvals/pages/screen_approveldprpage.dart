import 'package:dhani_communications/core/appconstants.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/widgets/custom_nondatawidget.dart';
import 'package:dhani_communications/widgets/customshimmer_widget.dart';
import 'package:dhani_communications/widgets/date_filter_dialog.dart';
import 'package:dhani_communications/features/approvals/bloc/fetch_approvel_dprbloc/fetch_approvel_dpr_bloc.dart';
import 'package:dhani_communications/features/approvals/bloc/update_approvel_dpr/update_approvel_dpr_bloc.dart';
import 'package:dhani_communications/features/approvals/models/approvels_dprmodel.dart';
import 'package:dhani_communications/widgets/custom_snackbar.dart';
import 'package:dhani_communications/widgets/rejection_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dhani_communications/core/localization/app_localization.dart';

class ScreenApprovelDprPage extends StatefulWidget {
  const ScreenApprovelDprPage({super.key});

  @override
  State<ScreenApprovelDprPage> createState() => _ScreenApprovelDprPageState();
}

class _ScreenApprovelDprPageState extends State<ScreenApprovelDprPage> {
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    context.read<FetchApprovelDprBloc>().add(FetchApprovelDpr());
  }

  // ---------------- FILTER DIALOG ----------------

  void _showFilterDialog() {
    DateFilterDialog.show(
      context: context,
      title: context.tr('filter_dpr'),
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


  // â”€â”€â”€ Approve action â”€â”€â”€
  void _showApproveConfirmation(BuildContext context, ApproveDprDataModel dpr) {
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
                          text: context.tr('approve_dpr'),
                          weight: FontWeight.bold,
                          color: Appcolors.kblackcolor,
                        ),
                        ResponsiveSizedBox.height5,
                        TextStyles.caption(
                          text: dpr.employeeName,
                          color: Appcolors.kgreyColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ResponsiveSizedBox.height15,
              TextStyles.body(
                text: context.tr('are_you_sure_you_want_to_approve_this_dpr_progre'),
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
                        Navigator.pop(sheetContext);
                        context.read<UpdateApprovelDprBloc>().add(
                          ApproveDprEvent(progressId: dpr.progressId),
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
                        text: context.tr('approve'),
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
  void _showRejectConfirmation(BuildContext context, ApproveDprDataModel dpr) {
    RejectionBottomSheet.show(
      context: context,
      title: context.tr('reject_dpr'),
      subtitle:
          'Please provide a reason for rejecting ${dpr.employeeName}\'s DPR progress.',
      onReject: (remarks) {
        context.read<UpdateApprovelDprBloc>().add(
          RejectDprEvent(progressId: dpr.progressId, approverRemarks: remarks),
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
    
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Appcolors.kprimarycolor,
          ),
        ),
        title: TextStyles.title(
          text: context.tr('approve_dpr'),
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
      body: BlocListener<UpdateApprovelDprBloc, UpdateApprovelDprState>(
        listener: (context, updateState) {
          if (updateState is UpdateApprovelDprLoadingState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) =>
                  const Center(child: CircularProgressIndicator()),
            );
          } else if (updateState is UpdateApprovelDprSuccessState) {
            Navigator.of(context, rootNavigator: true).pop();
            CustomSnackbar.show(
              context: context,
              message: updateState.message,
              type: SnackBarType.success,
            );
            context.read<FetchApprovelDprBloc>().add(FetchApprovelDpr());
          } else if (updateState is UpdateApprovelDprErrorState) {
            Navigator.of(context, rootNavigator: true).pop();
            CustomSnackbar.show(
              context: context,
              message: updateState.message,
              type: SnackBarType.error,
            );
          }
        },
        child: BlocBuilder<FetchApprovelDprBloc, FetchApprovelDprState>(
          builder: (context, state) {
            if (state is FetchApprovelDprLoading) {
              return CustomListShimmer();
            }
            if (state is FetchApprovelDprError) {
              return NoDataWidget(title: state.message, assetIcon: Appconstants.dprreport,onRefresh: (){
                        context.read<FetchApprovelDprBloc>().add(
                          FetchApprovelDpr(),
                        );
              },);
            }
            if (state is FetchApprovelDprLoaded) {
              final dprList = state.approveDprList;
              if (dprList.isEmpty) {
                return NoDataWidget(title: context.tr('no_dpr_records_found'), assetIcon:Appconstants.dprreport);
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<FetchApprovelDprBloc>().add(FetchApprovelDpr());
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                  itemCount: dprList.length,
                  itemBuilder: (context, index) {
                    final dpr = dprList[index];
                    final isPending =
                        dpr.status.toUpperCase() != 'APPROVED' &&
                        dpr.status.toUpperCase() != 'REJECTED';

                    return Slidable(
                      key: ValueKey(dpr.progressId),
                      enabled: isPending,
                      startActionPane: isPending
                          ? ActionPane(
                              extentRatio: 0.25,
                              motion: const StretchMotion(),
                              children: [
                                CustomSlidableAction(
                                  onPressed: (_) {
                                    _showApproveConfirmation(context, dpr);
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
                                        text: context.tr('approve'),
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
                                    _showRejectConfirmation(context, dpr);
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
                                        text: context.tr('reject'),
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
                        onTap: () =>
                            context.push('/approveldprdetailpage', extra: dpr),
                        child: _buildDprCard(dpr),
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

  Widget _buildDprCard(ApproveDprDataModel dpr) {
    final statusStr = dpr.status.toUpperCase();
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
            offset: const Offset(0, 4),
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
                color: Appcolors.kprimarycolor.withOpacity(0.1),
                borderRadius: BorderRadiusStyles.kradius10(),
              ),
              child: Icon(
                Icons.assignment_rounded,
                color: Appcolors.kprimarycolor,
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
                    text: dpr.employeeName,
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                  ),
                  ResponsiveSizedBox.height5,

                  /// DPR Name
                  TextStyles.caption(
                    text: dpr.dprName,
                    color: Appcolors.kblackcolor,
                    weight: FontWeight.w600,
                  ),
                  ResponsiveSizedBox.height5,

                  /// Project Name
                  Row(
                    children: [
                      Icon(
                        Icons.business_rounded,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      Expanded(
                        child: TextStyles.caption(
                          text: dpr.projectName,
                          color: Appcolors.kgreyColor,
                        ),
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height5,

                  /// Progress Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(text: _formatDate(dpr.progressDate)),
                    ],
                  ),
                  ResponsiveSizedBox.height5,

                  /// Quantity
                  Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(text: "Qty: ${dpr.progressQuantity}"),
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
