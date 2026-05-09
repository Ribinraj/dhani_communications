import 'package:dhani_communications/core/appconstants.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:dhani_communications/features/dashboard/blocs/cash_balance_bloc/cash_balance_bloc.dart';
import 'package:dhani_communications/features/dashboard/models/cash_transaction_model.dart';
import 'package:dhani_communications/widgets/custom_nondatawidget.dart';
import 'package:dhani_communications/widgets/customshimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ScreenCashBalancePage extends StatefulWidget {
  const ScreenCashBalancePage({super.key});

  @override
  State<ScreenCashBalancePage> createState() => _ScreenCashBalancePageState();
}

class _ScreenCashBalancePageState extends State<ScreenCashBalancePage> {
  @override
  void initState() {
    super.initState();
    context.read<CashBalanceBloc>().add(FetchCashBalanceEvent());
  }

  void _refreshCashBalance() {
    context.read<CashBalanceBloc>().add(FetchCashBalanceEvent());
  }

  String _formatAmount(String amount) {
    final parsed = double.tryParse(amount) ?? 0;
    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    ).format(parsed);
  }

  String _formatDateTime(String value) {
    if (value.isEmpty) return 'N/A';
    try {
      return DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(value));
    } catch (e) {
      return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.kwhitecolor,
      appBar: AppBar(
        backgroundColor: Appcolors.kwhitecolor,
        elevation: 2,
        shadowColor: Appcolors.kgreyColor.withValues(alpha: 0.1),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Appcolors.kprimarycolor,
            size: ResponsiveUtils.sp(5),
          ),
        ),
        title: TextStyles.subheadline(
          text: 'Cash Balance',
          weight: FontWeight.bold,
          color: Appcolors.kblackcolor,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<CashBalanceBloc, CashBalanceState>(
        builder: (context, state) {
          if (state is CashBalanceLoadingState ||
              state is CashTransactionsLoadingState) {
            return CustomListShimmer(itemCount: 4);
          }

          if (state is CashBalanceErrorState) {
            return NoDataWidget(
              title: state.message,
              assetIcon: Appconstants.cashbalance,
              onRefresh: _refreshCashBalance,
            );
          }

          if (state is CashTransactionsErrorState) {
            return NoDataWidget(
              title: state.message,
              assetIcon: Appconstants.cashbalance,
              onRefresh: _refreshCashBalance,
            );
          }

          if (state is CashTransactionsSuccessState) {
            return RefreshIndicator(
              onRefresh: () async => _refreshCashBalance(),
              child: ListView(
                padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                children: [
                  _buildBalanceCard(state.balance),
                  ResponsiveSizedBox.height(3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextStyles.subheadline(
                        text: 'Transactions',
                        weight: FontWeight.bold,
                        color: Appcolors.kblackcolor,
                      ),
                      TextStyles.caption(
                        text: '${state.transactions.length} entries',
                        color: Appcolors.kgreyColor,
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height15,
                  if (state.transactions.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: ResponsiveUtils.hp(12)),
                      child: NoDataWidget(
                        title: 'No cash transactions found',
                        assetIcon: Appconstants.cashbalance,
                        onRefresh: _refreshCashBalance,
                      ),
                    )
                  else
                    ...state.transactions.map(_buildTransactionCard),
                ],
              ),
            );
          }

          return NoDataWidget(
            title: 'No cash balance found',
            assetIcon: Appconstants.cashbalance,
            onRefresh: _refreshCashBalance,
          );
        },
      ),
    );
  }

  Widget _buildBalanceCard(String balance) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveUtils.wp(6)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Appcolors.kprimarycolor,
            Appcolors.kprimarycolor.withValues(alpha: 0.82),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadiusStyles.kradius15(),
        boxShadow: [
          BoxShadow(
            color: Appcolors.kprimarycolor.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
                decoration: BoxDecoration(
                  color: Appcolors.kwhitecolor.withValues(alpha: 0.16),
                  borderRadius: BorderRadiusStyles.kradius10(),
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Appcolors.kwhitecolor,
                  size: ResponsiveUtils.sp(7),
                ),
              ),
              ResponsiveSizedBox.width(3),
              TextStyles.medium(
                text: 'Available Balance',
                color: Appcolors.kwhitecolor.withValues(alpha: 0.9),
                weight: FontWeight.w600,
              ),
            ],
          ),
          ResponsiveSizedBox.height20,
          Text(
            _formatAmount(balance),
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(9),
              fontWeight: FontWeight.bold,
              color: Appcolors.kwhitecolor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(CashTransactionModel transaction) {
    final isCredit = transaction.isCredit;
    final color = isCredit ? Colors.green : Colors.red;
    final icon = isCredit
        ? Icons.arrow_downward_rounded
        : Icons.arrow_upward_rounded;

    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.hp(1.5)),
      padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
      decoration: BoxDecoration(
        color: Appcolors.kwhitecolor,
        borderRadius: BorderRadiusStyles.kradius15(),
        boxShadow: [
          BoxShadow(
            color: Appcolors.kgreyColor.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadiusStyles.kradius10(),
            ),
            child: Icon(icon, color: color, size: ResponsiveUtils.sp(6)),
          ),
          ResponsiveSizedBox.width(3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextStyles.medium(
                  text: transaction.notes.isEmpty
                      ? 'Cash Transaction'
                      : transaction.notes,
                  weight: FontWeight.bold,
                  color: Appcolors.kblackcolor,
                ),
                ResponsiveSizedBox.height5,
                TextStyles.caption(
                  text: _formatDateTime(transaction.createdAt),
                  color: Appcolors.kgreyColor,
                ),
                ResponsiveSizedBox.height5,
                TextStyles.caption(
                  text: transaction.transactionType,
                  color: color,
                  weight: FontWeight.w600,
                ),
              ],
            ),
          ),
          ResponsiveSizedBox.width(2),
          TextStyles.medium(
            text: '${isCredit ? '+' : '-'}${_formatAmount(transaction.amount)}',
            color: color,
            weight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
