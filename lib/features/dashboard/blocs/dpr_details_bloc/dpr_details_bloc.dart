import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/dashboard/models/dpr_model.dart';
import 'package:dhani_communications/features/dashboard/repo/apprepo.dart';
import 'package:meta/meta.dart';

part 'dpr_details_event.dart';
part 'dpr_details_state.dart';

class DprDetailsBloc extends Bloc<DprDetailsEvent, DprDetailsState> {
  final Apprepo repository;

  DprDetailsBloc({required this.repository}) : super(DprDetailsInitial()) {
    on<FetchDprDetailsEvent>(_onFetchDprDetails);
  }

  FutureOr<void> _onFetchDprDetails(
    FetchDprDetailsEvent event,
    Emitter<DprDetailsState> emit,
  ) async {
    emit(DprDetailsLoadingState());
    try {
      final response = await repository.getDprDetails(dprId: event.dprId);
      if (!response.error && response.status == 200 && response.data != null) {
        emit(DprDetailsSuccessState(dprDetails: response.data!));
      } else {
        emit(DprDetailsErrorState(message: response.message));
      }
    } catch (e) {
      emit(DprDetailsErrorState(message: e.toString()));
    }
  }
}
