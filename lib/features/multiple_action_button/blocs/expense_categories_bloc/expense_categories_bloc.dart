import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/data/models/expense_category_model.dart';
import 'package:dhani_communications/domain/repositories/apprepo.dart';
import 'package:meta/meta.dart';

part 'expense_categories_event.dart';
part 'expense_categories_state.dart';

class ExpenseCategoriesBloc
    extends Bloc<ExpenseCategoriesEvent, ExpenseCategoriesState> {
  final Apprepo repository;

  ExpenseCategoriesBloc({required this.repository})
    : super(ExpenseCategoriesInitial()) {
    on<FetchExpenseCategoriesEvent>(_onFetchExpenseCategories);
  }

  FutureOr<void> _onFetchExpenseCategories(
    FetchExpenseCategoriesEvent event,
    Emitter<ExpenseCategoriesState> emit,
  ) async {
    emit(ExpenseCategoriesLoadingState());
    try {
      final response = await repository.getExpenseCategories();
      if (!response.error && response.status == 200 && response.data != null) {
        emit(ExpenseCategoriesSuccessState(categories: response.data!));
      } else {
        emit(ExpenseCategoriesErrorState(message: response.message));
      }
    } catch (e) {
      emit(ExpenseCategoriesErrorState(message: e.toString()));
    }
  }
}
