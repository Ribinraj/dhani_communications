import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:dhani_communications/features/multiple_action_button/models/dpr_update_model.dart';
import 'package:dhani_communications/features/multiple_action_button/repo/multiactionrepo.dart';
import 'package:meta/meta.dart';

part 'update_dpr_event.dart';
part 'update_dpr_state.dart';

class UpdateDprBloc extends Bloc<UpdateDprEvent, UpdateDprState> {
  final Multiactionrepo repository;

  UpdateDprBloc({required this.repository}) : super(UpdateDprInitial()) {
    on<SubmitDprUpdateEvent>(_onSubmitDprUpdate);
  }

  FutureOr<void> _onSubmitDprUpdate(
    SubmitDprUpdateEvent event,
    Emitter<UpdateDprState> emit,
  ) async {
    emit(UpdateDprLoadingState());

    final response = await repository.updateDpr(dpr: event.dprupdatedata);

    if (!response.error && response.status == 200) {
      emit(
        UpdateDprSuccessState(dprId: response.data, message: response.message),
      );
    } else {
      emit(UpdateDprErrorState(message: response.message));
    }
  }
}
