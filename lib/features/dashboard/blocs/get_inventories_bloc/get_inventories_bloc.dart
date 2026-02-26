import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/dashboard/models/inventory_item_model.dart';
import 'package:dhani_communications/features/dashboard/repo/apprepo.dart';
import 'package:meta/meta.dart';

part 'get_inventories_event.dart';
part 'get_inventories_state.dart';

class GetInventoriesBloc
    extends Bloc<GetInventoriesEvent, GetInventoriesState> {
  final Apprepo repository;
  GetInventoriesBloc({required this.repository})
    : super(GetInventoriesInitial()) {
    on<GetInventoriesEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetInventeryInitialFetchingEvent>(getinventories);
  }

  FutureOr<void> getinventories(
    GetInventeryInitialFetchingEvent event,
    Emitter<GetInventoriesState> emit,
  ) async {
    emit(GetInventoriesLoadingState());
    try {
      final response = await repository.getInventories();
      if (!response.error && response.status == 200 && response.data != null) {
        emit(GetInventoriesSuccessState(inventoryitems:response.data!));
      } else {
        emit(GetInventoiesErrorState(error: response.message));
      }
    } catch (e) {
      emit(GetInventoiesErrorState(error: e.toString()));
    }
  }
}
