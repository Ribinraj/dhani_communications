import 'package:dhani_communications/core/appconstants.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/widgets/custom_nondatawidget.dart';
import 'package:dhani_communications/widgets/customshimmer_widget.dart';
import 'package:dhani_communications/widgets/date_filter_dialog.dart';
import 'package:dhani_communications/features/approvals/bloc/fetch_approvel_expense_bloc/fetch_approvel_expense_bloc.dart';
import 'package:dhani_communications/features/approvals/bloc/update_approvel_expense/update_approvel_expense_bloc.dart';
import 'package:dhani_communications/features/approvals/models/approvels_expensemodel.dart';
import 'package:dhani_communications/widgets/custom_snackbar.dart';
import 'package:dhani_communications/widgets/rejection_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dhani_communications/core/localization/app_localization.dart';

class ScreenExpenseApprovalPage extends StatefulWidget {
  const ScreenExpenseApprovalPage({super.key});

  @override
  State<ScreenExpenseApprovalPage> createState() =>
      _ScreenExpenseApprovalPageState();
}

class _ScreenExpenseApprovalPageState extends State<ScreenExpenseApprovalPage> {
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    context.read<FetchApprovelExpenseBloc>().add(
      FetchApprovelExpenseInitialEvent(),
    );
  }

  // ─── Approve Handler ───
  void _approveExpense(String expenseId) {
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
                          ApproveExpenseEvent(expenseId: expenseId),
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

  // ─── Reject Handler ───
  void _rejectExpense(String expenseId) {
    RejectionBottomSheet.show(
      context: context,
      title: context.tr('reject_expense'),
      subtitle: context.tr('please_provide_a_reason_for_rejecting_this_expen'),
      onReject: (remarks) {
        context.read<UpdateApprovelExpenseBloc>().add(
          RejectExpenseEvent(expenseId: expenseId, approverRemarks: remarks),
        );
      },
    );
  }

  // ─── Filter Dialog ───
  void _showFilterDialog() {
    DateFilterDialog.show(
      context: context,
      title: context.tr('filter_expenses'),
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

  // ─── UI ───
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
          text: context.tr('approve_expenses'),
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
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: BlocListener<UpdateApprovelExpenseBloc, UpdateApprovelExpenseState>(
        listener: (context, updateState) {
          if (updateState is UpdateApprovelExpenseLoadingState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) =>
                  const Center(child: CircularProgressIndicator()),
            );
          } else if (updateState is UpdateApprovelExpenseSuccessState) {
            Navigator.of(context, rootNavigator: true).pop();
            CustomSnackbar.show(
              context: context,
              message: updateState.message,
              type: SnackBarType.success,
            );
            // Refresh list
            context.read<FetchApprovelExpenseBloc>().add(
              FetchApprovelExpenseInitialEvent(),
            );
          } else if (updateState is UpdateApprovelExpenseErrorState) {
            Navigator.of(context, rootNavigator: true).pop();
            CustomSnackbar.show(
              context: context,
              message: updateState.message,
              type: SnackBarType.error,
            );
          }
        },
        child: BlocBuilder<FetchApprovelExpenseBloc, FetchApprovelExpenseState>(
          builder: (context, state) {
            if (state is FetchApprovelExpenseLoadingState) {
              return CustomListShimmer();
            } else if (state is FetchApprovelExpensesErrorState) {
              return NoDataWidget(
                title: state.message,
                assetIcon: Appconstants.expenses,
                onRefresh: () {
                  context.read<FetchApprovelExpenseBloc>().add(
                    FetchApprovelExpenseInitialEvent(),
                  );
                },
              );
            } else if (state is FetchApprovelExpensesSuccessSate) {
              final expenses = state.expenses;

              if (expenses.isEmpty) {
                return NoDataWidget(
                  title: context.tr('expenses_is_empty'),
                  assetIcon: Appconstants.expenses,
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];
                  final isPending = expense.status.toUpperCase() == 'PENDING';

                  return Slidable(
                    key: ValueKey(expense.expenseId),
                    enabled: isPending,
                    startActionPane: isPending
                        ? ActionPane(
                            extentRatio: 0.25,
                            motion: const StretchMotion(),
                            children: [
                              CustomSlidableAction(
                                onPressed: (_) =>
                                    _approveExpense(expense.expenseId),
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
                                onPressed: (_) =>
                                    _rejectExpense(expense.expenseId),
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
                      onTap: () => context.push(
                        '/expenseapproveldetailpage',
                        extra: expense,
                      ),
                      child: _buildExpenseCard(expense),
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

  // ─── EXPENSE CARD ───
  Widget _buildExpenseCard(ApprovelsExpensemodel expense) {
    final status = expense.status.toUpperCase();
    Color statusColor;
    IconData statusIcon;

    if (status == "APPROVED") {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (status == "REJECTED") {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
    } else {
      statusColor = Colors.orange;
      statusIcon = Icons.pending;
    }

    final displayStatus = status == 'APPROVED'
        ? 'Approved'
        : status == 'REJECTED'
        ? 'Rejected'
        : 'Pending';

    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.hp(2)),
      decoration: BoxDecoration(
        color: Appcolors.kwhitecolor,
        borderRadius: BorderRadiusStyles.kradius15(),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: Appcolors.kgreyColor.withOpacity(0.15),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Employee Name
                  TextStyles.medium(
                    text: expense.employeeName,
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                  ),
                  ResponsiveSizedBox.height5,
                  // Amount
                  TextStyles.title(
                    text: '₹${expense.expenseAmount}',
                    color: Appcolors.kprimarycolor,
                  ),
                  ResponsiveSizedBox.height5,
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text: _formatDate(expense.expenseDate),
                        color: Appcolors.kgreyColor,
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height5,
                  // Category
                  if (expense.expenseCategoryName.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.category_rounded,
                          size: ResponsiveUtils.sp(3.5),
                          color: Appcolors.kgreyColor,
                        ),
                        ResponsiveSizedBox.width(1.5),
                        Expanded(
                          child: TextStyles.caption(
                            text: expense.expenseCategoryName,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  if (expense.userRemarks != null &&
                      expense.userRemarks!.isNotEmpty) ...[
                    ResponsiveSizedBox.height5,
                    Row(
                      children: [
                        Icon(
                          Icons.comment_outlined,
                          size: ResponsiveUtils.sp(3.5),
                          color: Appcolors.kgreyColor,
                        ),
                        ResponsiveSizedBox.width(1.5),
                        Expanded(
                          child: TextStyles.caption(
                            text: expense.userRemarks!,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            ResponsiveSizedBox.width(2),
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
                    color: statusColor,
                    size: ResponsiveUtils.sp(6),
                  ),
                ),
                ResponsiveSizedBox.height5,
                TextStyles.caption(
                  text: displayStatus,
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
