import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/approvals/models/approvels_expensemodel.dart';
import 'package:dhani_communications/features/approvals/repo/approvels_repo.dart';
import 'package:meta/meta.dart';

part 'fetch_approvel_expense_event.dart';
part 'fetch_approvel_expense_state.dart';

class FetchApprovelExpenseBloc
    extends Bloc<FetchApprovelExpenseEvent, FetchApprovelExpenseState> {
  final ApprovelsRepo repository;
  FetchApprovelExpenseBloc({required this.repository})
    : super(FetchApprovelExpenseInitial()) {
    on<FetchApprovelExpenseEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchApprovelExpenseInitialEvent>(fetchapprovelexpense);
  }

  FutureOr<void> fetchapprovelexpense(
    FetchApprovelExpenseInitialEvent event,
    Emitter<FetchApprovelExpenseState> emit,
  ) async {
    emit(FetchApprovelExpenseLoadingState());
    final response = await repository.approvelexpenses();
    if (!response.error && response.status == 200) {
      emit(FetchApprovelExpensesSuccessSate(expenses: response.data!));
    } else {
      emit(FetchApprovelExpensesErrorState(message: response.message));
    }
  }
}
