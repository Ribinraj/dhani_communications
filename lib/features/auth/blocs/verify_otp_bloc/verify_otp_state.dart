part of 'verify_otp_bloc.dart';

@immutable
sealed class VerifyOtpState {}

// Initial State
final class VerifyOtpInitial extends VerifyOtpState {}

// Verify OTP States
final class VerifyOtpLoadingState extends VerifyOtpState {}

final class VerifyOtpSuccessState extends VerifyOtpState {
  final String message;

  VerifyOtpSuccessState({required this.message});
}

final class VerifyOtpErrorState extends VerifyOtpState {
  final String message;

  VerifyOtpErrorState({required this.message});
}

// Resend OTP States
final class ResendOtpLoadingState extends VerifyOtpState {}

final class ResendOtpSuccessState extends VerifyOtpState {
  final String message;

  ResendOtpSuccessState({required this.message});
}

final class ResendOtpErrorState extends VerifyOtpState {
  final String message;

  ResendOtpErrorState({required this.message});
}
