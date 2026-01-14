import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/widgets/custom_formtextfield.dart';
import 'package:dhani_communications/widgets/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';

class ScreenDprProgressPage extends StatefulWidget {
  const ScreenDprProgressPage({super.key});

  @override
  State<ScreenDprProgressPage> createState() => _ScreenDprProgressPageState();
}

class _ScreenDprProgressPageState extends State<ScreenDprProgressPage> {
  final _formKey = GlobalKey<FormState>();

  String? selectedProject;
  String? selectedProjectDpr;
  DateTime? selectedDate;

  final TextEditingController progressDateController = TextEditingController();
  final TextEditingController progressQuantityController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  /// Sample data (replace with API later)
  final List<String> projects = [
    'Project A',
    'Project B',
    'Project C',
  ];

  final List<String> projectDprList = [
    'DPR 001',
    'DPR 002',
    'DPR 003',
  ];

  @override
  void dispose() {
    progressDateController.dispose();
    progressQuantityController.dispose();
    remarksController.dispose();
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

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        progressDateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _submitDprProgress() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('DPR progress submitted for approval successfully!'),
          backgroundColor: Appcolors.ksecondarycolor,
        ),
      );

      debugPrint('Project: $selectedProject');
      debugPrint('Project DPR: $selectedProjectDpr');
      debugPrint('Progress Date: ${progressDateController.text}');
      debugPrint('Progress Quantity: ${progressQuantityController.text}');
      debugPrint('Remarks: ${remarksController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
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
                TextStyles.caption(
                  text: 'Project',
                  weight: FontWeight.w600,
                ),
                ResponsiveSizedBox.height10,
                CustomDropdown(
                  value: selectedProject,
                  hint: 'Select Project',
                  items: projects,
                  onChanged: (value) {
                    setState(() => selectedProject = value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a project';
                    }
                    return null;
                  },
                ),

                ResponsiveSizedBox.height20,

                /// Project DPR
                TextStyles.caption(
                  text: 'Project DPR',
                  weight: FontWeight.w600,
                ),
                ResponsiveSizedBox.height10,
                CustomDropdown(
                  value: selectedProjectDpr,
                  hint: 'Select Project DPR',
                  items: projectDprList,
                  onChanged: (value) {
                    setState(() => selectedProjectDpr = value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select project DPR';
                    }
                    return null;
                  },
                ),

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
                    if (double.tryParse(value) == null) {
                      return 'Enter valid quantity';
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
                SizedBox(
                  width: double.infinity,
                  height: ResponsiveUtils.hp(6),
                  child: ElevatedButton(
                    onPressed: _submitDprProgress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Appcolors.kprimarycolor,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(ResponsiveUtils.borderRadius(2.5)),
                      ),
                    ),
                    child: TextStyles.body(
                      text: 'Submit DPR Progress',
                      color: Appcolors.kwhitecolor,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),

                ResponsiveSizedBox.height30,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
