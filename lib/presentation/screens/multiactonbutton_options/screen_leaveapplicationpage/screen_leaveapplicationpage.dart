import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/widgets/custom_filepicker.dart';
import 'package:flutter/material.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:dhani_communications/widgets/custom_dropdown.dart';

import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';

class ScreenLeaveApplicationPage extends StatefulWidget {
  const ScreenLeaveApplicationPage({super.key});

  @override
  State<ScreenLeaveApplicationPage> createState() => _ScreenLeaveApplicationPageState();
}

class _ScreenLeaveApplicationPageState extends State<ScreenLeaveApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  
  String? selectedProject;
  String? selectedLeaveType;
  DateTime? fromDate;
  DateTime? toDate;
  
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  
  List<PlatformFile> attachedFiles = [];

  // Sample data - replace with your actual data
  final List<String> projects = ['Project A', 'Project B', 'Project C', 'Project D'];
  final List<String> leaveTypes = [
    'Sick Leave',
    'Casual Leave',
    'Earned Leave',
    'Maternity Leave',
    'Paternity Leave',
    'Compensatory Off',
    'Loss of Pay',
  ];

  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    remarksController.dispose();
    super.dispose();
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
        fromDateController.text = "${picked.day}/${picked.month}/${picked.year}";
        
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select From Date first'),
          backgroundColor: Appcolors.kredcolor,
        ),
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
        toDateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _submitLeave() {
    if (_formKey.currentState!.validate()) {
      // Handle form submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Leave submitted for approval successfully!'),
          backgroundColor: Appcolors.ksecondarycolor,
        ),
      );
      
      // Add your submission logic here
      print('Project: $selectedProject');
      print('From Date: ${fromDateController.text}');
      print('To Date: ${toDateController.text}');
      print('Leave Type: $selectedLeaveType');
      print('Remarks: ${remarksController.text}');
      print('Attached Files: ${attachedFiles.length}');
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
                  text: 'Please fill the form, attach your report (if any) and submit your leaves for approval',
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
                CustomDropdown(
                  value: selectedProject,
                  hint: 'Select Project',
                  items: projects,
                  onChanged: (value) {
                    setState(() {
                      selectedProject = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a project';
                    }
                    return null;
                  },
                ),
                
                ResponsiveSizedBox.height20,
                
                // From Date
                TextStyles.caption(
                  text: 'From Date',
                  color: Appcolors.kblackcolor,
                  weight: FontWeight.w600,
                ),
                ResponsiveSizedBox.height10,
                TextFormField(
                  controller: fromDateController,
                  readOnly: true,
                  onTap: () => _selectFromDate(context),
                  decoration: InputDecoration(
                    hintText: 'Select From Date',
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
                      borderRadius: BorderRadius.circular(ResponsiveUtils.borderRadius(2.5)),
                      borderSide: const BorderSide(
                        color: Appcolors.kbordercolor,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.borderRadius(2.5)),
                      borderSide: const BorderSide(
                        color: Appcolors.kbordercolor,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.borderRadius(2.5)),
                      borderSide: const BorderSide(
                        color: Appcolors.kprimarycolor,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.borderRadius(2.5)),
                      borderSide: const BorderSide(
                        color: Appcolors.kredcolor,
                        width: 1.5,
                      ),
                    ),
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
                  text: 'To Date',
                  color: Appcolors.kblackcolor,
                  weight: FontWeight.w600,
                ),
                ResponsiveSizedBox.height10,
                TextFormField(
                  controller: toDateController,
                  readOnly: true,
                  onTap: () => _selectToDate(context),
                  decoration: InputDecoration(
                    hintText: 'Select To Date',
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
                      borderRadius: BorderRadius.circular(ResponsiveUtils.borderRadius(2.5)),
                      borderSide: const BorderSide(
                        color: Appcolors.kbordercolor,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.borderRadius(2.5)),
                      borderSide: const BorderSide(
                        color: Appcolors.kbordercolor,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.borderRadius(2.5)),
                      borderSide: const BorderSide(
                        color: Appcolors.kprimarycolor,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.borderRadius(2.5)),
                      borderSide: const BorderSide(
                        color: Appcolors.kredcolor,
                        width: 1.5,
                      ),
                    ),
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
                  text: 'Type of Leave',
                  color: Appcolors.kblackcolor,
                  weight: FontWeight.w600,
                ),
                ResponsiveSizedBox.height10,
                CustomDropdown(
                  value: selectedLeaveType,
                  hint: 'Select Type of Leave',
                  items: leaveTypes,
                  onChanged: (value) {
                    setState(() {
                      selectedLeaveType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select type of leave';
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
                      borderRadius: BorderRadius.circular(ResponsiveUtils.borderRadius(2.5)),
                      borderSide: const BorderSide(
                        color: Appcolors.kbordercolor,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.borderRadius(2.5)),
                      borderSide: const BorderSide(
                        color: Appcolors.kbordercolor,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.borderRadius(2.5)),
                      borderSide: const BorderSide(
                        color: Appcolors.kprimarycolor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                
                ResponsiveSizedBox.height20,
                
                // Attachments section using Custom File Picker
                TextStyles.caption(
                  text: 'Attachments',
                  color: Appcolors.kblackcolor,
                  weight: FontWeight.w600,
                ),
                ResponsiveSizedBox.height10,
                
                CustomFilePicker(
                  attachedFiles: attachedFiles,
                  onFilesChanged: (files) {
                    setState(() {
                      attachedFiles = files;
                    });
                  },
                ),
                
                ResponsiveSizedBox.height40,
                
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: ResponsiveUtils.hp(6),
                  child: ElevatedButton(
                    onPressed: _submitLeave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Appcolors.kprimarycolor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.borderRadius(2.5)),
                      ),
                      elevation: 2,
                    ),
                    child: TextStyles.body(
                      text: 'Submit Leave',
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