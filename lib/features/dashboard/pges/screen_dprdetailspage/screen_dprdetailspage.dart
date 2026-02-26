import 'dart:math';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:dhani_communications/features/dashboard/models/dpr_model.dart';
import 'package:dhani_communications/features/dashboard/blocs/dpr_details_bloc/dpr_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ScreenDprDetailsPage extends StatefulWidget {
  final int dprId;

  const ScreenDprDetailsPage({super.key, required this.dprId});

  @override
  State<ScreenDprDetailsPage> createState() => _ScreenDprDetailsPageState();
}

class _ScreenDprDetailsPageState extends State<ScreenDprDetailsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch DPR details when page loads
    context.read<DprDetailsBloc>().add(
      FetchDprDetailsEvent(dprId: widget.dprId),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.kwhitecolor,
      appBar: AppBar(
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
          text: 'DPR Details',
          weight: FontWeight.bold,
          color: Appcolors.kblackcolor,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<DprDetailsBloc, DprDetailsState>(
        builder: (context, state) {
          if (state is DprDetailsLoadingState) {
            return Center(
              child: CircularProgressIndicator(color: Appcolors.kprimarycolor),
            );
          }

          if (state is DprDetailsErrorState) {
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
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.wp(8),
                    ),
                    child: TextStyles.title(
                      text: state.message,
                      color: Appcolors.kgreyColor,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ResponsiveSizedBox.height20,
                  ElevatedButton(
                    onPressed: () {
                      context.read<DprDetailsBloc>().add(
                        FetchDprDetailsEvent(dprId: widget.dprId),
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

          if (state is DprDetailsSuccessState) {
            final dprDetails = state.dprDetails;
            return RefreshIndicator(
              color: Appcolors.kprimarycolor,
              onRefresh: () async {
                context.read<DprDetailsBloc>().add(
                  FetchDprDetailsEvent(dprId: widget.dprId),
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Header Card with DPR Info
                    _buildHeaderCard(dprDetails),

                    // Transactions Section
                    _buildTransactionsSection(dprDetails),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeaderCard(DprDetailsModel dprDetails) {
    final percentage = dprDetails.percentageCompleted;

    return Container(
      margin: EdgeInsets.all(ResponsiveUtils.wp(4)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Appcolors.kprimarycolor,
            Appcolors.kprimarycolor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadiusStyles.kradius15(),
        boxShadow: [
          BoxShadow(
            color: Appcolors.kprimarycolor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.wp(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SIC Badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.wp(3),
                vertical: ResponsiveUtils.hp(0.5),
              ),
              decoration: BoxDecoration(
                color: Appcolors.kwhitecolor.withOpacity(0.2),
                borderRadius: BorderRadiusStyles.kradius5(),
              ),
              child: TextStyles.caption(
                text: 'SIC: ${dprDetails.sic}',
                weight: FontWeight.w600,
                color: Appcolors.kwhitecolor,
              ),
            ),
            ResponsiveSizedBox.height15,

            // Description
            TextStyles.headline(
              text: dprDetails.description,
              weight: FontWeight.bold,
              color: Appcolors.kwhitecolor,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            ResponsiveSizedBox.height20,

            // Progress Circle and Stats Row
            Row(
              children: [
                // Circular Progress
                SizedBox(
                  width: ResponsiveUtils.wp(22),
                  height: ResponsiveUtils.wp(22),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: ResponsiveUtils.wp(22),
                        height: ResponsiveUtils.wp(22),
                        child: CircularProgressIndicator(
                          value: 1.0,
                          strokeWidth: 8,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Appcolors.kwhitecolor.withOpacity(0.3),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ResponsiveUtils.wp(22),
                        height: ResponsiveUtils.wp(22),
                        child: CircularProgressIndicator(
                          value: min(percentage / 100, 1.0),
                          strokeWidth: 8,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Appcolors.kwhitecolor,
                          ),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextStyles.title(
                            text: '$percentage',
                            weight: FontWeight.bold,
                            color: Appcolors.kwhitecolor,
                          ),
                          TextStyles.caption(
                            text: '%',
                            weight: FontWeight.w600,
                            color: Appcolors.kwhitecolor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ResponsiveSizedBox.width(5),
                // Stats
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatRow(
                        icon: Icons.straighten,
                        label: 'UOM',
                        value: dprDetails.uom,
                      ),
                      ResponsiveSizedBox.height10,
                      _buildStatRow(
                        icon: Icons.inventory_2_outlined,
                        label: 'SCQ',
                        value: dprDetails.scq,
                      ),
                      ResponsiveSizedBox.height10,
                      _buildStatRow(
                        icon: Icons.check_circle_outline,
                        label: 'Completed',
                        value: _formatCompleted(dprDetails.completed),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: ResponsiveUtils.sp(4),
          color: Appcolors.kwhitecolor.withOpacity(0.8),
        ),
        ResponsiveSizedBox.width(2),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(3.2),
                    color: Appcolors.kwhitecolor.withOpacity(0.8),
                  ),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(3.5),
                    fontWeight: FontWeight.bold,
                    color: Appcolors.kwhitecolor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionsSection(DprDetailsModel dprDetails) {
    final transactions = dprDetails.transactions;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.wp(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextStyles.title(
                text: 'Progress History',
                weight: FontWeight.bold,
                color: Appcolors.kblackcolor,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.wp(3),
                  vertical: ResponsiveUtils.hp(0.5),
                ),
                decoration: BoxDecoration(
                  color: Appcolors.kprimarycolor.withOpacity(0.1),
                  borderRadius: BorderRadiusStyles.kradius10(),
                ),
                child: TextStyles.caption(
                  text: '${transactions.length} entries',
                  weight: FontWeight.w600,
                  color: Appcolors.kprimarycolor,
                ),
              ),
            ],
          ),
          ResponsiveSizedBox.height15,
          if (transactions.isEmpty)
            Center(
              child: Column(
                children: [
                  ResponsiveSizedBox.height20,
                  Icon(
                    Icons.history_outlined,
                    size: ResponsiveUtils.sp(15),
                    color: Appcolors.kgreyColor.withOpacity(0.5),
                  ),
                  ResponsiveSizedBox.height10,
                  TextStyles.medium(
                    text: 'No progress entries yet',
                    color: Appcolors.kgreyColor,
                  ),
                  ResponsiveSizedBox.height20,
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              separatorBuilder: (context, index) => ResponsiveSizedBox.height10,
              itemBuilder: (context, index) {
                return _buildTransactionCard(transactions[index]);
              },
            ),
          ResponsiveSizedBox.height20,
        ],
      ),
    );
  }

  Widget _buildTransactionCard(DprTransactionModel transaction) {
    final statusColor = _getStatusColor(transaction.status);

    return Container(
      decoration: BoxDecoration(
        color: Appcolors.kwhitecolor,
        borderRadius: BorderRadiusStyles.kradius10(),
        border: Border.all(color: Appcolors.kgreyColor.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Appcolors.kgreyColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Date, Status, Quantity
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Date
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: ResponsiveUtils.sp(4),
                      color: Appcolors.kprimarycolor,
                    ),
                    ResponsiveSizedBox.width(2),
                    TextStyles.medium(
                      text: transaction.progressDate,
                      weight: FontWeight.w600,
                      color: Appcolors.kblackcolor,
                    ),
                  ],
                ),
                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.wp(2.5),
                    vertical: ResponsiveUtils.hp(0.4),
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadiusStyles.kradius5(),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: TextStyles.caption(
                    text: transaction.statusDisplayText,
                    weight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            ResponsiveSizedBox.height10,

            // User and Quantity Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // User Name
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: ResponsiveUtils.wp(4),
                        backgroundColor: Appcolors.kprimarycolor.withOpacity(
                          0.1,
                        ),
                        child: TextStyles.caption(
                          text:
                              transaction.userName.isNotEmpty &&
                                  transaction.userName != '-'
                              ? transaction.userName[0].toUpperCase()
                              : 'U',
                          weight: FontWeight.bold,
                          color: Appcolors.kprimarycolor,
                        ),
                      ),
                      ResponsiveSizedBox.width(2),
                      Expanded(
                        child: TextStyles.medium(
                          text: transaction.userName,
                          color: Appcolors.kblackcolor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // Quantity
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.wp(3),
                    vertical: ResponsiveUtils.hp(0.5),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadiusStyles.kradius5(),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        size: ResponsiveUtils.sp(4),
                        color: Colors.green,
                      ),
                      ResponsiveSizedBox.width(1),
                      TextStyles.medium(
                        text: _formatQuantity(transaction.progressQuantity),
                        weight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // User Remarks (if any)
            if (transaction.userRemarks != null &&
                transaction.userRemarks!.isNotEmpty) ...[
              ResponsiveSizedBox.height10,
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
                decoration: BoxDecoration(
                  color: Appcolors.kgreyColor.withOpacity(0.05),
                  borderRadius: BorderRadiusStyles.kradius5(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextStyles.caption(
                      text: 'Remarks:',
                      weight: FontWeight.w600,
                      color: Appcolors.kgreyColor,
                    ),
                    ResponsiveSizedBox.height5,
                    TextStyles.caption(
                      text: transaction.userRemarks!,
                      color: Appcolors.kblackcolor.withOpacity(0.8),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatCompleted(double completed) {
    if (completed == completed.roundToDouble()) {
      return completed.toInt().toString();
    }
    return completed.toStringAsFixed(2);
  }

  String _formatQuantity(double quantity) {
    if (quantity == quantity.roundToDouble()) {
      return quantity.toInt().toString();
    }
    return quantity.toStringAsFixed(2);
  }
}
