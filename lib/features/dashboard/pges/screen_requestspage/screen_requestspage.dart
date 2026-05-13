import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/features/dashboard/blocs/request_list_bloc/request_list_bloc.dart';
import 'package:dhani_communications/features/dashboard/models/request_model.dart';
import 'package:dhani_communications/widgets/date_filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';
import 'package:dhani_communications/core/localization/app_localization.dart';

class ScreenrequestsPage extends StatefulWidget {
  const ScreenrequestsPage({super.key});

  @override
  State<ScreenrequestsPage> createState() => _ScreenrequestsPageState();
}

class _ScreenrequestsPageState extends State<ScreenrequestsPage> {
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    context.read<RequestListBloc>().add(FetchRequestListEvent());
  }

  void _showFilterDialog() {
    DateFilterDialog.show(
      context: context,
      title: context.tr('filter_requests'),
      initialFromDate: _fromDate,
      initialToDate: _toDate,
      onApply: (fromDate, toDate) {
        setState(() {
          _fromDate = fromDate;
          _toDate = toDate;
        });
      },
      onClear: () {
        setState(() {
          _fromDate = null;
          _toDate = null;
        });
      },
    );
  }

  /// Filter list by date range (client-side)
  List<RequestModel> _applyDateFilter(List<RequestModel> list) {
    if (_fromDate == null && _toDate == null) return list;
    return list.where((request) {
      final date = DateTime.tryParse(request.createdAt);
      if (date == null) return true;
      if (_fromDate != null && date.isBefore(_fromDate!)) return false;
      if (_toDate != null) {
        final endOfDay = DateTime(
          _toDate!.year,
          _toDate!.month,
          _toDate!.day,
          23,
          59,
          59,
        );
        if (date.isAfter(endOfDay)) return false;
      }
      return true;
    }).toList();
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
          text: context.tr('requests'),
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
                      decoration: const BoxDecoration(
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
      body: BlocBuilder<RequestListBloc, RequestListState>(
        builder: (context, state) {
          if (state is RequestListLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RequestListErrorState) {
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
                  ElevatedButton.icon(
                    onPressed: () {
                      context
                          .read<RequestListBloc>()
                          .add(FetchRequestListEvent());
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(context.tr('retry')),
                  ),
                ],
              ),
            );
          }

          if (state is RequestListSuccessState) {
            final filteredList = _applyDateFilter(state.requestList);

            if (filteredList.isEmpty) {
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
                      text: context.tr('no_request_records_found'),
                      color: Appcolors.kgreyColor,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final request = filteredList[index];
                return GestureDetector(
                  onTap: () {
                    context.push('/requestdetailspage', extra: request);
                  },
                  child: _buildRequestCard(request),
                );
              },
            );
          }

          // Initial state – trigger fetch
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildRequestCard(RequestModel request) {
    final String status = request.status;

    Color statusColor;
    IconData statusIcon;

    switch (status.toUpperCase()) {
      case 'COMPLETED':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'REJECTED':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case 'PENDING':
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
    }

    // Format date display
    String displayDate = request.modifiedAt;
    final parsedDate = DateTime.tryParse(request.createdAt);
    if (parsedDate != null) {
      displayDate =
          '${parsedDate.day.toString().padLeft(2, '0')} '
          '${_monthName(parsedDate.month)} '
          '${parsedDate.year}';
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
                  // Request Category as heading
                  TextStyles.headline(
                    text: request.requestCategory,
                    weight: FontWeight.bold,
                    color: Appcolors.kprimarycolor,
                  ),
                  ResponsiveSizedBox.height5,
                  // Request ID (secondary)
                  Row(
                    children: [
                      Icon(
                        Icons.tag,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text: 'ID: ${request.requestId}',
                        color: Appcolors.kgreyColor,
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height5,
                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text: displayDate,
                        color: Appcolors.kgreyColor,
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height5,
                  // Notes
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
                          text: request.notes,
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
                  text: _capitalizeFirst(status),
                  weight: FontWeight.w600,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[month - 1];
  }

  String _capitalizeFirst(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }
}
