part of 'projects_bloc.dart';

@immutable
sealed class ProjectsEvent {}

/// Event to fetch projects list
class FetchProjectsEvent extends ProjectsEvent {}
