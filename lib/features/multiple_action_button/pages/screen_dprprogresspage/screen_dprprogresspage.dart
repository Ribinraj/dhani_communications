import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:dhani_communications/data/models/dpr_model.dart';
import 'package:dhani_communications/data/models/project_model.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/update_dpr_bloc/update_dpr_bloc.dart';
import 'package:dhani_communications/presentation/blocs/dpr_list_bloc/dpr_list_bloc.dart';
import 'package:dhani_communications/presentation/blocs/projects_bloc/projects_bloc.dart';

import 'package:dhani_communications/features/multiple_action_button/models/dpr_update_model.dart';
import 'package:dhani_communications/widgets/custom_dropdown.dart';
import 'package:dhani_communications/widgets/custom_dpr_card.dart';
import 'package:dhani_communications/widgets/custom_formtextfield.dart';
import 'package:dhani_communications/widgets/custom_project_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ScreenDprProgressPage extends StatefulWidget {
  const ScreenDprProgressPage({super.key});

  @override
  State<ScreenDprProgressPage> createState() => _ScreenDprProgressPageState();
}

class _ScreenDprProgressPageState extends State<ScreenDprProgressPage> {
  final _formKey = GlobalKey<FormState>();

  ProjectModel? selectedProject;
  DprModel? selectedDpr;
  DateTime? selectedDate;

  final TextEditingController progressDateController = TextEditingController();
  final TextEditingController progressQuantityController =
      TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectsBloc>().add(FetchProjectsEvent());
    });
  }

  @override
  void dispose() {
    progressDateController.dispose();
    progressQuantityController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  /// Called when a project is selected — fetches DPR list for that project
  void _onProjectSelected(ProjectModel? project) {
    if (project == null) return;
    setState(() {
      selectedProject = project;
      selectedDpr = null; // Reset DPR selection when project changes
    });
    // Fetch DPR list for the selected project
    context.read<DprListBloc>().add(
      FetchDprListEvent(projectId: project.projectId),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Appcolors.kprimarycolor,
              onPrimary: Appcolors.kwhitecolor,
              onSurface: Appcolors.kblackcolor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        progressDateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  /// Format date to API format (yyyy-MM-dd)
  String _formatDateForApi(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  void _submitDprProgress() {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate project selection
    if (selectedProject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a project'),
          backgroundColor: Appcolors.kredcolor,
        ),
      );
      return;
    }

    // Validate DPR selection
    if (selectedDpr == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a project DPR'),
          backgroundColor: Appcolors.kredcolor,
        ),
      );
      return;
    }

    // Validate date selection
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select progress date'),
          backgroundColor: Appcolors.kredcolor,
        ),
      );
      return;
    }

    // Parse and validate quantity
    final quantity = double.tryParse(progressQuantityController.text.trim());
    if (quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid progress quantity'),
          backgroundColor: Appcolors.kredcolor,
        ),
      );
      return;
    }

    // Create DPR update model
    final dprUpdateData = DprUpdateModel(
      projectId: selectedProject!.projectId,
      dprId: selectedDpr!.dprId,
      progressDate: _formatDateForApi(selectedDate!),
      progressQuantity: quantity,
      userRemarks: remarksController.text.trim(),
    );

    // Dispatch submit event
    context.read<UpdateDprBloc>().add(
      SubmitDprUpdateEvent(dprupdatedata: dprUpdateData),
    );
  }

  /// Clear form after successful submission
  void _clearForm() {
    setState(() {
      selectedProject = null;
      selectedDpr = null;
      selectedDate = null;
    });
    progressDateController.clear();
    progressQuantityController.clear();
    remarksController.clear();
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    final bool isProjectSelected = selectedProject != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.kwhitecolor,
        elevation: 2,
        shadowColor: Appcolors.kgreyColor.withOpacity(0.1),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Appcolors.kprimarycolor,
            size: ResponsiveUtils.sp(5),
          ),
        ),
        title: TextStyles.subheadline(
          text: 'DPR Progress Submission',
          weight: FontWeight.bold,
          color: Appcolors.kblackcolor,
        ),
        centerTitle: true,
      ),
      body: BlocListener<UpdateDprBloc, UpdateDprState>(
        listener: (context, state) {
          if (state is UpdateDprSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Appcolors.ksecondarycolor,
              ),
            );
            // Clear form after successful submission
            _clearForm();
                  Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              context.pop();
            }
          });
          } else if (state is UpdateDprErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Appcolors.kredcolor,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveSizedBox.height20,

                  /// Header
                  TextStyles.body(
                    text:
                        'Please fill the form and submit your DPR progress for approval',
                    color: Appcolors.kblackcolor,
                    weight: FontWeight.w500,
                  ),

                  ResponsiveSizedBox.height30,

                  /// Project
                  TextStyles.caption(text: 'Project', weight: FontWeight.w600),
                  ResponsiveSizedBox.height10,
                  BlocBuilder<ProjectsBloc, ProjectsState>(
                    builder: (context, state) {
                      if (state is ProjectsLoadingState) {
                        return CustomProjectDropdown(
                          selectedProject: selectedProject,
                          projects: const [],
                          onChanged: _onProjectSelected,
                          isLoading: true,
                        );
                      }

                      if (state is ProjectsErrorState) {
                        return CustomProjectDropdown(
                          selectedProject: selectedProject,
                          projects: const [],
                          onChanged: _onProjectSelected,
                          errorMessage: state.message,
                          onRetry: () {
                            context.read<ProjectsBloc>().add(
                              FetchProjectsEvent(),
                            );
                          },
                        );
                      }

                      if (state is ProjectsSuccessState) {
                        // Auto-select if only 1 project
                        if (state.projects.length == 1 &&
                            selectedProject == null) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _onProjectSelected(state.projects.first);
                          });
                        }
                        return CustomProjectDropdown(
                          selectedProject: selectedProject,
                          projects: state.projects,
                          onChanged: _onProjectSelected,
                          hintText: 'Select Project',
                          showIcon: true,
                          showLocation: true,
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),

                  ResponsiveSizedBox.height20,

                  /// Project DPR
                  TextStyles.caption(
                    text: 'Project DPR',
                    weight: FontWeight.w600,
                  ),
                  ResponsiveSizedBox.height10,

                  // DPR dropdown — inactive (grey) until a project is selected
                  BlocBuilder<DprListBloc, DprListState>(
                    builder: (context, state) {
                      // No project selected — show disabled/inactive dropdown
                      if (!isProjectSelected) {
                        return _buildInactiveDprDropdown(
                          hint: 'Select a project first',
                        );
                      }

                      // Loading state
                      if (state is DprListLoadingState) {
                        return Container(
                          padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                          decoration: BoxDecoration(
                            color: Appcolors.kgreyColor.withOpacity(0.05),
                            border: Border.all(
                              color: Appcolors.kgreyColor.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(
                              ResponsiveUtils.borderRadius(2.5),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: ResponsiveUtils.wp(5),
                                height: ResponsiveUtils.wp(5),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Appcolors.kprimarycolor,
                                ),
                              ),
                              ResponsiveSizedBox.width(3),
                              TextStyles.medium(
                                text: 'Loading DPR list...',
                                color: Appcolors.kgreyColor,
                              ),
                            ],
                          ),
                        );
                      }

                      // Error state
                      if (state is DprListErrorState) {
                        return Container(
                          padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.red.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(
                              ResponsiveUtils.borderRadius(2.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: ResponsiveUtils.sp(5),
                              ),
                              ResponsiveSizedBox.width(2),
                              Expanded(
                                child: TextStyles.medium(
                                  text: state.message,
                                  color: Colors.red,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (selectedProject != null) {
                                    context.read<DprListBloc>().add(
                                      FetchDprListEvent(
                                        projectId: selectedProject!.projectId,
                                      ),
                                    );
                                  }
                                },
                                child: TextStyles.medium(
                                  text: 'Retry',
                                  color: Appcolors.kprimarycolor,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Success state — show DPR dropdown
                      if (state is DprListSuccessState) {
                        final dprList = state.dprList;

                        if (dprList.isEmpty) {
                          return _buildInactiveDprDropdown(
                            hint: 'No DPR records found for this project',
                          );
                        }

                        return CustomDropdown(
                          value: selectedDpr?.description,
                          hint: 'Select Project DPR',
                          items: dprList
                              .map((e) => e.description)
                              .where((e) => e.isNotEmpty)
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedDpr = dprList.firstWhere(
                                (e) => e.description == value,
                              );
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select project DPR';
                            }
                            return null;
                          },
                        );
                      }

                      return _buildInactiveDprDropdown(
                        hint: 'Select a project first',
                      );
                    },
                  ),

                  // Show DPR Card when a DPR is selected
                  if (selectedDpr != null) ...[
                    ResponsiveSizedBox.height15,
                    CustomDprCard(dpr: selectedDpr!, showArrow: false),
                  ],

                  ResponsiveSizedBox.height20,

                  /// Progress Date
                  TextStyles.caption(
                    text: 'Progress Date',
                    weight: FontWeight.w600,
                  ),
                  ResponsiveSizedBox.height10,
                  CustomFormtextfield(
                    controller: progressDateController,
                    hintText: 'Select Progress Date',
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      color: Appcolors.kprimarycolor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select progress date';
                      }
                      return null;
                    },
                  ),

                  ResponsiveSizedBox.height20,

                  /// Progress Quantity
                  TextStyles.caption(
                    text: 'Progress Quantity',
                    weight: FontWeight.w600,
                  ),
                  ResponsiveSizedBox.height10,
                  CustomFormtextfield(
                    controller: progressQuantityController,
                    hintText: 'Enter Progress Quantity',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter progress quantity';
                      }
                      final quantity = double.tryParse(value);
                      if (quantity == null) {
                        return 'Enter valid quantity';
                      }
                      if (quantity <= 0) {
                        return 'Quantity must be greater than 0';
                      }
                      return null;
                    },
                  ),

                  ResponsiveSizedBox.height20,

                  /// Remarks
                  TextStyles.caption(
                    text: 'Remarks (Optional)',
                    weight: FontWeight.w600,
                  ),
                  ResponsiveSizedBox.height10,
                  CustomFormtextfield(
                    controller: remarksController,
                    hintText: 'Enter remarks',
                    maxLines: 4,
                  ),

                  ResponsiveSizedBox.height40,

                  /// Submit Button
                  BlocBuilder<UpdateDprBloc, UpdateDprState>(
                    builder: (context, state) {
                      final isLoading = state is UpdateDprLoadingState;

                      return SizedBox(
                        width: double.infinity,
                        height: ResponsiveUtils.hp(6),
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submitDprProgress,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Appcolors.kprimarycolor,
                            disabledBackgroundColor:
                                Appcolors.kgreyColor.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveUtils.borderRadius(2.5),
                              ),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                                  width: ResponsiveUtils.wp(5),
                                  height: ResponsiveUtils.wp(5),
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Appcolors.kwhitecolor,
                                  ),
                                )
                              : TextStyles.body(
                                  text: 'Submit DPR Progress',
                                  color: Appcolors.kwhitecolor,
                                  weight: FontWeight.w600,
                                ),
                        ),
                      );
                    },
                  ),

                  ResponsiveSizedBox.height30,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a greyed-out inactive dropdown to indicate the DPR dropdown is disabled
  Widget _buildInactiveDprDropdown({required String hint}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.wp(4),
        vertical: ResponsiveUtils.hp(1.8),
      ),
      decoration: BoxDecoration(
        color: Appcolors.kgreyColor.withOpacity(0.08),
        border: Border.all(color: Appcolors.kgreyColor.withOpacity(0.25)),
        borderRadius: BorderRadius.circular(ResponsiveUtils.borderRadius(2.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextStyles.medium(
              text: hint,
              color: Appcolors.kgreyColor.withOpacity(0.6),
            ),
          ),
          Icon(
            Icons.arrow_drop_down,
            color: Appcolors.kgreyColor.withOpacity(0.4),
          ),
        ],
      ),
    );
  }
}