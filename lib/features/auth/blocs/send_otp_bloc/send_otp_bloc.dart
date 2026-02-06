import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/auth/repo/authrepo.dart';
import 'package:meta/meta.dart';

part 'send_otp_event.dart';
part 'send_otp_state.dart';

class SendOtpBloc extends Bloc<SendOtpEvent, SendOtpState> {
  final Authrepo repository;
  SendOtpBloc({required this.repository}) : super(SendOtpInitial()) {
    on<SendOtpEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<SendOtpButtonClickEvent>(sendotp);
  }

  FutureOr<void> sendotp(
      SendOtpButtonClickEvent event, Emitter<SendOtpState> emit) async {
    emit(SendOtpLoadingState());
    try {
      final response =
          await repository.sendOtp(mobileNumber: event.mobileNumber);
      if (!response.error && response.status == 200) {

     
        emit(SendOtpSuccessState(executiveId:response.data!));
      } else {
        emit(SendOtpErrorState(message: response.message));
      }
    } catch (e) {
      emit(SendOtpErrorState(message: e.toString()));
    }
  }
}
