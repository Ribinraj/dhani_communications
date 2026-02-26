import 'dart:convert';
import 'dart:io';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:dhani_communications/features/dashboard/models/project_model.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/leave_categories_bloc/leave_categories_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/new_leave_bloc/new_leave_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/models/leave_categories_model.dart';
import 'package:dhani_communications/features/multiple_action_button/models/new_leave_request_model.dart';
import 'package:dhani_communications/features/dashboard/blocs/projects_bloc/projects_bloc.dart';
import 'package:dhani_communications/widgets/custom_dropdown.dart';
import 'package:dhani_communications/widgets/custom_formtextfield.dart';
import 'package:dhani_communications/widgets/custom_gallery_picker.dart';
import 'package:dhani_communications/widgets/custom_project_dropdown.dart';
import 'package:dhani_communications/widgets/custom_snackbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ScreenLeaveApplicationPage extends StatefulWidget {
  const ScreenLeaveApplicationPage({super.key});

  @override
  State<ScreenLeaveApplicationPage> createState() =>
      _ScreenLeaveApplicationPageState();
}

class _ScreenLeaveApplicationPageState
    extends State<ScreenLeaveApplicationPage> {
  final _formKey = GlobalKey<FormState>();

  ProjectModel? selectedProject;
  LeaveCategory? selectedLeaveType;
  DateTime? fromDate;
  DateTime? toDate;

  double? leavesLatt;
  double? leavesLong;

  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  List<PlatformFile> attachedFiles = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectsBloc>().add(FetchProjectsEvent());
      context.read<LeaveCategoriesBloc>().add(
        LeaveCategoriesFetchingInitialEvent(),
      );
      _fetchLocation();
    });
  }

  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  /// Fetch current device location
  Future<void> _fetchLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          CustomSnackbar.show(
            context: context,
            message: 'Location services are disabled. Please enable them.',
            type: SnackBarType.error,
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            CustomSnackbar.show(
              context: context,
              message: 'Location permission denied.',
              type: SnackBarType.error,
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          CustomSnackbar.show(
            context: context,
            message:
                'Location permissions are permanently denied. Please enable them in settings.',
            type: SnackBarType.error,
          );
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      setState(() {
        leavesLatt = position.latitude;
        leavesLong = position.longitude;
      });
    } catch (e) {
      debugPrint('Error fetching location: $e');
    }
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fromDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
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

    if (picked != null && picked != fromDate) {
      setState(() {
        fromDate = picked;
        fromDateController.text = DateFormat('yyyy-MM-dd').format(picked);

        // Reset to date if it's before from date
        if (toDate != null && toDate!.isBefore(picked)) {
          toDate = null;
          toDateController.clear();
        }
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    if (fromDate == null) {
      CustomSnackbar.show(
        context: context,
        message: 'Please select From Date first',
        type: SnackBarType.error,
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: toDate ?? fromDate!,
      firstDate: fromDate!,
      lastDate: DateTime(2030),
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

    if (picked != null && picked != toDate) {
      setState(() {
        toDate = picked;
        toDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  /// Convert attached files to base64 LeaveAttachment list
  Future<List<LeaveAttachment>> _convertAttachmentsToBase64() async {
    List<LeaveAttachment> attachments = [];
    for (var file in attachedFiles) {
      try {
        if (file.path != null) {
          final bytes = await File(file.path!).readAsBytes();
          final base64String = base64Encode(bytes);
          attachments.add(
            LeaveAttachment(fileName: file.name, file: base64String),
          );
        }
      } catch (e) {
        debugPrint('Error converting file to base64: $e');
      }
    }
    return attachments;
  }

  Future<void> _submitLeave() async {
    if (_formKey.currentState!.validate()) {
      // Additional validations
      if (selectedProject == null) {
        CustomSnackbar.show(
          context: context,
          message: 'Please select your Project',
          type: SnackBarType.error,
        );
        return;
      }

      if (selectedLeaveType == null) {
        CustomSnackbar.show(
          context: context,
          message: 'Please select Type of Leave',
          type: SnackBarType.error,
        );
        return;
      }

      if (toDate != null && fromDate != null && toDate!.isBefore(fromDate!)) {
        CustomSnackbar.show(
          context: context,
          message: 'Please check the From & To Dates',
          type: SnackBarType.error,
        );
        return;
      }

      // Convert attachments to base64
      final attachments = await _convertAttachmentsToBase64();

      if (mounted) {
        final leaveRequest = NewLeaveRequestModel(
          projectId: selectedProject!.projectId,
          fromDate: fromDateController.text,
          toDate: toDateController.text,
          leavesLatt: leavesLatt,
          leavesLong: leavesLong,
          leaveCategoryId: selectedLeaveType!.leaveCategoryId ?? '',
          userRemarks: remarksController.text.isNotEmpty
              ? remarksController.text
              : null,
          attachements: attachments.isNotEmpty ? attachments : null,
        );

        context.read<NewLeaveBloc>().add(
          SubmitNewLeaveEvent(leave: leaveRequest),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NewLeaveBloc, NewLeaveState>(
      listener: (context, state) {
        if (state is NewLeaveSuccessState) {
          CustomSnackbar.show(
            context: context,
            message: state.message,
            type: SnackBarType.success,
          );
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              context.pop();
            }
          });
        } else if (state is NewLeaveErrorState) {
          CustomSnackbar.show(
            context: context,
            message: state.message,
            type: SnackBarType.error,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
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
            text: 'Leave Application',
            weight: FontWeight.bold,
            color: Appcolors.kblackcolor,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveSizedBox.height20,

                  // Header text
                  TextStyles.body(
                    text:
                        'Please fill the form, attach your report (if any) and submit your leaves for approval',
                    color: Appcolors.kblackcolor,
                    weight: FontWeight.w500,
                    maxLines: 2,
                  ),

                  ResponsiveSizedBox.height30,

                  // Project dropdown
                  TextStyles.caption(
                    text: 'Project *',
                    color: Appcolors.kblackcolor,
                    weight: FontWeight.w600,
                  ),
                  ResponsiveSizedBox.height10,
                  BlocBuilder<ProjectsBloc, ProjectsState>(
                    builder: (context, state) {
                      if (state is ProjectsLoadingState) {
                        return CustomProjectDropdown(
                          selectedProject: selectedProject,
                          projects: const [],
                          onChanged: (project) {
                            setState(() {
                              selectedProject = project;
                            });
                          },
                          isLoading: true,
                        );
                      }

                      if (state is ProjectsErrorState) {
                        return CustomProjectDropdown(
                          selectedProject: selectedProject,
                          projects: const [],
                          onChanged: (project) {
                            setState(() {
                              selectedProject = project;
                            });
                          },
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
                            setState(() {
                              selectedProject = state.projects.first;
                            });
                          });
                        }
                        return CustomProjectDropdown(
                          selectedProject: selectedProject,
                          projects: state.projects,
                          onChanged: (project) {
                            setState(() {
                              selectedProject = project;
                            });
                          },
                          hintText: 'Select Project',
                          showIcon: true,
                          showLocation: true,
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),

                  ResponsiveSizedBox.height20,

                  // From Date
                  TextStyles.caption(
                    text: 'From Date *',
                    color: Appcolors.kblackcolor,
                    weight: FontWeight.w600,
                  ),
                  ResponsiveSizedBox.height10,
                  CustomFormtextfield(
                    controller: fromDateController,
                    hintText: 'Select From Date',
                    readOnly: true,
                    onTap: () => _selectFromDate(context),
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      color: Appcolors.kprimarycolor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select from date';
                      }
                      return null;
                    },
                  ),

                  ResponsiveSizedBox.height20,

                  // To Date
                  TextStyles.caption(
                    text: 'To Date *',
                    color: Appcolors.kblackcolor,
                    weight: FontWeight.w600,
                  ),
                  ResponsiveSizedBox.height10,
                  CustomFormtextfield(
                    controller: toDateController,
                    hintText: 'Select To Date',
                    readOnly: true,
                    onTap: () => _selectToDate(context),
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      color: Appcolors.kprimarycolor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select to date';
                      }
                      return null;
                    },
                  ),

                  ResponsiveSizedBox.height20,

                  // Type of Leave dropdown
                  TextStyles.caption(
                    text: 'Type of Leave *',
                    color: Appcolors.kblackcolor,
                    weight: FontWeight.w600,
                  ),
                  ResponsiveSizedBox.height10,
                  BlocBuilder<LeaveCategoriesBloc, LeaveCategoriesState>(
                    builder: (context, state) {
                      if (state is LeaveCategoriesLoadingState) {
                        return Container(
                          padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                          decoration: BoxDecoration(
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
                                text: 'Loading leave types...',
                                color: Appcolors.kgreyColor,
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is LeaveCategoriesErrorState) {
                        return Container(
                          padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Appcolors.kredcolor.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(
                              ResponsiveUtils.borderRadius(2.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Appcolors.kredcolor,
                                size: ResponsiveUtils.sp(5),
                              ),
                              ResponsiveSizedBox.width(2),
                              Expanded(
                                child: TextStyles.medium(
                                  text: state.message,
                                  color: Appcolors.kredcolor,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.read<LeaveCategoriesBloc>().add(
                                    LeaveCategoriesFetchingInitialEvent(),
                                  );
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

                      if (state is LeaveCategoriesSuccessState) {
                        final leaveCategories = state.leavecategories;
                        return CustomDropdown(
                          value: selectedLeaveType?.leaveCategory,
                          hint: 'Select Type of Leave',
                          items: leaveCategories
                              .map((e) => e.leaveCategory ?? '')
                              .where((e) => e.isNotEmpty)
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedLeaveType = leaveCategories.firstWhere(
                                (e) => e.leaveCategory == value,
                              );
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select type of leave';
                            }
                            return null;
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),

                  ResponsiveSizedBox.height20,

                  // Remarks (Optional)
                  TextStyles.caption(
                    text: 'Remarks (Optional)',
                    color: Appcolors.kblackcolor,
                    weight: FontWeight.w600,
                  ),
                  ResponsiveSizedBox.height10,
                  CustomFormtextfield(
                    controller: remarksController,
                    hintText: 'Enter any additional remarks',
                    maxLines: 4,
                  ),

                  ResponsiveSizedBox.height20,

                  // Attachments section using Custom Gallery Picker
                  CustomGalleryPicker(
                    attachedFiles: attachedFiles,
                    onFilesChanged: (files) {
                      setState(() {
                        attachedFiles = files;
                      });
                    },
                  ),

                  ResponsiveSizedBox.height40,

                  // Submit Button
                  BlocBuilder<NewLeaveBloc, NewLeaveState>(
                    builder: (context, state) {
                      final isLoading = state is NewLeaveLoadingState;
                      return SizedBox(
                        width: double.infinity,
                        height: ResponsiveUtils.hp(6),
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submitLeave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Appcolors.kprimarycolor,
                            disabledBackgroundColor: Appcolors.kprimarycolor
                                .withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveUtils.borderRadius(2.5),
                              ),
                            ),
                            elevation: 2,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : TextStyles.body(
                                  text: 'Submit Leave',
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
}
