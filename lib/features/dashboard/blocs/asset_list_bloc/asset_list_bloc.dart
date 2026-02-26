import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/dashboard/models/company_asset_model.dart';
import 'package:dhani_communications/features/dashboard/repo/apprepo.dart';
import 'package:meta/meta.dart';

part 'asset_list_event.dart';
part 'asset_list_state.dart';

class AssetListBloc extends Bloc<AssetListEvent, AssetListState> {
  final Apprepo repository;

  AssetListBloc({required this.repository}) : super(AssetListInitial()) {
    on<FetchAssetListEvent>(_onFetchAssetList);
  }

  FutureOr<void> _onFetchAssetList(
    FetchAssetListEvent event,
    Emitter<AssetListState> emit,
  ) async {
    emit(AssetListLoadingState());
    try {
      log('Fetching company assets list');

      final response = await repository.getCompanyAssets();

      if (!response.error && response.status == 200 && response.data != null) {
        List<CompanyAssetModel> filteredList = response.data!;

        // Apply client-side filtering if dates are provided
        if (event.startDate != null || event.endDate != null) {
          filteredList = _filterByDate(
            response.data!,
            event.startDate,
            event.endDate,
          );
          log('After client-side filtering: ${filteredList.length} items');
        }

        emit(AssetListSuccessState(assetsList: filteredList));
      } else {
        emit(AssetListErrorState(message: response.message));
      }
    } catch (e) {
      log('Error fetching asset list: $e');
      emit(AssetListErrorState(message: e.toString()));
    }
  }

  /// Filter asset list by date range (client-side filtering)
  List<CompanyAssetModel> _filterByDate(
    List<CompanyAssetModel> list,
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

    return list.where((asset) {
      final transactionDate = DateTime.tryParse(asset.transactionDate);

      if (transactionDate == null) return true; // Keep if date can't be parsed

      // Check if asset transaction date falls within the filter date range
      if (start != null && transactionDate.isBefore(start)) {
        return false;
      }
      if (end != null && transactionDate.isAfter(end)) {
        return false;
      }
      return true;
    }).toList();
  }
}
