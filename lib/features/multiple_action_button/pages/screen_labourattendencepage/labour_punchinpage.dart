import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:dhani_communications/features/dashboard/models/project_model.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/labor_punchin_bloc/labor_punchin_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/models/labor_attendance_request_model.dart';
import 'package:dhani_communications/features/dashboard/blocs/projects_bloc/projects_bloc.dart';
import 'package:dhani_communications/widgets/custom_camera.dart';
import 'package:dhani_communications/widgets/custom_dropdown.dart';
import 'package:dhani_communications/widgets/custom_formtextfield.dart';
import 'package:dhani_communications/widgets/custom_project_dropdown.dart';
import 'package:dhani_communications/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

/// Labour type model
class LaborType {
  final String label;
  final String value;

  const LaborType({required this.label, required this.value});
}

class LabourPunchInPage extends StatefulWidget {
  const LabourPunchInPage({super.key});

  @override
  State<LabourPunchInPage> createState() => _LabourPunchInPageState();
}

class _LabourPunchInPageState extends State<LabourPunchInPage> {
  final _formKey = GlobalKey<FormState>();
  final _remarksController = TextEditingController();
  final _cameraKey = GlobalKey<CustomCameraWidgetState>();

  // CASUAL specific controllers
  final _laborNameController = TextEditingController();
  final _laborMobileController = TextEditingController();

  // CONTRACT specific controllers
  final _contractorNameController = TextEditingController();
  final _totalLaboursController = TextEditingController();

  ProjectModel? _selectedProject;
  String? _selectedLabourTypeValue; // "CASUAL" or "CONTRACT"
  String? _selectedLabourTypeLabel; // display label for dropdown
  bool _isProcessing = false;

  // Labour type list
  final List<LaborType> _labourTypes = const [
    LaborType(label: "CASUAL - LABOUR HIRED", value: "CASUAL"),
    LaborType(label: "CONTRACT - LABOUR HAJRI", value: "CONTRACT"),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectsBloc>().add(FetchProjectsEvent());
    });
  }

  @override
  void dispose() {
    _remarksController.dispose();
    _laborNameController.dispose();
    _laborMobileController.dispose();
    _contractorNameController.dispose();
    _totalLaboursController.dispose();
    super.dispose();
  }

  /// Get current device location
  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

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

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  void _recordLabourAttendance() async {
    if (_formKey.currentState!.validate()) {
      // Validate project
      if (_selectedProject == null) {
        CustomSnackbar.show(
          context: context,
          message: 'Please select a project',
          type: SnackBarType.error,
        );
        return;
      }

      // Validate labour type
      if (_selectedLabourTypeValue == null) {
        CustomSnackbar.show(
          context: context,
          message: 'Please select a labour type',
          type: SnackBarType.error,
        );
        return;
      }

      // Validate CASUAL specific fields
      if (_selectedLabourTypeValue == 'CASUAL') {
        if (_laborNameController.text.trim().isEmpty) {
          CustomSnackbar.show(
            context: context,
            message: 'Please enter Labor Name',
            type: SnackBarType.error,
          );
          return;
        }
      }

      // Validate CONTRACT specific fields
      if (_selectedLabourTypeValue == 'CONTRACT') {
        if (_contractorNameController.text.trim().isEmpty) {
          CustomSnackbar.show(
            context: context,
            message: 'Please enter Contractor Name',
            type: SnackBarType.error,
          );
          return;
        }
        if (_totalLaboursController.text.trim().isEmpty) {
          CustomSnackbar.show(
            context: context,
            message: 'Please enter Total Number of Labours',
            type: SnackBarType.error,
          );
          return;
        }
      }

      // Show loading instantly
      setState(() {
        _isProcessing = true;
      });

      try {
        // Capture image
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

        // Create labor attendance request model
        final laborAttendance = LaborAttendanceRequestModel(
          projectId: _selectedProject!.projectId,
          laborType: _selectedLabourTypeValue!,
          attendanceLatt: position.latitude,
          attendanceLong: position.longitude,
          userRemarks: _remarksController.text.isNotEmpty
              ? _remarksController.text
              : null,
          picture: base64Image,
          // CASUAL specific
          laborName: _selectedLabourTypeValue == 'CASUAL'
              ? _laborNameController.text.trim()
              : null,
          laborMobile: _selectedLabourTypeValue == 'CASUAL'
              ? _laborMobileController.text.trim()
              : null,
          // CONTRACT specific
          contractorName: _selectedLabourTypeValue == 'CONTRACT'
              ? _contractorNameController.text.trim()
              : null,
          totalLabours: _selectedLabourTypeValue == 'CONTRACT'
              ? _totalLaboursController.text.trim()
              : null,
        );

        // Dispatch event to bloc
        setState(() => _isProcessing = false);
        if (mounted) {
          context.read<LaborPunchInBloc>().add(
            LaborPunchInSubmitEvent(laborAttendance: laborAttendance),
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
    return BlocListener<LaborPunchInBloc, LaborPunchInState>(
      listener: (context, state) {
        if (state is LaborPunchInSuccessState) {
          CustomSnackbar.show(
            context: context,
            message: state.message,
            type: SnackBarType.success,
          );
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) Navigator.pop(context);
          });
        } else if (state is LaborPunchInErrorState) {
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
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Appcolors.kprimarycolor,
              size: ResponsiveUtils.sp(5),
            ),
          ),
          title: TextStyles.title(
            text: 'Labour Punch In',
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
                  // Camera Section - Back Camera
                  Center(
                    child: CustomCameraWidget(
                      key: _cameraKey,
                      lensDirection: CameraLensDirection.back,
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

                  // Labour Type Dropdown
                  CustomDropdown(
                    value: _selectedLabourTypeLabel,
                    hint: 'Select Labour Type',
                    items: _labourTypes.map((e) => e.label).toList(),
                    onChanged: (value) {
                      final selectedType = _labourTypes.firstWhere(
                        (e) => e.label == value,
                      );
                      setState(() {
                        _selectedLabourTypeLabel = value;
                        _selectedLabourTypeValue = selectedType.value;
                        // Clear opposite type's fields when switching
                        if (selectedType.value == 'CASUAL') {
                          _contractorNameController.clear();
                          _totalLaboursController.clear();
                        } else {
                          _laborNameController.clear();
                          _laborMobileController.clear();
                        }
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a labour type';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: ResponsiveUtils.hp(3)),

                  // CASUAL specific fields
                  if (_selectedLabourTypeValue == 'CASUAL') ...[
                    CustomFormtextfield(
                      controller: _laborNameController,
                      hintText: 'Enter Labor Name',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter Labor Name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: ResponsiveUtils.hp(3)),
                    CustomFormtextfield(
                      controller: _laborMobileController,
                      hintText: 'Enter Labor Mobile (optional)',
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: ResponsiveUtils.hp(3)),
                  ],

                  // CONTRACT specific fields
                  if (_selectedLabourTypeValue == 'CONTRACT') ...[
                    CustomFormtextfield(
                      controller: _contractorNameController,
                      hintText: 'Enter Contractor Name',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter Contractor Name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: ResponsiveUtils.hp(3)),
                    CustomFormtextfield(
                      controller: _totalLaboursController,
                      hintText: 'Enter Total Number of Labours',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter Total Number of Labours';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: ResponsiveUtils.hp(3)),
                  ],

                  // Remarks Field
                  CustomFormtextfield(
                    controller: _remarksController,
                    hintText: 'Enter remarks (optional)',
                    maxLines: 4,
                  ),

                  SizedBox(height: ResponsiveUtils.hp(4)),

                  // Record Labour Attendance Button
                  BlocBuilder<LaborPunchInBloc, LaborPunchInState>(
                    builder: (context, state) {
                      final isSubmitting = state is LaborPunchInLoadingState;
                      final isLoading = _isProcessing || isSubmitting;

                      return SizedBox(
                        width: double.infinity,
                        height: ResponsiveUtils.hp(6.5),
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _recordLabourAttendance,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F8FDF),
                            disabledBackgroundColor: const Color(
                              0xFF4F8FDF,
                            ).withOpacity(0.4),
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
                                  'Record Labour Attendance',
                                  style: TextStyle(
                                    fontSize: ResponsiveUtils.sp(3.5),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
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
