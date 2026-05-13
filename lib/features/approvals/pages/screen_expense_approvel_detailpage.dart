import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/features/approvals/bloc/fetch_approvel_expense_bloc/fetch_approvel_expense_bloc.dart';
import 'package:dhani_communications/features/approvals/bloc/update_approvel_expense/update_approvel_expense_bloc.dart';
import 'package:dhani_communications/features/approvals/models/approvels_expensemodel.dart';
import 'package:dhani_communications/widgets/custom_snackbar.dart';
import 'package:dhani_communications/widgets/rejection_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dhani_communications/core/localization/app_localization.dart';

class ScreenExpenseAprvelsDetailpage extends StatelessWidget {
  final ApprovelsExpensemodel expense;

  const ScreenExpenseAprvelsDetailpage({super.key, required this.expense});

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

  Future<void> _openDocument(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          CustomSnackbar.show(
            context: context,
            message: context.tr('could_not_open_document'),
            type: SnackBarType.error,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackbar.show(
          context: context,
          message: context.trParams('error_opening_document', {'error': e}),
          type: SnackBarType.error,
        );
      }
    }
  }

  String _getDocumentType(String url) {
    final lowerUrl = url.toLowerCase();
    if (lowerUrl.contains('.pdf')) return 'pdf';
    if (lowerUrl.contains('.jpg') ||
        lowerUrl.contains('.jpeg') ||
        lowerUrl.contains('.png')) {
      return 'image';
    }
    if (lowerUrl.contains('.doc') || lowerUrl.contains('.docx')) return 'doc';
    return 'file';
  }

  IconData _getDocumentIcon(String type) {
    switch (type) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'image':
        return Icons.image;
      case 'doc':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getDocumentColor(String type) {
    switch (type) {
      case 'pdf':
        return Colors.red;
      case 'image':
        return Colors.blue;
      case 'doc':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  void _approveExpense(BuildContext context) {
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
                    text: context.tr('approve_expense'),
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                  ),
                ],
              ),
              ResponsiveSizedBox.height15,
              TextStyles.body(
                text: context.tr('are_you_sure_you_want_to_approve_this_expense'),
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
                        context.read<UpdateApprovelExpenseBloc>().add(
                          ApproveExpenseEvent(expenseId: expense.expenseId),
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

  void _rejectExpense(BuildContext context) {
    RejectionBottomSheet.show(
      context: context,
      title: context.tr('reject_expense'),
      subtitle: context.tr('please_provide_a_reason_for_rejecting_this_expen'),
      onReject: (remarks) {
        context.read<UpdateApprovelExpenseBloc>().add(
          RejectExpenseEvent(
            expenseId: expense.expenseId,
            approverRemarks: remarks,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String status = _getStatusDisplay(expense.status);
    final bool isPending = _isPending(expense.status);

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

    return BlocListener<UpdateApprovelExpenseBloc, UpdateApprovelExpenseState>(
      listener: (context, updateState) {
        if (updateState is UpdateApprovelExpenseLoadingState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => const Center(child: CircularProgressIndicator()),
          );
        } else if (updateState is UpdateApprovelExpenseSuccessState) {
          Navigator.of(context, rootNavigator: true).pop();
          CustomSnackbar.show(
            context: context,
            message: updateState.message,
            type: SnackBarType.success,
          );
          // Refresh list and go back
          context.read<FetchApprovelExpenseBloc>().add(
            FetchApprovelExpenseInitialEvent(),
          );
          context.pop();
        } else if (updateState is UpdateApprovelExpenseErrorState) {
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
            text: context.tr('expense_approval_details'),
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
                        onPressed: () => _rejectExpense(context),
                        icon: const Icon(Icons.cancel, color: Colors.white),
                        label: TextStyles.medium(
                          text: context.tr('reject'),
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
                        onPressed: () => _approveExpense(context),
                        icon: const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                        ),
                        label: TextStyles.medium(
                          text: context.tr('approve'),
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
              // ─── Amount Card ───
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
                    TextStyles.caption(
                      text: context.tr('total_amount'),
                      color: Appcolors.kwhitecolor.withOpacity(0.9),
                    ),
                    ResponsiveSizedBox.height10,
                    Text(
                      '₹${expense.expenseAmount}',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(12),
                        fontWeight: FontWeight.bold,
                        color: Appcolors.kwhitecolor,
                      ),
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
                title: context.tr('employee_information'),
                children: [
                  _buildDetailRow(
                    icon: Icons.person_outline,
                    iconColor: Appcolors.kprimarycolor,
                    label: 'Employee Name',
                    value: expense.employeeName,
                  ),
                  ResponsiveSizedBox.height20,
                  _buildDetailRow(
                    icon: Icons.business_rounded,
                    iconColor: Colors.teal,
                    label: 'Project',
                    value: expense.projectName,
                  ),
                ],
              ),
              ResponsiveSizedBox.height(3),

              // ─── Expense Details Card ───
              _buildSectionCard(
                title: context.tr('expense_information'),
                children: [
                  _buildDetailRow(
                    icon: Icons.badge_rounded,
                    iconColor: Appcolors.kprimarycolor,
                    label: 'Expense ID',
                    value: '#${expense.expenseId}',
                  ),
                  ResponsiveSizedBox.height20,
                  _buildDetailRow(
                    icon: Icons.calendar_today,
                    iconColor: Appcolors.kprimarycolor,
                    label: 'Date',
                    value: _formatDate(expense.expenseDate),
                  ),
                  ResponsiveSizedBox.height20,
                  // Category
                  if (expense.expenseCategoryName.isNotEmpty &&
                      expense.expenseCategoryName != '-') ...[
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadiusStyles.kradius10(),
                          ),
                          child: Icon(
                            Icons.category_rounded,
                            color: Colors.purple,
                            size: ResponsiveUtils.sp(5),
                          ),
                        ),
                        ResponsiveSizedBox.width(3),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextStyles.caption(
                                text: context.tr('category'),
                                color: Appcolors.kgreyColor,
                              ),
                              ResponsiveSizedBox.height5,
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveUtils.wp(3),
                                  vertical: ResponsiveUtils.hp(0.6),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.purple.withOpacity(0.1),
                                  borderRadius: BorderRadiusStyles.kradius5(),
                                ),
                                child: TextStyles.medium(
                                  text: expense.expenseCategoryName,
                                  weight: FontWeight.w600,
                                  color: Colors.purple.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ResponsiveSizedBox.height20,
                  ],

                  // Vehicle Info
                  if (expense.vehicleId != null &&
                      expense.vehicleId!.isNotEmpty) ...[
                    _buildDetailRow(
                      icon: Icons.directions_car,
                      iconColor: Colors.blue,
                      label: 'Vehicle ID',
                      value: expense.vehicleId!,
                    ),
                    ResponsiveSizedBox.height20,
                  ],

                  // Fuel Fill KM
                  if (expense.fuelFillKm != null &&
                      expense.fuelFillKm!.isNotEmpty) ...[
                    _buildDetailRow(
                      icon: Icons.local_gas_station,
                      iconColor: Colors.orange,
                      label: 'Fuel Fill KM',
                      value: expense.fuelFillKm!,
                    ),
                    ResponsiveSizedBox.height20,
                  ],

                  // Last Service KM
                  if (expense.lastServiceKm != null &&
                      expense.lastServiceKm!.isNotEmpty) ...[
                    _buildDetailRow(
                      icon: Icons.build_circle,
                      iconColor: Colors.brown,
                      label: 'Last Service KM',
                      value: expense.lastServiceKm!,
                    ),
                    ResponsiveSizedBox.height20,
                  ],

                  // Approver
                  if (expense.approver.isNotEmpty) ...[
                    _buildDetailRow(
                      icon: Icons.person_outline,
                      iconColor: Colors.teal,
                      label: 'Approver',
                      value: expense.approver,
                    ),
                    ResponsiveSizedBox.height20,
                  ],

                  // Created Date
                  _buildDetailRow(
                    icon: Icons.access_time_rounded,
                    iconColor: Colors.indigo,
                    label: 'Created',
                    value: _formatDate(expense.createdDate),
                  ),
                  ResponsiveSizedBox.height20,

                  // Last Modified
                  _buildDetailRow(
                    icon: Icons.update_rounded,
                    iconColor: Colors.deepPurple,
                    label: 'Last Modified',
                    value: _formatDate(expense.lastModifiedDate),
                  ),
                ],
              ),
              ResponsiveSizedBox.height(3),

              // ─── User Remarks ───
              _buildRemarksCard(
                title: context.tr('user_remarks'),
                icon: Icons.comment,
                iconColor: Colors.amber.shade700,
                bgColor: Colors.amber.withOpacity(0.1),
                remarks: expense.userRemarks,
                emptyText: context.tr('no_remarks_provided'),
              ),

              // ─── Approver Remarks ───
              if (expense.approverRemarks != null &&
                  expense.approverRemarks!.isNotEmpty) ...[
                ResponsiveSizedBox.height(3),
                _buildRemarksCard(
                  title: context.tr('approver_remarks'),
                  icon: Icons.verified_user_rounded,
                  iconColor: Colors.green.shade700,
                  bgColor: Colors.green.withOpacity(0.1),
                  remarks: expense.approverRemarks,
                  emptyText: '',
                ),
              ],

              // ─── HQ Remarks ───
              if (expense.headquarterRemarks != null &&
                  expense.headquarterRemarks!.isNotEmpty) ...[
                ResponsiveSizedBox.height(3),
                _buildRemarksCard(
                  title: context.tr('hq_remarks'),
                  icon: Icons.business,
                  iconColor: Colors.blue.shade700,
                  bgColor: Colors.blue.withOpacity(0.1),
                  remarks: expense.headquarterRemarks,
                  emptyText: '',
                ),
              ],

              // ─── Documents ───
              if (expense.expenseDocuments.isNotEmpty) ...[
                ResponsiveSizedBox.height(3),
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
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadiusStyles.kradius10(),
                            ),
                            child: Icon(
                              Icons.attachment,
                              color: Colors.blue,
                              size: ResponsiveUtils.sp(5),
                            ),
                          ),
                          ResponsiveSizedBox.width(2),
                          TextStyles.subheadline(
                            text: context.tr('documents'),
                            weight: FontWeight.bold,
                            color: Appcolors.kblackcolor,
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveUtils.wp(2.5),
                              vertical: ResponsiveUtils.hp(0.5),
                            ),
                            decoration: BoxDecoration(
                              color: Appcolors.kprimarycolor.withOpacity(0.1),
                              borderRadius: BorderRadiusStyles.kradius20(),
                            ),
                            child: TextStyles.caption(
                              text: '${expense.expenseDocuments.length} files',
                              weight: FontWeight.w600,
                              color: Appcolors.kprimarycolor,
                            ),
                          ),
                        ],
                      ),
                      ResponsiveSizedBox.height15,
                      ...List.generate(expense.expenseDocuments.length, (
                        index,
                      ) {
                        final document = expense.expenseDocuments[index];
                        return _buildDocumentItem(
                          context,
                          document,
                          index,
                          expense.expenseDocuments.length,
                        );
                      }),
                    ],
                  ),
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

  Widget _buildDocumentItem(
    BuildContext context,
    ExpenseDocumentModel document,
    int index,
    int totalCount,
  ) {
    final docType = _getDocumentType(document.document);
    final docColor = _getDocumentColor(docType);
    final fileName = document.fileName.isNotEmpty
        ? document.fileName
        : document.document.split('/').last;

    return Container(
      margin: EdgeInsets.only(
        bottom: index < totalCount - 1 ? ResponsiveUtils.hp(1.5) : 0,
      ),
      padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
      decoration: BoxDecoration(
        color: docColor.withOpacity(0.05),
        borderRadius: BorderRadiusStyles.kradius10(),
        border: Border.all(color: docColor.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.wp(2.5)),
            decoration: BoxDecoration(
              color: docColor.withOpacity(0.1),
              borderRadius: BorderRadiusStyles.kradius10(),
            ),
            child: Icon(
              _getDocumentIcon(docType),
              color: docColor,
              size: ResponsiveUtils.sp(6),
            ),
          ),
          ResponsiveSizedBox.width(3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextStyles.medium(
                  text: fileName,
                  weight: FontWeight.w600,
                  color: Appcolors.kblackcolor,
                  overflow: TextOverflow.ellipsis,
                ),
                ResponsiveSizedBox.height5,
                TextStyles.caption(
                  text: docType.toUpperCase(),
                  color: Appcolors.kgreyColor,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              _openDocument(context, document.document);
            },
            icon: Icon(
              Icons.download_rounded,
              color: docColor,
              size: ResponsiveUtils.sp(5.5),
            ),
          ),
        ],
      ),
    );
  }
}
