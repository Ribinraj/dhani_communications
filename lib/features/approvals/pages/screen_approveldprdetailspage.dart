import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/features/approvals/bloc/fetch_approvel_dprbloc/fetch_approvel_dpr_bloc.dart';
import 'package:dhani_communications/features/approvals/bloc/update_approvel_dpr/update_approvel_dpr_bloc.dart';
import 'package:dhani_communications/features/approvals/models/approvels_dprmodel.dart';
import 'package:dhani_communications/widgets/custom_snackbar.dart';
import 'package:dhani_communications/widgets/rejection_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenApprovelDprDetailsPage extends StatelessWidget {
  final ApproveDprDataModel dpr;

  const ScreenApprovelDprDetailsPage({super.key, required this.dpr});

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

  String _getStatusDisplay(String status) {
    if (status.toUpperCase() == 'APPROVED') return 'Approved';
    if (status.toUpperCase() == 'REJECTED') return 'Rejected';
    return 'Pending';
  }

  bool _isPending(String status) =>
      status.toUpperCase() != 'APPROVED' && status.toUpperCase() != 'REJECTED';

  void _approveDpr(BuildContext context) {
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
                  TextStyles.headline(
                    text: 'Approve DPR',
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                  ),
                ],
              ),
              ResponsiveSizedBox.height15,
              TextStyles.body(
                text: 'Are you sure you want to approve this DPR progress?',
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

  void _rejectDpr(BuildContext context) {
    RejectionBottomSheet.show(
      context: context,
      title: 'Reject DPR',
      subtitle: 'Please provide a reason for rejecting this DPR progress.',
      onReject: (remarks) {
        context.read<UpdateApprovelDprBloc>().add(
          RejectDprEvent(progressId: dpr.progressId, approverRemarks: remarks),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String status = _getStatusDisplay(dpr.status);
    final bool isPending = _isPending(dpr.status);

    Color statusColor;
    IconData statusIcon;
    if (status == 'Approved') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (status == 'Rejected') {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
    } else {
      statusColor = Colors.orange;
      statusIcon = Icons.pending;
    }

    return BlocListener<UpdateApprovelDprBloc, UpdateApprovelDprState>(
      listener: (context, updateState) {
        if (updateState is UpdateApprovelDprLoadingState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => const Center(child: CircularProgressIndicator()),
          );
        } else if (updateState is UpdateApprovelDprSuccessState) {
          Navigator.of(context, rootNavigator: true).pop();
          CustomSnackbar.show(
            context: context,
            message: updateState.message,
            type: SnackBarType.success,
          );
          context.read<FetchApprovelDprBloc>().add(FetchApprovelDpr());
          context.pop();
        } else if (updateState is UpdateApprovelDprErrorState) {
          Navigator.of(context, rootNavigator: true).pop();
          CustomSnackbar.show(
            context: context,
            message: updateState.message,
            type: SnackBarType.error,
          );
        }
      },
      child: Scaffold(
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
            text: 'DPR Approval Details',
            weight: FontWeight.bold,
            color: Appcolors.kblackcolor,
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: isPending
            ? Container(
                padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                decoration: BoxDecoration(
                  color: Appcolors.kwhitecolor,
                  boxShadow: [
                    BoxShadow(
                      color: Appcolors.kgreyColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _rejectDpr(context),
                        icon: const Icon(Icons.cancel, color: Colors.white),
                        label: TextStyles.medium(
                          text: 'Reject',
                          weight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(
                            vertical: ResponsiveUtils.hp(1.5),
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
                        onPressed: () => _approveDpr(context),
                        icon: const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                        ),
                        label: TextStyles.medium(
                          text: 'Approve',
                          weight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(
                            vertical: ResponsiveUtils.hp(1.5),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusStyles.kradius10(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : null,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Header Card ───
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(ResponsiveUtils.wp(6)),
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
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // DPR Name
                    TextStyles.caption(
                      text: 'DPR Progress',
                      color: Appcolors.kwhitecolor.withOpacity(0.9),
                    ),
                    ResponsiveSizedBox.height10,
                    Text(
                      dpr.dprName,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(6),
                        fontWeight: FontWeight.bold,
                        color: Appcolors.kwhitecolor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    ResponsiveSizedBox.height5,
                    TextStyles.caption(
                      text: 'Quantity: ${dpr.progressQuantity}',
                      color: Appcolors.kwhitecolor.withOpacity(0.9),
                    ),
                    ResponsiveSizedBox.height10,
                    // Status Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.wp(4),
                        vertical: ResponsiveUtils.hp(0.8),
                      ),
                      decoration: BoxDecoration(
                        color: Appcolors.kwhitecolor,
                        borderRadius: BorderRadiusStyles.kradius20(),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            statusIcon,
                            color: statusColor,
                            size: ResponsiveUtils.sp(4.5),
                          ),
                          ResponsiveSizedBox.width(1.5),
                          TextStyles.medium(
                            text: status,
                            weight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ResponsiveSizedBox.height(3),

              // ─── Employee Info Card ───
              _buildSectionCard(
                title: 'Employee Information',
                children: [
                  _buildDetailRow(
                    icon: Icons.person_outline,
                    iconColor: Appcolors.kprimarycolor,
                    label: 'Employee Name',
                    value: dpr.employeeName,
                  ),
                  ResponsiveSizedBox.height20,
                  _buildDetailRow(
                    icon: Icons.business_rounded,
                    iconColor: Colors.teal,
                    label: 'Project',
                    value: dpr.projectName,
                  ),
                ],
              ),
              ResponsiveSizedBox.height(3),

              // ─── DPR Details Card ───
              _buildSectionCard(
                title: 'DPR Information',
                children: [
                  _buildDetailRow(
                    icon: Icons.badge_rounded,
                    iconColor: Appcolors.kprimarycolor,
                    label: 'Progress ID',
                    value: '#${dpr.progressId}',
                  ),
                  ResponsiveSizedBox.height20,
                  _buildDetailRow(
                    icon: Icons.assignment_rounded,
                    iconColor: Colors.indigo,
                    label: 'DPR Name',
                    value: dpr.dprName,
                  ),
                  ResponsiveSizedBox.height20,
                  _buildDetailRow(
                    icon: Icons.calendar_today,
                    iconColor: Colors.blue,
                    label: 'Progress Date',
                    value: _formatDate(dpr.progressDate),
                  ),
                  ResponsiveSizedBox.height20,
                  _buildDetailRow(
                    icon: Icons.inventory_2_outlined,
                    iconColor: Colors.deepOrange,
                    label: 'Progress Quantity',
                    value: dpr.progressQuantity,
                  ),
                  ResponsiveSizedBox.height20,
                  // Approver
                  if (dpr.approver.isNotEmpty) ...[
                    _buildDetailRow(
                      icon: Icons.person_outline,
                      iconColor: Colors.teal,
                      label: 'Approver',
                      value: dpr.approver,
                    ),
                    ResponsiveSizedBox.height20,
                  ],
                  // Approved By
                  if (dpr.approvedBy != null && dpr.approvedBy!.isNotEmpty) ...[
                    _buildDetailRow(
                      icon: Icons.verified_user_rounded,
                      iconColor: Colors.green,
                      label: 'Approved By',
                      value: dpr.approvedBy!,
                    ),
                    ResponsiveSizedBox.height20,
                  ],
                  // Created Date
                  _buildDetailRow(
                    icon: Icons.access_time_rounded,
                    iconColor: Colors.indigo,
                    label: 'Created',
                    value: _formatDate(dpr.createdDate),
                  ),
                  ResponsiveSizedBox.height20,
                  // Last Modified
                  _buildDetailRow(
                    icon: Icons.update_rounded,
                    iconColor: Colors.deepPurple,
                    label: 'Last Modified',
                    value: _formatDate(dpr.lastModifiedDate),
                  ),
                ],
              ),
              ResponsiveSizedBox.height(3),

              // ─── User Remarks ───
              _buildRemarksCard(
                title: 'User Remarks',
                icon: Icons.comment,
                iconColor: Colors.amber.shade700,
                bgColor: Colors.amber.withOpacity(0.1),
                remarks: dpr.userRemarks,
                emptyText: 'No remarks provided',
              ),

              // ─── Approver Remarks ───
              if (dpr.approverRemarks != null &&
                  dpr.approverRemarks!.isNotEmpty) ...[
                ResponsiveSizedBox.height(3),
                _buildRemarksCard(
                  title: 'Approver Remarks',
                  icon: Icons.verified_user_rounded,
                  iconColor: Colors.green.shade700,
                  bgColor: Colors.green.withOpacity(0.1),
                  remarks: dpr.approverRemarks,
                  emptyText: '',
                ),
              ],

              // ─── HQ Remarks ───
              if (dpr.headquarterRemarks != null &&
                  dpr.headquarterRemarks!.isNotEmpty) ...[
                ResponsiveSizedBox.height(3),
                _buildRemarksCard(
                  title: 'HQ Remarks',
                  icon: Icons.business,
                  iconColor: Colors.blue.shade700,
                  bgColor: Colors.blue.withOpacity(0.1),
                  remarks: dpr.headquarterRemarks,
                  emptyText: '',
                ),
              ],
              ResponsiveSizedBox.height(3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
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
            text: title,
            weight: FontWeight.bold,
            color: Appcolors.kblackcolor,
          ),
          ResponsiveSizedBox.height20,
          ...children,
        ],
      ),
    );
  }

  Widget _buildRemarksCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    String? remarks,
    required String emptyText,
  }) {
    return Container(
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
                  color: bgColor,
                  borderRadius: BorderRadiusStyles.kradius10(),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: ResponsiveUtils.sp(5),
                ),
              ),
              ResponsiveSizedBox.width(2),
              TextStyles.subheadline(
                text: title,
                weight: FontWeight.bold,
                color: Appcolors.kblackcolor,
              ),
            ],
          ),
          ResponsiveSizedBox.height15,
          TextStyles.medium(
            text: (remarks != null && remarks.isNotEmpty) ? remarks : emptyText,
            color: Appcolors.kgreyColor,
          ),
        ],
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
      children: [
        Container(
          padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
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
