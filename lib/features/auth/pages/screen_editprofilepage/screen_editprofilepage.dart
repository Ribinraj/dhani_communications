import 'dart:convert';
import 'dart:io';

import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/features/auth/models/profile_model.dart';
import 'package:dhani_communications/features/auth/blocs/update_profile_bloc/update_profile_bloc.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_dashboard.dart/widgets/paint.dart';
import 'package:dhani_communications/widgets/custom_dropdown.dart';
import 'package:dhani_communications/widgets/custom_image_picker.dart';
import 'package:dhani_communications/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dhani_communications/core/appconstants.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';

class ScreenEditProfilePage extends StatefulWidget {
  final ProfileData? profileData;

  const ScreenEditProfilePage({super.key, this.profileData});

  @override
  State<ScreenEditProfilePage> createState() => _ScreenEditProfilePageState();
}

class _ScreenEditProfilePageState extends State<ScreenEditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Profile photo
  File? _selectedProfilePhoto;

  // Dropdown values
  String? _selectedBloodGroup;
  String? _selectedMaritalStatus;

  // Text Controllers - Editable fields matching the React Native code
  late TextEditingController _childrenController;
  late TextEditingController _presentAddressController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _personalInsuranceController;
  late TextEditingController _accidentalInsuranceController;
  late TextEditingController _healthInsuranceController;
  late TextEditingController _pmjjbyController;
  late TextEditingController _pmsbiController;
  late TextEditingController _paiSbi1000Controller;
  late TextEditingController _paiSbi500Controller;

  bool _isLoading = false;

  // Blood group options
  final List<String> _bloodGroupList = [
    'A',
    'A+',
    'A-',
    'B',
    'B+',
    'B-',
    'AB',
    'AB+',
    'AB-',
    'O',
    'O+',
    'O-',
  ];

  // Marital status options
  final List<String> _maritalStatusList = [
    'SINGLE',
    'MARRIED',
    'DIVORCED',
    'OTHERS',
  ];

  // Display labels for marital status
  String _getMaritalStatusLabel(String value) {
    switch (value) {
      case 'SINGLE':
        return 'Single';
      case 'MARRIED':
        return 'Married';
      case 'DIVORCED':
        return 'Divorced';
      case 'OTHERS':
        return 'Others';
      default:
        return value;
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final profile = widget.profileData?.profile;

    // Initialize dropdown values
    _selectedBloodGroup =
        (profile?.bloodGroup != null &&
            profile!.bloodGroup!.isNotEmpty &&
            _bloodGroupList.contains(profile.bloodGroup))
        ? profile.bloodGroup
        : null;

    _selectedMaritalStatus =
        (profile?.martialStatus != null &&
            profile!.martialStatus!.isNotEmpty &&
            _maritalStatusList.contains(profile.martialStatus))
        ? profile.martialStatus
        : null;

    // Initialize text controllers
    _childrenController = TextEditingController(
      text: profile?.noOfChildren ?? '',
    );
    _presentAddressController = TextEditingController(
      text: profile?.presentAddress ?? '',
    );
    _heightController = TextEditingController(text: profile?.height ?? '');
    _weightController = TextEditingController(text: profile?.weight ?? '');
    _personalInsuranceController = TextEditingController(
      text: profile?.personalInsurance ?? '',
    );
    _accidentalInsuranceController = TextEditingController(
      text: profile?.accidentalInsurance ?? '',
    );
    _healthInsuranceController = TextEditingController(
      text: profile?.healthInsurance ?? '',
    );
    _pmjjbyController = TextEditingController(text: profile?.pmjjby436 ?? '');
    _pmsbiController = TextEditingController(text: profile?.pmsbi20 ?? '');
    _paiSbi1000Controller = TextEditingController(
      text: profile?.paiSbi1000 ?? '',
    );
    _paiSbi500Controller = TextEditingController(
      text: profile?.paiSbi500 ?? '',
    );
  }

  @override
  void dispose() {
    _childrenController.dispose();
    _presentAddressController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _personalInsuranceController.dispose();
    _accidentalInsuranceController.dispose();
    _healthInsuranceController.dispose();
    _pmjjbyController.dispose();
    _pmsbiController.dispose();
    _paiSbi1000Controller.dispose();
    _paiSbi500Controller.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final updatedData = <String, dynamic>{
        'martialStatus': _selectedMaritalStatus ?? '',
        'noOfChildren': _childrenController.text,
        'presentAddress': _presentAddressController.text,
        'height': _heightController.text,
        'weight': _weightController.text,
        'bloodGroup': _selectedBloodGroup ?? '',
        'personalInsurance': _personalInsuranceController.text,
        'accidentalInsurance': _accidentalInsuranceController.text,
        'healthInsurance': _healthInsuranceController.text,
        'pmjjby_436': _pmjjbyController.text,
        'pmsbi_20': _pmsbiController.text,
        'pai_sbi_1000': _paiSbi1000Controller.text,
        'pai_sbi_500': _paiSbi500Controller.text,
      };

      // Include profile photo if one was selected
      if (_selectedProfilePhoto != null) {
        try {
          final bytes = await _selectedProfilePhoto!.readAsBytes();
          final base64Image = base64Encode(bytes);
          final fileName = _selectedProfilePhoto!.path.split('/').last;
          updatedData['profilePhoto'] = base64Image;
          updatedData['fileName'] = fileName;
        } catch (e) {
          debugPrint('Error converting photo to base64: $e');
        }
      }

      if (mounted) {
        context.read<UpdateProfileBloc>().add(
          SubmitUpdateProfileEvent(profileData: updatedData),
        );
      }
    }
  }

  Future<void> _onChangeProfilePhoto() async {
    final file = await CustomImagePicker.show(context);
    if (file != null) {
      setState(() {
        _selectedProfilePhoto = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<UpdateProfileBloc, UpdateProfileState>(
      listener: (context, state) {
        if (state is UpdateProfileLoadingState) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is UpdateProfileSuccessState) {
          setState(() {
            _isLoading = false;
          });
          CustomSnackbar.show(
            context: context,
            message: state.message,
            type: SnackBarType.success,
          );
          Navigator.pop(context, true);
        } else if (state is UpdateProfileErrorState) {
          setState(() {
            _isLoading = false;
          });
          CustomSnackbar.show(
            context: context,
            message: state.message,
            type: SnackBarType.error,
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Custom Paint Background
            CustomPaint(
              painter: HomeBackgroundPainter(),
              size: Size(screenWidth, screenHeight),
            ),
            // Main Content
            CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  expandedHeight: 0,
                  floating: false,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: Appcolors.kwhitecolor.withOpacity(0.95),
                  elevation: 2,
                  shadowColor: Appcolors.kgreyColor.withOpacity(0.1),
                  flexibleSpace: _buildAppBar(),
                ),
                // Form Content
                SliverToBoxAdapter(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ResponsiveSizedBox.height20,
                        // Profile Picture Editor
                        _buildProfilePictureEditor(),
                        ResponsiveSizedBox.height30,
                        // Personal Info Section
                        _buildPersonalInfoSection(),
                        ResponsiveSizedBox.height20,
                        // Insurance Section
                        _buildInsuranceSection(),
                        ResponsiveSizedBox.height20,
                        // Mandatory note
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUtils.wp(4),
                          ),
                          child: TextStyles.caption(
                            text: '* marked fields are mandatory',
                            color: Appcolors.kgreyColor,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ResponsiveSizedBox.height20,
                        // Save Button
                        _buildSaveButton(),
                        ResponsiveSizedBox.height(15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Loading Overlay
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(ResponsiveUtils.wp(6)),
                    decoration: BoxDecoration(
                      color: Appcolors.kwhitecolor,
                      borderRadius: BorderRadiusStyles.kradius15(),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: Appcolors.kprimarycolor,
                        ),
                        ResponsiveSizedBox.height15,
                        TextStyles.medium(
                          text: 'Updating profile...',
                          color: Appcolors.kblackcolor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + ResponsiveUtils.hp(1),
        left: ResponsiveUtils.wp(4),
        right: ResponsiveUtils.wp(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Image.asset(
                  Appconstants.applogo,
                  height: ResponsiveUtils.hp(5),
                ),
                ResponsiveSizedBox.width(3),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextStyles.subheadline(
                        text: 'Edit Profile',
                        weight: FontWeight.bold,
                        color: Appcolors.kblackcolor,
                        overflow: TextOverflow.ellipsis,
                      ),
                      TextStyles.caption(
                        text: 'Update your information',
                        color: Appcolors.kgreyColor.withOpacity(0.7),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded),
            color: Appcolors.kprimarycolor,
            iconSize: ResponsiveUtils.sp(6.5),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePictureEditor() {
    final profile = widget.profileData?.profile;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.wp(4)),
      padding: EdgeInsets.all(ResponsiveUtils.wp(6)),
      decoration: BoxDecoration(
        color: Appcolors.kwhitecolor,
        borderRadius: BorderRadiusStyles.kradius20(),
        boxShadow: [
          BoxShadow(
            color: Appcolors.kgreyColor.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Appcolors.kprimarycolor, width: 4),
                ),
                child: CircleAvatar(
                  radius: ResponsiveUtils.wp(15),
                  backgroundColor: Appcolors.kgreyColor.withOpacity(0.2),
                  backgroundImage: _selectedProfilePhoto != null
                      ? FileImage(_selectedProfilePhoto!)
                      : (profile?.profilePicture != null &&
                                profile!.profilePicture!.isNotEmpty
                            ? NetworkImage(profile.profilePicture!)
                            : null),
                  child:
                      (_selectedProfilePhoto == null &&
                          (profile?.profilePicture == null ||
                              profile!.profilePicture!.isEmpty))
                      ? Icon(
                          Icons.person,
                          size: ResponsiveUtils.wp(15),
                          color: Appcolors.kprimarycolor,
                        )
                      : null,
                ),
              ),

              // Camera button
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _onChangeProfilePhoto,
                  child: Container(
                    padding: EdgeInsets.all(ResponsiveUtils.wp(2.5)),
                    decoration: BoxDecoration(
                      color: Appcolors.kprimarycolor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Appcolors.kwhitecolor,
                        width: 3,
                      ),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: ResponsiveUtils.sp(4.5),
                      color: Appcolors.kwhitecolor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          ResponsiveSizedBox.height15,
          TextStyles.body(
            text: widget.profileData?.employeeName ?? 'User',
            weight: FontWeight.bold,
            color: Appcolors.kblackcolor,
          ),
          ResponsiveSizedBox.height5,
          TextStyles.caption(
            text: 'EMP ID: #${widget.profileData?.employeeId ?? '-'}',
            color: Appcolors.kgreyColor,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return _buildSection(
      title: 'Personal Information',
      icon: Icons.person_outline_rounded,
      children: [
        // Marital Status Dropdown
        _buildDropdownField(
          label: 'Marital Status*',
          value: _selectedMaritalStatus,
          items: _maritalStatusList,
          hint: 'Select Marital Status',
          onChanged: (value) {
            setState(() {
              _selectedMaritalStatus = value;
            });
          },
          displayMapper: _getMaritalStatusLabel,
        ),
        ResponsiveSizedBox.height15,

        // Number of Children
        _buildTextField(
          'Number of Children*',
          _childrenController,
          Icons.child_care_outlined,
          keyboardType: TextInputType.number,
        ),

        // Present Address
        _buildTextField(
          'Present Address*',
          _presentAddressController,
          Icons.home_outlined,
          maxLines: 2,
        ),

        // Height
        _buildTextField(
          'Height (Feet & Inches)*',
          _heightController,
          Icons.height_outlined,
          keyboardType: TextInputType.number,
        ),

        // Weight
        _buildTextField(
          'Weight (KG)*',
          _weightController,
          Icons.monitor_weight_outlined,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildInsuranceSection() {
    return _buildSection(
      title: 'Insurance Details',
      icon: Icons.security_rounded,
      children: [
        _buildTextField(
          'Personal Insurance',
          _personalInsuranceController,
          Icons.security_outlined,
        ),
        _buildTextField(
          'Accidental Insurance',
          _accidentalInsuranceController,
          Icons.local_hospital_outlined,
        ),
        _buildTextField(
          'Health Insurance',
          _healthInsuranceController,
          Icons.health_and_safety_outlined,
        ),
        _buildTextField(
          'PMJJBY@436',
          _pmjjbyController,
          Icons.account_balance_outlined,
        ),
        _buildTextField(
          'PMSBY@20',
          _pmsbiController,
          Icons.account_balance_outlined,
        ),
        _buildTextField(
          'PAI_SBI@1000',
          _paiSbi1000Controller,
          Icons.account_balance_outlined,
        ),
        _buildTextField(
          'PAI_SBI@500',
          _paiSbi500Controller,
          Icons.account_balance_outlined,
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.wp(4)),
      decoration: BoxDecoration(
        color: Appcolors.kwhitecolor,
        borderRadius: BorderRadiusStyles.kradius15(),
        boxShadow: [
          BoxShadow(
            color: Appcolors.kgreyColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
            decoration: BoxDecoration(
              color: Appcolors.kprimarycolor.withOpacity(0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(ResponsiveUtils.borderRadius(3.75)),
                topRight: Radius.circular(ResponsiveUtils.borderRadius(3.75)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
                  decoration: BoxDecoration(
                    color: Appcolors.kprimarycolor,
                    borderRadius: BorderRadiusStyles.kradius10(),
                  ),
                  child: Icon(
                    icon,
                    color: Appcolors.kwhitecolor,
                    size: ResponsiveUtils.sp(5),
                  ),
                ),
                ResponsiveSizedBox.width(3),
                TextStyles.subheadline(
                  text: title,
                  weight: FontWeight.bold,
                  color: Appcolors.kblackcolor,
                ),
              ],
            ),
          ),
          // Section Content
          Padding(
            padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required String hint,
    required Function(String?) onChanged,
    String Function(String)? displayMapper,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextStyles.caption(
          text: label,
          color: Appcolors.kblackcolor,
          weight: FontWeight.w600,
        ),
        ResponsiveSizedBox.height5,
        CustomDropdown(
          value: value,
          hint: hint,
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool enabled = true,
    bool isDateField = false,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveUtils.hp(2)),
      child: TextFormField(
        controller: controller,
        enabled: enabled && !_isLoading,
        keyboardType: keyboardType,
        maxLines: maxLines,
        readOnly: isDateField,
        onTap: isDateField
            ? () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1950),
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
                if (date != null) {
                  controller.text =
                      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                }
              }
            : null,
        style: TextStyle(
          fontSize: ResponsiveUtils.sp(3.5),
          fontWeight: FontWeight.w500,
          color: enabled ? Appcolors.kblackcolor : Appcolors.kgreyColor,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: ResponsiveUtils.sp(3.5),
            color: Appcolors.kgreyColor,
          ),
          prefixIcon: Icon(
            icon,
            color: Appcolors.kprimarycolor,
            size: ResponsiveUtils.sp(5),
          ),
          suffixIcon: isDateField
              ? Icon(
                  Icons.calendar_today,
                  color: Appcolors.kprimarycolor,
                  size: ResponsiveUtils.sp(4.5),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadiusStyles.kradius10(),
            borderSide: BorderSide(
              color: Appcolors.kgreyColor.withOpacity(0.3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadiusStyles.kradius10(),
            borderSide: BorderSide(
              color: Appcolors.kgreyColor.withOpacity(0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadiusStyles.kradius10(),
            borderSide: BorderSide(color: Appcolors.kprimarycolor, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadiusStyles.kradius10(),
            borderSide: BorderSide(
              color: Appcolors.kgreyColor.withOpacity(0.2),
            ),
          ),
          filled: !enabled,
          fillColor: enabled ? null : Appcolors.kgreyColor.withOpacity(0.05),
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.wp(4),
            vertical: ResponsiveUtils.hp(1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.wp(4)),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Appcolors.kprimarycolor,
          disabledBackgroundColor: Appcolors.kprimarycolor.withOpacity(0.5),
          minimumSize: Size(double.infinity, ResponsiveUtils.hp(6)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusStyles.kradius15(),
          ),
          elevation: 5,
          shadowColor: Appcolors.kprimarycolor.withOpacity(0.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.save_rounded,
              color: Appcolors.kwhitecolor,
              size: ResponsiveUtils.sp(5.5),
            ),
            ResponsiveSizedBox.width(2),
            TextStyles.subheadline(
              text: 'Update Profile',
              weight: FontWeight.bold,
              color: Appcolors.kwhitecolor,
            ),
          ],
        ),
      ),
    );
  }
}
