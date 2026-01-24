import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/data/models/expense_model.dart';
import 'package:dhani_communications/domain/repositories/apprepo.dart';
import 'package:meta/meta.dart';

part 'expense_list_event.dart';
part 'expense_list_state.dart';

class ExpenseListBloc extends Bloc<ExpenseListEvent, ExpenseListState> {
  final Apprepo repository;

  ExpenseListBloc({required this.repository}) : super(ExpenseListInitial()) {
    on<FetchExpenseListEvent>(_onFetchExpenseList);
  }

  FutureOr<void> _onFetchExpenseList(
    FetchExpenseListEvent event,
    Emitter<ExpenseListState> emit,
  ) async {
    emit(ExpenseListLoadingState());
    try {
      final response = await repository.getExpensesList(
        projectId: event.projectId,
        startDate: event.startDate,
        endDate: event.endDate,
      );
      if (!response.error && response.status == 200 && response.data != null) {
        emit(ExpenseListSuccessState(expensesList: response.data!));
      } else {
        emit(ExpenseListErrorState(message: response.message));
      }
    } catch (e) {
      emit(ExpenseListErrorState(message: e.toString()));
    }
  }
}
