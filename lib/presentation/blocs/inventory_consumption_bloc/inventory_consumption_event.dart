part of 'inventory_consumption_bloc.dart';

@immutable
sealed class InventoryConsumptionEvent {}

final class InventoryConsumptionButtonClikEvent
    extends InventoryConsumptionEvent {
  final InventoryConsumptionModel inventorydata;

  InventoryConsumptionButtonClikEvent({required this.inventorydata});
}
