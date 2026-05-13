import 'package:dhani_communications/core/appconstants.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/features/dashboard/blocs/get_machines_bloc/get_machines_bloc.dart';
import 'package:dhani_communications/features/dashboard/models/machine_hire_model.dart';
import 'package:dhani_communications/widgets/date_filter_dialog.dart';
import 'package:dhani_communications/widgets/custom_nondatawidget.dart';
import 'package:dhani_communications/widgets/customshimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';
import 'package:dhani_communications/core/localization/app_localization.dart';

class ScreenMachineHiringPage extends StatefulWidget {
  const ScreenMachineHiringPage({super.key});

  @override
  State<ScreenMachineHiringPage> createState() =>
      _ScreenMachineHiringPageState();
}

class _ScreenMachineHiringPageState extends State<ScreenMachineHiringPage> {
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    context.read<GetMachinesBloc>().add(GetMachinesInitialFetchingEvent());
  }

  void _applyFilter() {
    context.read<GetMachinesBloc>().add(
      GetMachinesInitialFetchingEvent(
        startDate: _fromDate == null
            ? null
            : DateFormat('yyyy-MM-dd').format(_fromDate!),
        endDate: _toDate == null
            ? null
            : DateFormat('yyyy-MM-dd').format(_toDate!),
      ),
    );
  }

  void _showFilterDialog() {
    DateFilterDialog.show(
      context: context,
      title: context.tr('filter_hiring'),
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
        context.read<GetMachinesBloc>().add(GetMachinesInitialFetchingEvent());
      },
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String _formatAmount(String? amount) {
    if (amount == null || amount.isEmpty) return 'N/A';
    if (amount.startsWith('₹')) return amount;
    return '₹$amount';
  }

  String _getStatusDisplay(String? status) {
    final value = status?.toUpperCase() ?? '';
    if (value == 'APPROVED') return 'Approved';
    if (value == 'REJECTED') return 'Rejected';
    return 'Pending';
  }

  Color _getStatusColor(String status) {
    if (status == 'Approved') return Colors.green;
    if (status == 'Rejected') return Colors.red;
    return Colors.orange;
  }

  IconData _getStatusIcon(String status) {
    if (status == 'Approved') return Icons.check_circle;
    if (status == 'Rejected') return Icons.cancel;
    return Icons.pending;
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
          text: context.tr('machine_hiring'),
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
      body: BlocBuilder<GetMachinesBloc, GetMachinesState>(
        builder: (context, state) {
          if (state is GetMachinesLoadingState) {
            return CustomListShimmer();
          }

          if (state is GetMachinesErrorState) {
            return NoDataWidget(
              title: state.message,
              assetIcon: Appconstants.machinery,
            );
          }

          if (state is GetMachinesSuccessState) {
            final hiringList = state.machinelist;

            if (hiringList.isEmpty) {
              return NoDataWidget(
                title: context.tr('no_hiring_records_found'),
                assetIcon: Appconstants.machinery,
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
              itemCount: hiringList.length,
              itemBuilder: (context, index) {
                final hiring = hiringList[index];
                return GestureDetector(
                  onTap: () {
                    context.push('/machinehiredetailpage', extra: hiring);
                  },
                  child: _buildHiringCard(hiring),
                );
              },
            );
          }

          return NoDataWidget(
            title: context.tr('no_hiring_records_found'),
            assetIcon: Appconstants.machinery,
          );
        },
      ),
    );
  }

  Widget _buildHiringCard(MachineHireModel hiring) {
    final status = _getStatusDisplay(hiring.status);
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);

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
            // Tool Icon
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
              decoration: BoxDecoration(
                color: Appcolors.kprimarycolor.withOpacity(0.1),
                borderRadius: BorderRadiusStyles.kradius10(),
              ),
              child: Icon(
                Icons.build_circle_rounded,
                size: ResponsiveUtils.sp(10),
                color: Appcolors.kprimarycolor,
              ),
            ),
            ResponsiveSizedBox.width(3),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tool Name
                  TextStyles.subheadline(
                    text: hiring.machine ?? 'Unknown Machine',
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                    overflow: TextOverflow.ellipsis,
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
                        text: _formatDate(hiring.hireDate),
                        color: Appcolors.kgreyColor,
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height5,
                  // Amount
                  Row(
                    children: [
                      Icon(
                        Icons.currency_rupee,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kprimarycolor,
                      ),
                      ResponsiveSizedBox.width(1),
                      TextStyles.medium(
                        text: _formatAmount(hiring.amountPaid),
                        weight: FontWeight.w600,
                        color: Appcolors.kprimarycolor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
