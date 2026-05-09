import 'dart:async';
import 'dart:developer';

import 'package:dhani_communications/features/dashboard/models/machine_hire_model.dart';
import 'package:dhani_communications/features/dashboard/repo/apprepo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'get_machines_event.dart';
part 'get_machines_state.dart';

class GetMachinesBloc extends Bloc<GetMachinesEvent, GetMachinesState> {
  final Apprepo repository;

  GetMachinesBloc({required this.repository}) : super(GetMachinesInitial()) {
    on<GetMachinesInitialFetchingEvent>(_onFetchMachines);
  }

  FutureOr<void> _onFetchMachines(
    GetMachinesInitialFetchingEvent event,
    Emitter<GetMachinesState> emit,
  ) async {
    emit(GetMachinesLoadingState());
    try {
      final response = await repository.machinehirelist();

      if (!response.error && response.status == 200 && response.data != null) {
        var machineList = response.data!;

        if (event.startDate != null || event.endDate != null) {
          machineList = _filterByDate(
            machineList,
            event.startDate,
            event.endDate,
          );
        }

        emit(GetMachinesSuccessState(machinelist: machineList));
      } else {
        emit(GetMachinesErrorState(message: response.message));
      }
    } catch (e) {
      log('Error fetching machine hire list: $e');
      emit(GetMachinesErrorState(message: e.toString()));
    }
  }

  List<MachineHireModel> _filterByDate(
    List<MachineHireModel> list,
    String? startDate,
    String? endDate,
  ) {
    final start = startDate == null ? null : DateTime.tryParse(startDate);
    var end = endDate == null ? null : DateTime.tryParse(endDate);

    if (end != null) {
      end = DateTime(end.year, end.month, end.day, 23, 59, 59);
    }

    return list.where((machine) {
      final hireDate = machine.hireDate;
      if (hireDate == null || hireDate.isEmpty) return true;

      final machineDate = DateTime.tryParse(hireDate);
      if (machineDate == null) return true;

      if (start != null && machineDate.isBefore(start)) return false;
      if (end != null && machineDate.isAfter(end)) return false;
      return true;
    }).toList();
  }
}
