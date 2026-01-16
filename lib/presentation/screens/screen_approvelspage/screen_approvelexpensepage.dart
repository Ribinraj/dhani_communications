import 'package:flutter/material.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:dhani_communications/core/constants.dart';

class ScreenExpenseApprovalPage extends StatefulWidget {
  const ScreenExpenseApprovalPage({super.key});

  @override
  State<ScreenExpenseApprovalPage> createState() =>
      _ScreenExpenseApprovalPageState();
}

class _ScreenExpenseApprovalPageState extends State<ScreenExpenseApprovalPage> {
  DateTime? _fromDate;
  DateTime? _toDate;

  // Sample expenses list
  final List<Map<String, dynamic>> expensesList = [
    {
      'date': '03 Jan 2026',
      'amount': '₹2,500',
      'remarks': 'Client meeting transportation',
      'status': 'Approved',
    },
    {
      'date': '03 Jan 2026',
      'amount': '₹1,250',
      'remarks': 'Team lunch with client',
      'status': 'Pending',
    },
    {
      'date': '02 Jan 2026',
      'amount': '₹5,800',
      'remarks': 'Flight tickets for business trip',
      'status': 'Approved',
    },
    {
      'date': '02 Jan 2026',
      'amount': '₹750',
      'remarks': 'Office stationery purchase',
      'status': 'Pending',
    },
    {
      'date': '01 Jan 2026',
      'amount': '₹3,200',
      'remarks': 'Hotel stay for conference',
      'status': 'Approved',
    },
    {
      'date': '01 Jan 2026',
      'amount': '₹450',
      'remarks': 'Breakfast meeting expenses',
      'status': 'Rejected',
    },
  ];

  // ------------------ FILTER DIALOG -------------------

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        DateTime? tempFromDate = _fromDate;
        DateTime? tempToDate = _toDate;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusStyles.kradius20(),
              ),
              child: Container(
                padding: EdgeInsets.all(ResponsiveUtils.wp(6)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(ResponsiveUtils.wp(2.5)),
                          decoration: BoxDecoration(
                            color: Appcolors.kprimarycolor.withOpacity(0.1),
                            borderRadius: BorderRadiusStyles.kradius10(),
                          ),
                          child: Icon(
                            Icons.filter_list_rounded,
                            color: Appcolors.kprimarycolor,
                            size: ResponsiveUtils.sp(6),
                          ),
                        ),
                        ResponsiveSizedBox.width(3),
                        TextStyles.headline(
                          text: 'Filter Expenses',
                          weight: FontWeight.bold,
                          color: Appcolors.kblackcolor,
                        ),
                      ],
                    ),
                    ResponsiveSizedBox.height30,
                    _buildDateSelector(
                      label: 'From Date',
                      date: tempFromDate,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: tempFromDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setDialogState(() => tempFromDate = date);
                        }
                      },
                    ),
                    ResponsiveSizedBox.height20,
                    _buildDateSelector(
                      label: 'To Date',
                      date: tempToDate,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: tempToDate ?? DateTime.now(),
                          firstDate: tempFromDate ?? DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setDialogState(() => tempToDate = date);
                        }
                      },
                    ),
                    ResponsiveSizedBox.height30,
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _fromDate = null;
                                _toDate = null;
                              });
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Appcolors.kgreyColor,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusStyles.kradius10(),
                              ),
                            ),
                            child: TextStyles.medium(
                              text: 'Clear',
                              color: Appcolors.kgreyColor,
                            ),
                          ),
                        ),
                        ResponsiveSizedBox.width(3),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _fromDate = tempFromDate;
                                _toDate = tempToDate;
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Appcolors.kprimarycolor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusStyles.kradius10(),
                              ),
                            ),
                            child: TextStyles.medium(
                              text: 'Apply',
                              color: Appcolors.kwhitecolor,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // DATE PICKER WIDGET
  Widget _buildDateSelector({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
        decoration: BoxDecoration(
          borderRadius: BorderRadiusStyles.kradius10(),
          border: Border.all(
            color: Appcolors.kgreyColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              color: Appcolors.kprimarycolor,
            ),
            ResponsiveSizedBox.width(3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextStyles.caption(
                    text: label,
                    color: Appcolors.kgreyColor,
                  ),
                  ResponsiveSizedBox.height5,
                  TextStyles.medium(
                    text: date != null
                        ? '${date.day.toString().padLeft(2, '0')} ${_getMonthName(date.month)} ${date.year}'
                        : 'Select date',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }

  // ------------------- UI --------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.kwhitecolor,
      appBar: AppBar(
        backgroundColor: Appcolors.kwhitecolor,
        elevation: 2,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Appcolors.kprimarycolor),
        ),
        title: TextStyles.subheadline(
          text: 'Approve Expenses',
          weight: FontWeight.bold,
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
                ),
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
      body: ListView.builder(
        padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
        itemCount: expensesList.length,
        itemBuilder: (context, index) {
          final expense = expensesList[index];

          return Slidable(
            key: ValueKey(index),
            startActionPane: ActionPane(
              extentRatio: 0.25,
              motion: const StretchMotion(),
              children: [
                CustomSlidableAction(
                  onPressed: (_) {},
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  borderRadius: BorderRadiusStyles.kradius15(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: ResponsiveUtils.sp(8)),
                      ResponsiveSizedBox.height5,
                      TextStyles.caption(
                        text: 'Approve',
                        color: Colors.white,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            endActionPane: ActionPane(
              extentRatio: 0.25,
              motion: const StretchMotion(),
              children: [
                CustomSlidableAction(
                  onPressed: (_) {},
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  borderRadius: BorderRadiusStyles.kradius15(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cancel, size: ResponsiveUtils.sp(8)),
                      ResponsiveSizedBox.height5,
                      TextStyles.caption(
                        text: 'Reject',
                        color: Colors.white,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () => context.push('/expensedetailspage'),
              child: _buildExpenseCard(expense),
            ),
          );
        },
      ),
    );
  }

  // ----------------- EXPENSE CARD ---------------------

  Widget _buildExpenseCard(Map<String, dynamic> expense) {
    final status = expense["status"];
    Color statusColor;
    IconData statusIcon;

    if (status == "Approved") {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (status == "Rejected") {
      statusColor = Colors.red;
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
            blurRadius: 10,
            offset: Offset(0, 4),
            color: Appcolors.kgreyColor.withOpacity(0.15),
          )
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
                  TextStyles.headline(
                    text: expense['amount'],
                    color: Appcolors.kprimarycolor,
                  ),
                  ResponsiveSizedBox.height5,
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: ResponsiveUtils.sp(3.5),
                          color: Appcolors.kgreyColor),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text: expense['date'],
                        color: Appcolors.kgreyColor,
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height5,
                  Row(
                    children: [
                      Icon(Icons.comment_outlined,
                          size: ResponsiveUtils.sp(3.5),
                          color: Appcolors.kgreyColor),
                      ResponsiveSizedBox.width(1.5),
                      Expanded(
                        child: TextStyles.caption(
                          text: expense['remarks'],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
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
                  child: Icon(statusIcon,
                      color: statusColor, size: ResponsiveUtils.sp(6)),
                ),
                ResponsiveSizedBox.height5,
                TextStyles.caption(
                  text: status,
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
