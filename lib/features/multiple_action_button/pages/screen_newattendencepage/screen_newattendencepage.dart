import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';

import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:dhani_communications/features/dashboard/models/project_model.dart';

import 'package:dhani_communications/features/multiple_action_button/blocs/new_attendance_check_bloc/new_attendance_check_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/new_attendence_bloc/new_attendence_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/models/attendence_requestmodel.dart';
import 'package:dhani_communications/features/dashboard/blocs/projects_bloc/projects_bloc.dart';
import 'package:dhani_communications/widgets/custom_camera.dart';
import 'package:dhani_communications/widgets/custom_formtextfield.dart';
import 'package:dhani_communications/widgets/custom_project_dropdown.dart';
import 'package:dhani_communications/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class DailyAttendancePage extends StatefulWidget {
  const DailyAttendancePage({super.key});

  @override
  State<DailyAttendancePage> createState() => _DailyAttendancePageState();
}

class _DailyAttendancePageState extends State<DailyAttendancePage> {
  final _formKey = GlobalKey<FormState>();
  final _remarksController = TextEditingController();
  final _cameraKey = GlobalKey<CustomCameraWidgetState>();

  ProjectModel? _selectedProject;
  String? _attendanceType; // Stored from attendance/check response
  bool _isProcessing =
      false; // Local loading for photo capture + location + base64

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch projects on load
      context.read<ProjectsBloc>().add(FetchProjectsEvent());
      // Check attendance status on load
      context.read<NewAttendanceCheckBloc>().add(CheckNewAttendanceEvent());
    });
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  /// Get current device location
  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        CustomSnackbar.show(
          context: context,
          message: 'Location services are disabled. Please enable them.',
          type: SnackBarType.error,
        );
      }
      return null;
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
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
        return null;
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
      return null;
    }

    // Get current position
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  void _recordAttendance() async {
    if (_formKey.currentState!.validate()) {
      // Check if project is selected
      if (_selectedProject == null) {
        CustomSnackbar.show(
          context: context,
          message: 'Please select a project',
          type: SnackBarType.error,
        );
        return;
      }

      // Show loading instantly
      setState(() {
        _isProcessing = true;
      });

      try {
        // Capture image when button is clicked
        final capturedImage = await _cameraKey.currentState?.captureImage();

        if (capturedImage == null) {
          setState(() => _isProcessing = false);
          if (mounted) {
            CustomSnackbar.show(
              context: context,
              message: 'Failed to capture image. Please try again.',
              type: SnackBarType.error,
            );
          }
          return;
        }

        // Get current location
        final position = await _getCurrentLocation();
        if (position == null) {
          setState(() => _isProcessing = false);
          return;
        }

        // Convert image to base64
        final imageBytes = await capturedImage.readAsBytes();
        final base64Image = base64Encode(imageBytes);

        // Create attendance request model
        final attendanceRequest = AttendanceRequestModel(
          projectId: _selectedProject!.projectId,
          attendance: 0.5, // Hardcoded attendance value
          attendanceLatt: position.latitude,
          attendanceLong: position.longitude,
          attendanceType: _attendanceType ?? '',
          userRemarks: _remarksController.text.isNotEmpty
              ? _remarksController.text
              : null,
          picture: base64Image,
        );

        // Dispatch event to bloc (bloc will handle its own loading state)
        setState(() => _isProcessing = false);
        if (mounted) {
          context.read<NewAttendenceBloc>().add(
            NewAttendenceMarkingEvent(attendence: attendanceRequest),
          );
        }
      } catch (e) {
        setState(() => _isProcessing = false);
        if (mounted) {
          CustomSnackbar.show(
            context: context,
            message: 'Error: $e',
            type: SnackBarType.error,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listen for attendance check response
        BlocListener<NewAttendanceCheckBloc, NewAttendanceCheckState>(
          listener: (context, state) {
            if (state is NewAttendanceCheckSuccessState) {
              setState(() {
                _attendanceType = state.data.attendanceType;
              });
              // Show message if attendance is not accepted
              if (!state.data.canMark) {
                CustomSnackbar.show(
                  context: context,
                  message: state.data.status,
                  type: SnackBarType.info,
                );
              }
            } else if (state is NewAttendanceCheckErrorState) {
              CustomSnackbar.show(
                context: context,
                message: state.message,
                type: SnackBarType.error,
              );
            }
          },
        ),
        // Listen for attendance submit response
        BlocListener<NewAttendenceBloc, NewAttendenceState>(
          listener: (context, state) {
            if (state is NewAttendenceSuccessState) {
              CustomSnackbar.show(
                context: context,
                message: state.message,
                type: SnackBarType.success,
              );
              // Pop back after successful attendance
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) Navigator.pop(context);
              });
            } else if (state is NewAttendenceErrorState) {
              CustomSnackbar.show(
                context: context,
                message: state.message,
                type: SnackBarType.error,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Appcolors.kprimarycolor,
              size: ResponsiveUtils.sp(5),
            ),
          ),
          title: TextStyles.title(
            text: 'New Attendance',
            weight: FontWeight.bold,
            color: Appcolors.kblackcolor,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.wp(5),
              vertical: ResponsiveUtils.hp(3),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Camera Section
                  Center(
                    child: CustomCameraWidget(
                      key: _cameraKey,
                      lensDirection: CameraLensDirection.front,
                      onImageCaptured: (image) {
                        debugPrint('Image captured: ${image.path}');
                      },
                      height: ResponsiveUtils.wp(60),
                      width: ResponsiveUtils.wp(60),
                    ),
                  ),

                  SizedBox(height: ResponsiveUtils.hp(4)),

                  // Project Dropdown using CustomProjectDropdown
                  BlocBuilder<ProjectsBloc, ProjectsState>(
                    builder: (context, state) {
                      if (state is ProjectsLoadingState) {
                        return CustomProjectDropdown(
                          selectedProject: _selectedProject,
                          projects: const [],
                          onChanged: (project) {
                            setState(() {
                              _selectedProject = project;
                            });
                          },
                          isLoading: true,
                        );
                      }

                      if (state is ProjectsErrorState) {
                        return CustomProjectDropdown(
                          selectedProject: _selectedProject,
                          projects: const [],
                          onChanged: (project) {
                            setState(() {
                              _selectedProject = project;
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
                        return CustomProjectDropdown(
                          selectedProject: _selectedProject,
                          projects: state.projects,
                          onChanged: (project) {
                            setState(() {
                              _selectedProject = project;
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

                  SizedBox(height: ResponsiveUtils.hp(3)),

                  // Remarks Field
                  CustomFormtextfield(
                    controller: _remarksController,
                    hintText: 'Enter remarks (optional)',
                    maxLines: 4,
                  ),

                  SizedBox(height: ResponsiveUtils.hp(4)),

                  // Record Attendance Button
                  BlocBuilder<NewAttendanceCheckBloc, NewAttendanceCheckState>(
                    builder: (context, checkState) {
                      // Button is enabled only when check status is ACCEPT
                      final bool canMark =
                          checkState is NewAttendanceCheckSuccessState &&
                          checkState.data.canMark;
                      final bool isCheckLoading =
                          checkState is NewAttendanceCheckLoadingState;

                      return BlocBuilder<NewAttendenceBloc, NewAttendenceState>(
                        builder: (context, submitState) {
                          final isSubmitting =
                              submitState is NewAttendenceLoadingState;
                          final isLoading =
                              _isProcessing || isSubmitting || isCheckLoading;
                          final isButtonEnabled = canMark && !isLoading;

                          return SizedBox(
                            width: double.infinity,
                            height: ResponsiveUtils.hp(6.5),
                            child: ElevatedButton(
                              onPressed: isButtonEnabled
                                  ? _recordAttendance
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4F8FDF),
                                disabledBackgroundColor: const Color(
                                  0xFF4F8FDF,
                                ).withValues(alpha: 0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveUtils.borderRadius(2.5),
                                  ),
                                ),
                                elevation: 3,
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
                                  : Text(
                                      canMark
                                          ? 'Record Attendance'
                                          : 'Attendance Not Available',
                                      style: TextStyle(
                                        fontSize: ResponsiveUtils.sp(3.5),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
