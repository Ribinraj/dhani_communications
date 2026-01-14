import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:dhani_communications/core/responsiveutils.dart';

import 'package:dhani_communications/widgets/custom_dropdown.dart';

import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';

class ScreenNewexpensepage extends StatefulWidget {
  const ScreenNewexpensepage({super.key});

  @override
  State<ScreenNewexpensepage> createState() => _ScreenExpensePageState();
}

class _ScreenExpensePageState extends State<ScreenNewexpensepage> {
  final _formKey = GlobalKey<FormState>();
  
  String? selectedProject;
  String? selectedExpenseCategory;
  String? selectedBillType;
  DateTime? selectedDate;
  
  final TextEditingController expenseDateController = TextEditingController();
  final TextEditingController expenseAmountController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  
  List<PlatformFile> attachedFiles = [];

  // Sample data - replace with your actual data
  final List<String> projects = ['Project A', 'Project B', 'Project C', 'Project D'];
  final List<String> expenseCategories = [
    'Transportation',
    'Food & Accommodation',
    'Materials',
    'Equipment',
    'Labor',
    'Others'
  ];
  final List<String> billTypes = [
    'Invoice',
    'Receipt',
    'Bill',
    'Voucher',
    'Other'
  ];

  @override
  void dispose() {
    expenseDateController.dispose();
    expenseAmountController.dispose();
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
    
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        expenseDateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
      );

      if (result != null) {
        setState(() {
          attachedFiles.addAll(result.files);
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${result.files.length} file(s) attached successfully!'),
            backgroundColor: Appcolors.ksecondarycolor,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error picking files'),
          backgroundColor: Appcolors.kredcolor,
        ),
      );
    }
  }

  void _removeFile(int index) {
    setState(() {
      attachedFiles.removeAt(index);
    });
  }

  void _submitExpense() {
    if (_formKey.currentState!.validate()) {
      // Handle form submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Expense submitted for approval successfully!'),
          backgroundColor: Appcolors.ksecondarycolor,
        ),
      );
      
      // Add your submission logic here
      print('Project: $selectedProject');
      print('Expense Date: ${expenseDateController.text}');
      print('Expense Category: $selectedExpenseCategory');
      print('Bill Type: $selectedBillType');
      print('Expense Amount: ${expenseAmountController.text}');
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
          text: 'Expense Submission',
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
                  text: 'Please fill the form, attach your bills and submit your expenses for approval',
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
                
                // Expense Date
                TextStyles.caption(
                  text: 'Expense Date',
                  color: Appcolors.kblackcolor,
                  weight: FontWeight.w600,
                ),
                ResponsiveSizedBox.height10,
                TextFormField(
                  controller: expenseDateController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: InputDecoration(
                    hintText: 'Select Expense Date',
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
                      return 'Please select expense date';
                    }
                    return null;
                  },
                ),
                
                ResponsiveSizedBox.height20,
                
                // Expense Category dropdown
                TextStyles.caption(
                  text: 'Expense Category',
                  color: Appcolors.kblackcolor,
                  weight: FontWeight.w600,
                ),
                ResponsiveSizedBox.height10,
                CustomDropdown(
                  value: selectedExpenseCategory,
                  hint: 'Select Expense Category',
                  items: expenseCategories,
                  onChanged: (value) {
                    setState(() {
                      selectedExpenseCategory = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select expense category';
                    }
                    return null;
                  },
                ),
                
                ResponsiveSizedBox.height20,
                
                // Bill Type dropdown
                TextStyles.caption(
                  text: 'Bill Type',
                  color: Appcolors.kblackcolor,
                  weight: FontWeight.w600,
                ),
                ResponsiveSizedBox.height10,
                CustomDropdown(
                  value: selectedBillType,
                  hint: 'Select Bill Type',
                  items: billTypes,
                  onChanged: (value) {
                    setState(() {
                      selectedBillType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select bill type';
                    }
                    return null;
                  },
                ),
                
                ResponsiveSizedBox.height20,
                
                // Expense Amount
                TextStyles.caption(
                  text: 'Expense Amount',
                  color: Appcolors.kblackcolor,
                  weight: FontWeight.w600,
                ),
                ResponsiveSizedBox.height10,
                TextFormField(
                  controller: expenseAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter Expense Amount',
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
                      return 'Please enter expense amount';
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
                
                ResponsiveSizedBox.height20,
                
                // Add Attachment section
                TextStyles.caption(
                  text: 'Attachments',
                  color: Appcolors.kblackcolor,
                  weight: FontWeight.w600,
                ),
                ResponsiveSizedBox.height10,
                
                // Add Attachment Button
                InkWell(
                  onTap: _pickFiles,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.wp(4),
                      vertical: ResponsiveUtils.hp(2),
                    ),
                    decoration: BoxDecoration(
                      color: Appcolors.kwhitecolor,
                      borderRadius: BorderRadius.circular(ResponsiveUtils.borderRadius(2.5)),
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
                      borderRadius: BorderRadius.circular(ResponsiveUtils.borderRadius(2.5)),
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
                            padding: EdgeInsets.only(bottom: ResponsiveUtils.hp(1)),
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
                
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: ResponsiveUtils.hp(6),
                  child: ElevatedButton(
                    onPressed: _submitExpense,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Appcolors.kprimarycolor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.borderRadius(2.5)),
                      ),
                      elevation: 2,
                    ),
                    child: TextStyles.body(
                      text: 'Submit Expense',
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