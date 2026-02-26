part of 'inventory_transfer_bloc.dart';

@immutable
sealed class InventoryTransferEvent {}

final class InventoryTransferButtonClickEvent extends InventoryTransferEvent {
  final InventoryTransferModel transferData;

  InventoryTransferButtonClickEvent({required this.transferData});
}
