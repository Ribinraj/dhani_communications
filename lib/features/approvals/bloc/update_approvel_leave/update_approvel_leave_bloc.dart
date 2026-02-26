import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/approvals/repo/approvels_repo.dart';
import 'package:meta/meta.dart';

part 'update_approvel_leave_event.dart';
part 'update_approvel_leave_state.dart';

class UpdateApprovelLeaveBloc
    extends Bloc<UpdateApprovelLeaveEvent, UpdateApprovelLeaveState> {
  final ApprovelsRepo repository;

  UpdateApprovelLeaveBloc({required this.repository})
    : super(UpdateApprovelLeaveInitial()) {
    on<ApproveLeaveEvent>(_onApproveLeave);
    on<RejectLeaveEvent>(_onRejectLeave);
  }

  FutureOr<void> _onApproveLeave(
    ApproveLeaveEvent event,
    Emitter<UpdateApprovelLeaveState> emit,
  ) async {
    emit(UpdateApprovelLeaveLoadingState());
    final response = await repository.updateLeaveApproval(
      leaveId: event.leaveId,
      status: 'APPROVED',
      approverRemarks: null,
    );
    if (!response.error && response.status == 200) {
      emit(UpdateApprovelLeaveSuccessState(message: response.message));
    } else {
      emit(UpdateApprovelLeaveErrorState(message: response.message));
    }
  }

  FutureOr<void> _onRejectLeave(
    RejectLeaveEvent event,
    Emitter<UpdateApprovelLeaveState> emit,
  ) async {
    emit(UpdateApprovelLeaveLoadingState());
    final response = await repository.updateLeaveApproval(
      leaveId: event.leaveId,
      status: 'REJECTED',
      approverRemarks: event.approverRemarks,
    );
    if (!response.error && response.status == 200) {
      emit(UpdateApprovelLeaveSuccessState(message: response.message));
    } else {
      emit(UpdateApprovelLeaveErrorState(message: response.message));
    }
  }
}
