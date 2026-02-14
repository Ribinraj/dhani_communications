import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/data/models/inventory_consumption_model.dart';
import 'package:dhani_communications/domain/repositories/apprepo.dart';
import 'package:meta/meta.dart';

part 'inventory_consumption_event.dart';
part 'inventory_consumption_state.dart';

class InventoryConsumptionBloc
    extends Bloc<InventoryConsumptionEvent, InventoryConsumptionState> {
  final Apprepo repository;
  InventoryConsumptionBloc({required this.repository})
    : super(InventoryConsumptionInitial()) {
    on<InventoryConsumptionButtonClikEvent>(inventoryCunsomptiom);
  }

  FutureOr<void> inventoryCunsomptiom(
    InventoryConsumptionButtonClikEvent event,
    Emitter<InventoryConsumptionState> emit,
  ) async {
    emit(InventoryConsumptionLoadingState());
    final response = await repository.inventoryconsumption(
      inventorydata: event.inventorydata,
    );
    if (!response.error && response.status == 200) {
      emit(InventoryConsumptionSuccessState(message: response.data!));
    } else {
      emit(InventoryCunsomptionErrorState(message: response.message));
    }
  }
}
