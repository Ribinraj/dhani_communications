part of 'asset_transfer_bloc.dart';

@immutable
sealed class AssetTransferState {}

final class AssetTransferInitial extends AssetTransferState {}

final class AssetTransferLoadingState extends AssetTransferState {}

final class AssetTransferSuccessState extends AssetTransferState {
  final String message;

  AssetTransferSuccessState({required this.message});
}

final class AssetTransferErrorState extends AssetTransferState {
  final String message;

  AssetTransferErrorState({required this.message});
}
