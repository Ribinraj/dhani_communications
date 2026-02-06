import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/auth/repo/authrepo.dart';
import 'package:meta/meta.dart';

part 'update_profile_event.dart';
part 'update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  final Authrepo repository;

  UpdateProfileBloc({required this.repository}) : super(UpdateProfileInitial()) {
    on<SubmitUpdateProfileEvent>(_onSubmitUpdateProfile);
  }

  FutureOr<void> _onSubmitUpdateProfile(
    SubmitUpdateProfileEvent event,
    Emitter<UpdateProfileState> emit,
  ) async {
    emit(UpdateProfileLoadingState());
    try {
      final response = await repository.updateProfile(profileData: event.profileData);
      if (!response.error && response.status == 200) {
        emit(UpdateProfileSuccessState(message: response.message));
      } else {
        emit(UpdateProfileErrorState(message: response.message));
      }
    } catch (e) {
      emit(UpdateProfileErrorState(message: e.toString()));
    }
  }
}
