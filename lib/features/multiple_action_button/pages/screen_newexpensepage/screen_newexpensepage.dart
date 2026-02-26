import 'dart:convert';
import 'dart:io';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/features/dashboard/models/expense_category_model.dart';
import 'package:dhani_communications/features/dashboard/models/project_model.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/hq_vehicles_bloc/hq_vehicles_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/new_expense_bloc/new_expense_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/models/hq_vehicle_model.dart';
import 'package:dhani_communications/features/multiple_action_button/models/new_expense_request_model.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/expense_categories_bloc/expense_categories_bloc.dart';
import 'package:dhani_communications/features/dashboard/blocs/projects_bloc/projects_bloc.dart';
import 'package:dhani_communications/widgets/custom_formtextfield.dart';
import 'package:dhani_communications/widgets/custom_project_dropdown.dart';
import 'package:dhani_communications/widgets/custom_snackbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dhani_communications/core/responsiveutils.dart';

import 'package:dhani_communications/widgets/custom_dropdown.dart';

import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ScreenNewexpensepage extends StatefulWidget {
  const ScreenNewexpensepage({super.key});

  @override
  State<ScreenNewexpensepage> createState() => _ScreenExpensePageState();
}

class _ScreenExpensePageState extends State<ScreenNewexpensepage> {
  final _formKey = GlobalKey<FormState>();

  ProjectModel? selectedProject;
  ExpenseCategoryModel? selectedExpenseCategory;
  String? selectedBillType;
  HqVehicleModel? selectedVehicle;
  DateTime? selectedDate;

  bool _requireVehicle = false;
  bool _requireFuel = false;

  final TextEditingController expenseDateController = TextEditingController();
  final TextEditingController expenseAmountController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController fuelFillKmController = TextEditingController();

  List<PlatformFile> attachedFiles = [];

  // Bill types matching the React code
  final List<Map<String, String>> billTypeList = [
    {'label': 'GST Bill', 'value': 'GST'},
    {'label': 'Non GST Bill', 'value': 'NONGST'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectsBloc>().add(FetchProjectsEvent());
      context.read<ExpenseCategoriesBloc>().add(FetchExpenseCategoriesEvent());
      context.read<HqVehiclesBloc>().add(FetchHqVehiclesEvent());
    });
  }

  @override
  void dispose() {
    expenseDateController.dispose();
    expenseAmountController.dispose();
    remarksController.dispose();
    fuelFillKmController.dispose();
    super.dispose();
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

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        expenseDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: ResponsiveUtils.hp(2),
              horizontal: ResponsiveUtils.wp(4),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Appcolors.kgreyColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ResponsiveSizedBox.height20,
                TextStyles.title(
                  text: 'Upload Attachment',
                  weight: FontWeight.bold,
                  color: Appcolors.kblackcolor,
                ),
                ResponsiveSizedBox.height20,
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Appcolors.kprimarycolor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Appcolors.kprimarycolor,
                    ),
                  ),
                  title: TextStyles.body(
                    text: 'Take a Photo',
                    color: Appcolors.kblackcolor,
                    weight: FontWeight.w500,
                  ),
                  subtitle: TextStyles.medium(
                    text: 'Use camera to capture image',
                    color: Appcolors.kgreyColor,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _takePhoto();
                  },
                ),
                ResponsiveSizedBox.height10,
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Appcolors.kprimarycolor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.photo_library_rounded,
                      color: Appcolors.kprimarycolor,
                    ),
                  ),
                  title: TextStyles.body(
                    text: 'Choose from Gallery',
                    color: Appcolors.kblackcolor,
                    weight: FontWeight.w500,
                  ),
                  subtitle: TextStyles.medium(
                    text: 'Upload images or PDF files',
                    color: Appcolors.kgreyColor,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickFromGallery();
                  },
                ),
                ResponsiveSizedBox.height10,
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _takePhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 60,
      );

      if (photo != null) {
        final file = File(photo.path);
        final fileSize = await file.length();

        setState(() {
          attachedFiles.add(
            PlatformFile(name: photo.name, path: photo.path, size: fileSize),
          );
        });

        if (mounted) {
          CustomSnackbar.show(
            context: context,
            message: 'Photo captured successfully!',
            type: SnackBarType.success,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.show(
          context: context,
          message: 'Error capturing photo',
          type: SnackBarType.error,
        );
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'gif'],
      );

      if (result != null) {
        setState(() {
          attachedFiles.addAll(result.files);
        });

        if (mounted) {
          CustomSnackbar.show(
            context: context,
            message: '${result.files.length} file(s) attached successfully!',
            type: SnackBarType.success,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.show(
          context: context,
          message: 'Error picking files',
          type: SnackBarType.error,
        );
      }
    }
  }

  void _removeFile(int index) {
    setState(() {
      attachedFiles.removeAt(index);
    });
  }

  /// Convert attached files to base64 NewExpenseAttachment list
  Future<List<NewExpenseAttachment>> _convertAttachmentsToBase64() async {
    List<NewExpenseAttachment> attachments = [];
    for (var file in attachedFiles) {
      try {
        if (file.path != null) {
          final bytes = await File(file.path!).readAsBytes();
          final base64String = base64Encode(bytes);
          attachments.add(
            NewExpenseAttachment(fileName: file.name, file: base64String),
          );
        }
      } catch (e) {
        debugPrint('Error converting file to base64: $e');
      }
    }
    return attachments;
  }

  void _onExpenseCategoryChanged(ExpenseCategoryModel category) {
    setState(() {
      selectedExpenseCategory = category;
      _requireVehicle = category.requireVehicle == 'YES';
      _requireFuel = category.requireFuel == 'YES';

      // Reset vehicle-related fields if vehicle is no longer required
      if (!_requireVehicle) {
        selectedVehicle = null;
        _requireFuel = false;
      }
      if (!_requireFuel) {
        fuelFillKmController.clear();
      }
    });
  }

  Future<void> _submitExpense() async {
    if (_formKey.currentState!.validate()) {
      // Additional validations matching React code
      if (selectedProject == null) {
        CustomSnackbar.show(
          context: context,
          message: 'Please select your Project',
          type: SnackBarType.error,
        );
        return;
      }

      if (selectedExpenseCategory == null) {
        CustomSnackbar.show(
          context: context,
          message: 'Please choose Expense Category',
          type: SnackBarType.error,
        );
        return;
      }

      if (_requireVehicle && selectedVehicle == null) {
        CustomSnackbar.show(
          context: context,
          message: 'Please select Vehicle',
          type: SnackBarType.error,
        );
        return;
      }

      if (_requireFuel && fuelFillKmController.text.isEmpty) {
        CustomSnackbar.show(
          context: context,
          message: 'Please enter the KM Reading',
          type: SnackBarType.error,
        );
        return;
      }

      // GST bill requires attachments
      if (selectedBillType == 'GST' && attachedFiles.isEmpty) {
        CustomSnackbar.show(
          context: context,
          message: 'Please attach the invoice for GST Bill',
          type: SnackBarType.error,
        );
        return;
      }

      // Convert attachments to base64
      final attachments = await _convertAttachmentsToBase64();

      if (mounted) {
        final expenseRequest = NewExpenseRequestModel(
          projectId: selectedProject!.projectId,
          expenseDate: expenseDateController.text,
          expenseCategoryId: int.parse(
            selectedExpenseCategory!.expenseCategoryId,
          ),
          expenseAmount: double.parse(expenseAmountController.text),
          vehicleId: _requireVehicle
              ? int.tryParse(selectedVehicle!.vehicleId)
              : null,
          fuelFillKm: _requireFuel
              ? int.tryParse(fuelFillKmController.text)
              : null,
          userRemarks: remarksController.text.isNotEmpty
              ? remarksController.text
              : null,
          attachements: attachments.isNotEmpty ? attachments : null,
        );

        context.read<NewExpenseBloc>().add(
          SubmitNewExpenseEvent(expense: expenseRequest),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          text: 'Expense Submission',
          weight: FontWeight.bold,
          color: Appcolors.kblackcolor,
        ),
        centerTitle: true,
      ),
      body: BlocListener<NewExpenseBloc, NewExpenseState>(
        listener: (context, state) {
          if (state is NewExpenseSuccessState) {
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
          } else if (state is NewExpenseErrorState) {
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
                    text:
                        'Please fill the form, attach your bills and submit your expenses for approval',
                    color: Appcolors.kblackcolor,
                    weight: FontWeight.w500,
                    maxLines: 2,
                  ),

                  ResponsiveSizedBox.height30,

                  // ── Project dropdown ──
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

                  // ── Expense Date ──
                  TextStyles.caption(
                    text: 'Expense Date *',
                    color: Appcolors.kblackcolor,
                    weight: FontWeight.w600,
                  ),
                  ResponsiveSizedBox.height10,
                  CustomFormtextfield(
                    controller: expenseDateController,
                    hintText: 'Select Expense Date',
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      color: Appcolors.kprimarycolor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select expense date';
                      }
                      return null;
                    },
                  ),

                  ResponsiveSizedBox.height20,

                  // ── Expense Category dropdown ──
                  TextStyles.caption(
                    text: 'Expense Category *',
                    color: Appcolors.kblackcolor,
                    weight: FontWeight.w600,
                  ),
                  ResponsiveSizedBox.height10,
                  BlocBuilder<ExpenseCategoriesBloc, ExpenseCategoriesState>(
                    builder: (context, state) {
                      if (state is ExpenseCategoriesLoadingState) {
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
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Appcolors.kprimarycolor,
                                ),
                              ),
                              ResponsiveSizedBox.width(3),
                              TextStyles.medium(
                                text: 'Loading categories...',
                                color: Appcolors.kgreyColor,
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is ExpenseCategoriesErrorState) {
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
                                  context.read<ExpenseCategoriesBloc>().add(
                                    FetchExpenseCategoriesEvent(),
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

                      if (state is ExpenseCategoriesSuccessState) {
                        final categories = state.categories;
                        return CustomDropdown(
                          value: selectedExpenseCategory?.expenseCategory,
                          hint: 'Select Expense Category',
                          items: categories
                              .map((e) => e.expenseCategory)
                              .toList(),
                          onChanged: (value) {
                            final category = categories.firstWhere(
                              (e) => e.expenseCategory == value,
                            );
                            _onExpenseCategoryChanged(category);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select expense category';
                            }
                            return null;
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),

                  ResponsiveSizedBox.height20,

                  // ── Bill Type dropdown ──
                  TextStyles.caption(
                    text: 'Bill Type',
                    color: Appcolors.kblackcolor,
                    weight: FontWeight.w600,
                  ),
                  ResponsiveSizedBox.height10,
                  CustomDropdown(
                    value: selectedBillType != null
                        ? billTypeList.firstWhere(
                            (e) => e['value'] == selectedBillType,
                          )['label']
                        : null,
                    hint: 'Select Bill Type',
                    items: billTypeList.map((e) => e['label']!).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBillType = billTypeList.firstWhere(
                          (e) => e['label'] == value,
                        )['value'];
                      });
                    },
                  ),

                  ResponsiveSizedBox.height20,

                  // ── Vehicle dropdown (conditional) ──
                  if (_requireVehicle) ...[
                    TextStyles.caption(
                      text: 'Select Vehicle *',
                      color: Appcolors.kblackcolor,
                      weight: FontWeight.w600,
                    ),
                    ResponsiveSizedBox.height10,
                    BlocBuilder<HqVehiclesBloc, HqVehiclesState>(
                      builder: (context, state) {
                        if (state is HqVehiclesLoadingState) {
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
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Appcolors.kprimarycolor,
                                  ),
                                ),
                                ResponsiveSizedBox.width(3),
                                TextStyles.medium(
                                  text: 'Loading vehicles...',
                                  color: Appcolors.kgreyColor,
                                ),
                              ],
                            ),
                          );
                        }

                        if (state is HqVehiclesErrorState) {
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
                                    context.read<HqVehiclesBloc>().add(
                                      FetchHqVehiclesEvent(),
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

                        if (state is HqVehiclesSuccessState) {
                          final vehicles = state.vehicles;
                          return CustomDropdown(
                            value: selectedVehicle?.vehicleRegNumber,
                            hint: 'Select Vehicle',
                            items: vehicles
                                .map((e) => e.vehicleRegNumber)
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedVehicle = vehicles.firstWhere(
                                  (e) => e.vehicleRegNumber == value,
                                );
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a vehicle';
                              }
                              return null;
                            },
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                    ResponsiveSizedBox.height20,
                  ],

                  // ── KM Reading (conditional) ──
                  if (_requireFuel) ...[
                    TextStyles.caption(
                      text: 'KM Reading *',
                      color: Appcolors.kblackcolor,
                      weight: FontWeight.w600,
                    ),
                    ResponsiveSizedBox.height10,
                    CustomFormtextfield(
                      controller: fuelFillKmController,
                      hintText: 'Please enter KM Reading',
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(
                        Icons.speed,
                        color: Appcolors.kprimarycolor,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the KM Reading';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    ResponsiveSizedBox.height20,
                  ],

                  // ── Expense Amount ──
                  TextStyles.caption(
                    text: 'Expense Amount *',
                    color: Appcolors.kblackcolor,
                    weight: FontWeight.w600,
                  ),
                  ResponsiveSizedBox.height10,
                  CustomFormtextfield(
                    controller: expenseAmountController,
                    hintText: 'Enter Expense Amount',
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(
                      Icons.currency_rupee,
                      color: Appcolors.kprimarycolor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter expense amount';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid amount';
                      }
                      return null;
                    },
                  ),

                  ResponsiveSizedBox.height20,

                  // ── Remarks (Optional) ──
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

                  // ── Attachments section ──
                  TextStyles.caption(
                    text: 'Attachments',
                    color: Appcolors.kblackcolor,
                    weight: FontWeight.w600,
                  ),
                  ResponsiveSizedBox.height10,

                  // Add Attachment Button
                  InkWell(
                    onTap: _showAttachmentOptions,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.wp(4),
                        vertical: ResponsiveUtils.hp(2),
                      ),
                      decoration: BoxDecoration(
                        color: Appcolors.kwhitecolor,
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(2.5),
                        ),
                        border: Border.all(
                          color: Appcolors.kbordercolor,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.attach_file,
                            color: Appcolors.kprimarycolor,
                          ),
                          ResponsiveSizedBox.width10,
                          TextStyles.body(
                            text: 'Add Attachment',
                            color: Appcolors.kprimarycolor,
                            weight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Display attached files
                  if (attachedFiles.isNotEmpty) ...[
                    ResponsiveSizedBox.height15,
                    Container(
                      padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
                      decoration: BoxDecoration(
                        color: Appcolors.kwhitecolor,
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(2.5),
                        ),
                        border: Border.all(
                          color: Appcolors.kbordercolor,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextStyles.caption(
                            text: 'Attached Files (${attachedFiles.length})',
                            color: Appcolors.kblackcolor,
                            weight: FontWeight.w600,
                          ),
                          ResponsiveSizedBox.height10,
                          ...attachedFiles.asMap().entries.map((entry) {
                            int index = entry.key;
                            PlatformFile file = entry.value;
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: ResponsiveUtils.hp(1),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.insert_drive_file,
                                    color: Appcolors.kprimarycolor,
                                    size: ResponsiveUtils.sp(5),
                                  ),
                                  ResponsiveSizedBox.width10,
                                  Expanded(
                                    child: TextStyles.caption(
                                      text: file.name,
                                      color: Appcolors.kblackcolor,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Appcolors.kredcolor,
                                    ),
                                    onPressed: () => _removeFile(index),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],

                  ResponsiveSizedBox.height40,

                  // ── Submit Button ──
                  BlocBuilder<NewExpenseBloc, NewExpenseState>(
                    builder: (context, state) {
                      final isLoading = state is NewExpenseLoadingState;
                      return SizedBox(
                        width: double.infinity,
                        height: ResponsiveUtils.hp(6),
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submitExpense,
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
                                  text: 'Submit Expense',
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
