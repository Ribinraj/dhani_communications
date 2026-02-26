import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/dashboard/models/asset_transfer_model.dart';
import 'package:dhani_communications/features/dashboard/repo/apprepo.dart';
import 'package:meta/meta.dart';

part 'asset_transfer_event.dart';
part 'asset_transfer_state.dart';

class AssetTransferBloc extends Bloc<AssetTransferEvent, AssetTransferState> {
  final Apprepo repository;
  AssetTransferBloc({required this.repository})
    : super(AssetTransferInitial()) {
    on<AssetTransferButtonClickEvent>(assetTransfer);
  }

  FutureOr<void> assetTransfer(
    AssetTransferButtonClickEvent event,
    Emitter<AssetTransferState> emit,
  ) async {
    emit(AssetTransferLoadingState());
    final response = await repository.assetTransfer(
      transferData: event.transferData,
    );
    if (!response.error && response.status == 200) {
      emit(AssetTransferSuccessState(message: response.message));
    } else {
      emit(AssetTransferErrorState(message: response.message));
    }
  }
}
