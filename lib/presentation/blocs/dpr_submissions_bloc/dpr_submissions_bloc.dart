import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/data/models/dpr_model.dart';
import 'package:dhani_communications/domain/repositories/apprepo.dart';
import 'package:meta/meta.dart';

part 'dpr_submissions_event.dart';
part 'dpr_submissions_state.dart';

class DprSubmissionsBloc extends Bloc<DprSubmissionsEvent, DprSubmissionsState> {
  final Apprepo repository;

  DprSubmissionsBloc({required this.repository}) : super(DprSubmissionsInitial()) {
    on<FetchDprSubmissionsEvent>(_onFetchDprSubmissions);
  }

  FutureOr<void> _onFetchDprSubmissions(
    FetchDprSubmissionsEvent event,
    Emitter<DprSubmissionsState> emit,
  ) async {
    emit(DprSubmissionsLoadingState());
    try {
      final response = await repository.getMyDprSubmissions(
        projectId: event.projectId,
        startDate: event.startDate,
        endDate: event.endDate,
      );
      if (!response.error && response.status == 200 && response.data != null) {
        emit(DprSubmissionsSuccessState(submissions: response.data!));
      } else {
        emit(DprSubmissionsErrorState(message: response.message));
      }
    } catch (e) {
      emit(DprSubmissionsErrorState(message: e.toString()));
    }
  }
}
