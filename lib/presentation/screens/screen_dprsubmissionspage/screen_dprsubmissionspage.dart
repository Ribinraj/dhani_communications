import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/network_services.dart';
import 'package:dhani_communications/data/models/dpr_model.dart';
import 'package:dhani_communications/domain/repositories/apprepo.dart';
import 'package:dhani_communications/presentation/blocs/dpr_submissions_bloc/dpr_submissions_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';

class ScreenDprSubmissionsPage extends StatefulWidget {
  const ScreenDprSubmissionsPage({super.key});

  @override
  State<ScreenDprSubmissionsPage> createState() =>
      _ScreenDprSubmissionsPageState();
}

class _ScreenDprSubmissionsPageState extends State<ScreenDprSubmissionsPage> {
  DateTime? _fromDate;
  DateTime? _toDate;
  late DprSubmissionsBloc _dprSubmissionsBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dprSubmissionsBloc = DprSubmissionsBloc(
      repository: Apprepo(DioClient.create(context)),
    );
    // Fetch DPR submissions without filters initially
    _dprSubmissionsBloc.add(FetchDprSubmissionsEvent());
  }

  @override
  void dispose() {
    _dprSubmissionsBloc.close();
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

    _dprSubmissionsBloc.add(
      FetchDprSubmissionsEvent(startDate: startDateStr, endDate: endDateStr),
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
                          text: 'Filter Submissions',
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
                              // Fetch without filters
                              _dprSubmissionsBloc.add(
                                FetchDprSubmissionsEvent(),
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

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return Colors.green;
      case 'PENDING':
        return Colors.orange;
      case 'REJECTED':
        return Colors.red;
      default:
        return Appcolors.kgreyColor;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return Icons.check_circle;
      case 'PENDING':
        return Icons.pending;
      case 'REJECTED':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _dprSubmissionsBloc,
      child: Scaffold(
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
            text: 'My DPR Submissions',
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
        body: BlocBuilder<DprSubmissionsBloc, DprSubmissionsState>(
          builder: (context, state) {
            if (state is DprSubmissionsLoadingState) {
              return Center(
                child: CircularProgressIndicator(
                  color: Appcolors.kprimarycolor,
                ),
              );
            }

            if (state is DprSubmissionsErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: ResponsiveUtils.sp(20),
                      color: Colors.red.withOpacity(0.5),
                    ),
                    ResponsiveSizedBox.height20,
                    TextStyles.subheadline(
                      text: state.message,
                      color: Appcolors.kgreyColor,
                    ),
                    ResponsiveSizedBox.height20,
                    ElevatedButton(
                      onPressed: () {
                        _dprSubmissionsBloc.add(FetchDprSubmissionsEvent());
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

            if (state is DprSubmissionsSuccessState) {
              final submissionsList = state.submissions;

              if (submissionsList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_late_outlined,
                        size: ResponsiveUtils.sp(20),
                        color: Appcolors.kgreyColor.withOpacity(0.5),
                      ),
                      ResponsiveSizedBox.height20,
                      TextStyles.subheadline(
                        text: 'No DPR submissions found',
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
                  itemCount: submissionsList.length,
                  itemBuilder: (context, index) {
                    final submission = submissionsList[index];
                    return _buildSubmissionCard(submission);
                  },
                ),
              );
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_late_outlined,
                    size: ResponsiveUtils.sp(20),
                    color: Appcolors.kgreyColor.withOpacity(0.5),
                  ),
                  ResponsiveSizedBox.height20,
                  TextStyles.subheadline(
                    text: 'No DPR submissions found',
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

  Widget _buildSubmissionCard(DprSubmissionModel submission) {
    final statusColor = _getStatusColor(submission.status);
    final statusIcon = _getStatusIcon(submission.status);

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
            // Status Icon
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                statusIcon,
                color: statusColor,
                size: ResponsiveUtils.sp(7),
              ),
            ),
            ResponsiveSizedBox.width(3),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // DPR Name
                  TextStyles.subheadline(
                    text: submission.dprName.isNotEmpty
                        ? submission.dprName
                        : 'DPR #${submission.dprId}',
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  ResponsiveSizedBox.height5,
                  // Project Name
                  Row(
                    children: [
                      Icon(
                        Icons.business_center_outlined,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      Expanded(
                        child: TextStyles.caption(
                          text: submission.projectName,
                          color: Appcolors.kgreyColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height5,
                  // Date and Quantity
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text: _formatDate(submission.progressDate),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(3),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.wp(2),
                          vertical: ResponsiveUtils.hp(0.3),
                        ),
                        decoration: BoxDecoration(
                          color: Appcolors.kprimarycolor.withOpacity(0.1),
                          borderRadius: BorderRadiusStyles.kradius5(),
                        ),
                        child: TextStyles.caption(
                          text:
                              '${submission.progressQuantity.toStringAsFixed(submission.progressQuantity.truncateToDouble() == submission.progressQuantity ? 0 : 2)} ${submission.uom}',
                          weight: FontWeight.w600,
                          color: Appcolors.kprimarycolor,
                        ),
                      ),
                    ],
                  ),
                  if (submission.userRemarks != null &&
                      submission.userRemarks!.isNotEmpty) ...[
                    ResponsiveSizedBox.height5,
                    Row(
                      children: [
                        Icon(
                          Icons.notes,
                          size: ResponsiveUtils.sp(3.5),
                          color: Appcolors.kgreyColor,
                        ),
                        ResponsiveSizedBox.width(1.5),
                        Expanded(
                          child: TextStyles.caption(
                            text: submission.userRemarks!,
                            color: Appcolors.kgreyColor,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            // Status Badge
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.wp(2.5),
                    vertical: ResponsiveUtils.hp(0.5),
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadiusStyles.kradius5(),
                  ),
                  child: TextStyles.caption(
                    text: submission.statusDisplayText,
                    weight: FontWeight.w600,
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
}
