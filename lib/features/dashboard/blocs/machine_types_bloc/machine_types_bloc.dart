import 'dart:async';

import 'package:dhani_communications/features/dashboard/models/machine_type_model.dart';
import 'package:dhani_communications/features/dashboard/repo/apprepo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'machine_types_event.dart';
part 'machine_types_state.dart';

class MachineTypesBloc extends Bloc<MachineTypesEvent, MachineTypesState> {
  final Apprepo repository;

  MachineTypesBloc({required this.repository}) : super(MachineTypesInitial()) {
    on<FetchMachineTypesEvent>(_onFetchMachineTypes);
  }

  FutureOr<void> _onFetchMachineTypes(
    FetchMachineTypesEvent event,
    Emitter<MachineTypesState> emit,
  ) async {
    emit(MachineTypesLoadingState());
    try {
      final response = await repository.getMachineTypes();
      if (!response.error && response.status == 200 && response.data != null) {
        emit(MachineTypesSuccessState(machineTypes: response.data!));
      } else {
        emit(MachineTypesErrorState(message: response.message));
      }
    } catch (e) {
      emit(MachineTypesErrorState(message: e.toString()));
    }
  }
}
