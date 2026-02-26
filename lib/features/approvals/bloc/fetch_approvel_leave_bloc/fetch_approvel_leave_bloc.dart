import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/approvals/models/approvels_leavemodel.dart';
import 'package:dhani_communications/features/approvals/repo/approvels_repo.dart';
import 'package:meta/meta.dart';

part 'fetch_approvel_leave_event.dart';
part 'fetch_approvel_leave_state.dart';

class FetchApprovelLeaveBloc
    extends Bloc<FetchApprovelLeaveEvent, FetchApprovelLeaveState> {
  final ApprovelsRepo repository;
  FetchApprovelLeaveBloc({required this.repository})
    : super(FetchApprovelLeaveInitial()) {
    on<FetchApprovelleavesInitialEvent>(fetchapproveleaves);
  }

  FutureOr<void> fetchapproveleaves(
    FetchApprovelleavesInitialEvent event,
    Emitter<FetchApprovelLeaveState> emit,
  ) async {
    emit(FetchApprovelLeaveLoadingState());
    final response = await repository.approvelleaves();
    if (!response.error && response.status == 200) {
      emit(FetchApprovelLeaveSuccessState(leaves: response.data!));
    } else {
      emit(FetchApprovelLeavesErrorState(message: response.message));
    }
  }
}
