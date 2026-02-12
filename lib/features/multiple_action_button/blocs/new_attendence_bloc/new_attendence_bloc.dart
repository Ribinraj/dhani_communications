import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/models/attendence_requestmodel.dart';
import 'package:dhani_communications/features/multiple_action_button/repo/multiactionrepo.dart';
import 'package:meta/meta.dart';

part 'new_attendence_event.dart';
part 'new_attendence_state.dart';

class NewAttendenceBloc extends Bloc<NewAttendenceEvent, NewAttendenceState> {
  final Multiactionrepo repository;
  NewAttendenceBloc({required this.repository})
    : super(NewAttendenceInitial()) {
    on<NewAttendenceEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<NewAttendenceMarkingEvent>(newAttendence);
  }

  FutureOr<void> newAttendence(
    NewAttendenceMarkingEvent event,
    Emitter<NewAttendenceState> emit,
  ) async {
    emit(NewAttendenceLoadingState());
    try {
      final response = await repository.newattendence(
        attendence: event.attendence,
      );
      if (!response.error && response.status == 200) {
        emit(NewAttendenceSuccessState(message: response.message));
      } else {
        emit(NewAttendenceErrorState(message: response.message));
      }
    } catch (e) {
       emit(NewAttendenceErrorState(message:e.toString()));
    }
  }
}
