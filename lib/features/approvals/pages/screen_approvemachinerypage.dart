import 'package:dhani_communications/core/appconstants.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/features/approvals/bloc/fetch_approvel_machine_hire/fetch_approvel_machine_hire_bloc.dart';
import 'package:dhani_communications/features/approvals/models/approvels_machine_hire_model.dart';
import 'package:dhani_communications/widgets/date_filter_dialog.dart';
import 'package:dhani_communications/widgets/custom_nondatawidget.dart';
import 'package:dhani_communications/widgets/customshimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';

class ScreenApproveMachineryPage extends StatefulWidget {
  const ScreenApproveMachineryPage({super.key});

  @override
  State<ScreenApproveMachineryPage> createState() =>
      _ScreenApproveMachineryPageState();
}

class _ScreenApproveMachineryPageState
    extends State<ScreenApproveMachineryPage> {
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    context.read<FetchApprovelMachineHireBloc>().add(
      FetchApprovelMachineHireInitialEvent(),
    );
  }

  void _fetchMachineHires() {
    context.read<FetchApprovelMachineHireBloc>().add(
      FetchApprovelMachineHireInitialEvent(
        filterFrom: _fromDate == null
            ? null
            : DateFormat('yyyy-MM-dd').format(_fromDate!),
        filterTo: _toDate == null
            ? null
            : DateFormat('yyyy-MM-dd').format(_toDate!),
      ),
    );
  }

  // ---------------- FILTER DIALOG ----------------
  // Filter Dialog
  void _showFilterDialog() {
    DateFilterDialog.show(
      context: context,
      title: 'Filter Machinery',
      initialFromDate: _fromDate,
      initialToDate: _toDate,
      onApply: (fromDate, toDate) {
        setState(() {
          _fromDate = fromDate;
          _toDate = toDate;
        });
        _fetchMachineHires();
      },
      onClear: () {
        setState(() {
          _fromDate = null;
          _toDate = null;
        });
        _fetchMachineHires();
      },
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return 'N/A';
    try {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(dateStr));
    } catch (e) {
      return dateStr;
    }
  }

  String _formatAmount(String amount) {
    if (amount.isEmpty) return 'N/A';
    if (amount.startsWith('₹')) return amount;
    return '₹$amount';
  }

  String _getStatusDisplay(String status) {
    final value = status.toUpperCase();
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

  // ---------------- MAIN UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.kwhitecolor,
      appBar: AppBar(
        backgroundColor: Appcolors.kwhitecolor,
        elevation: 2,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Appcolors.kprimarycolor,
          ),
        ),
        title: TextStyles.subheadline(
          text: "Approve Machinery",
          weight: FontWeight.bold,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _showFilterDialog,
            icon: Stack(
              children: [
                Icon(Icons.filter_list_rounded, color: Appcolors.kprimarycolor),
                if (_fromDate != null || _toDate != null)
                  Positioned(
                    right: 0,
                    child: Container(
                      width: ResponsiveUtils.wp(2),
                      height: ResponsiveUtils.wp(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),

      body:
          BlocBuilder<
            FetchApprovelMachineHireBloc,
            FetchApprovelMachineHireState
          >(
            builder: (context, state) {
              if (state is FetchApprovelMachineHireLoadingState) {
                return CustomListShimmer();
              }

              if (state is FetchApprovelMachineHireErrorState) {
                return NoDataWidget(
                  title: state.message,
                  assetIcon: Appconstants.machinery,
                  onRefresh: _fetchMachineHires,
                );
              }

              if (state is FetchApprovelMachineHireSuccessState) {
                final hiringList = state.machineHires;

                if (hiringList.isEmpty) {
                  return NoDataWidget(
                    title: 'No machinery approvals found',
                    assetIcon: Appconstants.machinery,
                    onRefresh: _fetchMachineHires,
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => _fetchMachineHires(),
                  child: ListView.builder(
                    padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                    itemCount: hiringList.length,
                    itemBuilder: (context, index) {
                      final hiring = hiringList[index];

                      return Slidable(
                        key: ValueKey(hiring.hireId),
                        startActionPane: ActionPane(
                          motion: StretchMotion(),
                          extentRatio: 0.25,
                          children: [
                            CustomSlidableAction(
                              onPressed: (_) {},
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              borderRadius: BorderRadiusStyles.kradius15(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: ResponsiveUtils.sp(8),
                                  ),
                                  ResponsiveSizedBox.height5,
                                  TextStyles.caption(
                                    text: "Approve",
                                    color: Colors.white,
                                    weight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: StretchMotion(),
                          extentRatio: 0.25,
                          children: [
                            CustomSlidableAction(
                              onPressed: (_) {},
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              borderRadius: BorderRadiusStyles.kradius15(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cancel,
                                    size: ResponsiveUtils.sp(8),
                                  ),
                                  ResponsiveSizedBox.height5,
                                  TextStyles.caption(
                                    text: "Reject",
                                    color: Colors.white,
                                    weight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () => context.push(
                            '/machinehireapprovedetailpage',
                            extra: hiring,
                          ),
                          child: _buildMachineryCard(hiring),
                        ),
                      );
                    },
                  ),
                );
              }

              return NoDataWidget(
                title: 'No machinery approvals found',
                assetIcon: Appconstants.machinery,
                onRefresh: _fetchMachineHires,
              );
            },
          ),
    );
  }

  // ---------------- CARD UI ----------------

  Widget _buildMachineryCard(ApprovelsMachineHireModel hiring) {
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
            color: Appcolors.kgreyColor.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
              decoration: BoxDecoration(
                color: Appcolors.kprimarycolor.withValues(alpha: 0.1),
                borderRadius: BorderRadiusStyles.kradius10(),
              ),
              child: Icon(
                Icons.build_circle_rounded,
                color: Appcolors.kprimarycolor,
                size: ResponsiveUtils.sp(10),
              ),
            ),

            ResponsiveSizedBox.width(3),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextStyles.subheadline(
                    text: hiring.machine.isEmpty
                        ? 'Unknown Machine'
                        : hiring.machine,
                    weight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                  ResponsiveSizedBox.height5,

                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Appcolors.kgreyColor,
                        size: ResponsiveUtils.sp(3.5),
                      ),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text: _formatDate(hiring.hireDate),
                        color: Appcolors.kgreyColor,
                      ),
                    ],
                  ),

                  ResponsiveSizedBox.height5,

                  Row(
                    children: [
                      Icon(
                        Icons.currency_rupee,
                        color: Appcolors.kprimarycolor,
                        size: ResponsiveUtils.sp(3.5),
                      ),
                      ResponsiveSizedBox.width(1),
                      TextStyles.medium(
                        text: _formatAmount(hiring.amountPaid),
                        color: Appcolors.kprimarycolor,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            ResponsiveSizedBox.width(2),

            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: statusColor.withValues(alpha: 0.1),
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
                  color: statusColor,
                  weight: FontWeight.bold,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
