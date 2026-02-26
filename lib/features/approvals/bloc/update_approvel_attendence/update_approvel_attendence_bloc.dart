import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/approvals/repo/approvels_repo.dart';
import 'package:meta/meta.dart';

part 'update_approvel_attendence_event.dart';
part 'update_approvel_attendence_state.dart';

class UpdateApprovelAttendenceBloc
    extends Bloc<UpdateApprovelAttendenceEvent, UpdateApprovelAttendenceState> {
  final ApprovelsRepo repository;

  UpdateApprovelAttendenceBloc({required this.repository})
    : super(UpdateApprovelAttendenceInitial()) {
    on<ApproveAttendanceEvent>(_onApproveAttendance);
    on<RejectAttendanceEvent>(_onRejectAttendance);
  }

  FutureOr<void> _onApproveAttendance(
    ApproveAttendanceEvent event,
    Emitter<UpdateApprovelAttendenceState> emit,
  ) async {
    emit(UpdateApprovelAttendenceLoadingState());
    final response = await repository.updateAttendanceApproval(
      attendanceId: event.attendanceId,
      status: 'APPROVED',
      approverRemarks: null,
    );
    if (!response.error && response.status == 200) {
      emit(UpdateApprovelAttendenceSuccessState(message: response.message));
    } else {
      emit(UpdateApprovelAttendenceErrorState(message: response.message));
    }
  }

  FutureOr<void> _onRejectAttendance(
    RejectAttendanceEvent event,
    Emitter<UpdateApprovelAttendenceState> emit,
  ) async {
    emit(UpdateApprovelAttendenceLoadingState());
    final response = await repository.updateAttendanceApproval(
      attendanceId: event.attendanceId,
      status: 'REJECTED',
      approverRemarks: event.approverRemarks,
    );
    if (!response.error && response.status == 200) {
      emit(UpdateApprovelAttendenceSuccessState(message: response.message));
    } else {
      emit(UpdateApprovelAttendenceErrorState(message: response.message));
    }
  }
}
