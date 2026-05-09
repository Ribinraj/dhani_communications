import 'dart:async';

import 'package:dhani_communications/features/approvals/models/approvels_machine_hire_model.dart';
import 'package:dhani_communications/features/approvals/repo/approvels_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'fetch_approvel_machine_hire_event.dart';
part 'fetch_approvel_machine_hire_state.dart';

class FetchApprovelMachineHireBloc
    extends Bloc<FetchApprovelMachineHireEvent, FetchApprovelMachineHireState> {
  final ApprovelsRepo repository;

  FetchApprovelMachineHireBloc({required this.repository})
    : super(FetchApprovelMachineHireInitial()) {
    on<FetchApprovelMachineHireInitialEvent>(_fetchMachineHireList);
  }

  FutureOr<void> _fetchMachineHireList(
    FetchApprovelMachineHireInitialEvent event,
    Emitter<FetchApprovelMachineHireState> emit,
  ) async {
    emit(FetchApprovelMachineHireLoadingState());
    try {
      final response = await repository.approveMachineHireList(
        filterFrom: event.filterFrom,
        filterTo: event.filterTo,
      );
      if (!response.error && response.status == 200 && response.data != null) {
        emit(
          FetchApprovelMachineHireSuccessState(machineHires: response.data!),
        );
      } else {
        emit(FetchApprovelMachineHireErrorState(message: response.message));
      }
    } catch (e) {
      emit(FetchApprovelMachineHireErrorState(message: e.toString()));
    }
  }
}
