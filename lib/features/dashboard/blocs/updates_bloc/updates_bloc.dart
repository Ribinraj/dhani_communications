import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/dashboard/models/update_model.dart';
import 'package:dhani_communications/features/dashboard/repo/apprepo.dart';
import 'package:meta/meta.dart';

part 'updates_event.dart';
part 'updates_state.dart';

class UpdatesBloc extends Bloc<UpdatesEvent, UpdatesState> {
  final Apprepo repository;

  UpdatesBloc({required this.repository}) : super(UpdatesInitial()) {
    on<FetchUpdatesEvent>(_onFetchUpdates);
  }

  FutureOr<void> _onFetchUpdates(
    FetchUpdatesEvent event,
    Emitter<UpdatesState> emit,
  ) async {
    emit(UpdatesLoadingState());
    try {
      final response = await repository.getUpdates();
      if (!response.error && response.status == 200 && response.data != null) {
        emit(UpdatesSuccessState(updates: response.data!));
      } else {
        emit(UpdatesErrorState(message: response.message));
      }
    } catch (e) {
      emit(UpdatesErrorState(message: e.toString()));
    }
  }
}
