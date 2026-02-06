part of 'update_profile_bloc.dart';

@immutable
sealed class UpdateProfileEvent {}

/// Event to submit profile update
class SubmitUpdateProfileEvent extends UpdateProfileEvent {
  final Map<String, dynamic> profileData;

  SubmitUpdateProfileEvent({required this.profileData});
}
