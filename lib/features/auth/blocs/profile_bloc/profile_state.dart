part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoadingState extends ProfileState {}

final class ProfileSuccessState extends ProfileState {
  final ProfileData profile;

  ProfileSuccessState({required this.profile});
}

final class ProfileErrorState extends ProfileState {
  final String message;

  ProfileErrorState({required this.message});
}
