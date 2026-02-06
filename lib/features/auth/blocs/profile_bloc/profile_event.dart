part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

/// Event to fetch user profile
class FetchProfileEvent extends ProfileEvent {}
