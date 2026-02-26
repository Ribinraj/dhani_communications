import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/core/local_storages.dart';
import 'package:dhani_communications/features/auth/models/profile_model.dart';
import 'package:dhani_communications/features/auth/repo/authrepo.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final Authrepo repository;

  ProfileBloc({required this.repository}) : super(ProfileInitial()) {
    on<FetchProfileEvent>(_onFetchProfile);
  }

  FutureOr<void> _onFetchProfile(
    FetchProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoadingState());
    try {
      final response = await repository.getProfile();
      if (!response.error && response.status == 200 && response.data != null) {
        await LocalStorage.saveUserName(response.data!.employeeName);
        emit(ProfileSuccessState(profile: response.data!));
      } else {
        emit(ProfileErrorState(message: response.message));
      }
    } catch (e) {
      emit(ProfileErrorState(message: e.toString()));
    }
  }
}
