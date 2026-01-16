import 'package:dhani_communications/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';

class ScreenLeaveApprovalPage extends StatefulWidget {
  const ScreenLeaveApprovalPage({super.key});

  @override
  State<ScreenLeaveApprovalPage> createState() =>
      _ScreenLeaveApprovalPageState();
}

class _ScreenLeaveApprovalPageState extends State<ScreenLeaveApprovalPage> {
  DateTime? _fromDate;
  DateTime? _toDate;

  // Sample leave data
  final List<Map<String, dynamic>> leavesList = [
    {
      'fromDate': '03 Jan 2026',
      'toDate': '03 Jan 2026',
      'leaveType': 'Casual Leave',
      'status': 'Approved',
    },
    {
      'fromDate': '05 Jan 2026',
      'toDate': '07 Jan 2026',
      'leaveType': 'Sick Leave',
      'status': 'Pending',
    },
    {
      'fromDate': '10 Jan 2026',
      'toDate': '12 Jan 2026',
      'leaveType': 'Casual Leave',
      'status': 'Rejected',
    },
    {
      'fromDate': '15 Jan 2026',
      'toDate': '15 Jan 2026',
      'leaveType': 'Privilege Leave',
      'status': 'Approved',
    },
  ];

  // ---------------- FILTER DIALOG ----------------

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        DateTime? tempFrom = _fromDate;
        DateTime? tempTo = _toDate;

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
                          child: Icon(Icons.filter_list_rounded,
                              color: Appcolors.kprimarycolor),
                        ),
                        ResponsiveSizedBox.width(3),
                        TextStyles.headline(
                          text: 'Filter Leaves',
                          weight: FontWeight.bold,
                        ),
                      ],
                    ),
                    ResponsiveSizedBox.height30,

                    /// FROM DATE
                    _buildDateSelector(
                      label: "From Date",
                      date: tempFrom,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: tempFrom ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setDialogState(() => tempFrom = picked);
                        }
                      },
                    ),
                    ResponsiveSizedBox.height20,

                    /// TO DATE
                    _buildDateSelector(
                      label: "To Date",
                      date: tempTo,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: tempTo ?? DateTime.now(),
                          firstDate: tempFrom ?? DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setDialogState(() => tempTo = picked);
                        }
                      },
                    ),

                    ResponsiveSizedBox.height30,

                    Row(
                      children: [
                        /// CLEAR
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
                              side: BorderSide(color: Appcolors.kgreyColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusStyles.kradius10(),
                              ),
                            ),
                            child: TextStyles.medium(
                              text: "Clear",
                              color: Appcolors.kgreyColor,
                            ),
                          ),
                        ),

                        ResponsiveSizedBox.width(3),

                        /// APPLY
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _fromDate = tempFrom;
                                _toDate = tempTo;
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
                              text: "Apply",
                              color: Appcolors.kwhitecolor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ---------------- DATE PICKER UI REUSED ----------------

  Widget _buildDateSelector({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadiusStyles.kradius10(),
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
            Icon(Icons.calendar_today_rounded,
                color: Appcolors.kprimarycolor),
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
                        ? '${date.day.toString().padLeft(2, '0')} '
                            '${_getMonthName(date.month)} ${date.year}'
                        : "Select date",
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int m) {
    const names = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return names[m - 1];
  }

  // ------------------ LEAVE TYPE COLOR LOGIC ------------------

  Color _leaveColor(String type) {
    switch (type) {
      case 'Casual Leave':
        return Colors.blue;
      case 'Sick Leave':
        return Colors.orange;
      case 'Privilege Leave':
        return Colors.purple;
      default:
        return Appcolors.kprimarycolor;
    }
  }

  IconData _leaveIcon(String type) {
    switch (type) {
      case 'Casual Leave':
        return Icons.event_available;
      case 'Sick Leave':
        return Icons.sick;
      case 'Privilege Leave':
        return Icons.stars;
      default:
        return Icons.event;
    }
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
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Appcolors.kprimarycolor),
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
                Icon(Icons.filter_list_rounded,
                    color: Appcolors.kprimarycolor),
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
                  )
              ],
            ),
          )
        ],
      ),

      // ---------------- LIST ----------------
      body: ListView.builder(
        padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
        itemCount: leavesList.length,
        itemBuilder: (context, index) {
          final leave = leavesList[index];

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
                      Icon(Icons.check_circle,
                          size: ResponsiveUtils.sp(8)),
                      ResponsiveSizedBox.height5,
                      TextStyles.caption(
                        text: "Approve",
                        color: Colors.white,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
                )
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
                        text: "Reject",
                        color: Colors.white,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
                )
              ],
            ),

            child: GestureDetector(
              onTap: () => context.push('/leavedetailspage'),
              child: _buildLeaveCard(leave),
            ),
          );
        },
      ),
    );
  }

  // ------------------ CARD UI ------------------

  Widget _buildLeaveCard(Map<String, dynamic> leave) {
    final type = leave['leaveType'];
    final leaveColor = _leaveColor(type);

    final status = leave['status'];
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
            color: Appcolors.kgreyColor.withOpacity(0.15),
            blurRadius: 10,
            offset: Offset(0, 4),
          )
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
                    child: TextStyles.medium(
                      text: type,
                      color: leaveColor,
                      weight: FontWeight.bold,
                    ),
                  ),

                  ResponsiveSizedBox.height10,

                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: ResponsiveUtils.sp(3.5),
                          color: Appcolors.kgreyColor),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text: "From: ${leave['fromDate']}",
                      ),
                    ],
                  ),

                  ResponsiveSizedBox.height5,

                  Row(
                    children: [
                      Icon(Icons.event,
                          size: ResponsiveUtils.sp(3.5),
                          color: Appcolors.kgreyColor),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text: "To: ${leave['toDate']}",
                      ),
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
                  text: status,
                  color: statusColor,
                  weight: FontWeight.bold,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
