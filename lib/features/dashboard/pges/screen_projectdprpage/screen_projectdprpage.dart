import 'dart:math';

import 'package:dhani_communications/core/appconstants.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/network_services.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:dhani_communications/features/dashboard/models/dpr_model.dart';
import 'package:dhani_communications/features/dashboard/models/project_model.dart';
import 'package:dhani_communications/features/dashboard/repo/apprepo.dart';
import 'package:dhani_communications/features/dashboard/blocs/dpr_list_bloc/dpr_list_bloc.dart';
import 'package:dhani_communications/features/dashboard/blocs/projects_bloc/projects_bloc.dart';
import 'package:dhani_communications/widgets/custom_nondatawidget.dart';
import 'package:dhani_communications/widgets/custom_project_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ScreenProjectDprPage extends StatefulWidget {
  const ScreenProjectDprPage({super.key});

  @override
  State<ScreenProjectDprPage> createState() => _ScreenProjectDprPageState();
}

class _ScreenProjectDprPageState extends State<ScreenProjectDprPage> {
  late ProjectsBloc _projectsBloc;
  late DprListBloc _dprListBloc;
  ProjectModel? _selectedProject;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final repository = Apprepo(DioClient.create(context));
    _projectsBloc = ProjectsBloc(repository: repository);
    _dprListBloc = DprListBloc(repository: repository);

    // Fetch projects on load
    _projectsBloc.add(FetchProjectsEvent());
  }

  @override
  void dispose() {
    _projectsBloc.close();
    _dprListBloc.close();
    super.dispose();
  }

  void _onProjectSelected(ProjectModel? project) {
    if (project == null) return;

    setState(() {
      _selectedProject = project;
    });
    // Fetch DPR list for selected project
    _dprListBloc.add(FetchDprListEvent(projectId: project.projectId));
  }

  Color _getPercentageColor(int percentage) {
    if (percentage >= 100) {
      return Colors.green;
    } else if (percentage >= 75) {
      return Colors.teal;
    } else if (percentage >= 50) {
      return Colors.orange;
    } else if (percentage >= 25) {
      return Colors.amber;
    } else {
      return Appcolors.kredcolor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.kwhitecolor,
      appBar: AppBar(
        backgroundColor: Appcolors.kwhitecolor,
        elevation: 2,
        shadowColor: Appcolors.kgreyColor.withAlpha(33),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Appcolors.kprimarycolor,
            size: ResponsiveUtils.sp(5),
          ),
        ),
        title: TextStyles.title(
          text: 'Project DPR',
          weight: FontWeight.bold,
          color: Appcolors.kblackcolor,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.push('/dprsubmissionspage');
            },
            tooltip: 'My DPR Submissions',
            icon: Icon(
              Icons.assignment_turned_in_rounded,
              color: Appcolors.kprimarycolor,
              size: ResponsiveUtils.sp(6),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Project Dropdown Section
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
            decoration: BoxDecoration(
              color: Appcolors.kwhitecolor,
              boxShadow: [
                BoxShadow(
                  color: Appcolors.kgreyColor.withAlpha(33),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: BlocBuilder<ProjectsBloc, ProjectsState>(
              bloc: _projectsBloc,
              builder: (context, state) {
                if (state is ProjectsLoadingState) {
                  return CustomProjectDropdown(
                    selectedProject: _selectedProject,
                    projects: const [],
                    onChanged: _onProjectSelected,
                    isLoading: true,
                  );
                }

                if (state is ProjectsErrorState) {
                  return CustomProjectDropdown(
                    selectedProject: _selectedProject,
                    projects: const [],
                    onChanged: _onProjectSelected,
                    errorMessage: state.message,
                    onRetry: () {
                      _projectsBloc.add(FetchProjectsEvent());
                    },
                  );
                }

                if (state is ProjectsSuccessState) {
                  return CustomProjectDropdown(
                    selectedProject: _selectedProject,
                    projects: state.projects,
                    onChanged: _onProjectSelected,
                    hintText: 'Select a project',
                    showIcon: true,
                    showLocation: true,
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),

          // DPR List Section
          Expanded(
            child: BlocBuilder<DprListBloc, DprListState>(
              bloc: _dprListBloc,
              builder: (context, state) {
                if (_selectedProject == null) {
                  return NoDataWidget(
                    title: "Select a project to view DPR",
                    assetIcon: Appconstants.dprreport,
                  );
                }

                if (state is DprListLoadingState) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Appcolors.kprimarycolor,
                    ),
                  );
                }

                if (state is DprListErrorState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: ResponsiveUtils.sp(15),
                          color: Appcolors.kredcolor.withAlpha(200),
                        ),
                        ResponsiveSizedBox.height20,
                        TextStyles.subheadline(
                          text: state.message,
                          color: Appcolors.kgreyColor,
                        ),
                        ResponsiveSizedBox.height20,
                        ElevatedButton(
                          onPressed: () {
                            if (_selectedProject != null) {
                              _dprListBloc.add(
                                FetchDprListEvent(
                                  projectId: _selectedProject!.projectId,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Appcolors.kprimarycolor,
                          ),
                          child: TextStyles.medium(
                            text: 'Retry',
                            color: Appcolors.kwhitecolor,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state is DprListSuccessState) {
                  final dprList = state.dprList;

                  if (dprList.isEmpty) {
                    return NoDataWidget(
                      title: 'No DPR records found',
                      assetIcon: Appconstants.dprreport,
                    );
                  }

                  return RefreshIndicator(
                    color: Appcolors.kprimarycolor,
                    onRefresh: () async {
                      if (_selectedProject != null) {
                        _dprListBloc.add(
                          FetchDprListEvent(
                            projectId: _selectedProject!.projectId,
                          ),
                        );
                      }
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                      itemCount: dprList.length,
                      itemBuilder: (context, index) {
                        final dpr = dprList[index];
                        return _buildDprCard(dpr);
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDprCard(DprModel dpr) {
    final percentage = dpr.percentageCompleted;
    final percentageColor = _getPercentageColor(percentage);

    return GestureDetector(
      onTap: () {
        context.push('/dprdetailspage', extra: dpr.dprId);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: ResponsiveUtils.hp(2)),
        decoration: BoxDecoration(
          color: Appcolors.kwhitecolor,
          borderRadius: BorderRadiusStyles.kradius15(),
          boxShadow: [
            BoxShadow(
              color: Appcolors.kgreyColor.withAlpha(50),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
          child: Row(
            children: [
              // Circular Progress Indicator
              SizedBox(
                width: ResponsiveUtils.wp(14),
                height: ResponsiveUtils.wp(14),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background circle
                    SizedBox(
                      width: ResponsiveUtils.wp(18),
                      height: ResponsiveUtils.wp(18),
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 3,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Appcolors.kgreyColor.withAlpha(66),
                        ),
                      ),
                    ),
                    // Progress circle
                    SizedBox(
                      width: ResponsiveUtils.wp(18),
                      height: ResponsiveUtils.wp(18),
                      child: CircularProgressIndicator(
                        value: min(percentage / 100, 1.0),
                        strokeWidth: 3,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          percentageColor,
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    // Percentage text
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextStyles.title(
                          text: '$percentage',
                          weight: FontWeight.bold,
                          color: percentageColor,
                        ),
                        TextStyles.caption(
                          text: '%',
                          weight: FontWeight.w600,
                          color: percentageColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ResponsiveSizedBox.width(4),
              // DPR Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SIC Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.wp(2.5),
                        vertical: ResponsiveUtils.hp(0.5),
                      ),
                      decoration: BoxDecoration(
                        color: Appcolors.kprimarycolor.withAlpha(33),
                        borderRadius: BorderRadiusStyles.kradius5(),
                      ),
                      child: TextStyles.caption(
                        text: 'SIC: ${dpr.sic}',
                        weight: FontWeight.w600,
                        color: Appcolors.kprimarycolor,
                      ),
                    ),
                    ResponsiveSizedBox.height10,
                    // Description - Title
                    TextStyles.body(
                      text: dpr.description,
                      weight: FontWeight.bold,
                      color: Appcolors.kblackcolor,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    ResponsiveSizedBox.height5,
                    // UOM and SCQ
                    Row(
                      children: [
                        _buildInfoChip(
                          icon: Icons.straighten,
                          label: 'UOM',
                          value: dpr.uom,
                        ),
                        ResponsiveSizedBox.width(3),
                        _buildInfoChip(
                          icon: Icons.inventory_2_outlined,
                          label: 'SCQ',
                          value: dpr.scq,
                        ),
                      ],
                    ),
                    ResponsiveSizedBox.height5,
                    // Completed
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: ResponsiveUtils.sp(4),
                          color: Colors.green,
                        ),
                        ResponsiveSizedBox.width(1.5),
                        TextStyles.caption(
                          text: 'Completed: ${_formatCompleted(dpr.completed)}',
                          weight: FontWeight.w600,
                          color: Appcolors.kblackcolor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Arrow icon to indicate navigation
              Icon(
                Icons.chevron_right_rounded,
                color: Appcolors.kgreyColor,
                size: ResponsiveUtils.sp(6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: ResponsiveUtils.sp(3.5), color: Appcolors.kgreyColor),
        ResponsiveSizedBox.width(1),
        TextStyles.caption(text: '$label: $value', color: Appcolors.kgreyColor),
      ],
    );
  }

  String _formatCompleted(String completed) {
    final value = double.tryParse(completed) ?? 0;
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }
}
