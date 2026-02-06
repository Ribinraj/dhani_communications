import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/auth/repo/authrepo.dart';
import 'package:meta/meta.dart';

part 'verify_otp_event.dart';
part 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final Authrepo repository;

  VerifyOtpBloc({required this.repository}) : super(VerifyOtpInitial()) {
    on<VerifyOtpButtonClickEvent>(_onVerifyOtp);
    on<ResendOtpButtonClickEvent>(_onResendOtp);
  }

  FutureOr<void> _onVerifyOtp(
    VerifyOtpButtonClickEvent event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(VerifyOtpLoadingState());
    try {
      final response = await repository.verifyOtp(
        userId: event.userId,
        verifyOtp: event.otp,
      );
      if (!response.error && response.status == 200) {
        emit(VerifyOtpSuccessState(message: response.message));
      } else {
        emit(VerifyOtpErrorState(message: response.message));
      }
    } catch (e) {
      emit(VerifyOtpErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _onResendOtp(
    ResendOtpButtonClickEvent event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(ResendOtpLoadingState());
    try {
      final response = await repository.resendOtp(userId: event.userId);
      if (!response.error && response.status == 200) {
        emit(ResendOtpSuccessState(message: response.message));
      } else {
        emit(ResendOtpErrorState(message: response.message));
      }
    } catch (e) {
      emit(ResendOtpErrorState(message: e.toString()));
    }
  }
}
