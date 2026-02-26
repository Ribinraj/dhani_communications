import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/approvals/models/approvels_labourattendencemodel.dart';
import 'package:dhani_communications/features/approvals/repo/approvels_repo.dart';
import 'package:meta/meta.dart';

part 'fetch_labour_approvelattendence_event.dart';
part 'fetch_labour_approvelattendence_state.dart';

class FetchLabourApprovelattendenceBloc
    extends
        Bloc<
          FetchLabourApprovelattendenceEvent,
          FetchLabourApprovelattendenceState
        > {
  final ApprovelsRepo repository;
  FetchLabourApprovelattendenceBloc({required this.repository})
    : super(FetchLabourApprovelattendenceInitial()) {
    on<FetchLabourApprovelattendenceEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchLabourApprovelattendenceInitialFetchingEvent>(
      fetchlabourattendencelist,
    );
  }

  FutureOr<void> fetchlabourattendencelist(
    FetchLabourApprovelattendenceInitialFetchingEvent event,
    Emitter<FetchLabourApprovelattendenceState> emit,
  ) async {
    emit(FetchLabourApprovelAttendenceLoadingState());
    final response = await repository.labourapproveattendence();
    if (!response.error && response.status == 200) {
      emit(
        FetchLabourApprovelAttendenceSuccessState(attendence: response.data!),
      );
    } else {
      emit(FetchLabourApprovelAttendenceErrorState(message: response.message));
    }
  }
}
