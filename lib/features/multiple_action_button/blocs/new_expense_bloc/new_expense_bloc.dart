import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/models/new_expense_request_model.dart';
import 'package:dhani_communications/features/multiple_action_button/repo/multiactionrepo.dart';
import 'package:meta/meta.dart';

part 'new_expense_event.dart';
part 'new_expense_state.dart';

class NewExpenseBloc extends Bloc<NewExpenseEvent, NewExpenseState> {
  final Multiactionrepo repository;

  NewExpenseBloc({required this.repository}) : super(NewExpenseInitial()) {
    on<SubmitNewExpenseEvent>(_onSubmitExpense);
  }

  FutureOr<void> _onSubmitExpense(
    SubmitNewExpenseEvent event,
    Emitter<NewExpenseState> emit,
  ) async {
    emit(NewExpenseLoadingState());
    try {
      final response = await repository.createNewExpense(
        expense: event.expense,
      );
      if (!response.error && response.status == 200) {
        emit(NewExpenseSuccessState(message: response.message));
      } else {
        emit(NewExpenseErrorState(message: response.message));
      }
    } catch (e) {
      emit(NewExpenseErrorState(message: e.toString()));
    }
  }
}
