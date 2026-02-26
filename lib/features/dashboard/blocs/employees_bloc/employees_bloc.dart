import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/dashboard/repo/apprepo.dart';
import 'package:dhani_communications/features/dashboard/models/employees_model.dart';

import 'package:meta/meta.dart';

part 'employees_event.dart';
part 'employees_state.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final Apprepo repository;
  EmployeesBloc({required this.repository}) : super(EmployeesInitial()) {
    on<EmployeesFetchingInitialEvent>(fetchemployees);
  }

  FutureOr<void> fetchemployees(
    EmployeesFetchingInitialEvent event,
    Emitter<EmployeesState> emit,
  ) async {
    emit(EmployeesLoadingState());
    final response = await repository.geemployees();
    if (!response.error && response.status == 200) {
      emit(EmployeesSuccessState(employees: response.data!));
    } else {
      emit(EmployeesErrorState(error: response.message));
    }
  }
}
