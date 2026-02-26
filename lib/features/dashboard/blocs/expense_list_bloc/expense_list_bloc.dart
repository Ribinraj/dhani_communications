import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/dashboard/models/expense_model.dart';
import 'package:dhani_communications/features/dashboard/repo/apprepo.dart';
import 'package:meta/meta.dart';

part 'expense_list_event.dart';
part 'expense_list_state.dart';

class ExpenseListBloc extends Bloc<ExpenseListEvent, ExpenseListState> {
  final Apprepo repository;

  ExpenseListBloc({required this.repository}) : super(ExpenseListInitial()) {
    on<FetchExpenseListEvent>(_onFetchExpenseList);
  }

  FutureOr<void> _onFetchExpenseList(
    FetchExpenseListEvent event,
    Emitter<ExpenseListState> emit,
  ) async {
    emit(ExpenseListLoadingState());
    try {
      log(
        'Fetching expense list with startDate: ${event.startDate}, endDate: ${event.endDate}',
      );

      final response = await repository.getExpensesList(
        startDate: event.startDate,
        endDate: event.endDate,
      );

      if (!response.error && response.status == 200 && response.data != null) {
        List<ExpenseModel> filteredList = response.data!;

        // Apply client-side filtering if dates are provided
        if (event.startDate != null || event.endDate != null) {
          filteredList = _filterByDate(
            response.data!,
            event.startDate,
            event.endDate,
          );
          log('After client-side filtering: ${filteredList.length} items');
        }

        emit(ExpenseListSuccessState(expensesList: filteredList));
      } else {
        emit(ExpenseListErrorState(message: response.message));
      }
    } catch (e) {
      log('Error fetching expense list: $e');
      emit(ExpenseListErrorState(message: e.toString()));
    }
  }

  /// Filter expense list by date range (client-side fallback)
  List<ExpenseModel> _filterByDate(
    List<ExpenseModel> list,
    String? startDate,
    String? endDate,
  ) {
    DateTime? start;
    DateTime? end;

    if (startDate != null) {
      start = DateTime.tryParse(startDate);
    }
    if (endDate != null) {
      end = DateTime.tryParse(endDate);
      // Set end date to end of day
      if (end != null) {
        end = DateTime(end.year, end.month, end.day, 23, 59, 59);
      }
    }

    return list.where((expense) {
      final expenseDate = DateTime.tryParse(expense.expenseDate);
      if (expenseDate == null) return true; // Keep if date can't be parsed

      if (start != null && expenseDate.isBefore(start)) {
        return false;
      }
      if (end != null && expenseDate.isAfter(end)) {
        return false;
      }
      return true;
    }).toList();
  }
}
