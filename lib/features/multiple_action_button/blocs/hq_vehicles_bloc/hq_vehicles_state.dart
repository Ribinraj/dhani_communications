part of 'hq_vehicles_bloc.dart';

@immutable
sealed class HqVehiclesState {}

final class HqVehiclesInitial extends HqVehiclesState {}

final class HqVehiclesLoadingState extends HqVehiclesState {}

final class HqVehiclesSuccessState extends HqVehiclesState {
  final List<HqVehicleModel> vehicles;

  HqVehiclesSuccessState({required this.vehicles});
}

final class HqVehiclesErrorState extends HqVehiclesState {
  final String message;

  HqVehiclesErrorState({required this.message});
}
