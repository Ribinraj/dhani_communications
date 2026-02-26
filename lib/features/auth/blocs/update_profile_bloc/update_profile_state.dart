part of 'update_profile_bloc.dart';

@immutable
sealed class UpdateProfileState {}

final class UpdateProfileInitial extends UpdateProfileState {}

final class UpdateProfileLoadingState extends UpdateProfileState {}

final class UpdateProfileSuccessState extends UpdateProfileState {
  final String message;

  UpdateProfileSuccessState({required this.message});
}

final class UpdateProfileErrorState extends UpdateProfileState {
  final String message;

  UpdateProfileErrorState({required this.message});
}

final class UpdateProfilePhotoLoadingState extends UpdateProfileState {}

final class UpdateProfilePhotoSuccessState extends UpdateProfileState {
  final String message;

  UpdateProfilePhotoSuccessState({required this.message});
}

final class UpdateProfilePhotoErrorState extends UpdateProfileState {
  final String message;

  UpdateProfilePhotoErrorState({required this.message});
}
