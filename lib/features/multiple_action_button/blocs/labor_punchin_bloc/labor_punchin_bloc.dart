import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/models/labor_attendance_request_model.dart';
import 'package:dhani_communications/features/multiple_action_button/models/labor_punchout_request_model.dart';
import 'package:dhani_communications/features/multiple_action_button/repo/multiactionrepo.dart';
import 'package:meta/meta.dart';

part 'labor_punchin_event.dart';
part 'labor_punchin_state.dart';

class LaborPunchInBloc extends Bloc<LaborPunchInEvent, LaborPunchInState> {
  final Multiactionrepo repository;

  LaborPunchInBloc({required this.repository}) : super(LaborPunchInInitial()) {
    on<LaborPunchInSubmitEvent>(_onSubmit);
    on<LaborPunchOutSubmitEvent>(_onPunchOut);
  }

  FutureOr<void> _onSubmit(
    LaborPunchInSubmitEvent event,
    Emitter<LaborPunchInState> emit,
  ) async {
    emit(LaborPunchInLoadingState());
    try {
      final response = await repository.createLaborAttendance(
        laborAttendance: event.laborAttendance,
      );
      if (!response.error && response.status == 200) {
        emit(LaborPunchInSuccessState(message: response.message));
      } else {
        emit(LaborPunchInErrorState(message: response.message));
      }
    } catch (e) {
      emit(LaborPunchInErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _onPunchOut(
    LaborPunchOutSubmitEvent event,
    Emitter<LaborPunchInState> emit,
  ) async {
    emit(LaborPunchInLoadingState());
    try {
      final response = await repository.createLaborPunchOut(
        punchOut: event.punchOut,
      );
      if (!response.error && response.status == 200) {
        emit(LaborPunchInSuccessState(message: response.message));
      } else {
        emit(LaborPunchInErrorState(message: response.message));
      }
    } catch (e) {
      emit(LaborPunchInErrorState(message: e.toString()));
    }
  }
}
