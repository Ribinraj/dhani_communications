part of 'get_inventories_bloc.dart';

@immutable
sealed class GetInventoriesEvent {}
final class GetInventeryInitialFetchingEvent extends GetInventoriesEvent{}