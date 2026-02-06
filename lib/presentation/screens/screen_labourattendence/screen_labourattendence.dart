import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/network_services.dart';
import 'package:dhani_communications/data/models/labor_attendance_model.dart';
import 'package:dhani_communications/domain/repositories/apprepo.dart';
import 'package:dhani_communications/presentation/blocs/labor_attendance_list_bloc/labor_attendance_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';

class ScreenLabourAttendancePage extends StatefulWidget {
  const ScreenLabourAttendancePage({super.key});

  @override
  State<ScreenLabourAttendancePage> createState() =>
      _ScreenLabourAttendancePageState();
}

class _ScreenLabourAttendancePageState
    extends State<ScreenLabourAttendancePage> {
  DateTime? _fromDate;
  DateTime? _toDate;
  late LaborAttendanceListBloc _laborAttendanceListBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _laborAttendanceListBloc = LaborAttendanceListBloc(
      repository: Apprepo(DioClient.create(context)),
    );
    // Fetch labor attendance list without filters initially
    _laborAttendanceListBloc.add(FetchLaborAttendanceListEvent());
  }

  @override
  void dispose() {
    _laborAttendanceListBloc.close();
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

    _laborAttendanceListBloc.add(
      FetchLaborAttendanceListEvent(
        startDate: startDateStr,
        endDate: endDateStr,
      ),
    );
  }

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
                          text: 'Filter Attendance',
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
                          lastDate: DateTime.now(),
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
                          lastDate: DateTime.now(),
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
                              _laborAttendanceListBloc.add(
                                FetchLaborAttendanceListEvent(),
                              );
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
                              _applyFilter();
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
                                    borderRadius:
                                        BorderRadiusStyles.kradius10(),
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
                  TextStyles.caption(text: label, color: Appcolors.kgreyColor),
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
      'Dec',
    ];
    return months[month - 1];
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')} ${_getMonthName(date.month)} ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  String _getStatusDisplay(String status) {
    // APPROVED, REJECTED, PENDING
    if (status.toUpperCase() == 'APPROVED') return 'Approved';
    if (status.toUpperCase() == 'REJECTED') return 'Rejected';
    return 'Pending';
  }

  bool _isApproved(String status) {
    return status.toUpperCase() == 'APPROVED';
  }

  bool _isRejected(String status) {
    return status.toUpperCase() == 'REJECTED';
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
          text: 'Labour Attendance',
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
      body: BlocProvider(
        create: (context) => _laborAttendanceListBloc,
        child: BlocBuilder<LaborAttendanceListBloc, LaborAttendanceListState>(
          bloc: _laborAttendanceListBloc,
          builder: (context, state) {
            if (state is LaborAttendanceListLoadingState) {
              return Center(
                child: CircularProgressIndicator(
                  color: Appcolors.kprimarycolor,
                ),
              );
            }

            if (state is LaborAttendanceListErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: ResponsiveUtils.sp(15),
                      color: Colors.red.withOpacity(0.7),
                    ),
                    ResponsiveSizedBox.height20,
                    TextStyles.subheadline(
                      text: state.message,
                      color: Appcolors.kgreyColor,
                    ),
                    ResponsiveSizedBox.height20,
                    ElevatedButton(
                      onPressed: () {
                        _laborAttendanceListBloc.add(
                          FetchLaborAttendanceListEvent(),
                        );
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

            if (state is LaborAttendanceListSuccessState) {
              final attendanceList = state.laborAttendanceList;

              if (attendanceList.isEmpty) {
                return Center(
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
                        text: 'No attendance records found',
                        color: Appcolors.kgreyColor,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                color: Appcolors.kprimarycolor,
                onRefresh: () async {
                  _applyFilter();
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                  itemCount: attendanceList.length,
                  itemBuilder: (context, index) {
                    final attendance = attendanceList[index];
                    return GestureDetector(
                      onTap: () {
                        context.push(
                          '/labourattendencepagedetailpage',
                          extra: attendance,
                        );
                      },
                      child: _buildAttendanceCard(attendance),
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
                    Icons.event_busy_rounded,
                    size: ResponsiveUtils.sp(20),
                    color: Appcolors.kgreyColor.withOpacity(0.5),
                  ),
                  ResponsiveSizedBox.height20,
                  TextStyles.subheadline(
                    text: 'No attendance records found',
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

  Widget _buildAttendanceCard(LaborAttendanceModel attendance) {
    final bool isApproved = _isApproved(attendance.status);
    final bool isRejected = _isRejected(attendance.status);
    final String laborDisplayName =
        attendance.laborType.toUpperCase() == 'CONTRACT'
        ? attendance.contractorName.isNotEmpty
              ? attendance.contractorName
              : 'Contractor'
        : attendance.laborName.isNotEmpty
        ? attendance.laborName
        : 'Casual Labour';

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
            // Profile Image
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isApproved
                      ? Colors.green.withOpacity(0.5)
                      : isRejected
                      ? Colors.red.withOpacity(0.5)
                      : Colors.orange.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: ResponsiveUtils.wp(8),
                backgroundColor: Appcolors.kgreyColor.withOpacity(0.2),
                backgroundImage: attendance.picture.isNotEmpty
                    ? NetworkImage(attendance.picture)
                    : null,
                child: attendance.picture.isEmpty
                    ? Icon(
                        Icons.person,
                        size: ResponsiveUtils.sp(8),
                        color: Appcolors.kprimarycolor,
                      )
                    : null,
              ),
            ),
            ResponsiveSizedBox.width(3),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  TextStyles.subheadline(
                    text: laborDisplayName,
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                    overflow: TextOverflow.ellipsis,
                  ),
                  ResponsiveSizedBox.height5,
                  // Date and Labor Type
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text: _formatDate(attendance.hireDate),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(2),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.wp(2),
                          vertical: ResponsiveUtils.hp(0.3),
                        ),
                        decoration: BoxDecoration(
                          color:
                              attendance.laborType.toUpperCase() == 'CONTRACT'
                              ? Colors.purple.withOpacity(0.1)
                              : Colors.teal.withOpacity(0.1),
                          borderRadius: BorderRadiusStyles.kradius5(),
                        ),
                        child: TextStyles.caption(
                          text: attendance.laborType.toUpperCase() == 'CONTRACT'
                              ? 'Contract'
                              : 'Casual',
                          weight: FontWeight.w600,
                          color:
                              attendance.laborType.toUpperCase() == 'CONTRACT'
                              ? Colors.purple.shade700
                              : Colors.teal.shade700,
                        ),
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height5,
                  // KM and Time
                  Row(
                    children: [
                      Icon(
                        Icons.directions_walk_rounded,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kprimarycolor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text:
                            '${(attendance.distanceFromHQ / 1000).toStringAsFixed(2)} km',
                        weight: FontWeight.w600,
                        color: Appcolors.kprimarycolor,
                      ),
                      ResponsiveSizedBox.width(3),
                      Icon(
                        Icons.access_time_rounded,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text: '${attendance.punchIn} - ${attendance.punchOut}',
                        color: Appcolors.kgreyColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Approval Status
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
                  decoration: BoxDecoration(
                    color: isApproved
                        ? Colors.green.withOpacity(0.1)
                        : isRejected
                        ? Colors.red.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isApproved
                        ? Icons.check_circle
                        : isRejected
                        ? Icons.cancel
                        : Icons.pending,
                    color: isApproved
                        ? Colors.green
                        : isRejected
                        ? Colors.red
                        : Colors.orange,
                    size: ResponsiveUtils.sp(6),
                  ),
                ),
                ResponsiveSizedBox.height5,
                TextStyles.caption(
                  text: _getStatusDisplay(attendance.status),
                  weight: FontWeight.w600,
                  color: isApproved
                      ? Colors.green.shade700
                      : isRejected
                      ? Colors.red.shade700
                      : Colors.orange.shade700,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
