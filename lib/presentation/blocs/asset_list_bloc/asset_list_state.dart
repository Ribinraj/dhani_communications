part of 'asset_list_bloc.dart';

@immutable
sealed class AssetListState {}

final class AssetListInitial extends AssetListState {}

final class AssetListLoadingState extends AssetListState {}

final class AssetListSuccessState extends AssetListState {
  final List<CompanyAssetModel> assetsList;

  AssetListSuccessState({required this.assetsList});
}

final class AssetListErrorState extends AssetListState {
  final String message;

  AssetListErrorState({required this.message});
}
