part of 'inventory_consumption_bloc.dart';

@immutable
sealed class InventoryConsumptionState {}

final class InventoryConsumptionInitial extends InventoryConsumptionState {}

final class InventoryConsumptionLoadingState
    extends InventoryConsumptionState {}

final class InventoryConsumptionSuccessState extends InventoryConsumptionState {
  final String message;

  InventoryConsumptionSuccessState({required this.message});
}

final class InventoryCunsomptionErrorState extends InventoryConsumptionState {
  final String message;

  InventoryCunsomptionErrorState({required this.message});
}
