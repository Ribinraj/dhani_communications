import 'dart:async';

import 'package:dhani_communications/features/dashboard/models/cash_transaction_model.dart';
import 'package:dhani_communications/features/dashboard/repo/apprepo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cash_balance_event.dart';
part 'cash_balance_state.dart';

class CashBalanceBloc extends Bloc<CashBalanceEvent, CashBalanceState> {
  final Apprepo repository;

  CashBalanceBloc({required this.repository}) : super(CashBalanceInitial()) {
    on<FetchCashBalanceEvent>(_onFetchCashBalance);
    on<FetchCashTransactionsEvent>(_onFetchCashTransactions);
  }

  FutureOr<void> _onFetchCashBalance(
    FetchCashBalanceEvent event,
    Emitter<CashBalanceState> emit,
  ) async {
    emit(CashBalanceLoadingState());
    try {
      final balanceResponse = await repository.getCashBalance();
      if (balanceResponse.error ||
          balanceResponse.status != 200 ||
          balanceResponse.data == null) {
        emit(CashBalanceErrorState(message: balanceResponse.message));
        return;
      }

      final transactionsResponse = await repository.getCashTransactions();
      if (transactionsResponse.error ||
          transactionsResponse.status != 200 ||
          transactionsResponse.data == null) {
        emit(CashTransactionsErrorState(message: transactionsResponse.message));
        return;
      }

      emit(
        CashTransactionsSuccessState(
          balance: balanceResponse.data!,
          transactions: transactionsResponse.data!,
        ),
      );
    } catch (e) {
      emit(CashBalanceErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _onFetchCashTransactions(
    FetchCashTransactionsEvent event,
    Emitter<CashBalanceState> emit,
  ) async {
    add(FetchCashBalanceEvent());
  }
}
