part of 'inventory_transfer_bloc.dart';

@immutable
sealed class InventoryTransferState {}

final class InventoryTransferInitial extends InventoryTransferState {}

final class InventoryTransferLoadingState extends InventoryTransferState {}

final class InventoryTransferSuccessState extends InventoryTransferState {
  final String message;

  InventoryTransferSuccessState({required this.message});
}

final class InventoryTransferErrorState extends InventoryTransferState {
  final String message;

  InventoryTransferErrorState({required this.message});
}
