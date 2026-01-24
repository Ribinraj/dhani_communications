import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/data/models/headquarter_vehicle_model.dart';
import 'package:dhani_communications/data/models/vehicle_model.dart';
import 'package:dhani_communications/domain/repositories/apprepo.dart';
import 'package:meta/meta.dart';

part 'vehicles_event.dart';
part 'vehicles_state.dart';

class VehiclesBloc extends Bloc<VehiclesEvent, VehiclesState> {
  final Apprepo repository;

  VehiclesBloc({required this.repository}) : super(VehiclesInitial()) {
    on<FetchVehiclesEvent>(_onFetchVehicles);
    on<FetchHeadquarterVehiclesEvent>(_onFetchHeadquarterVehicles);
    on<UpdateVehicleEvent>(_onUpdateVehicle);
  }

  FutureOr<void> _onFetchVehicles(
    FetchVehiclesEvent event,
    Emitter<VehiclesState> emit,
  ) async {
    emit(VehiclesLoadingState());
    try {
      final response = await repository.getVehicles();
      if (!response.error && response.status == 200 && response.data != null) {
        emit(VehiclesSuccessState(vehicles: response.data!));
      } else {
        emit(VehiclesErrorState(message: response.message));
      }
    } catch (e) {
      emit(VehiclesErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _onFetchHeadquarterVehicles(
    FetchHeadquarterVehiclesEvent event,
    Emitter<VehiclesState> emit,
  ) async {
    emit(HeadquarterVehiclesLoadingState());
    try {
      final response = await repository.getHeadquarterVehicles();
      if (!response.error && response.status == 200 && response.data != null) {
        emit(HeadquarterVehiclesSuccessState(vehicles: response.data!));
      } else {
        emit(HeadquarterVehiclesErrorState(message: response.message));
      }
    } catch (e) {
      emit(HeadquarterVehiclesErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _onUpdateVehicle(
    UpdateVehicleEvent event,
    Emitter<VehiclesState> emit,
  ) async {
    emit(UpdateVehicleLoadingState());
    try {
      final response = await repository.updateVehicle(
        vehicleId: event.vehicleId,
        meterReading: event.meterReading,
        vehicleNumber: event.vehicleNumber,
      );
      if (!response.error && response.status == 200) {
        emit(UpdateVehicleSuccessState(message: response.message));
      } else {
        emit(UpdateVehicleErrorState(message: response.message));
      }
    } catch (e) {
      emit(UpdateVehicleErrorState(message: e.toString()));
    }
  }
}
