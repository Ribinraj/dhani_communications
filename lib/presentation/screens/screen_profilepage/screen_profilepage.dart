// import 'package:dhani_communications/core/constants.dart';
// import 'package:dhani_communications/core/local_storages.dart';
// import 'package:dhani_communications/features/auth/models/profile_model.dart';
// import 'package:dhani_communications/features/auth/blocs/profile_bloc/profile_bloc.dart';
// import 'package:dhani_communications/presentation/screens/screen_dashboard.dart/widgets/paint.dart';
// import 'package:dhani_communications/presentation/screens/screen_profilepage/widgets/profile_shimmer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dhani_communications/core/appconstants.dart';
// import 'package:dhani_communications/core/colors.dart';
// import 'package:dhani_communications/core/responsiveutils.dart';
// import 'package:go_router/go_router.dart';

// class ScreenProfilePage extends StatefulWidget {
//   const ScreenProfilePage({super.key});

//   @override
//   State<ScreenProfilePage> createState() => _ScreenProfilePageState();
// }

// class _ScreenProfilePageState extends State<ScreenProfilePage> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch profile data on init
//     context.read<ProfileBloc>().add(FetchProfileEvent());
//   }

//   void _navigateToEditProfile(ProfileData profileData) async {
//     final result = await context.push('/editprofilepage', extra: profileData);

//     // Refresh profile data if changes were made
//     if (result == true) {
//       if (mounted) {
//         context.read<ProfileBloc>().add(FetchProfileEvent());
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Profile updated successfully'),
//             duration: Duration(milliseconds: 1500),
//             behavior: SnackBarBehavior.floating,
//             backgroundColor: Colors.green,
//             margin: EdgeInsets.only(
//               bottom: ResponsiveUtils.hp(2),
//               left: ResponsiveUtils.wp(4),
//               right: ResponsiveUtils.wp(4),
//             ),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadiusStyles.kradius10(),
//             ),
//           ),
//         );
//       }
//     }
//   }

//   /// Show logout confirmation dialog
//   void _showLogoutDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadiusStyles.kradius15(),
//           ),
//           title: Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
//                 decoration: BoxDecoration(
//                   color: Colors.red.withOpacity(0.1),
//                   borderRadius: BorderRadiusStyles.kradius10(),
//                 ),
//                 child: Icon(
//                   Icons.logout_rounded,
//                   color: Colors.red,
//                   size: ResponsiveUtils.sp(6),
//                 ),
//               ),
//               ResponsiveSizedBox.width(3),
//               TextStyles.subheadline(
//                 text: 'Logout',
//                 weight: FontWeight.bold,
//                 color: Appcolors.kblackcolor,
//               ),
//             ],
//           ),
//           content: TextStyles.body(
//             text: 'Are you sure you want to logout?',
//             color: Appcolors.kgreyColor,
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: TextStyles.medium(
//                 text: 'Cancel',
//                 weight: FontWeight.w600,
//                 color: Appcolors.kgreyColor,
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 _performLogout();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadiusStyles.kradius10(),
//                 ),
//               ),
//               child: TextStyles.medium(
//                 text: 'Logout',
//                 weight: FontWeight.w600,
//                 color: Appcolors.kwhitecolor,
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   /// Perform logout - clear storage and navigate to login
//   Future<void> _performLogout() async {
//     // Clear all stored data
//     await LocalStorage.clearAll();

//     if (mounted) {
//       // Navigate to login and clear navigation stack
//       context.go('/login');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       body: Stack(
//         children: [
//           // Custom Paint Background
//           CustomPaint(
//             painter: HomeBackgroundPainter(),
//             size: Size(screenWidth, screenHeight),
//           ),
//           // Main Content
//           BlocBuilder<ProfileBloc, ProfileState>(
//             builder: (context, state) {
//               return CustomScrollView(
//                 slivers: [
//                   // App Bar
//                   SliverAppBar(
//                     expandedHeight: 0,
//                     floating: false,
//                     pinned: true,
//                     automaticallyImplyLeading: false,
//                     backgroundColor: Appcolors.kwhitecolor.withOpacity(0.95),
//                     elevation: 2,
//                     shadowColor: Appcolors.kgreyColor.withOpacity(0.1),
//                     flexibleSpace: _buildAppBar(state),
//                   ),
//                   // Profile Content
//                   SliverToBoxAdapter(child: _buildContent(state)),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildContent(ProfileState state) {
//     if (state is ProfileLoadingState || state is ProfileInitial) {
//       return const ProfileShimmer();
//     } else if (state is ProfileSuccessState) {
//       return _buildProfileContent(state.profile);
//     } else if (state is ProfileErrorState) {
//       return _buildErrorState(state.message);
//     }
//     return const ProfileShimmer();
//   }

//   Widget _buildErrorState(String message) {
//     return Container(
//       margin: EdgeInsets.all(ResponsiveUtils.wp(4)),
//       padding: EdgeInsets.all(ResponsiveUtils.wp(6)),
//       decoration: BoxDecoration(
//         color: Appcolors.kwhitecolor,
//         borderRadius: BorderRadiusStyles.kradius15(),
//         boxShadow: [
//           BoxShadow(
//             color: Appcolors.kgreyColor.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.error_outline_rounded,
//             size: ResponsiveUtils.wp(15),
//             color: Colors.red,
//           ),
//           ResponsiveSizedBox.height20,
//           TextStyles.subheadline(
//             text: 'Failed to load profile',
//             weight: FontWeight.bold,
//             color: Appcolors.kblackcolor,
//           ),
//           ResponsiveSizedBox.height10,
//           TextStyles.body(text: message, color: Appcolors.kgreyColor),
//           ResponsiveSizedBox.height20,
//           ElevatedButton(
//             onPressed: () {
//               context.read<ProfileBloc>().add(FetchProfileEvent());
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Appcolors.kprimarycolor,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadiusStyles.kradius10(),
//               ),
//             ),
//             child: TextStyles.medium(
//               text: 'Retry',
//               color: Appcolors.kwhitecolor,
//               weight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfileContent(ProfileData profileData) {
//     return Column(
//       children: [
//         ResponsiveSizedBox.height20,
//         // Profile Picture & Basic Info
//         _buildProfileHeader(profileData),
//         ResponsiveSizedBox.height30,
//         // Profile Details Sections
//         _buildPersonalInfoSection(profileData),
//         ResponsiveSizedBox.height20,
//         _buildIdentificationSection(profileData),
//         ResponsiveSizedBox.height20,
//         _buildInsuranceSection(profileData),
//         ResponsiveSizedBox.height20,
//         _buildOtherDetailsSection(profileData),
//         ResponsiveSizedBox.height20,
//         _buildAddressSection(profileData),
//         ResponsiveSizedBox.height(15),
//       ],
//     );
//   }

//   Widget _buildAppBar(ProfileState state) {
//     return Container(
//       padding: EdgeInsets.only(
//         top: MediaQuery.of(context).padding.top + ResponsiveUtils.hp(1),
//         left: ResponsiveUtils.wp(4),
//         right: ResponsiveUtils.wp(4),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Row(
//               children: [
//                 Image.asset(
//                   Appconstants.applogo,
//                   height: ResponsiveUtils.hp(5),
//                 ),
//                 ResponsiveSizedBox.width(3),
//                 Flexible(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       TextStyles.subheadline(
//                         text: 'My Profile',
//                         weight: FontWeight.bold,
//                         color: Appcolors.kblackcolor,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       TextStyles.caption(
//                         text: 'Personal information',
//                         color: Appcolors.kgreyColor.withOpacity(0.7),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             onPressed: state is ProfileSuccessState
//                 ? () => _navigateToEditProfile(state.profile)
//                 : null,
//             icon: const Icon(Icons.edit_rounded),
//             color: Appcolors.kprimarycolor,
//             iconSize: ResponsiveUtils.sp(6.5),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfileHeader(ProfileData profileData) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.wp(4)),
//       padding: EdgeInsets.symmetric(
//         vertical: ResponsiveUtils.wp(6),
//         horizontal: ResponsiveUtils.wp(20),
//       ),
//       decoration: BoxDecoration(
//         color: Appcolors.kwhitecolor,
//         borderRadius: BorderRadiusStyles.kradius20(),
//         boxShadow: [
//           BoxShadow(
//             color: Appcolors.kgreyColor.withOpacity(0.15),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Profile Picture
//           Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: Appcolors.kprimarycolor, width: 4),
//               boxShadow: [
//                 BoxShadow(
//                   color: Appcolors.kprimarycolor.withOpacity(0.3),
//                   blurRadius: 15,
//                   offset: Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: CircleAvatar(
//               radius: ResponsiveUtils.wp(15),
//               backgroundColor: Appcolors.kgreyColor.withOpacity(0.2),
//               backgroundImage:
//                   profileData.profile?.profilePicture != null &&
//                       profileData.profile!.profilePicture!.isNotEmpty
//                   ? NetworkImage(profileData.profile!.profilePicture!)
//                   : null,
//               child:
//                   profileData.profile?.profilePicture == null ||
//                       profileData.profile!.profilePicture!.isEmpty
//                   ? Icon(
//                       Icons.person,
//                       size: ResponsiveUtils.wp(15),
//                       color: Appcolors.kprimarycolor,
//                     )
//                   : null,
//             ),
//           ),
//           ResponsiveSizedBox.height20,
//           // Employee Name
//           TextStyles.headline(
//             text: profileData.employeeName,
//             weight: FontWeight.bold,
//             color: Appcolors.kblackcolor,
//           ),
//           ResponsiveSizedBox.height5,
//           // Position
//           Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: ResponsiveUtils.wp(4),
//               vertical: ResponsiveUtils.hp(0.8),
//             ),
//             decoration: BoxDecoration(
//               color: Appcolors.kprimarycolor.withOpacity(0.1),
//               borderRadius: BorderRadiusStyles.kradius10(),
//             ),
//             child: TextStyles.medium(
//               text:
//                   profileData.profile?.designationName ?? profileData.userRole,
//               weight: FontWeight.w600,
//               color: Appcolors.kprimarycolor,
//             ),
//           ),
//           ResponsiveSizedBox.height15,
//           // Employee ID
//           TextStyles.body(
//             text: 'EMP ID: #${profileData.employeeId}',
//             weight: FontWeight.w500,
//             color: Appcolors.kgreyColor,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPersonalInfoSection(ProfileData profileData) {
//     final profile = profileData.profile;
//     return _buildSection(
//       title: 'Personal Information',
//       icon: Icons.person_outline_rounded,
//       children: [
//         _buildInfoRow('Mobile Number', profileData.mobileNumber),
//         _buildInfoRow('Date of Birth', profile?.dateOfBirth ?? '-'),
//         _buildInfoRow('Date of Joining', profile?.dateOfJoining ?? '-'),
//         _buildInfoRow('Blood Group', profile?.bloodGroup ?? '-'),
//         _buildInfoRow('Mother\'s Name', profile?.motherName ?? '-'),
//         _buildInfoRow('Father\'s Name', profile?.fatherName ?? '-'),
//         _buildInfoRow('Qualification', profile?.highestQualification ?? '-'),
//         _buildInfoRow('Marital Status', profile?.martialStatus ?? '-'),
//         _buildInfoRow('Number of Children', profile?.noOfChildren ?? '-'),
//         _buildInfoRow(
//           'Height',
//           profile?.height != null ? '${profile!.height} cm' : '-',
//         ),
//         _buildInfoRow(
//           'Weight',
//           profile?.weight != null ? '${profile!.weight} kg' : '-',
//         ),
//       ],
//     );
//   }

//   Widget _buildIdentificationSection(ProfileData profileData) {
//     final profile = profileData.profile;
//     return _buildSection(
//       title: 'Identification Details',
//       icon: Icons.badge_rounded,
//       children: [
//         _buildInfoRow('Aadhar Number', profile?.adhaarNumber ?? '-'),
//         _buildInfoRow('PAN Number', profile?.panNumber ?? '-'),
//         _buildInfoRow('Passport Number', profile?.passportNumber ?? '-'),
//         _buildInfoRow('UAN/EPF Number', profile?.uanEpf ?? '-'),
//         _buildInfoRow('DL Number', profile?.drivingLicenseNumber ?? '-'),
//         _buildInfoRow('ESIC Number', profile?.esicNumber ?? '-'),
//       ],
//     );
//   }

//   Widget _buildInsuranceSection(ProfileData profileData) {
//     final profile = profileData.profile;
//     return _buildSection(
//       title: 'Insurance Details',
//       icon: Icons.security_rounded,
//       children: [
//         _buildInfoRow('Personal Insurance', profile?.personalInsurance ?? '-'),
//         _buildInfoRow('Health Insurance', profile?.healthInsurance ?? '-'),
//         _buildInfoRow(
//           'Accidental Insurance',
//           profile?.accidentalInsurance ?? '-',
//         ),
//         _buildInfoRow('PMJJBY @₹436', profile?.pmjjby436 ?? '-'),
//         _buildInfoRow('PMSBI @₹20', profile?.pmsbi20 ?? '-'),
//         _buildInfoRow('PAI_SBI @₹1000', profile?.paiSbi1000 ?? '-'),
//         _buildInfoRow('PAI_SBI @₹500', profile?.paiSbi500 ?? '-'),
//       ],
//     );
//   }

//   Widget _buildOtherDetailsSection(ProfileData profileData) {
//     final profile = profileData.profile;
//     return _buildSection(
//       title: 'Other Details',
//       icon: Icons.info_outline_rounded,
//       children: [
//         _buildInfoRow('Headquarters', profile?.headQuarterName ?? '-'),
//         _buildInfoRow('Leave Balance', profile?.leaveBalance ?? '-'),
//       ],
//     );
//   }

//   Widget _buildAddressSection(ProfileData profileData) {
//     final profile = profileData.profile;
//     return _buildSection(
//       title: 'Address Information',
//       icon: Icons.location_on_outlined,
//       children: [
//         _buildInfoRow(
//           'Present Address',
//           profile?.presentAddress ?? '-',
//           isMultiline: true,
//         ),
//         _buildInfoRow(
//           'Permanent Address',
//           profile?.permanentAddess ?? '-',
//           isMultiline: true,
//         ),
//       ],
//     );
//   }

//   Widget _buildSection({
//     required String title,
//     required IconData icon,
//     required List<Widget> children,
//   }) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.wp(4)),
//       decoration: BoxDecoration(
//         color: Appcolors.kwhitecolor,
//         borderRadius: BorderRadiusStyles.kradius15(),
//         boxShadow: [
//           BoxShadow(
//             color: Appcolors.kgreyColor.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Section Header
//           Container(
//             padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
//             decoration: BoxDecoration(
//               color: Appcolors.kprimarycolor.withOpacity(0.05),
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(ResponsiveUtils.borderRadius(3.75)),
//                 topRight: Radius.circular(ResponsiveUtils.borderRadius(3.75)),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
//                   decoration: BoxDecoration(
//                     color: Appcolors.kprimarycolor,
//                     borderRadius: BorderRadiusStyles.kradius10(),
//                   ),
//                   child: Icon(
//                     icon,
//                     color: Appcolors.kwhitecolor,
//                     size: ResponsiveUtils.sp(5),
//                   ),
//                 ),
//                 ResponsiveSizedBox.width(3),
//                 TextStyles.subheadline(
//                   text: title,
//                   weight: FontWeight.bold,
//                   color: Appcolors.kblackcolor,
//                 ),
//               ],
//             ),
//           ),
//           // Section Content
//           Padding(
//             padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
//             child: Column(children: children),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value, {bool isMultiline = false}) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: ResponsiveUtils.hp(1.5)),
//       child: Row(
//         crossAxisAlignment: isMultiline
//             ? CrossAxisAlignment.start
//             : CrossAxisAlignment.center,
//         children: [
//           Expanded(
//             flex: 2,
//             child: TextStyles.medium(
//               text: label,
//               weight: FontWeight.w600,
//               color: Appcolors.kgreyColor,
//             ),
//           ),
//           ResponsiveSizedBox.width(2),
//           Expanded(
//             flex: 3,
//             child: TextStyles.medium(
//               text: value.isEmpty ? '-' : value,
//               weight: FontWeight.w500,
//               color: Appcolors.kblackcolor,
//               maxLines: isMultiline ? null : 1,
//               overflow: isMultiline ? null : TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/local_storages.dart';
import 'package:dhani_communications/features/auth/models/profile_model.dart';
import 'package:dhani_communications/features/auth/blocs/profile_bloc/profile_bloc.dart';
import 'package:dhani_communications/presentation/screens/screen_dashboard.dart/widgets/paint.dart';
import 'package:dhani_communications/presentation/screens/screen_profilepage/widgets/profile_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  @override
  void initState() {
    super.initState();
    // Fetch profile data on init
    context.read<ProfileBloc>().add(FetchProfileEvent());
  }

  void _navigateToEditProfile(ProfileData profileData) async {
    final result = await context.push('/editprofilepage', extra: profileData);

    // Refresh profile data if changes were made
    if (result == true) {
      if (mounted) {
        context.read<ProfileBloc>().add(FetchProfileEvent());
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
  }

  /// Show logout confirmation dialog
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusStyles.kradius15(),
          ),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadiusStyles.kradius10(),
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: Colors.red,
                  size: ResponsiveUtils.sp(6),
                ),
              ),
              ResponsiveSizedBox.width(3),
              TextStyles.subheadline(
                text: 'Logout',
                weight: FontWeight.bold,
                color: Appcolors.kblackcolor,
              ),
            ],
          ),
          content: TextStyles.body(
            text: 'Are you sure you want to logout?',
            color: Appcolors.kgreyColor,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: TextStyles.medium(
                text: 'Cancel',
                weight: FontWeight.w600,
                color: Appcolors.kgreyColor,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _performLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusStyles.kradius10(),
                ),
              ),
              child: TextStyles.medium(
                text: 'Logout',
                weight: FontWeight.w600,
                color: Appcolors.kwhitecolor,
              ),
            ),
          ],
        );
      },
    );
  }

  /// Perform logout - clear storage and navigate to login
  Future<void> _performLogout() async {
    // Clear all stored data
    await LocalStorage.clearAll();

    if (mounted) {
      // Navigate to login and clear navigation stack
      context.go('/login');
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
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return CustomScrollView(
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
                    flexibleSpace: _buildAppBar(state),
                  ),
                  // Profile Content
                  SliverToBoxAdapter(child: _buildContent(state)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ProfileState state) {
    if (state is ProfileLoadingState || state is ProfileInitial) {
      return const ProfileShimmer();
    } else if (state is ProfileSuccessState) {
      return _buildProfileContent(state.profile);
    } else if (state is ProfileErrorState) {
      return _buildErrorState(state.message);
    }
    return const ProfileShimmer();
  }

  Widget _buildErrorState(String message) {
    return Container(
      margin: EdgeInsets.all(ResponsiveUtils.wp(4)),
      padding: EdgeInsets.all(ResponsiveUtils.wp(6)),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: ResponsiveUtils.wp(15),
            color: Colors.red,
          ),
          ResponsiveSizedBox.height20,
          TextStyles.subheadline(
            text: 'Failed to load profile',
            weight: FontWeight.bold,
            color: Appcolors.kblackcolor,
          ),
          ResponsiveSizedBox.height10,
          TextStyles.body(text: message, color: Appcolors.kgreyColor),
          ResponsiveSizedBox.height20,
          ElevatedButton(
            onPressed: () {
              context.read<ProfileBloc>().add(FetchProfileEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Appcolors.kprimarycolor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusStyles.kradius10(),
              ),
            ),
            child: TextStyles.medium(
              text: 'Retry',
              color: Appcolors.kwhitecolor,
              weight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(ProfileData profileData) {
    return Column(
      children: [
        ResponsiveSizedBox.height20,
        // Profile Picture & Basic Info
        _buildProfileHeader(profileData),
        ResponsiveSizedBox.height30,
        // Profile Details Sections
        _buildPersonalInfoSection(profileData),
        ResponsiveSizedBox.height20,
        _buildIdentificationSection(profileData),
        ResponsiveSizedBox.height20,
        _buildInsuranceSection(profileData),
        ResponsiveSizedBox.height20,
        _buildOtherDetailsSection(profileData),
        ResponsiveSizedBox.height20,
        _buildAddressSection(profileData),
        ResponsiveSizedBox.height20,
        // Logout Button Section
        _buildLogoutSection(),
        ResponsiveSizedBox.height(15),
      ],
    );
  }

  Widget _buildAppBar(ProfileState state) {
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
            onPressed: state is ProfileSuccessState
                ? () => _navigateToEditProfile(state.profile)
                : null,
            icon: const Icon(Icons.edit_rounded),
            color: Appcolors.kprimarycolor,
            iconSize: ResponsiveUtils.sp(6.5),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(ProfileData profileData) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.wp(4)),
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveUtils.wp(6),
        horizontal: ResponsiveUtils.wp(20),
      ),
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
              border: Border.all(color: Appcolors.kprimarycolor, width: 4),
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
              backgroundImage:
                  profileData.profile?.profilePicture != null &&
                      profileData.profile!.profilePicture!.isNotEmpty
                  ? NetworkImage(profileData.profile!.profilePicture!)
                  : null,
              child:
                  profileData.profile?.profilePicture == null ||
                      profileData.profile!.profilePicture!.isEmpty
                  ? Icon(
                      Icons.person,
                      size: ResponsiveUtils.wp(15),
                      color: Appcolors.kprimarycolor,
                    )
                  : null,
            ),
          ),
          ResponsiveSizedBox.height20,
          // Employee Name
          TextStyles.headline(
            text: profileData.employeeName,
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
              text:
                  profileData.profile?.designationName ?? profileData.userRole,
              weight: FontWeight.w600,
              color: Appcolors.kprimarycolor,
            ),
          ),
          ResponsiveSizedBox.height15,
          // Employee ID
          TextStyles.body(
            text: 'EMP ID: #${profileData.employeeId}',
            weight: FontWeight.w500,
            color: Appcolors.kgreyColor,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection(ProfileData profileData) {
    final profile = profileData.profile;
    return _buildSection(
      title: 'Personal Information',
      icon: Icons.person_outline_rounded,
      children: [
        _buildInfoRow('Mobile Number', profileData.mobileNumber),
        _buildInfoRow('Date of Birth', profile?.dateOfBirth ?? '-'),
        _buildInfoRow('Date of Joining', profile?.dateOfJoining ?? '-'),
        _buildInfoRow('Blood Group', profile?.bloodGroup ?? '-'),
        _buildInfoRow('Mother\'s Name', profile?.motherName ?? '-'),
        _buildInfoRow('Father\'s Name', profile?.fatherName ?? '-'),
        _buildInfoRow('Qualification', profile?.highestQualification ?? '-'),
        _buildInfoRow('Marital Status', profile?.martialStatus ?? '-'),
        _buildInfoRow('Number of Children', profile?.noOfChildren ?? '-'),
        _buildInfoRow(
          'Height',
          profile?.height != null ? '${profile!.height} cm' : '-',
        ),
        _buildInfoRow(
          'Weight',
          profile?.weight != null ? '${profile!.weight} kg' : '-',
        ),
      ],
    );
  }

  Widget _buildIdentificationSection(ProfileData profileData) {
    final profile = profileData.profile;
    return _buildSection(
      title: 'Identification Details',
      icon: Icons.badge_rounded,
      children: [
        _buildInfoRow('Aadhar Number', profile?.adhaarNumber ?? '-'),
        _buildInfoRow('PAN Number', profile?.panNumber ?? '-'),
        _buildInfoRow('Passport Number', profile?.passportNumber ?? '-'),
        _buildInfoRow('UAN/EPF Number', profile?.uanEpf ?? '-'),
        _buildInfoRow('DL Number', profile?.drivingLicenseNumber ?? '-'),
        _buildInfoRow('ESIC Number', profile?.esicNumber ?? '-'),
      ],
    );
  }

  Widget _buildInsuranceSection(ProfileData profileData) {
    final profile = profileData.profile;
    return _buildSection(
      title: 'Insurance Details',
      icon: Icons.security_rounded,
      children: [
        _buildInfoRow('Personal Insurance', profile?.personalInsurance ?? '-'),
        _buildInfoRow('Health Insurance', profile?.healthInsurance ?? '-'),
        _buildInfoRow(
          'Accidental Insurance',
          profile?.accidentalInsurance ?? '-',
        ),
        _buildInfoRow('PMJJBY @₹436', profile?.pmjjby436 ?? '-'),
        _buildInfoRow('PMSBI @₹20', profile?.pmsbi20 ?? '-'),
        _buildInfoRow('PAI_SBI @₹1000', profile?.paiSbi1000 ?? '-'),
        _buildInfoRow('PAI_SBI @₹500', profile?.paiSbi500 ?? '-'),
      ],
    );
  }

  Widget _buildOtherDetailsSection(ProfileData profileData) {
    final profile = profileData.profile;
    return _buildSection(
      title: 'Other Details',
      icon: Icons.info_outline_rounded,
      children: [
        _buildInfoRow('Headquarters', profile?.headQuarterName ?? '-'),
        _buildInfoRow('Leave Balance', profile?.leaveBalance ?? '-'),
      ],
    );
  }

  Widget _buildAddressSection(ProfileData profileData) {
    final profile = profileData.profile;
    return _buildSection(
      title: 'Address Information',
      icon: Icons.location_on_outlined,
      children: [
        _buildInfoRow(
          'Present Address',
          profile?.presentAddress ?? '-',
          isMultiline: true,
        ),
        _buildInfoRow(
          'Permanent Address',
          profile?.permanentAddess ?? '-',
          isMultiline: true,
        ),
      ],
    );
  }

  Widget _buildLogoutSection() {
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showLogoutDialog,
          borderRadius: BorderRadiusStyles.kradius15(),
          child: Padding(
            padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadiusStyles.kradius10(),
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: Colors.red,
                    size: ResponsiveUtils.sp(6),
                  ),
                ),
                ResponsiveSizedBox.width(4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextStyles.subheadline(
                        text: 'Logout',
                        weight: FontWeight.bold,
                        color: Appcolors.kblackcolor,
                      ),
                      ResponsiveSizedBox.height5,
                      TextStyles.caption(
                        text: 'Sign out from your account',
                        color: Appcolors.kgreyColor,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Appcolors.kgreyColor,
                  size: ResponsiveUtils.sp(5),
                ),
              ],
            ),
          ),
        ),
      ),
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

  Widget _buildInfoRow(String label, String value, {bool isMultiline = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveUtils.hp(1.5)),
      child: Row(
        crossAxisAlignment: isMultiline
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
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
              text: value.isEmpty ? '-' : value,
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