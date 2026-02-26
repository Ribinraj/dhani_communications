part of 'employees_bloc.dart';

@immutable
sealed class EmployeesState {}

final class EmployeesInitial extends EmployeesState {}

final class EmployeesLoadingState extends EmployeesState {}

final class EmployeesSuccessState extends EmployeesState {
  final List<EmployeeModel> employees;

  EmployeesSuccessState({required this.employees});
}

final class EmployeesErrorState extends EmployeesState {
  final String error;

  EmployeesErrorState({required this.error});
}
