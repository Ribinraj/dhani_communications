import 'package:bloc/bloc.dart';
import 'package:dhani_communications/features/approvals/models/approvels_dprmodel.dart';
import 'package:dhani_communications/features/approvals/repo/approvels_repo.dart';
import 'package:meta/meta.dart';

part 'fetch_approvel_dpr_event.dart';
part 'fetch_approvel_dpr_state.dart';

class FetchApprovelDprBloc
    extends Bloc<FetchApprovelDprEvent, FetchApprovelDprState> {
  final ApprovelsRepo repository;
  FetchApprovelDprBloc({required this.repository }) : super(FetchApprovelDprInitial()) {
    on<FetchApprovelDprEvent>((event, emit) async {
      emit(FetchApprovelDprLoading());
      final result = await repository.approveDpr();
      if (result.error) {
        emit(FetchApprovelDprError(message: result.message));
      } else {
        emit(FetchApprovelDprLoaded(approveDprList: result.data!));
      }
    });
  }
}
