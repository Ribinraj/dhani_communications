import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/data/models/punch_in_list_model.dart';
import 'package:dhani_communications/domain/repositories/apprepo.dart';
import 'package:meta/meta.dart';

part 'punch_in_list_event.dart';
part 'punch_in_list_state.dart';

class PunchInListBloc extends Bloc<PunchInListEvent, PunchInListState> {
  final Apprepo repository;

  PunchInListBloc({required this.repository}) : super(PunchInListInitial()) {
    on<FetchPunchInListEvent>(_onFetchPunchInList);
  }

  FutureOr<void> _onFetchPunchInList(
    FetchPunchInListEvent event,
    Emitter<PunchInListState> emit,
  ) async {
    emit(PunchInListLoadingState());
    try {
      final response = await repository.getPunchInList();
      if (!response.error && response.status == 200 && response.data != null) {
        emit(PunchInListSuccessState(punchInList: response.data!));
      } else {
        emit(PunchInListErrorState(message: response.message));
      }
    } catch (e) {
      emit(PunchInListErrorState(message: e.toString()));
    }
  }
}
