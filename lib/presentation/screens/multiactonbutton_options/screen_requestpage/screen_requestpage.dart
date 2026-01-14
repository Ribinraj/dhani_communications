import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/widgets/custom_dropdown.dart';
import 'package:dhani_communications/widgets/custom_formtextfield.dart';
import 'package:flutter/material.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';

class ScreenNewRequestPage extends StatefulWidget {
  const ScreenNewRequestPage({super.key});

  @override
  State<ScreenNewRequestPage> createState() => _ScreenNewRequestPageState();
}

class _ScreenNewRequestPageState extends State<ScreenNewRequestPage> {
  final _formKey = GlobalKey<FormState>();

  String? selectedRequestCategory;
  final TextEditingController remarksController = TextEditingController();

  /// Sample request categories (replace later with API)
  final List<String> requestCategories = [
    'Material Request',
    'Leave Request',
    'Advance Request',
    'Equipment Request',
    'Other',
  ];

  @override
  void dispose() {
    remarksController.dispose();
    super.dispose();
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request submitted for approval successfully!'),
          backgroundColor: Appcolors.ksecondarycolor,
        ),
      );

      debugPrint('Request Category: $selectedRequestCategory');
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
          text: 'New Request',
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

                /// Header text
                TextStyles.body(
                  text:
                      'Please fill the form and submit your request for approval',
                  color: Appcolors.kblackcolor,
                  weight: FontWeight.w500,
                ),

                ResponsiveSizedBox.height30,

                /// Request Category
                TextStyles.caption(
                  text: 'Request Category',
                  weight: FontWeight.w600,
                ),
                ResponsiveSizedBox.height10,
                CustomDropdown(
                  value: selectedRequestCategory,
                  hint: 'Select Request Category',
                  items: requestCategories,
                  onChanged: (value) {
                    setState(() => selectedRequestCategory = value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select request category';
                    }
                    return null;
                  },
                ),

                ResponsiveSizedBox.height20,

                /// Remarks (Optional)
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
                    onPressed: _submitRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Appcolors.kprimarycolor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(2.5),
                        ),
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
