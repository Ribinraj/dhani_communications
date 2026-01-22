part of 'verify_otp_bloc.dart';

@immutable
sealed class VerifyOtpEvent {}

final class VerifyOtpButtonClickEvent extends VerifyOtpEvent {
  final String userId;
  final String otp;

  VerifyOtpButtonClickEvent({required this.userId, required this.otp});
}

final class ResendOtpButtonClickEvent extends VerifyOtpEvent {
  final String userId;

  ResendOtpButtonClickEvent({required this.userId});
}
