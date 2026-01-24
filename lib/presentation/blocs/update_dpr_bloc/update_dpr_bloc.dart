import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/domain/repositories/apprepo.dart';
import 'package:meta/meta.dart';

part 'update_dpr_event.dart';
part 'update_dpr_state.dart';

class UpdateDprBloc extends Bloc<UpdateDprEvent, UpdateDprState> {
  final Apprepo repository;

  UpdateDprBloc({required this.repository}) : super(UpdateDprInitial()) {
    on<SubmitDprUpdateEvent>(_onSubmitDprUpdate);
  }

  FutureOr<void> _onSubmitDprUpdate(
    SubmitDprUpdateEvent event,
    Emitter<UpdateDprState> emit,
  ) async {
    emit(UpdateDprLoadingState());
    try {
      final response = await repository.updateDpr(
        dprId: event.dprId,
        projectId: event.projectId,
        dprDate: event.dprDate,
        progress: event.progress,
        userRemarks: event.userRemarks,
      );
      if (!response.error && response.status == 200) {
        emit(UpdateDprSuccessState(
          dprId: response.data,
          message: response.message,
        ));
      } else {
        emit(UpdateDprErrorState(message: response.message));
      }
    } catch (e) {
      emit(UpdateDprErrorState(message: e.toString()));
    }
  }
}
