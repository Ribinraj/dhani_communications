import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:dhani_communications/core/responsiveutils.dart';

import 'package:dhani_communications/widgets/custom_dropdown.dart';
import 'package:go_router/go_router.dart';


class ScreenNewmachineryhire extends StatefulWidget {
  const ScreenNewmachineryhire({super.key});

  @override
  State<ScreenNewmachineryhire> createState() => _ScreenMachineHirePageState();
}

class _ScreenMachineHirePageState extends State<ScreenNewmachineryhire> {
  final _formKey = GlobalKey<FormState>();
  
  String? selectedProject;
  String? selectedMachineType;
  DateTime? selectedDate;
  TimeOfDay? fromTime;
  TimeOfDay? toTime;
  
  final TextEditingController hireDateController = TextEditingController();
  final TextEditingController fromTimeController = TextEditingController();
  final TextEditingController toTimeController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  // Sample data - replace with your actual data
  final List<String> projects = ['Project A', 'Project B', 'Project C', 'Project D'];
  final List<String> machineTypes = ['Excavator', 'Bulldozer', 'Crane', 'Loader', 'Grader'];

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
        hireDateController.text = "${picked.day}/${picked.month}/${picked.year}";
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

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      // Handle form submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Machine hire request submitted successfully!'),
          backgroundColor: Appcolors.ksecondarycolor,
        ),
      );
      
      // Add your submission logic here
      print('Project: $selectedProject');
      print('Machine Type: $selectedMachineType');
      print('Hire Date: ${hireDateController.text}');
      print('From Time: ${fromTimeController.text}');
      print('To Time: ${toTimeController.text}');
      print('Total Amount: ${totalAmountController.text}');
      print('Remarks: ${remarksController.text}');
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
          text: 'New Machinery Hire',
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
                
                // Machine Type dropdown
                TextStyles.caption(
                  text: 'Machine Type',
                  color: Appcolors.kblackcolor,
                  weight: FontWeight.w600,
                ),
                ResponsiveSizedBox.height10,
                CustomDropdown(
                  value: selectedMachineType,
                  hint: 'Select Machine Type',
                  items: machineTypes,
                  onChanged: (value) {
                    setState(() {
                      selectedMachineType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a machine type';
                    }
                    return null;
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
                
                ResponsiveSizedBox.height40,
                
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: ResponsiveUtils.hp(6),
                  child: ElevatedButton(
                    onPressed: _submitRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Appcolors.kprimarycolor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.borderRadius(2.5)),
                      ),
                      elevation: 2,
                    ),
                    child: TextStyles.body(
                      text: 'Submit Request',
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