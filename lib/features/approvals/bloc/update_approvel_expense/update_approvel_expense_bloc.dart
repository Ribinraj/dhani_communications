import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/approvals/repo/approvels_repo.dart';
import 'package:meta/meta.dart';

part 'update_approvel_expense_event.dart';
part 'update_approvel_expense_state.dart';

class UpdateApprovelExpenseBloc
    extends Bloc<UpdateApprovelExpenseEvent, UpdateApprovelExpenseState> {
  final ApprovelsRepo repository;

  UpdateApprovelExpenseBloc({required this.repository})
    : super(UpdateApprovelExpenseInitial()) {
    on<ApproveExpenseEvent>(_onApproveExpense);
    on<RejectExpenseEvent>(_onRejectExpense);
  }

  FutureOr<void> _onApproveExpense(
    ApproveExpenseEvent event,
    Emitter<UpdateApprovelExpenseState> emit,
  ) async {
    emit(UpdateApprovelExpenseLoadingState());
    final response = await repository.updateExpenseApproval(
      expenseId: event.expenseId,
      status: 'APPROVED',
    );
    if (!response.error && response.status == 200) {
      emit(UpdateApprovelExpenseSuccessState(message: response.message));
    } else {
      emit(UpdateApprovelExpenseErrorState(message: response.message));
    }
  }

  FutureOr<void> _onRejectExpense(
    RejectExpenseEvent event,
    Emitter<UpdateApprovelExpenseState> emit,
  ) async {
    emit(UpdateApprovelExpenseLoadingState());
    final response = await repository.updateExpenseApproval(
      expenseId: event.expenseId,
      status: 'REJECTED',
      approverRemarks: event.approverRemarks,
    );
    if (!response.error && response.status == 200) {
      emit(UpdateApprovelExpenseSuccessState(message: response.message));
    } else {
      emit(UpdateApprovelExpenseErrorState(message: response.message));
    }
  }
}
