import 'dart:async';

import 'package:dhani_communications/features/approvals/repo/approvels_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'update_machine_hire_approval_event.dart';
part 'update_machine_hire_approval_state.dart';

class UpdateMachineHireApprovalBloc
    extends
        Bloc<UpdateMachineHireApprovalEvent, UpdateMachineHireApprovalState> {
  final ApprovelsRepo repository;

  UpdateMachineHireApprovalBloc({required this.repository})
    : super(UpdateMachineHireApprovalInitial()) {
    on<ApproveMachineHireEvent>(_onApproveMachineHire);
    on<RejectMachineHireEvent>(_onRejectMachineHire);
  }

  FutureOr<void> _onApproveMachineHire(
    ApproveMachineHireEvent event,
    Emitter<UpdateMachineHireApprovalState> emit,
  ) async {
    emit(UpdateMachineHireApprovalLoadingState());
    final response = await repository.updateMachineHireApproval(
      hireId: event.hireId,
      status: 'APPROVED',
      approverRemarks: null,
    );
    if (!response.error && response.status == 200) {
      emit(UpdateMachineHireApprovalSuccessState(message: response.message));
    } else {
      emit(UpdateMachineHireApprovalErrorState(message: response.message));
    }
  }

  FutureOr<void> _onRejectMachineHire(
    RejectMachineHireEvent event,
    Emitter<UpdateMachineHireApprovalState> emit,
  ) async {
    emit(UpdateMachineHireApprovalLoadingState());
    final response = await repository.updateMachineHireApproval(
      hireId: event.hireId,
      status: 'REJECTED',
      approverRemarks: event.approverRemarks,
    );
    if (!response.error && response.status == 200) {
      emit(UpdateMachineHireApprovalSuccessState(message: response.message));
    } else {
      emit(UpdateMachineHireApprovalErrorState(message: response.message));
    }
  }
}
