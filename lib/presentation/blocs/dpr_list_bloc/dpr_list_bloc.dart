import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/data/models/dpr_model.dart';
import 'package:dhani_communications/domain/repositories/apprepo.dart';
import 'package:meta/meta.dart';

part 'dpr_list_event.dart';
part 'dpr_list_state.dart';

class DprListBloc extends Bloc<DprListEvent, DprListState> {
  final Apprepo repository;

  DprListBloc({required this.repository}) : super(DprListInitial()) {
    on<FetchDprListEvent>(_onFetchDprList);
  }

  FutureOr<void> _onFetchDprList(
    FetchDprListEvent event,
    Emitter<DprListState> emit,
  ) async {
    emit(DprListLoadingState());
    try {
      final response = await repository.getDprList(projectId: event.projectId);
      if (!response.error && response.status == 200 && response.data != null) {
        emit(DprListSuccessState(dprList: response.data!));
      } else {
        emit(DprListErrorState(message: response.message));
      }
    } catch (e) {
      emit(DprListErrorState(message: e.toString()));
    }
  }
}
