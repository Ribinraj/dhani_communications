import 'dart:async';

import 'package:dhani_communications/features/multiple_action_button/models/new_request_model.dart';
import 'package:dhani_communications/features/multiple_action_button/repo/multiactionrepo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'new_request_event.dart';
part 'new_request_state.dart';

class NewRequestBloc extends Bloc<NewRequestEvent, NewRequestState> {
  final Multiactionrepo repository;

  NewRequestBloc({required this.repository}) : super(NewRequestInitial()) {
    on<SubmitNewRequestEvent>(_submitNewRequest);
  }

  FutureOr<void> _submitNewRequest(
    SubmitNewRequestEvent event,
    Emitter<NewRequestState> emit,
  ) async {
    emit(NewRequestLoadingState());
    try {
      final response = await repository.createNewRequest(
        request: event.request,
      );
      if (!response.error && response.status == 200) {
        emit(NewRequestSuccessState(message: response.message));
      } else {
        emit(NewRequestErrorState(message: response.message));
      }
    } catch (e) {
      emit(NewRequestErrorState(message: e.toString()));
    }
  }
}
