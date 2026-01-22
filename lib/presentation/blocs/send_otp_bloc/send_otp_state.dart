part of 'send_otp_bloc.dart';

@immutable
sealed class SendOtpState {}

final class SendOtpInitial extends SendOtpState {}
final class SendOtpLoadingState extends SendOtpState {}

final class SendOtpSuccessState extends SendOtpState {
  final String executiveId;


  SendOtpSuccessState({required this.executiveId});



}

final class SendOtpErrorState extends SendOtpState {
  final String message;

  SendOtpErrorState({required this.message});
}