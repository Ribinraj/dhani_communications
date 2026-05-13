import 'dart:core';

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
import 'package:dhani_communications/core/localization/app_localization.dart';

extension TimeFormatExtension on String? {
  String to12Hour() {
    if (this == null || this!.isEmpty) return '--';
    try {
      final input = DateFormat("HH:mm");
      final output = DateFormat("hh:mm a");
      return output.format(input.parse(this!));
    } catch (e) {
      return '--';
    }
  }
}

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
        _laborAttendanceListBloc.add(FetchLaborAttendanceListEvent());
      },
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
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
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Appcolors.kprimarycolor,
            size: ResponsiveUtils.sp(5),
          ),
        ),
        title: TextStyles.title(
          text: context.tr('labour_attendance'),
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
                        text: context.tr('retry'),
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
                  title: context.tr('attendance_list_is_empty'),
                );
              }

              return RefreshIndicator(
                color: Appcolors.kprimarycolor,
                onRefresh: () async => _applyFilter(),
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

            // Initial / unknown state
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

  Widget _buildAttendanceCard(LaborAttendanceModel attendance) {
    final bool isApproved = _isApproved(attendance.status);
    final bool isRejected = _isRejected(attendance.status);

    final bool isContract = attendance.laborType.toUpperCase() == 'CONTRACT';

    final String laborDisplayName = isContract
        ? (attendance.contractorName.isNotEmpty
            ? attendance.contractorName
            : 'Contractor')
        : (attendance.laborName.isNotEmpty
            ? attendance.laborName
            : 'Casual Labour');

    // Status colours
    final Color statusColor = isApproved
        ? Colors.green
        : isRejected
            ? Appcolors.kredcolor
            : Appcolors.korangecolor;

    final Color statusBgColor = isApproved
        ? Colors.green.withAlpha(30)
        : isRejected
            ? Appcolors.kredcolor.withAlpha(30)
            : Appcolors.korangecolor.withAlpha(30);

    final IconData statusIcon = isApproved
        ? Icons.check_circle_rounded
        : isRejected
            ? Icons.cancel_rounded
            : Icons.pending_rounded;

    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.hp(1.8)),
      decoration: BoxDecoration(
        color: Appcolors.kwhitecolor,
        borderRadius: BorderRadiusStyles.kradius15(),
        boxShadow: [
          BoxShadow(
            color: Appcolors.kgreyColor.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.wp(3.5)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Avatar ──────────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: statusColor.withAlpha(100),
                  width: 1.5,
                ),
              ),
              child: CircleAvatar(
                radius: ResponsiveUtils.wp(7),
                backgroundColor: Appcolors.kgreyColor.withAlpha(40),
                backgroundImage: attendance.picture.isNotEmpty
                    ? NetworkImage(attendance.picture)
                    : null,
                child: attendance.picture.isEmpty
                    ? Icon(
                        Icons.person,
                        size: ResponsiveUtils.sp(7),
                        color: Appcolors.kprimarycolor,
                      )
                    : null,
              ),
            ),

            SizedBox(width: ResponsiveUtils.wp(3)),

            // ── Info column ─────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    laborDisplayName,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(4.2),
                      fontWeight: FontWeight.w600,
                      color: Appcolors.kblackcolor,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),

                  SizedBox(height: ResponsiveUtils.hp(0.6)),

                  // Row 1: Date  |  Labour type badge
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: ResponsiveUtils.sp(3.2),
                        color: Appcolors.kgreyColor,
                      ),
                      SizedBox(width: ResponsiveUtils.wp(1)),
                      Text(
                        _formatDate(attendance.hireDate),
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(3.2),
                          color: Appcolors.kgreyColor,
                        ),
                      ),
                      SizedBox(width: ResponsiveUtils.wp(2)),
                      _buildTypeBadge(isContract),
                    ],
                  ),

                  SizedBox(height: ResponsiveUtils.hp(0.6)),

                  // Row 2: Time (Expanded)  |  Distance
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: ResponsiveUtils.sp(3.2),
                        color: Appcolors.kgreyColor,
                      ),
                      SizedBox(width: ResponsiveUtils.wp(1)),
                      // ✅ Expanded so time never overflows into status
                      Expanded(
                        child: Text(
                          '${attendance.punchIn.to12Hour()} – ${attendance.punchOut.to12Hour()}',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.sp(3.2),
                            color: Appcolors.kgreyColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(width: ResponsiveUtils.wp(2)),
                      Icon(
                        Icons.social_distance_rounded,
                        size: ResponsiveUtils.sp(3.2),
                        color: Appcolors.kprimarycolor,
                      ),
                      SizedBox(width: ResponsiveUtils.wp(1)),
                      Text(
                        '${attendance.distanceFromHQ} km',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(3.2),
                          fontWeight: FontWeight.w600,
                          color: Appcolors.kprimarycolor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: ResponsiveUtils.wp(2)),

            // ── Status column ────────────────────────────────────────
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    statusIcon,
                    color: statusColor,
                    size: ResponsiveUtils.sp(5.5),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.hp(0.4)),
                Text(
                  _getStatusDisplay(attendance.status),
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(2.8),
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeBadge(bool isContract) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.wp(2),
        vertical: ResponsiveUtils.hp(0.25),
      ),
      decoration: BoxDecoration(
        color: isContract
            ? Colors.purple.withAlpha(30)
            : Colors.teal.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isContract ? 'Contract' : 'Casual',
        style: TextStyle(
          fontSize: ResponsiveUtils.sp(2.8),
          fontWeight: FontWeight.w600,
          color: isContract ? Colors.purple.shade700 : Colors.teal.shade700,
        ),
      ),
    );
  }
}