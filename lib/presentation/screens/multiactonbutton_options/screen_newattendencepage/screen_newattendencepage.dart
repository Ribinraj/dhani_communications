import 'package:camera/camera.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/widgets/custom_camera.dart';
import 'package:dhani_communications/widgets/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:dhani_communications/core/responsiveutils.dart';




class DailyAttendancePage extends StatefulWidget {
  const DailyAttendancePage({super.key});

  @override
  State<DailyAttendancePage> createState() => _DailyAttendancePageState();
}

class _DailyAttendancePageState extends State<DailyAttendancePage> {
  final _formKey = GlobalKey<FormState>();
  final _remarksController = TextEditingController();
  final _cameraKey = GlobalKey<CustomCameraWidgetState>();
  
  String? _selectedProject;
  
  // Sample project list - replace with your actual data
  final List<String> _projects = [
    'Project Alpha',
    'Project Beta',
    'Project Gamma',
    'Project Delta',
    'Project Epsilon',
  ];

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  void _recordAttendance() async {
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

      // TODO: Implement attendance recording logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Attendance recorded successfully!'),
          backgroundColor: Color(0xFF49CF41),
        ),
      );

      // Reset form if needed
      // _formKey.currentState!.reset();
      // setState(() {
      //   _capturedImage = null;
      //   _selectedProject = null;
      // });
      // _remarksController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar:AppBar(
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
                      // Image captured callback - you can use this for additional logic
                      debugPrint('Image captured: ${image.path}');
                    },
                    height: ResponsiveUtils.wp(60),
                    width: ResponsiveUtils.wp(60),
                  ),
                ),
                
                SizedBox(height: ResponsiveUtils.hp(4)),

                // Project Dropdown
                CustomDropdown(
                  value: _selectedProject,
                  hint: 'Select Project',
                  items: _projects,
                  onChanged: (value) {
                    setState(() {
                      _selectedProject = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a project';
                    }
                    return null;
                  },
                ),

                SizedBox(height: ResponsiveUtils.hp(3)),

                // Remarks Field
                TextFormField(
                  controller: _remarksController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter remarks (optional)',
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: ResponsiveUtils.sp(3.5),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.wp(4),
                      vertical: ResponsiveUtils.hp(2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.borderRadius(2.5),
                      ),
                      borderSide: const BorderSide(
                        color: Color(0xFF59CBEF),
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.borderRadius(2.5),
                      ),
                      borderSide: const BorderSide(
                        color: Color(0xFF59CBEF),
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.borderRadius(2.5),
                      ),
                      borderSide: const BorderSide(
                        color: Color(0xFF4F8FDF),
                        width: 2,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(3.5),
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: ResponsiveUtils.hp(4)),

                // Record Attendance Button
                SizedBox(
                  width: double.infinity,
                  height: ResponsiveUtils.hp(6.5),
                  child: ElevatedButton(
                    onPressed: _recordAttendance,
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
                      'Record Attendance',
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