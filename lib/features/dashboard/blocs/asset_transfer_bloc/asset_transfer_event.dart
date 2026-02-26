part of 'asset_transfer_bloc.dart';

@immutable
sealed class AssetTransferEvent {}

final class AssetTransferButtonClickEvent extends AssetTransferEvent {
  final AssetTransferModel transferData;

  AssetTransferButtonClickEvent({required this.transferData});
}
