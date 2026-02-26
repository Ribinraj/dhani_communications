import 'package:dhani_communications/core/appconstants.dart';
import 'package:dhani_communications/widgets/date_filter_dialog.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/network_services.dart';
import 'package:dhani_communications/features/dashboard/models/labor_attendance_model.dart';
import 'package:dhani_communications/features/dashboard/repo/apprepo.dart';
import 'package:dhani_communications/features/dashboard/blocs/labor_attendance_list_bloc/labor_attendance_list_bloc.dart';
import 'package:dhani_communications/widgets/custom_nondatawidget.dart';
import 'package:dhani_communications/widgets/customshimmer_widget.dart';
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
    DateFilterDialog.show(
      context: context,
      title: 'Filter Attendance',
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
        _laborAttendanceListBloc.add(FetchLaborAttendanceListEvent());
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
        create: (context) => _laborAttendanceListBloc,
        child: BlocBuilder<LaborAttendanceListBloc, LaborAttendanceListState>(
          bloc: _laborAttendanceListBloc,
          builder: (context, state) {
            if (state is LaborAttendanceListLoadingState) {
              return CustomListShimmer();
            }

            if (state is LaborAttendanceListErrorState) {
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
                return NoDataWidget(
                  assetIcon: Appconstants.contractlabours,
                  title: "Attendence list is Empty",
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
                    color: Appcolors.kgreyColor.withAlpha(77),
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
                      ? Appcolors.kgreencolor.withAlpha(77)
                      : isRejected
                      ? Appcolors.kredcolor.withAlpha(77)
                      : Appcolors.korangecolor.withAlpha(77),
                  width: 1,
                ),
              ),
              child: CircleAvatar(
                radius: ResponsiveUtils.wp(8),
                backgroundColor: Appcolors.kgreyColor.withAlpha(66),
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
                  TextStyles.title(
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
                              ? Colors.purple.withAlpha(33)
                              : Colors.teal.withAlpha(33),
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
                        text: '${attendance.distanceFromHQ} km',
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
                        ? Colors.green.withAlpha(33)
                        : isRejected
                        ? Appcolors.kredcolor.withAlpha(33)
                        : Appcolors.korangecolor.withAlpha(33),
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
                        ? Appcolors.kredcolor
                        : Appcolors.korangecolor,
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
                      ? Appcolors.kredcolor.shade700
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
