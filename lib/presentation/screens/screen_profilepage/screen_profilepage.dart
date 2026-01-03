import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/presentation/screens/screen_dashboard.dart/widgets/paint.dart';
import 'package:flutter/material.dart';
import 'package:dhani_communications/core/appconstants.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';

class ScreenProfilePage extends StatefulWidget {
  const ScreenProfilePage({super.key});

  @override
  State<ScreenProfilePage> createState() => _ScreenProfilePageState();
}

class _ScreenProfilePageState extends State<ScreenProfilePage> {
    Map<String, dynamic> profileData = {
    'employeeName': 'John Doe',
    'position': 'Administrator',
    'employeeId': '#12345',
    'mobile': '+91 9876543210',
    'dob': '15 Jan 1990',
    'doj': '01 Apr 2020',
    'bloodGroup': 'O+',
    'motherName': 'Jane Doe',
    'fatherName': 'Richard Doe',
    'qualification': 'B.Tech - Computer Science',
    'maritalStatus': 'Married',
    'children': '2',
    'height': '175 cm',
    'weight': '70 kg',
    'aadhar': 'XXXX XXXX 1234',
    'pan': 'ABCDE1234F',
    'passport': 'K1234567',
    'uan': '123456789012',
    'dl': 'KA0123456789',
    'esic': '1234567890123456',
    'personalInsurance': 'Active - Policy #123456',
    'healthInsurance': 'Active - Policy #654321',
    'accidentalInsurance': 'Active - Policy #789012',
    'pmjjby': 'Active',
    'paiSbi1000': 'Active',
    'paiSbi500': 'Active',
    'headquarters': 'Bangalore, Karnataka',
    'presentAddress': '#123, 4th Cross, MG Road, Bangalore, Karnataka - 560001',
    'permanentAddress': '#456, 2nd Main, Church Street, Bangalore, Karnataka - 560002',
  };

  void _navigateToEditProfile() async {
    final result = await context.push('/editprofilepage', extra: profileData);
    
    // Update profile data if changes were made
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        profileData = result;
      });
      
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
              // Profile Content
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    ResponsiveSizedBox.height20,
                    // Profile Picture & Basic Info
                    _buildProfileHeader(),
                    ResponsiveSizedBox.height30,
                    // Profile Details Sections
                    _buildPersonalInfoSection(),
                    ResponsiveSizedBox.height20,
                    _buildIdentificationSection(),
                    ResponsiveSizedBox.height20,
                    _buildInsuranceSection(),
                    ResponsiveSizedBox.height20,
                    _buildOtherDetailsSection(),
                    ResponsiveSizedBox.height20,
                    _buildAddressSection(),
                    ResponsiveSizedBox.height(15),
                  ],
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
                        text: 'My Profile',
                        weight: FontWeight.bold,
                        color: Appcolors.kblackcolor,
                        overflow: TextOverflow.ellipsis,
                      ),
                      TextStyles.caption(
                        text: 'Personal information',
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
_navigateToEditProfile();
            },
            icon: const Icon(Icons.edit_rounded),
            color: Appcolors.kprimarycolor,
            iconSize: ResponsiveUtils.sp(6.5),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.wp(4)),
      padding: EdgeInsets.symmetric(vertical:ResponsiveUtils.wp(6),horizontal: ResponsiveUtils.wp(20)),
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
          // Profile Picture
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Appcolors.kprimarycolor,
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Appcolors.kprimarycolor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
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
          ResponsiveSizedBox.height20,
          // Employee Name
          TextStyles.headline(
            text: 'John Doe',
            weight: FontWeight.bold,
            color: Appcolors.kblackcolor,
          ),
          ResponsiveSizedBox.height5,
          // Position
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.wp(4),
              vertical: ResponsiveUtils.hp(0.8),
            ),
            decoration: BoxDecoration(
              color: Appcolors.kprimarycolor.withOpacity(0.1),
              borderRadius: BorderRadiusStyles.kradius10(),
            ),
            child: TextStyles.medium(
              text: 'Administrator',
              weight: FontWeight.w600,
              color: Appcolors.kprimarycolor,
            ),
          ),
          ResponsiveSizedBox.height15,
          // Employee ID
          TextStyles.body(
            text: 'EMP ID: #12345',
            weight: FontWeight.w500,
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
        _buildInfoRow('Mobile Number', '+91 9876543210'),
        _buildInfoRow('Date of Birth', '15 Jan 1990'),
        _buildInfoRow('Date of Joining', '01 Apr 2020'),
        _buildInfoRow('Blood Group', 'O+'),
        _buildInfoRow('Mother\'s Name', 'Jane Doe'),
        _buildInfoRow('Father\'s Name', 'Richard Doe'),
        _buildInfoRow('Qualification', 'B.Tech - Computer Science'),
        _buildInfoRow('Marital Status', 'Married'),
        _buildInfoRow('Number of Children', '2'),
        _buildInfoRow('Height', '175 cm'),
        _buildInfoRow('Weight', '70 kg'),
      ],
    );
  }

  Widget _buildIdentificationSection() {
    return _buildSection(
      title: 'Identification Details',
      icon: Icons.badge_rounded,
      children: [
        _buildInfoRow('Aadhar Number', 'XXXX XXXX 1234'),
        _buildInfoRow('PAN Number', 'ABCDE1234F'),
        _buildInfoRow('Passport Number', 'K1234567'),
        _buildInfoRow('UAN/EPF Number', '123456789012'),
        _buildInfoRow('DL Number', 'KA0123456789'),
        _buildInfoRow('ESIC Number', '1234567890123456'),
      ],
    );
  }

  Widget _buildInsuranceSection() {
    return _buildSection(
      title: 'Insurance Details',
      icon: Icons.security_rounded,
      children: [
        _buildInfoRow('Personal Insurance', 'Active - Policy #123456'),
        _buildInfoRow('Health Insurance', 'Active - Policy #654321'),
        _buildInfoRow('Accidental Insurance', 'Active - Policy #789012'),
        _buildInfoRow('PMJJBY @₹20', 'Active'),
        _buildInfoRow('PAI_SBI @₹1000', 'Active'),
        _buildInfoRow('PAI_SBI @₹500', 'Active'),
      ],
    );
  }

  Widget _buildOtherDetailsSection() {
    return _buildSection(
      title: 'Other Details',
      icon: Icons.info_outline_rounded,
      children: [
        _buildInfoRow('Headquarters', 'Bangalore, Karnataka'),
      ],
    );
  }

  Widget _buildAddressSection() {
    return _buildSection(
      title: 'Address Information',
      icon: Icons.location_on_outlined,
      children: [
        _buildInfoRow(
          'Present Address',
          '#123, 4th Cross, MG Road, Bangalore, Karnataka - 560001',
          isMultiline: true,
        ),
        _buildInfoRow(
          'Permanent Address',
          '#456, 2nd Main, Church Street, Bangalore, Karnataka - 560002',
          isMultiline: true,
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
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isMultiline = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveUtils.hp(1.5)),
      child: Row(
        crossAxisAlignment:
            isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: TextStyles.medium(
              text: label,
              weight: FontWeight.w600,
              color: Appcolors.kgreyColor,
            ),
          ),
          ResponsiveSizedBox.width(2),
          Expanded(
            flex: 3,
            child: TextStyles.medium(
              text: value,
              weight: FontWeight.w500,
              color: Appcolors.kblackcolor,
              maxLines: isMultiline ? null : 1,
              overflow: isMultiline ? null : TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

