import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:dhani_communications/features/approvals/bloc/fetch_approvel_machine_hire/fetch_approvel_machine_hire_bloc.dart';
import 'package:dhani_communications/features/approvals/bloc/update_machine_hire_approval/update_machine_hire_approval_bloc.dart';
import 'package:dhani_communications/features/approvals/models/approvels_machine_hire_model.dart';
import 'package:dhani_communications/widgets/custom_snackbar.dart';
import 'package:dhani_communications/widgets/rejection_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ScreenMachineHireApproveDetailPage extends StatelessWidget {
  final ApprovelsMachineHireModel machineHire;

  const ScreenMachineHireApproveDetailPage({
    super.key,
    required this.machineHire,
  });

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return 'N/A';
    try {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(dateStr));
    } catch (e) {
      return dateStr;
    }
  }

  String _formatDateTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      return DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(dateStr));
    } catch (e) {
      return dateStr;
    }
  }

  String _formatAmount(String amount) {
    if (amount.isEmpty) return 'N/A';
    if (amount.startsWith('₹')) return amount;
    return '₹$amount';
  }

  String _getStatusDisplay(String status) {
    final value = status.toUpperCase();
    if (value == 'APPROVED') return 'Approved';
    if (value == 'REJECTED') return 'Rejected';
    return 'Pending';
  }

  bool _isPending(String status) =>
      status.toUpperCase() != 'APPROVED' && status.toUpperCase() != 'REJECTED';

  Color _getStatusColor(String status) {
    if (status == 'Approved') return Colors.green;
    if (status == 'Rejected') return Colors.red;
    return Colors.orange;
  }

  IconData _getStatusIcon(String status) {
    if (status == 'Approved') return Icons.check_circle;
    if (status == 'Rejected') return Icons.cancel;
    return Icons.pending;
  }

  void _approveMachineHire(BuildContext context) {
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
                    color: Appcolors.kgreyColor.withValues(alpha: 0.3),
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
                      color: Colors.green.withValues(alpha: 0.1),
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
                    text: 'Approve Machine Hire',
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                  ),
                ],
              ),
              ResponsiveSizedBox.height15,
              TextStyles.body(
                text:
                    'Are you sure you want to approve this machine hire request?',
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
                        context.read<UpdateMachineHireApprovalBloc>().add(
                          ApproveMachineHireEvent(hireId: machineHire.hireId),
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

  void _rejectMachineHire(BuildContext context) {
    RejectionBottomSheet.show(
      context: context,
      title: 'Reject Machine Hire',
      subtitle: 'Please provide a reason for rejecting this machine hire.',
      onReject: (remarks) {
        context.read<UpdateMachineHireApprovalBloc>().add(
          RejectMachineHireEvent(
            hireId: machineHire.hireId,
            approverRemarks: remarks,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = _getStatusDisplay(machineHire.status);
    final isPending = _isPending(machineHire.status);
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);

    return BlocListener<
      UpdateMachineHireApprovalBloc,
      UpdateMachineHireApprovalState
    >(
      listener: (context, updateState) {
        if (updateState is UpdateMachineHireApprovalLoadingState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => const Center(child: CircularProgressIndicator()),
          );
        } else if (updateState is UpdateMachineHireApprovalSuccessState) {
          Navigator.of(context, rootNavigator: true).pop();
          CustomSnackbar.show(
            context: context,
            message: updateState.message,
            type: SnackBarType.success,
          );
          context.read<FetchApprovelMachineHireBloc>().add(
            FetchApprovelMachineHireInitialEvent(),
          );
          context.pop();
        } else if (updateState is UpdateMachineHireApprovalErrorState) {
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
          shadowColor: Appcolors.kgreyColor.withValues(alpha: 0.1),
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Appcolors.kprimarycolor,
              size: ResponsiveUtils.sp(5),
            ),
          ),
          title: TextStyles.subheadline(
            text: 'Machine Hire Approval',
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
                      color: Appcolors.kgreyColor.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _rejectMachineHire(context),
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
                        onPressed: () => _approveMachineHire(context),
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
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(ResponsiveUtils.wp(6)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Appcolors.kprimarycolor,
                      Appcolors.kprimarycolor.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadiusStyles.kradius15(),
                  boxShadow: [
                    BoxShadow(
                      color: Appcolors.kprimarycolor.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextStyles.caption(
                      text: 'Machine Hire',
                      color: Appcolors.kwhitecolor.withValues(alpha: 0.9),
                    ),
                    ResponsiveSizedBox.height10,
                    Text(
                      machineHire.machine.isEmpty
                          ? 'Unknown Machine'
                          : machineHire.machine,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(6),
                        fontWeight: FontWeight.bold,
                        color: Appcolors.kwhitecolor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    ResponsiveSizedBox.height5,
                    TextStyles.caption(
                      text: _formatAmount(machineHire.amountPaid),
                      color: Appcolors.kwhitecolor.withValues(alpha: 0.9),
                    ),
                    ResponsiveSizedBox.height10,
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
              _buildSectionCard(
                title: 'Hire Information',
                children: [
                  _buildDetailRow(
                    icon: Icons.tag,
                    iconColor: Appcolors.kprimarycolor,
                    label: 'Hire ID',
                    value: '#${machineHire.hireId}',
                  ),
                  ResponsiveSizedBox.height20,
                  _buildDetailRow(
                    icon: Icons.construction,
                    iconColor: Colors.orange,
                    label: 'Machine',
                    value: machineHire.machine.isEmpty
                        ? 'N/A'
                        : machineHire.machine,
                  ),
                  ResponsiveSizedBox.height20,
                  _buildDetailRow(
                    icon: Icons.work_outline,
                    iconColor: Colors.purple,
                    label: 'Project ID',
                    value: machineHire.projectId,
                  ),
                  ResponsiveSizedBox.height20,
                  _buildDetailRow(
                    icon: Icons.calendar_today,
                    iconColor: Colors.blue,
                    label: 'Hire Date',
                    value: _formatDate(machineHire.hireDate),
                  ),
                  ResponsiveSizedBox.height20,
                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailRow(
                          icon: Icons.access_time,
                          iconColor: Colors.teal,
                          label: 'From Time',
                          value: machineHire.fromTime,
                        ),
                      ),
                      ResponsiveSizedBox.width(2),
                      Expanded(
                        child: _buildDetailRow(
                          icon: Icons.access_time_filled,
                          iconColor: Colors.indigo,
                          label: 'To Time',
                          value: machineHire.toTime,
                        ),
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height20,
                  _buildDetailRow(
                    icon: Icons.timelapse,
                    iconColor: Colors.deepOrange,
                    label: 'Total Hours',
                    value: machineHire.totalHours,
                  ),
                  ResponsiveSizedBox.height20,
                  _buildDetailRow(
                    icon: Icons.currency_rupee,
                    iconColor: Colors.green,
                    label: 'Amount Paid',
                    value: _formatAmount(machineHire.amountPaid),
                  ),
                  ResponsiveSizedBox.height20,
                  _buildDetailRow(
                    icon: Icons.person_outline,
                    iconColor: Colors.teal,
                    label: 'Approver',
                    value: machineHire.approver.isEmpty
                        ? 'N/A'
                        : machineHire.approver,
                  ),
                  ResponsiveSizedBox.height20,
                  _buildDetailRow(
                    icon: Icons.access_time_rounded,
                    iconColor: Colors.indigo,
                    label: 'Created',
                    value: _formatDateTime(machineHire.createdAt?.date),
                  ),
                ],
              ),
              ResponsiveSizedBox.height(3),
              _buildRemarksCard(
                title: 'User Notes',
                icon: Icons.comment,
                iconColor: Colors.amber.shade700,
                bgColor: Colors.amber.withValues(alpha: 0.1),
                remarks: machineHire.notes,
                emptyText: 'No notes provided',
              ),
              if (machineHire.approverRemarks != null &&
                  machineHire.approverRemarks!.isNotEmpty) ...[
                ResponsiveSizedBox.height(3),
                _buildRemarksCard(
                  title: 'Approver Remarks',
                  icon: Icons.verified_user_rounded,
                  iconColor: Colors.green.shade700,
                  bgColor: Colors.green.withValues(alpha: 0.1),
                  remarks: machineHire.approverRemarks,
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
            color: Appcolors.kgreyColor.withValues(alpha: 0.15),
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
            color: Appcolors.kgreyColor.withValues(alpha: 0.15),
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
            color: iconColor.withValues(alpha: 0.1),
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
                text: value.isEmpty ? 'N/A' : value,
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
