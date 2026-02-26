import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/dashboard/models/inventory_transfer_model.dart';
import 'package:dhani_communications/features/dashboard/repo/apprepo.dart';
import 'package:meta/meta.dart';

part 'inventory_transfer_event.dart';
part 'inventory_transfer_state.dart';

class InventoryTransferBloc
    extends Bloc<InventoryTransferEvent, InventoryTransferState> {
  final Apprepo repository;
  InventoryTransferBloc({required this.repository})
    : super(InventoryTransferInitial()) {
    on<InventoryTransferButtonClickEvent>(inventoryTransfer);
  }

  FutureOr<void> inventoryTransfer(
    InventoryTransferButtonClickEvent event,
    Emitter<InventoryTransferState> emit,
  ) async {
    emit(InventoryTransferLoadingState());
    final response = await repository.inventoryTransfer(
      transferData: event.transferData,
    );
    if (!response.error && response.status == 200) {
      emit(InventoryTransferSuccessState(message: response.message));
    } else {
      emit(InventoryTransferErrorState(message: response.message));
    }
  }
}
