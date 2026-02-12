import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/models/hq_vehicle_model.dart';
import 'package:dhani_communications/features/multiple_action_button/repo/multiactionrepo.dart';
import 'package:meta/meta.dart';

part 'hq_vehicles_event.dart';
part 'hq_vehicles_state.dart';

class HqVehiclesBloc extends Bloc<HqVehiclesEvent, HqVehiclesState> {
  final Multiactionrepo repository;

  HqVehiclesBloc({required this.repository}) : super(HqVehiclesInitial()) {
    on<FetchHqVehiclesEvent>(_onFetchHqVehicles);
  }

  FutureOr<void> _onFetchHqVehicles(
    FetchHqVehiclesEvent event,
    Emitter<HqVehiclesState> emit,
  ) async {
    emit(HqVehiclesLoadingState());
    try {
      final response = await repository.getHqVehicles();
      if (!response.error && response.status == 200 && response.data != null) {
        emit(HqVehiclesSuccessState(vehicles: response.data!));
      } else {
        emit(HqVehiclesErrorState(message: response.message));
      }
    } catch (e) {
      emit(HqVehiclesErrorState(message: e.toString()));
    }
  }
}
