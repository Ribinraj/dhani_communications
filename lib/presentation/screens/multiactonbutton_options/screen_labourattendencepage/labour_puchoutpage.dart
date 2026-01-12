import 'package:camera/camera.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/widgets/custom_camera.dart';
import 'package:dhani_communications/widgets/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:dhani_communications/core/responsiveutils.dart';

class LabourPunchOutPage extends StatefulWidget {
  const LabourPunchOutPage({super.key});

  @override
  State<LabourPunchOutPage> createState() => _LabourPunchOutPageState();
}

class _LabourPunchOutPageState extends State<LabourPunchOutPage> {
  final _formKey = GlobalKey<FormState>();
  final _cameraKey = GlobalKey<CustomCameraWidgetState>();
  
  String? _selectedLabour;
  
  // Sample punched-in labour list - replace with your actual data
  final List<String> _punchedInLabours = [
    'John Doe - Mason',
    'Jane Smith - Carpenter',
    'Mike Johnson - Electrician',
    'Sarah Williams - Plumber',
    'David Brown - Painter',
    'Robert Davis - Helper',
    'Emily Wilson - Welder',
  ];

  @override
  void _punchOutLabour() async {
    if (_formKey.currentState!.validate()) {
      // Capture image when button is clicked
      final capturedImage = await _cameraKey.currentState?.captureImage();
      
      if (capturedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to capture image. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // TODO: Implement labour punch out logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Labour punched out successfully!'),
          backgroundColor: Color(0xFF49CF41),
        ),
      );

      // Reset form if needed
      // _formKey.currentState!.reset();
      // setState(() {
      //   _selectedLabour = null;
      // });
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
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Appcolors.kprimarycolor,
            size: ResponsiveUtils.sp(5),
          ),
        ),
        title: TextStyles.subheadline(
          text: 'Labour Punch Out',
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
                      // Image captured callback - you can use this for additional logic
                      debugPrint('Image captured: ${image.path}');
                    },
                    height: ResponsiveUtils.wp(60),
                    width: ResponsiveUtils.wp(60),
                  ),
                ),
                
                SizedBox(height: ResponsiveUtils.hp(4)),

                // Punched In Labour Dropdown
                CustomDropdown(
                  value: _selectedLabour,
                  hint: 'Select Punched In Labour',
                  items: _punchedInLabours,
                  onChanged: (value) {
                    setState(() {
                      _selectedLabour = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a labour';
                    }
                    return null;
                  },
                ),

                SizedBox(height: ResponsiveUtils.hp(4)),

                // Punch Out Button
                SizedBox(
                  width: double.infinity,
                  height: ResponsiveUtils.hp(6.5),
                  child: ElevatedButton(
                    onPressed: _punchOutLabour,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F8FDF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(2.5),
                        ),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      'Punch Out',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(4.2),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}