import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:dhani_communications/core/responsiveutils.dart';

import 'package:dhani_communications/features/dashboard/blocs/machine_types_bloc/machine_types_bloc.dart';
import 'package:dhani_communications/features/dashboard/blocs/projects_bloc/projects_bloc.dart';
import 'package:dhani_communications/features/dashboard/models/machine_type_model.dart';
import 'package:dhani_communications/features/dashboard/models/project_model.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/new_machinery_hire_bloc/new_machinery_hire_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/models/new_machinery_hire_request_model.dart';
import 'package:dhani_communications/widgets/custom_dropdown.dart';
import 'package:dhani_communications/widgets/custom_project_dropdown.dart';
import 'package:dhani_communications/widgets/custom_snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ScreenNewmachineryhire extends StatefulWidget {
  const ScreenNewmachineryhire({super.key});

  @override
  State<ScreenNewmachineryhire> createState() => _ScreenMachineHirePageState();
}

class _ScreenMachineHirePageState extends State<ScreenNewmachineryhire> {
  final _formKey = GlobalKey<FormState>();

  ProjectModel? selectedProject;
  MachineTypeModel? selectedMachineType;
  DateTime? selectedDate;
  TimeOfDay? fromTime;
  TimeOfDay? toTime;

  final TextEditingController hireDateController = TextEditingController();
  final TextEditingController fromTimeController = TextEditingController();
  final TextEditingController toTimeController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectsBloc>().add(FetchProjectsEvent());
      context.read<MachineTypesBloc>().add(FetchMachineTypesEvent());
    });
  }

  @override
  void dispose() {
    hireDateController.dispose();
    fromTimeController.dispose();
    toTimeController.dispose();
    totalAmountController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
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

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        hireDateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _selectFromTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: fromTime ?? TimeOfDay.now(),
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

    if (picked != null && picked != fromTime) {
      setState(() {
        fromTime = picked;
        fromTimeController.text = picked.format(context);
      });
    }
  }

  Future<void> _selectToTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: toTime ?? TimeOfDay.now(),
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

    if (picked != null && picked != toTime) {
      setState(() {
        toTime = picked;
        toTimeController.text = picked.format(context);
      });
    }
  }

  String _formatDateForApi(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  String _formatTimeForApi(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildDropdownStatus(String message, {VoidCallback? onRetry}) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
      decoration: BoxDecoration(
        border: Border.all(color: Appcolors.kbordercolor),
        borderRadius: BorderRadiusStyles.kradius10(),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextStyles.medium(
              text: message,
              color: Appcolors.kgreyColor,
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: TextStyles.medium(
                text: 'Retry',
                color: Appcolors.kprimarycolor,
              ),
            ),
        ],
      ),
    );
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      if (selectedProject == null) {
        CustomSnackbar.show(
          context: context,
          message: 'Please select a project',
          type: SnackBarType.error,
        );
        return;
      }

      if (selectedMachineType == null) {
        CustomSnackbar.show(
          context: context,
          message: 'Please select a machine type',
          type: SnackBarType.error,
        );
        return;
      }

      final machineryId = int.tryParse(selectedMachineType!.machineryId);
      if (machineryId == null) {
        CustomSnackbar.show(
          context: context,
          message: 'Invalid machine type selected',
          type: SnackBarType.error,
        );
        return;
      }

      final request = NewMachineryHireRequestModel(
        projectId: selectedProject!.projectId,
        machineryId: machineryId,
        hireDate: _formatDateForApi(selectedDate!),
        fromTime: _formatTimeForApi(fromTime!),
        toTime: _formatTimeForApi(toTime!),
        amountPaid: totalAmountController.text.trim(),
        notes: remarksController.text.trim(),
      );

      context.read<NewMachineryHireBloc>().add(
        SubmitNewMachineryHireEvent(machineryHire: request),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.kwhitecolor,
        elevation: 2,
        shadowColor: Appcolors.kgreyColor.withValues(alpha: 0.1),
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
        title: TextStyles.subheadline(
          text: 'New Machinery Hire',
          weight: FontWeight.bold,
          color: Appcolors.kblackcolor,
        ),
        centerTitle: true,
      ),
      body: BlocListener<NewMachineryHireBloc, NewMachineryHireState>(
        listener: (context, state) {
          if (state is NewMachineryHireSuccessState) {
            CustomSnackbar.show(
              context: context,
              message: state.message,
              type: SnackBarType.success,
            );
            final router = GoRouter.of(context);
            Future.delayed(const Duration(seconds: 1), () {
              if (!mounted) return;
              router.go('/main');
            });
          } else if (state is NewMachineryHireErrorState) {
            CustomSnackbar.show(
              context: context,
              message: state.message,
              type: SnackBarType.error,
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

                  // Header text
                  TextStyles.body(
                    text: 'Please fill the form to record machine hire request',
                    color: Appcolors.kblackcolor,
                    weight: FontWeight.w500,
                  ),

                  ResponsiveSizedBox.height30,

                  // Project dropdown
                  TextStyles.caption(
                    text: 'Project',
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

                      return CustomProjectDropdown(
                        selectedProject: selectedProject,
                        projects: const [],
                        onChanged: (project) {
                          setState(() {
                            selectedProject = project;
                          });
                        },
                      );
                    },
                  ),

                  ResponsiveSizedBox.height20,

                  // Machine Type dropdown
                  TextStyles.caption(
                    text: 'Machine Type',
                    color: Appcolors.kblackcolor,
                    weight: FontWeight.w600,
                  ),
                  ResponsiveSizedBox.height10,
                  BlocBuilder<MachineTypesBloc, MachineTypesState>(
                    builder: (context, state) {
                      if (state is MachineTypesLoadingState) {
                        return _buildDropdownStatus('Loading machine types...');
                      }

                      if (state is MachineTypesErrorState) {
                        return _buildDropdownStatus(
                          state.message,
                          onRetry: () {
                            context.read<MachineTypesBloc>().add(
                              FetchMachineTypesEvent(),
                            );
                          },
                        );
                      }

                      if (state is MachineTypesSuccessState) {
                        final machineNames = state.machineTypes
                            .map((machine) => machine.machineName)
                            .where((name) => name.isNotEmpty)
                            .toList();
                        final selectedMachineName =
                            machineNames.contains(
                              selectedMachineType?.machineName,
                            )
                            ? selectedMachineType?.machineName
                            : null;

                        if (machineNames.isEmpty) {
                          return _buildDropdownStatus(
                            'No machine types available',
                          );
                        }

                        return CustomDropdown(
                          value: selectedMachineName,
                          hint: 'Select Machine Type',
                          items: machineNames,
                          onChanged: (value) {
                            setState(() {
                              selectedMachineType = null;
                              for (final machine in state.machineTypes) {
                                if (machine.machineName == value) {
                                  selectedMachineType = machine;
                                  break;
                                }
                              }
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a machine type';
                            }
                            return null;
                          },
                        );
                      }

                      return CustomDropdown(
                        value: null,
                        hint: 'Select Machine Type',
                        items: const [],
                        onChanged: (_) {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a machine type';
                          }
                          return null;
                        },
                      );
                    },
                  ),

                  ResponsiveSizedBox.height20,

                  // Hire Date
                  TextStyles.caption(
                    text: 'Hire Date',
                    color: Appcolors.kblackcolor,
                    weight: FontWeight.w600,
                  ),
                  ResponsiveSizedBox.height10,
                  TextFormField(
                    controller: hireDateController,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    decoration: InputDecoration(
                      hintText: 'Select Hire Date',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: ResponsiveUtils.sp(3.5),
                      ),
                      filled: true,
                      fillColor: Appcolors.kwhitecolor,
                      suffixIcon: const Icon(
                        Icons.calendar_today,
                        color: Appcolors.kprimarycolor,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.wp(4),
                        vertical: ResponsiveUtils.hp(1.8),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(2.5),
                        ),
                        borderSide: const BorderSide(
                          color: Appcolors.kbordercolor,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(2.5),
                        ),
                        borderSide: const BorderSide(
                          color: Appcolors.kbordercolor,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(2.5),
                        ),
                        borderSide: const BorderSide(
                          color: Appcolors.kprimarycolor,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(2.5),
                        ),
                        borderSide: const BorderSide(
                          color: Appcolors.kredcolor,
                          width: 1.5,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select hire date';
                      }
                      return null;
                    },
                  ),

                  ResponsiveSizedBox.height20,

                  // From Time
                  TextStyles.caption(
                    text: 'From Time',
                    color: Appcolors.kblackcolor,
                    weight: FontWeight.w600,
                  ),
                  ResponsiveSizedBox.height10,
                  TextFormField(
                    controller: fromTimeController,
                    readOnly: true,
                    onTap: () => _selectFromTime(context),
                    decoration: InputDecoration(
                      hintText: 'Select From Time',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: ResponsiveUtils.sp(3.5),
                      ),
                      filled: true,
                      fillColor: Appcolors.kwhitecolor,
                      suffixIcon: const Icon(
                        Icons.access_time,
                        color: Appcolors.kprimarycolor,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.wp(4),
                        vertical: ResponsiveUtils.hp(1.8),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(2.5),
                        ),
                        borderSide: const BorderSide(
                          color: Appcolors.kbordercolor,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(2.5),
                        ),
                        borderSide: const BorderSide(
                          color: Appcolors.kbordercolor,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(2.5),
                        ),
                        borderSide: const BorderSide(
                          color: Appcolors.kprimarycolor,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(2.5),
                        ),
                        borderSide: const BorderSide(
                          color: Appcolors.kredcolor,
                          width: 1.5,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select from time';
                      }
                      return null;
                    },
                  ),

                  ResponsiveSizedBox.height20,

                  // To Time
                  TextStyles.caption(
                    text: 'To Time',
                    color: Appcolors.kblackcolor,
                    weight: FontWeight.w600,
                  ),
                  ResponsiveSizedBox.height10,
                  TextFormField(
                    controller: toTimeController,
                    readOnly: true,
                    onTap: () => _selectToTime(context),
                    decoration: InputDecoration(
                      hintText: 'Select To Time',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: ResponsiveUtils.sp(3.5),
                      ),
                      filled: true,
                      fillColor: Appcolors.kwhitecolor,
                      suffixIcon: const Icon(
                        Icons.access_time,
                        color: Appcolors.kprimarycolor,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.wp(4),
                        vertical: ResponsiveUtils.hp(1.8),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(2.5),
                        ),
                        borderSide: const BorderSide(
                          color: Appcolors.kbordercolor,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(2.5),
                        ),
                        borderSide: const BorderSide(
                          color: Appcolors.kbordercolor,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(2.5),
                        ),
                        borderSide: const BorderSide(
                          color: Appcolors.kprimarycolor,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(2.5),
                        ),
                        borderSide: const BorderSide(
                          color: Appcolors.kredcolor,
                          width: 1.5,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select to time';
                      }
                      return null;
                    },
                  ),

                  ResponsiveSizedBox.height20,

                  // Total Amount
                  TextStyles.caption(
                    text: 'Total Amount',
                    color: Appcolors.kblackcolor,
                    weight: FontWeight.w600,
                  ),
                  ResponsiveSizedBox.height10,
                  TextFormField(
                    controller: totalAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter Total Amount',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: ResponsiveUtils.sp(3.5),
                      ),
                      filled: true,
                      fillColor: Appcolors.kwhitecolor,
                      prefixIcon: const Icon(
                        Icons.currency_rupee,
                        color: Appcolors.kprimarycolor,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.wp(4),
                        vertical: ResponsiveUtils.hp(1.8),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(2.5),
                        ),
                        borderSide: const BorderSide(
                          color: Appcolors.kbordercolor,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(2.5),
                        ),
                        borderSide: const BorderSide(
                          color: Appcolors.kbordercolor,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(2.5),
                        ),
                        borderSide: const BorderSide(
                          color: Appcolors.kprimarycolor,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(2.5),
                        ),
                        borderSide: const BorderSide(
                          color: Appcolors.kredcolor,
                          width: 1.5,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter total amount';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid amount';
                      }
                      return null;
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
                  TextFormField(
                    controller: remarksController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Enter any additional remarks',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: ResponsiveUtils.sp(3.5),
                      ),
                      filled: true,
                      fillColor: Appcolors.kwhitecolor,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.wp(4),
                        vertical: ResponsiveUtils.hp(1.8),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(2.5),
                        ),
                        borderSide: const BorderSide(
                          color: Appcolors.kbordercolor,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(2.5),
                        ),
                        borderSide: const BorderSide(
                          color: Appcolors.kbordercolor,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(2.5),
                        ),
                        borderSide: const BorderSide(
                          color: Appcolors.kprimarycolor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  ResponsiveSizedBox.height40,

                  // Submit Button
                  BlocBuilder<NewMachineryHireBloc, NewMachineryHireState>(
                    builder: (context, state) {
                      final isLoading = state is NewMachineryHireLoadingState;
                      return SizedBox(
                        width: double.infinity,
                        height: ResponsiveUtils.hp(6),
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submitRequest,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Appcolors.kprimarycolor,
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
                                    strokeWidth: 2.5,
                                    color: Appcolors.kwhitecolor,
                                  ),
                                )
                              : TextStyles.body(
                                  text: 'Submit Request',
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
