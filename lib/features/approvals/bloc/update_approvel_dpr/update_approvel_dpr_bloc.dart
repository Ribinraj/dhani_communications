import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/approvals/repo/approvels_repo.dart';
import 'package:meta/meta.dart';

part 'update_approvel_dpr_event.dart';
part 'update_approvel_dpr_state.dart';

class UpdateApprovelDprBloc
    extends Bloc<UpdateApprovelDprEvent, UpdateApprovelDprState> {
  final ApprovelsRepo repository;

  UpdateApprovelDprBloc({required this.repository})
    : super(UpdateApprovelDprInitial()) {
    on<ApproveDprEvent>(_onApproveDpr);
    on<RejectDprEvent>(_onRejectDpr);
  }

  FutureOr<void> _onApproveDpr(
    ApproveDprEvent event,
    Emitter<UpdateApprovelDprState> emit,
  ) async {
    emit(UpdateApprovelDprLoadingState());
    final response = await repository.updateDprApproval(
      progressId: event.progressId,
      status: 'APPROVED',
      approverRemarks: event.approverRemarks,
    );
    if (!response.error && response.status == 200) {
      emit(UpdateApprovelDprSuccessState(message: response.message));
    } else {
      emit(UpdateApprovelDprErrorState(message: response.message));
    }
  }

  FutureOr<void> _onRejectDpr(
    RejectDprEvent event,
    Emitter<UpdateApprovelDprState> emit,
  ) async {
    emit(UpdateApprovelDprLoadingState());
    final response = await repository.updateDprApproval(
      progressId: event.progressId,
      status: 'REJECTED',
      approverRemarks: event.approverRemarks,
    );
    if (!response.error && response.status == 200) {
      emit(UpdateApprovelDprSuccessState(message: response.message));
    } else {
      emit(UpdateApprovelDprErrorState(message: response.message));
    }
  }
}
