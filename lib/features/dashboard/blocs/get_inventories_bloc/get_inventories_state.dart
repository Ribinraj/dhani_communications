part of 'get_inventories_bloc.dart';

@immutable
sealed class GetInventoriesState {}

final class GetInventoriesInitial extends GetInventoriesState {}

final class GetInventoriesLoadingState extends GetInventoriesState {}

final class GetInventoriesSuccessState extends GetInventoriesState {
  final List<InventoryItem> inventoryitems;

  GetInventoriesSuccessState({required this.inventoryitems});
}

final class GetInventoiesErrorState extends GetInventoriesState {
  final String error;

  GetInventoiesErrorState({required this.error});
}
