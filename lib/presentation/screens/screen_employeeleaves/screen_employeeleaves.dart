import 'package:dhani_communications/core/constants.dart';
import 'package:flutter/material.dart';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';

class ScreenEmployeeLeavesPage extends StatefulWidget {
  const ScreenEmployeeLeavesPage({super.key});

  @override
  State<ScreenEmployeeLeavesPage> createState() =>
      _ScreenEmployeeLeavesPageState();
}

class _ScreenEmployeeLeavesPageState extends State<ScreenEmployeeLeavesPage> {
  DateTime? _fromDate;
  DateTime? _toDate;

  // Sample leaves data
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
    {
      'fromDate': '20 Jan 2026',
      'toDate': '22 Jan 2026',
      'leaveType': 'Sick Leave',
      'status': 'Pending',
    },
    {
      'fromDate': '25 Jan 2026',
      'toDate': '26 Jan 2026',
      'leaveType': 'Casual Leave',
      'status': 'Approved',
    },
    {
      'fromDate': '28 Jan 2026',
      'toDate': '30 Jan 2026',
      'leaveType': 'Privilege Leave',
      'status': 'Rejected',
    },
    {
      'fromDate': '02 Feb 2026',
      'toDate': '04 Feb 2026',
      'leaveType': 'Sick Leave',
      'status': 'Approved',
    },
  ];

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                    // Dialog Title
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
                          text: 'Filter Leaves',
                          weight: FontWeight.bold,
                          color: Appcolors.kblackcolor,
                        ),
                      ],
                    ),
                    ResponsiveSizedBox.height30,
                    // From Date
                    _buildDateSelector(
                      label: 'From Date',
                      date: tempFromDate,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: tempFromDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) {
                          setDialogState(() {
                            tempFromDate = date;
                          });
                        }
                      },
                    ),
                    ResponsiveSizedBox.height20,
                    // To Date
                    _buildDateSelector(
                      label: 'To Date',
                      date: tempToDate,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: tempToDate ?? DateTime.now(),
                          firstDate: tempFromDate ?? DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) {
                          setDialogState(() {
                            tempToDate = date;
                          });
                        }
                      },
                    ),
                    ResponsiveSizedBox.height30,
                    // Buttons
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
                              text: 'Clear',
                              weight: FontWeight.w600,
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Filter applied'),
                                  duration: Duration(milliseconds: 1000),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Appcolors.kprimarycolor,
                                  margin: EdgeInsets.only(
                                    bottom: ResponsiveUtils.hp(2),
                                    left: ResponsiveUtils.wp(4),
                                    right: ResponsiveUtils.wp(4),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusStyles.kradius10(),
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Appcolors.kprimarycolor,
                              padding: EdgeInsets.symmetric(
                                vertical: ResponsiveUtils.hp(1.5),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusStyles.kradius10(),
                              ),
                            ),
                            child: TextStyles.medium(
                              text: 'Apply',
                              weight: FontWeight.w600,
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
          border: Border.all(
            color: Appcolors.kgreyColor.withOpacity(0.3),
            width: 1.5,
          ),
          borderRadius: BorderRadiusStyles.kradius10(),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              color: Appcolors.kprimarycolor,
              size: ResponsiveUtils.sp(5),
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
                    weight: FontWeight.w600,
                    color: date != null
                        ? Appcolors.kblackcolor
                        : Appcolors.kgreyColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
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
      'Dec'
    ];
    return months[month - 1];
  }

  Color _getLeaveTypeColor(String leaveType) {
    switch (leaveType) {
      case 'Casual Leave':
        return Colors.blue;
      case 'Sick Leave':
        return Colors.orange;
      case 'Privilege Leave':
        return Colors.purple;
      case 'Earned Leave':
        return Colors.teal;
      case 'Maternity Leave':
        return Colors.pink;
      case 'Paternity Leave':
        return Colors.indigo;
      default:
        return Appcolors.kprimarycolor;
    }
  }

  IconData _getLeaveTypeIcon(String leaveType) {
    switch (leaveType) {
      case 'Casual Leave':
        return Icons.event_available;
      case 'Sick Leave':
        return Icons.sick;
      case 'Privilege Leave':
        return Icons.stars;
      case 'Earned Leave':
        return Icons.card_giftcard;
      case 'Maternity Leave':
        return Icons.child_care;
      case 'Paternity Leave':
        return Icons.family_restroom;
      default:
        return Icons.event_note;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.kwhitecolor,
      appBar: AppBar(
        backgroundColor: Appcolors.kwhitecolor,
        elevation: 2,
        shadowColor: Appcolors.kgreyColor.withOpacity(0.1),
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
        title: TextStyles.subheadline(
          text: 'Employee Leaves',
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
      body: leavesList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy_rounded,
                    size: ResponsiveUtils.sp(20),
                    color: Appcolors.kgreyColor.withOpacity(0.5),
                  ),
                  ResponsiveSizedBox.height20,
                  TextStyles.subheadline(
                    text: 'No leave records found',
                    color: Appcolors.kgreyColor,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
              itemCount: leavesList.length,
              itemBuilder: (context, index) {
                final leave = leavesList[index];
                return GestureDetector(
                  onTap: () {
                    context.push('/leavedetailspage');
                  },
                  child: _buildLeaveCard(leave),
                );
              },
            ),
    );
  }

  Widget _buildLeaveCard(Map<String, dynamic> leave) {
    final String status = leave['status'];
    final String leaveType = leave['leaveType'];
    final Color leaveTypeColor = _getLeaveTypeColor(leaveType);

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
            // Leave Type Icon
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
              decoration: BoxDecoration(
                color: leaveTypeColor.withOpacity(0.1),
                borderRadius: BorderRadiusStyles.kradius10(),
              ),
              child: Icon(
                _getLeaveTypeIcon(leaveType),
                color: leaveTypeColor,
                size: ResponsiveUtils.sp(7),
              ),
            ),
            ResponsiveSizedBox.width(3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Leave Type
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.wp(2.5),
                      vertical: ResponsiveUtils.hp(0.5),
                    ),
                    decoration: BoxDecoration(
                      color: leaveTypeColor.withOpacity(0.1),
                      borderRadius: BorderRadiusStyles.kradius5(),
                    ),
                    child: TextStyles.medium(
                      text: leaveType,
                      weight: FontWeight.w600,
                      color: leaveTypeColor,
                    ),
                  ),
                  ResponsiveSizedBox.height10,
                  // From Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text: 'From: ${leave['fromDate']}',
                        color: Appcolors.kgreyColor,
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height5,
                  // To Date
                  Row(
                    children: [
                      Icon(
                        Icons.event,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text: 'To: ${leave['toDate']}',
                        color: Appcolors.kgreyColor,
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
                  text: status,
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