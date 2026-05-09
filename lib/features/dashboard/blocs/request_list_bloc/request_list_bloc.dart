import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/dashboard/models/request_model.dart';
import 'package:dhani_communications/features/dashboard/repo/apprepo.dart';
import 'package:meta/meta.dart';

part 'request_list_event.dart';
part 'request_list_state.dart';

class RequestListBloc extends Bloc<RequestListEvent, RequestListState> {
  final Apprepo repository;

  RequestListBloc({required this.repository}) : super(RequestListInitial()) {
    on<FetchRequestListEvent>(_onFetchRequestList);
  }

  FutureOr<void> _onFetchRequestList(
    FetchRequestListEvent event,
    Emitter<RequestListState> emit,
  ) async {
    emit(RequestListLoadingState());
    try {
      log('Fetching request list...');
      final response = await repository.getRequestList();

      if (!response.error && response.status == 200 && response.data != null) {
        emit(RequestListSuccessState(requestList: response.data!));
      } else {
        emit(RequestListErrorState(message: response.message));
      }
    } catch (e) {
      log('Error fetching request list: $e');
      emit(RequestListErrorState(message: e.toString()));
    }
  }
}
