import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/features/auth/models/profile_model.dart';
import 'package:dhani_communications/features/auth/blocs/update_profile_bloc/update_profile_bloc.dart';
import 'package:dhani_communications/presentation/screens/screen_dashboard.dart/widgets/paint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dhani_communications/core/appconstants.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';

class ScreenEditProfilePage extends StatefulWidget {
  final ProfileData? profileData;

  const ScreenEditProfilePage({
    super.key,
    this.profileData,
  });

  @override
  State<ScreenEditProfilePage> createState() => _ScreenEditProfilePageState();
}

class _ScreenEditProfilePageState extends State<ScreenEditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers - Editable fields only
  late TextEditingController _motherNameController;
  late TextEditingController _fatherNameController;
  late TextEditingController _bloodGroupController;
  late TextEditingController _dobController;
  late TextEditingController _qualificationController;
  late TextEditingController _maritalStatusController;
  late TextEditingController _childrenController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _aadharController;
  late TextEditingController _panController;
  late TextEditingController _dlController;
  late TextEditingController _esicController;
  late TextEditingController _personalInsuranceController;
  late TextEditingController _healthInsuranceController;
  late TextEditingController _accidentalInsuranceController;
  late TextEditingController _pmjjInsuranceController;
  late TextEditingController _pmjjbyController;
  late TextEditingController _pmsbiController;
  late TextEditingController _paiSbi1000Controller;
  late TextEditingController _paiSbi500Controller;
  late TextEditingController _presentAddressController;
  late TextEditingController _permanentAddressController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final profile = widget.profileData?.profile;

    _motherNameController = TextEditingController(text: profile?.motherName ?? '');
    _fatherNameController = TextEditingController(text: profile?.fatherName ?? '');
    _bloodGroupController = TextEditingController(text: profile?.bloodGroup ?? '');
    _dobController = TextEditingController(text: profile?.dateOfBirth ?? '');
    _qualificationController = TextEditingController(text: profile?.highestQualification ?? '');
    _maritalStatusController = TextEditingController(text: profile?.martialStatus ?? '');
    _childrenController = TextEditingController(text: profile?.noOfChildren ?? '');
    _heightController = TextEditingController(text: profile?.height ?? '');
    _weightController = TextEditingController(text: profile?.weight ?? '');
    _aadharController = TextEditingController(text: profile?.adhaarNumber ?? '');
    _panController = TextEditingController(text: profile?.panNumber ?? '');
    _dlController = TextEditingController(text: profile?.drivingLicenseNumber ?? '');
    _esicController = TextEditingController(text: profile?.esicNumber ?? '');
    _personalInsuranceController = TextEditingController(text: profile?.personalInsurance ?? '');
    _healthInsuranceController = TextEditingController(text: profile?.healthInsurance ?? '');
    _accidentalInsuranceController = TextEditingController(text: profile?.accidentalInsurance ?? '');
    _pmjjInsuranceController = TextEditingController(text: profile?.pmjjInsurance ?? '');
    _pmjjbyController = TextEditingController(text: profile?.pmjjby436 ?? '');
    _pmsbiController = TextEditingController(text: profile?.pmsbi20 ?? '');
    _paiSbi1000Controller = TextEditingController(text: profile?.paiSbi1000 ?? '');
    _paiSbi500Controller = TextEditingController(text: profile?.paiSbi500 ?? '');
    _presentAddressController = TextEditingController(text: profile?.presentAddress ?? '');
    _permanentAddressController = TextEditingController(text: profile?.permanentAddess ?? '');
  }

  @override
  void dispose() {
    _motherNameController.dispose();
    _fatherNameController.dispose();
    _bloodGroupController.dispose();
    _dobController.dispose();
    _qualificationController.dispose();
    _maritalStatusController.dispose();
    _childrenController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _aadharController.dispose();
    _panController.dispose();
    _dlController.dispose();
    _esicController.dispose();
    _personalInsuranceController.dispose();
    _healthInsuranceController.dispose();
    _accidentalInsuranceController.dispose();
    _pmjjInsuranceController.dispose();
    _pmjjbyController.dispose();
    _pmsbiController.dispose();
    _paiSbi1000Controller.dispose();
    _paiSbi500Controller.dispose();
    _presentAddressController.dispose();
    _permanentAddressController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'motherName': _motherNameController.text,
        'fatherName': _fatherNameController.text,
        'bloodGroup': _bloodGroupController.text,
        'dateOfBirth': _dobController.text,
        'highestQualification': _qualificationController.text,
        'martialStatus': _maritalStatusController.text,
        'noOfChildren': _childrenController.text.isNotEmpty 
            ? int.tryParse(_childrenController.text) ?? 0 
            : 0,
        'height': _heightController.text,
        'weight': _weightController.text,
        'adhaarNumber': _aadharController.text,
        'panNumber': _panController.text,
        'drivingLicenseNumber': _dlController.text,
        'esicNumber': _esicController.text,
        'personalInsurance': _personalInsuranceController.text,
        'healthInsurance': _healthInsuranceController.text,
        'accidentalInsurance': _accidentalInsuranceController.text,
        'pmjj_insurance': _pmjjInsuranceController.text,
        'pmjjby_436': _pmjjbyController.text,
        'pmsbi_20': _pmsbiController.text,
        'pai_sbi_1000': _paiSbi1000Controller.text,
        'pai_sbi_500': _paiSbi500Controller.text,
        'presentAddress': _presentAddressController.text,
        'permanentAddess': _permanentAddressController.text,
      };

      context.read<UpdateProfileBloc>().add(
            SubmitUpdateProfileEvent(profileData: updatedData),
          );
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              duration: Duration(milliseconds: 1500),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              margin: EdgeInsets.only(
                bottom: ResponsiveUtils.hp(2),
                left: ResponsiveUtils.wp(4),
                right: ResponsiveUtils.wp(4),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusStyles.kradius10(),
              ),
            ),
          );
          // Return true to indicate profile was updated
          Navigator.pop(context, true);
        } else if (state is UpdateProfileErrorState) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              duration: Duration(milliseconds: 2000),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              margin: EdgeInsets.only(
                bottom: ResponsiveUtils.hp(2),
                left: ResponsiveUtils.wp(4),
                right: ResponsiveUtils.wp(4),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusStyles.kradius10(),
              ),
            ),
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
                        // Identification Section
                        _buildIdentificationSection(),
                        ResponsiveSizedBox.height20,
                        // Insurance Section
                        _buildInsuranceSection(),
                        ResponsiveSizedBox.height20,
                        // Address Section
                        _buildAddressSection(),
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
                  border: Border.all(
                    color: Appcolors.kprimarycolor,
                    width: 4,
                  ),
                ),
                child: CircleAvatar(
                  radius: ResponsiveUtils.wp(15),
                  backgroundColor: Appcolors.kgreyColor.withOpacity(0.2),
                  backgroundImage: profile?.profilePicture != null &&
                          profile!.profilePicture!.isNotEmpty
                      ? NetworkImage(profile.profilePicture!)
                      : null,
                  child: profile?.profilePicture == null ||
                          profile!.profilePicture!.isEmpty
                      ? Icon(
                          Icons.person,
                          size: ResponsiveUtils.wp(15),
                          color: Appcolors.kprimarycolor,
                        )
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Change profile picture'),
                        duration: Duration(milliseconds: 800),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Appcolors.kprimarycolor,
                        margin: EdgeInsets.only(
                          bottom: ResponsiveUtils.hp(2),
                          left: ResponsiveUtils.wp(4),
                          right: ResponsiveUtils.wp(4),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusStyles.kradius10(),
                        ),
                      ),
                    );
                  },
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
        _buildTextField('Date of Birth', _dobController, Icons.calendar_today_outlined, isDateField: true),
        _buildTextField('Blood Group', _bloodGroupController, Icons.bloodtype_outlined),
        _buildTextField('Mother\'s Name', _motherNameController, Icons.person_outline),
        _buildTextField('Father\'s Name', _fatherNameController, Icons.person_outline),
        _buildTextField('Qualification', _qualificationController, Icons.school_outlined),
        _buildTextField('Marital Status', _maritalStatusController, Icons.favorite_outline),
        _buildTextField('Number of Children', _childrenController, Icons.child_care_outlined, keyboardType: TextInputType.number),
        _buildTextField('Height (cm)', _heightController, Icons.height_outlined, keyboardType: TextInputType.number),
        _buildTextField('Weight (kg)', _weightController, Icons.monitor_weight_outlined, keyboardType: TextInputType.number),
      ],
    );
  }

  Widget _buildIdentificationSection() {
    return _buildSection(
      title: 'Identification Details',
      icon: Icons.badge_rounded,
      children: [
        _buildTextField('Aadhar Number', _aadharController, Icons.credit_card_outlined),
        _buildTextField('PAN Number', _panController, Icons.credit_card_outlined),
        _buildTextField('DL Number', _dlController, Icons.directions_car_outlined),
        _buildTextField('ESIC Number', _esicController, Icons.medical_services_outlined),
      ],
    );
  }

  Widget _buildInsuranceSection() {
    return _buildSection(
      title: 'Insurance Details',
      icon: Icons.security_rounded,
      children: [
        _buildTextField('Personal Insurance', _personalInsuranceController, Icons.security_outlined),
        _buildTextField('Health Insurance', _healthInsuranceController, Icons.health_and_safety_outlined),
        _buildTextField('Accidental Insurance', _accidentalInsuranceController, Icons.local_hospital_outlined),
        _buildTextField('PMJJ Insurance', _pmjjInsuranceController, Icons.account_balance_outlined),
        _buildTextField('PMJJBY @₹436', _pmjjbyController, Icons.account_balance_outlined),
        _buildTextField('PMSBI @₹20', _pmsbiController, Icons.account_balance_outlined),
        _buildTextField('PAI_SBI @₹1000', _paiSbi1000Controller, Icons.account_balance_outlined),
        _buildTextField('PAI_SBI @₹500', _paiSbi500Controller, Icons.account_balance_outlined),
      ],
    );
  }

  Widget _buildAddressSection() {
    return _buildSection(
      title: 'Address Information',
      icon: Icons.location_on_outlined,
      children: [
        _buildTextField('Present Address', _presentAddressController, Icons.home_outlined, maxLines: 3),
        _buildTextField('Permanent Address', _permanentAddressController, Icons.location_on_outlined, maxLines: 3),
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
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
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
            borderSide: BorderSide(color: Appcolors.kgreyColor.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadiusStyles.kradius10(),
            borderSide: BorderSide(color: Appcolors.kgreyColor.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadiusStyles.kradius10(),
            borderSide: BorderSide(color: Appcolors.kprimarycolor, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadiusStyles.kradius10(),
            borderSide: BorderSide(color: Appcolors.kgreyColor.withOpacity(0.2)),
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
              text: 'Save Changes',
              weight: FontWeight.bold,
              color: Appcolors.kwhitecolor,
            ),
          ],
        ),
      ),
    );
  }
}
