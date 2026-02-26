import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/dashboard/models/expense_model.dart';
import 'package:dhani_communications/features/dashboard/repo/apprepo.dart';
import 'package:meta/meta.dart';

part 'create_expense_event.dart';
part 'create_expense_state.dart';

class CreateExpenseBloc extends Bloc<CreateExpenseEvent, CreateExpenseState> {
  final Apprepo repository;

  CreateExpenseBloc({required this.repository}) : super(CreateExpenseInitial()) {
    on<SubmitExpenseEvent>(_onSubmitExpense);
  }

  FutureOr<void> _onSubmitExpense(
    SubmitExpenseEvent event,
    Emitter<CreateExpenseState> emit,
  ) async {
    emit(CreateExpenseLoadingState());
    try {
      final response = await repository.createExpense(
        projectId: event.projectId,
        expenseDate: event.expenseDate,
        expenseCategoryId: event.expenseCategoryId,
        expenseAmount: event.expenseAmount,
        vehicleId: event.vehicleId,
        fuelFillKm: event.fuelFillKm,
        userRemarks: event.userRemarks,
        attachements: event.attachements,
      );
      if (!response.error && response.status == 200) {
        emit(CreateExpenseSuccessState(
          expenseId: response.data,
          message: response.message,
        ));
      } else {
        emit(CreateExpenseErrorState(message: response.message));
      }
    } catch (e) {
      emit(CreateExpenseErrorState(message: e.toString()));
    }
  }
}
