import 'package:dhani_communications/core/appconstants.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/widgets/date_filter_dialog.dart';
import 'package:dhani_communications/core/network_services.dart';
import 'package:dhani_communications/features/dashboard/models/expense_model.dart';
import 'package:dhani_communications/features/dashboard/repo/apprepo.dart';
import 'package:dhani_communications/features/dashboard/blocs/expense_list_bloc/expense_list_bloc.dart';
import 'package:dhani_communications/widgets/custom_nondatawidget.dart';
import 'package:dhani_communications/widgets/customshimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';

class ScreenEmployeeExpensesPage extends StatefulWidget {
  const ScreenEmployeeExpensesPage({super.key});

  @override
  State<ScreenEmployeeExpensesPage> createState() =>
      _ScreenEmployeeExpensesPageState();
}

class _ScreenEmployeeExpensesPageState
    extends State<ScreenEmployeeExpensesPage> {
  DateTime? _fromDate;
  DateTime? _toDate;
  late ExpenseListBloc _expenseListBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _expenseListBloc = ExpenseListBloc(
      repository: Apprepo(DioClient.create(context)),
    );
    // Fetch expense list without filters initially
    _expenseListBloc.add(FetchExpenseListEvent());
  }

  @override
  void dispose() {
    _expenseListBloc.close();
    super.dispose();
  }

  void _applyFilter() {
    String? startDateStr;
    String? endDateStr;

    if (_fromDate != null) {
      startDateStr = DateFormat('yyyy-MM-dd').format(_fromDate!);
    }
    if (_toDate != null) {
      endDateStr = DateFormat('yyyy-MM-dd').format(_toDate!);
    }

    _expenseListBloc.add(
      FetchExpenseListEvent(startDate: startDateStr, endDate: endDateStr),
    );
  }

  void _showFilterDialog() {
    DateFilterDialog.show(
      context: context,
      title: 'Filter Expenses',
      initialFromDate: _fromDate,
      initialToDate: _toDate,
      onApply: (fromDate, toDate) {
        setState(() {
          _fromDate = fromDate;
          _toDate = toDate;
        });
        _applyFilter();
      },
      onClear: () {
        setState(() {
          _fromDate = null;
          _toDate = null;
        });
        _expenseListBloc.add(FetchExpenseListEvent());
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

  String _getStatusDisplay(String status) {
    if (status.toUpperCase() == 'APPROVED') return 'Approved';
    if (status.toUpperCase() == 'REJECTED') return 'Rejected';
    return 'Pending';
  }

  bool _isApproved(String status) => status.toUpperCase() == 'APPROVED';
  bool _isRejected(String status) => status.toUpperCase() == 'REJECTED';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.kwhitecolor,
      appBar: AppBar(
        backgroundColor: Appcolors.kappbarbackgroundcolor,

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
          text: 'Employee Expenses',
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
                      decoration: BoxDecoration(
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
      body: BlocProvider(
        create: (context) => _expenseListBloc,
        child: BlocBuilder<ExpenseListBloc, ExpenseListState>(
          bloc: _expenseListBloc,
          builder: (context, state) {
            if (state is ExpenseListLoadingState) {
              return CustomListShimmer();
            }

            if (state is ExpenseListErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: ResponsiveUtils.sp(15),
                      color: Appcolors.kredcolor.withOpacity(0.7),
                    ),
                    ResponsiveSizedBox.height20,
                    TextStyles.subheadline(
                      text: state.message,
                      color: Appcolors.kgreyColor,
                    ),
                    ResponsiveSizedBox.height20,
                    ElevatedButton(
                      onPressed: () {
                        _expenseListBloc.add(FetchExpenseListEvent());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolors.kprimarycolor,
                      ),
                      child: TextStyles.medium(
                        text: 'Retry',
                        color: Appcolors.kwhitecolor,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is ExpenseListSuccessState) {
              final expensesList = state.expensesList;

              if (expensesList.isEmpty) {
                return NoDataWidget(
                  title: "Expense List is Empty",
                  assetIcon: Appconstants.expenses,
                );
              }

              return RefreshIndicator(
                color: Appcolors.kprimarycolor,
                onRefresh: () async {
                  _applyFilter();
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                  itemCount: expensesList.length,
                  itemBuilder: (context, index) {
                    final expense = expensesList[index];
                    return GestureDetector(
                      onTap: () {
                        context.push('/expensedetailspage', extra: expense);
                      },
                      child: _buildExpenseCard(expense),
                    );
                  },
                ),
              );
            }

            // Initial state
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_rounded,
                    size: ResponsiveUtils.sp(20),
                    color: Appcolors.kgreyColor.withOpacity(0.5),
                  ),
                  ResponsiveSizedBox.height20,
                  TextStyles.subheadline(
                    text: 'No expense records found',
                    color: Appcolors.kgreyColor,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildExpenseCard(ExpenseModel expense) {
    final bool isApproved = _isApproved(expense.status);
    final bool isRejected = _isRejected(expense.status);
    final String statusDisplay = _getStatusDisplay(expense.status);

    Color statusColor;
    IconData statusIcon;
    if (isApproved) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (isRejected) {
      statusColor = Appcolors.kredcolor;
      statusIcon = Icons.cancel;
    } else {
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Amount
                  TextStyles.headline(
                    text: '₹${expense.expenseAmount.toStringAsFixed(2)}',
                    weight: FontWeight.bold,
                    color: Appcolors.kprimarycolor,
                  ),
                  ResponsiveSizedBox.height5,
                  // Date and Category
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
                      ResponsiveSizedBox.width(2),
                      if (expense.expenseCategoryName.isNotEmpty &&
                          expense.expenseCategoryName != '-')
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveUtils.wp(2),
                              vertical: ResponsiveUtils.hp(0.3),
                            ),
                            decoration: BoxDecoration(
                              color: Appcolors.kprimarycolor.withOpacity(0.1),
                              borderRadius: BorderRadiusStyles.kradius5(),
                            ),
                            child: TextStyles.caption(
                              text: expense.expenseCategoryName,
                              weight: FontWeight.w600,
                              color: Appcolors.kprimarycolor,
                            ),
                          ),
                        ),
                    ],
                  ),
                  ResponsiveSizedBox.height5,
                  // Remarks
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
                          text: expense.userRemarks.isNotEmpty
                              ? expense.userRemarks
                              : 'No remarks',
                          color: Appcolors.kgreyColor,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ResponsiveSizedBox.width(2),
            // Status
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
                  text: statusDisplay,
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
