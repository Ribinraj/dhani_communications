part of 'asset_list_bloc.dart';

@immutable
sealed class AssetListEvent {}

class FetchAssetListEvent extends AssetListEvent {
  final String? startDate;
  final String? endDate;

  FetchAssetListEvent({this.startDate, this.endDate});
}
