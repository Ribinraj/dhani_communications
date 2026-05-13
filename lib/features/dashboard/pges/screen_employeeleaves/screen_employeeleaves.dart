import 'package:dhani_communications/core/appconstants.dart';
import 'package:dhani_communications/widgets/date_filter_dialog.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/network_services.dart';
import 'package:dhani_communications/features/dashboard/models/leave_model.dart';
import 'package:dhani_communications/features/dashboard/repo/apprepo.dart';
import 'package:dhani_communications/features/dashboard/blocs/leave_list_bloc/leave_list_bloc.dart';
import 'package:dhani_communications/widgets/custom_nondatawidget.dart';
import 'package:dhani_communications/widgets/customshimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';
import 'package:dhani_communications/core/localization/app_localization.dart';

class ScreenEmployeeLeavesPage extends StatefulWidget {
  const ScreenEmployeeLeavesPage({super.key});

  @override
  State<ScreenEmployeeLeavesPage> createState() =>
      _ScreenEmployeeLeavesPageState();
}

class _ScreenEmployeeLeavesPageState extends State<ScreenEmployeeLeavesPage> {
  DateTime? _fromDate;
  DateTime? _toDate;
  late LeaveListBloc _leaveListBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _leaveListBloc = LeaveListBloc(
      repository: Apprepo(DioClient.create(context)),
    );
    // Fetch leave list without filters initially
    _leaveListBloc.add(FetchLeaveListEvent());
  }

  @override
  void dispose() {
    _leaveListBloc.close();
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

    _leaveListBloc.add(
      FetchLeaveListEvent(startDate: startDateStr, endDate: endDateStr),
    );
  }

  void _showFilterDialog() {
    DateFilterDialog.show(
      context: context,
      title: context.tr('filter_leaves'),
      initialFromDate: _fromDate,
      initialToDate: _toDate,
      lastDate: DateTime(2030),
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
        _leaveListBloc.add(FetchLeaveListEvent());
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

  Color _getLeaveTypeColor(String leaveType) {
    final type = leaveType.toLowerCase();
    if (type.contains('casual')) return Colors.blue;
    if (type.contains('sick')) return Colors.orange;
    if (type.contains('privilege')) return Colors.purple;
    if (type.contains('earned')) return Colors.teal;
    if (type.contains('maternity')) return Colors.pink;
    if (type.contains('paternity')) return Colors.indigo;
    return Appcolors.kprimarycolor;
  }

  IconData _getLeaveTypeIcon(String leaveType) {
    final type = leaveType.toLowerCase();
    if (type.contains('casual')) return Icons.event_available;
    if (type.contains('sick')) return Icons.sick;
    if (type.contains('privilege')) return Icons.stars;
    if (type.contains('earned')) return Icons.card_giftcard;
    if (type.contains('maternity')) return Icons.child_care;
    if (type.contains('paternity')) return Icons.family_restroom;
    return Icons.event_note;
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
          text: context.tr('employee_leaves'),
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
        create: (context) => _leaveListBloc,
        child: BlocBuilder<LeaveListBloc, LeaveListState>(
          bloc: _leaveListBloc,
          builder: (context, state) {
            if (state is LeaveListLoadingState) {
              return CustomListShimmer();
            }

            if (state is LeaveListErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: ResponsiveUtils.sp(15),
                      color: Appcolors.kredcolor.withAlpha(200),
                    ),
                    ResponsiveSizedBox.height20,
                    TextStyles.subheadline(
                      text: state.message,
                      color: Appcolors.kgreyColor,
                    ),
                    ResponsiveSizedBox.height20,
                    ElevatedButton(
                      onPressed: () {
                        _leaveListBloc.add(FetchLeaveListEvent());
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

            if (state is LeaveListSuccessState) {
              final leavesList = state.leavesList;

              if (leavesList.isEmpty) {
                return NoDataWidget(
                  title: context.tr('leaves_are_empty'),
                  assetIcon: Appconstants.leaves,
                );
              }

              return RefreshIndicator(
                color: Appcolors.kprimarycolor,
                onRefresh: () async {
                  _applyFilter();
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                  itemCount: leavesList.length,
                  itemBuilder: (context, index) {
                    final leave = leavesList[index];
                    return GestureDetector(
                      onTap: () {
                        context.push('/leavedetailspage', extra: leave);
                      },
                      child: _buildLeaveCard(leave),
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
                    text: context.tr('no_leave_records_found'),
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

  Widget _buildLeaveCard(LeaveModel leave) {
    final bool isApproved = _isApproved(leave.status);
    final bool isRejected = _isRejected(leave.status);
    final String statusDisplay = _getStatusDisplay(leave.status);
    final String leaveType = leave.leaveCategoryName;
    final Color leaveTypeColor = _getLeaveTypeColor(leaveType);

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
                      text: leaveType.isNotEmpty ? leaveType : 'Leave',
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
                        text: 'From: ${_formatDate(leave.fromDate)}',
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
                        text: 'To: ${_formatDate(leave.toDate)}',
                        color: Appcolors.kgreyColor,
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height5,
                  // Total Days
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kprimarycolor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text: '${leave.total} day${leave.total > 1 ? 's' : ''}',
                        weight: FontWeight.w600,
                        color: Appcolors.kprimarycolor,
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
