import 'package:dhani_communications/core/appconstants.dart';
import 'package:dhani_communications/widgets/date_filter_dialog.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/network_services.dart';
import 'package:dhani_communications/features/dashboard/models/attendance_model.dart';
import 'package:dhani_communications/features/dashboard/repo/apprepo.dart';
import 'package:dhani_communications/features/dashboard/blocs/attendance_list_bloc/attendance_list_bloc.dart';
import 'package:dhani_communications/widgets/custom_nondatawidget.dart';
import 'package:dhani_communications/widgets/customshimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';
import 'package:dhani_communications/core/localization/app_localization.dart';

class ScreenEmployeeAttendancePage extends StatefulWidget {
  const ScreenEmployeeAttendancePage({super.key});

  @override
  State<ScreenEmployeeAttendancePage> createState() =>
      _ScreenEmployeeAttendancePageState();
}

class _ScreenEmployeeAttendancePageState
    extends State<ScreenEmployeeAttendancePage> {
  DateTime? _fromDate;
  DateTime? _toDate;
  late AttendanceListBloc _attendanceListBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _attendanceListBloc = AttendanceListBloc(
      repository: Apprepo(DioClient.create(context)),
    );
    // Fetch attendance list without filters initially
    _attendanceListBloc.add(FetchAttendanceListEvent());
  }

  @override
  void dispose() {
    _attendanceListBloc.close();
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

    _attendanceListBloc.add(
      FetchAttendanceListEvent(startDate: startDateStr, endDate: endDateStr),
    );
  }

  void _showFilterDialog() {
    DateFilterDialog.show(
      context: context,
      title: context.tr('filter_attendance'),
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
        _attendanceListBloc.add(FetchAttendanceListEvent());
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

  String _getStatusFromAttendance(double attendance) {
    // 1.0 = Present, 0.5 = Half Day, 0.0 = Absent
    if (attendance >= 1.0) return 'Present';
    if (attendance >= 0.5) return 'Half Day';
    return 'Absent';
  }

  String _getSession(String attendanceType) {
    // Use attendanceType from API: MORNING, AFTERNOON, etc.
    if (attendanceType.toUpperCase() == 'MORNING') return 'Morning';
    if (attendanceType.toUpperCase() == 'AFTERNOON') return 'Afternoon';
    return attendanceType.isNotEmpty ? attendanceType : 'Morning';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _attendanceListBloc,
      child: Scaffold(
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
            text: context.tr('employee_attendance'),
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
        body: BlocBuilder<AttendanceListBloc, AttendanceListState>(
          builder: (context, state) {
            if (state is AttendanceListLoadingState) {
              return CustomListShimmer(itemCount: 10);
            }

            if (state is AttendanceListErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: ResponsiveUtils.sp(20),
                      color: Colors.red.withValues(alpha: 77),
                    ),
                    ResponsiveSizedBox.height20,
                    TextStyles.subheadline(
                      text: state.message,
                      color: Appcolors.kgreyColor,
                    ),
                    ResponsiveSizedBox.height20,
                    ElevatedButton(
                      onPressed: () {
                        _attendanceListBloc.add(FetchAttendanceListEvent());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolors.kprimarycolor,
                      ),
                      child: TextStyles.medium(
                        text: context.tr('retry'),
                        color: Appcolors.kwhitecolor,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is AttendanceListSuccessState) {
              final attendanceList = state.attendanceList;

              if (attendanceList.isEmpty) {
                return NoDataWidget(
                  title: context.tr('attendence_list_is_empty'),
                  assetIcon: Appconstants.attenedence,
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
                          '/employeeattendencedetailpage',
                          extra: attendance,
                        );
                      },
                      child: _buildAttendanceCard(attendance),
                    );
                  },
                ),
              );
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy_rounded,
                    size: ResponsiveUtils.sp(20),
                    color: Appcolors.kgreyColor.withValues(alpha: 77),
                  ),
                  ResponsiveSizedBox.height20,
                  TextStyles.subheadline(
                    text: context.tr('no_attendance_records_found'),
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

  Widget _buildAttendanceCard(AttendanceModel attendance) {
    final status = _getStatusFromAttendance(attendance.attendance);
    final bool isPresent = status == 'Present' || status == 'Half Day';
    final bool isApproved = attendance.status.toLowerCase() == 'approved';
    final session = _getSession(attendance.attendanceType);

    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.hp(2)),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Appcolors.kgreyColor.withAlpha(44),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        color: Appcolors.kwhitecolor,
        borderRadius: BorderRadiusStyles.kradius15(),
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
        child: Row(
          children: [
            // Profile Image or Picture
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isPresent
                      ? Colors.green.withValues(alpha: 77)
                      : Colors.red.withValues(alpha: 77),
                  width: 1,
                ),
              ),
              child: CircleAvatar(
                radius: ResponsiveUtils.wp(8),
                backgroundColor: Appcolors.kgreyColor.withAlpha(55),
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
                  // Attendance ID
                  TextStyles.title(
                    text: 'Attendance #${attendance.attendanceId}',
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                    overflow: TextOverflow.ellipsis,
                  ),
                  ResponsiveSizedBox.height5,
                  // Date and Session
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text: _formatDate(attendance.attendanceDate),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(2),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.wp(2),
                          vertical: ResponsiveUtils.hp(0.3),
                        ),
                        decoration: BoxDecoration(
                          color: session == 'Morning'
                              ? Appcolors.korangecolor.withAlpha(11)
                              : Appcolors.kprimarycolor.withAlpha(11),
                          borderRadius: BorderRadiusStyles.kradius5(),
                        ),
                        child: TextStyles.caption(
                          text: session,
                          weight: FontWeight.w600,
                          color: session == 'Morning'
                              ? Appcolors.korangecolor.shade700
                              : Appcolors.kprimarycolor,
                        ),
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height5,
                  // Distance and Status
                  Row(
                    children: [
                      Icon(
                        Icons.directions_walk_rounded,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kprimarycolor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text: '${attendance.distanceFromHQ} km',
                        weight: FontWeight.w600,
                        color: Appcolors.kprimarycolor,
                      ),
                      ResponsiveSizedBox.width(3),
                      // Status Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.wp(2.5),
                          vertical: ResponsiveUtils.hp(0.4),
                        ),
                        decoration: BoxDecoration(
                          color: isPresent
                              ? Colors.green.withAlpha(11)
                              : Colors.red.withAlpha(11),
                          borderRadius: BorderRadiusStyles.kradius5(),
                        ),
                        child: TextStyles.caption(
                          text: status,
                          weight: FontWeight.w600,
                          color: isPresent
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                        ),
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
                        ? Colors.green.withAlpha(11)
                        : Appcolors.korangecolor.withAlpha(11),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isApproved ? Icons.check_circle : Icons.pending,
                    color: isApproved ? Colors.green : Appcolors.korangecolor,
                    size: ResponsiveUtils.sp(6),
                  ),
                ),
                ResponsiveSizedBox.height5,
                TextStyles.caption(
                  text: isApproved ? 'Approved' : 'Pending',
                  weight: FontWeight.w600,
                  color: isApproved
                      ? Colors.green.shade700
                      : Appcolors.korangecolor.shade700,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
