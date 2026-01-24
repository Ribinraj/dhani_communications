import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dhani_communications/data/models/project_model.dart';
import 'package:dhani_communications/domain/repositories/apprepo.dart';
import 'package:meta/meta.dart';

part 'projects_event.dart';
part 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final Apprepo repository;

  ProjectsBloc({required this.repository}) : super(ProjectsInitial()) {
    on<FetchProjectsEvent>(_onFetchProjects);
  }

  FutureOr<void> _onFetchProjects(
    FetchProjectsEvent event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(ProjectsLoadingState());
    try {
      final response = await repository.getProjects();
      if (!response.error && response.status == 200 && response.data != null) {
        emit(ProjectsSuccessState(projects: response.data!));
      } else {
        emit(ProjectsErrorState(message: response.message));
      }
    } catch (e) {
      emit(ProjectsErrorState(message: e.toString()));
    }
  }
}
