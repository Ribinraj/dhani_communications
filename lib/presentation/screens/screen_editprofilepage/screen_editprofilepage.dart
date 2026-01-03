import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/presentation/screens/screen_dashboard.dart/widgets/paint.dart';
import 'package:flutter/material.dart';
import 'package:dhani_communications/core/appconstants.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';

class ScreenEditProfilePage extends StatefulWidget {
  final Map<String, dynamic>? profileData;

  const ScreenEditProfilePage({
    super.key,
    this.profileData,
  });

  @override
  State<ScreenEditProfilePage> createState() => _ScreenEditProfilePageState();
}

class _ScreenEditProfilePageState extends State<ScreenEditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  late TextEditingController _employeeNameController;
  late TextEditingController _positionController;
  late TextEditingController _employeeIdController;
  late TextEditingController _mobileController;
  late TextEditingController _dobController;
  late TextEditingController _dojController;
  late TextEditingController _bloodGroupController;
  late TextEditingController _motherNameController;
  late TextEditingController _fatherNameController;
  late TextEditingController _qualificationController;
  late TextEditingController _maritalStatusController;
  late TextEditingController _childrenController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _aadharController;
  late TextEditingController _panController;
  late TextEditingController _passportController;
  late TextEditingController _uanController;
  late TextEditingController _dlController;
  late TextEditingController _esicController;
  late TextEditingController _personalInsuranceController;
  late TextEditingController _healthInsuranceController;
  late TextEditingController _accidentalInsuranceController;
  late TextEditingController _pmjjbyController;
  late TextEditingController _paiSbi1000Controller;
  late TextEditingController _paiSbi500Controller;
  late TextEditingController _headquartersController;
  late TextEditingController _presentAddressController;
  late TextEditingController _permanentAddressController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final data = widget.profileData ?? {};

    _employeeNameController = TextEditingController(text: data['employeeName'] ?? '');
    _positionController = TextEditingController(text: data['position'] ?? '');
    _employeeIdController = TextEditingController(text: data['employeeId'] ?? '');
    _mobileController = TextEditingController(text: data['mobile'] ?? '');
    _dobController = TextEditingController(text: data['dob'] ?? '');
    _dojController = TextEditingController(text: data['doj'] ?? '');
    _bloodGroupController = TextEditingController(text: data['bloodGroup'] ?? '');
    _motherNameController = TextEditingController(text: data['motherName'] ?? '');
    _fatherNameController = TextEditingController(text: data['fatherName'] ?? '');
    _qualificationController = TextEditingController(text: data['qualification'] ?? '');
    _maritalStatusController = TextEditingController(text: data['maritalStatus'] ?? '');
    _childrenController = TextEditingController(text: data['children'] ?? '');
    _heightController = TextEditingController(text: data['height'] ?? '');
    _weightController = TextEditingController(text: data['weight'] ?? '');
    _aadharController = TextEditingController(text: data['aadhar'] ?? '');
    _panController = TextEditingController(text: data['pan'] ?? '');
    _passportController = TextEditingController(text: data['passport'] ?? '');
    _uanController = TextEditingController(text: data['uan'] ?? '');
    _dlController = TextEditingController(text: data['dl'] ?? '');
    _esicController = TextEditingController(text: data['esic'] ?? '');
    _personalInsuranceController = TextEditingController(text: data['personalInsurance'] ?? '');
    _healthInsuranceController = TextEditingController(text: data['healthInsurance'] ?? '');
    _accidentalInsuranceController = TextEditingController(text: data['accidentalInsurance'] ?? '');
    _pmjjbyController = TextEditingController(text: data['pmjjby'] ?? '');
    _paiSbi1000Controller = TextEditingController(text: data['paiSbi1000'] ?? '');
    _paiSbi500Controller = TextEditingController(text: data['paiSbi500'] ?? '');
    _headquartersController = TextEditingController(text: data['headquarters'] ?? '');
    _presentAddressController = TextEditingController(text: data['presentAddress'] ?? '');
    _permanentAddressController = TextEditingController(text: data['permanentAddress'] ?? '');
  }

  @override
  void dispose() {
    _employeeNameController.dispose();
    _positionController.dispose();
    _employeeIdController.dispose();
    _mobileController.dispose();
    _dobController.dispose();
    _dojController.dispose();
    _bloodGroupController.dispose();
    _motherNameController.dispose();
    _fatherNameController.dispose();
    _qualificationController.dispose();
    _maritalStatusController.dispose();
    _childrenController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _aadharController.dispose();
    _panController.dispose();
    _passportController.dispose();
    _uanController.dispose();
    _dlController.dispose();
    _esicController.dispose();
    _personalInsuranceController.dispose();
    _healthInsuranceController.dispose();
    _accidentalInsuranceController.dispose();
    _pmjjbyController.dispose();
    _paiSbi1000Controller.dispose();
    _paiSbi500Controller.dispose();
    _headquartersController.dispose();
    _presentAddressController.dispose();
    _permanentAddressController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'employeeName': _employeeNameController.text,
        'position': _positionController.text,
        'employeeId': _employeeIdController.text,
        'mobile': _mobileController.text,
        'dob': _dobController.text,
        'doj': _dojController.text,
        'bloodGroup': _bloodGroupController.text,
        'motherName': _motherNameController.text,
        'fatherName': _fatherNameController.text,
        'qualification': _qualificationController.text,
        'maritalStatus': _maritalStatusController.text,
        'children': _childrenController.text,
        'height': _heightController.text,
        'weight': _weightController.text,
        'aadhar': _aadharController.text,
        'pan': _panController.text,
        'passport': _passportController.text,
        'uan': _uanController.text,
        'dl': _dlController.text,
        'esic': _esicController.text,
        'personalInsurance': _personalInsuranceController.text,
        'healthInsurance': _healthInsuranceController.text,
        'accidentalInsurance': _accidentalInsuranceController.text,
        'pmjjby': _pmjjbyController.text,
        'paiSbi1000': _paiSbi1000Controller.text,
        'paiSbi500': _paiSbi500Controller.text,
        'headquarters': _headquartersController.text,
        'presentAddress': _presentAddressController.text,
        'permanentAddress': _permanentAddressController.text,
      };

      // Return updated data to previous screen
      Navigator.pop(context, updatedData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully'),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
                      // Basic Info Section
                      _buildBasicInfoSection(),
                      ResponsiveSizedBox.height20,
                      // Personal Info Section
                      _buildPersonalInfoSection(),
                      ResponsiveSizedBox.height20,
                      // Identification Section
                      _buildIdentificationSection(),
                      ResponsiveSizedBox.height20,
                      // Insurance Section
                      _buildInsuranceSection(),
                      ResponsiveSizedBox.height20,
                      // Other Details Section
                      _buildOtherDetailsSection(),
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
        ],
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
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close_rounded),
            color: Appcolors.kprimarycolor,
            iconSize: ResponsiveUtils.sp(6.5),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePictureEditor() {
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
                  child: Icon(
                    Icons.person,
                    size: ResponsiveUtils.wp(15),
                    color: Appcolors.kprimarycolor,
                  ),
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
            text: 'Tap to change profile picture',
            color: Appcolors.kgreyColor,
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return _buildSection(
      title: 'Basic Information',
      icon: Icons.info_outline_rounded,
      children: [
        _buildTextField('Employee Name', _employeeNameController, Icons.person_outline),
        _buildTextField('Position', _positionController, Icons.work_outline),
        _buildTextField('Employee ID', _employeeIdController, Icons.badge_outlined, enabled: false),
      ],
    );
  }

  Widget _buildPersonalInfoSection() {
    return _buildSection(
      title: 'Personal Information',
      icon: Icons.person_outline_rounded,
      children: [
        _buildTextField('Mobile Number', _mobileController, Icons.phone_outlined, keyboardType: TextInputType.phone),
        _buildTextField('Date of Birth', _dobController, Icons.calendar_today_outlined, isDateField: true),
        _buildTextField('Date of Joining', _dojController, Icons.calendar_today_outlined, isDateField: true),
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
        _buildTextField('Passport Number', _passportController, Icons.description_outlined),
        _buildTextField('UAN/EPF Number', _uanController, Icons.numbers_outlined),
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
        _buildTextField('PMJJBY @₹20', _pmjjbyController, Icons.account_balance_outlined),
        _buildTextField('PAI_SBI @₹1000', _paiSbi1000Controller, Icons.account_balance_outlined),
        _buildTextField('PAI_SBI @₹500', _paiSbi500Controller, Icons.account_balance_outlined),
      ],
    );
  }

  Widget _buildOtherDetailsSection() {
    return _buildSection(
      title: 'Other Details',
      icon: Icons.info_outline_rounded,
      children: [
        _buildTextField('Headquarters', _headquartersController, Icons.location_city_outlined),
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
        enabled: enabled,
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
                  controller.text = '${date.day.toString().padLeft(2, '0')} ${_getMonthName(date.month)} ${date.year}';
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
        onPressed: _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Appcolors.kprimarycolor,
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

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}

