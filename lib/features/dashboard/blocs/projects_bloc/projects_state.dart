part of 'projects_bloc.dart';

@immutable
sealed class ProjectsState {}

final class ProjectsInitial extends ProjectsState {}

final class ProjectsLoadingState extends ProjectsState {}

final class ProjectsSuccessState extends ProjectsState {
  final List<ProjectModel> projects;

  ProjectsSuccessState({required this.projects});
}

final class ProjectsErrorState extends ProjectsState {
  final String message;

  ProjectsErrorState({required this.message});
}
