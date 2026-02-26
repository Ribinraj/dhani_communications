import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/approvals/models/approvels_attendencemodel.dart';
import 'package:dhani_communications/features/approvals/repo/approvels_repo.dart';
import 'package:meta/meta.dart';

part 'fetch_approvelattendence_event.dart';
part 'fetch_approvelattendence_state.dart';

class FetchApprovelattendenceBloc
    extends Bloc<FetchApprovelattendenceEvent, FetchApprovelattendenceState> {
  final ApprovelsRepo repository;
  FetchApprovelattendenceBloc({required this.repository})
    : super(FetchApprovelattendenceInitial()) {
    on<FetchApprovelattendenceEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchApprovelAttendenceInitialFetchingEvent>(fetchapprovelattendence);
  }

  FutureOr<void> fetchapprovelattendence(
    FetchApprovelAttendenceInitialFetchingEvent event,
    Emitter<FetchApprovelattendenceState> emit,
  ) async {
    emit(FetchApprovelAttendenceLoadingState());
    final responsese = await repository.approveattendence();
    if (!responsese.error && responsese.status == 200) {
      emit(FetchApprovelAttendenceSuccessState(attendence: responsese.data!));
    } else {
      emit(FetchApproveAttendenceErrorState(message: responsese.message));
    }
  }
}
