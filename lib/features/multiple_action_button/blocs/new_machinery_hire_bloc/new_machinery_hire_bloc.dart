import 'dart:async';

import 'package:dhani_communications/features/multiple_action_button/models/new_machinery_hire_request_model.dart';
import 'package:dhani_communications/features/multiple_action_button/repo/multiactionrepo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'new_machinery_hire_event.dart';
part 'new_machinery_hire_state.dart';

class NewMachineryHireBloc
    extends Bloc<NewMachineryHireEvent, NewMachineryHireState> {
  final Multiactionrepo repository;

  NewMachineryHireBloc({required this.repository})
    : super(NewMachineryHireInitial()) {
    on<SubmitNewMachineryHireEvent>(_onSubmitMachineryHire);
  }

  FutureOr<void> _onSubmitMachineryHire(
    SubmitNewMachineryHireEvent event,
    Emitter<NewMachineryHireState> emit,
  ) async {
    emit(NewMachineryHireLoadingState());
    try {
      final response = await repository.createNewMachineryHire(
        machineryHire: event.machineryHire,
      );
      if (!response.error && response.status == 200) {
        emit(NewMachineryHireSuccessState(message: response.message));
      } else {
        emit(NewMachineryHireErrorState(message: response.message));
      }
    } catch (e) {
      emit(NewMachineryHireErrorState(message: e.toString()));
    }
  }
}
