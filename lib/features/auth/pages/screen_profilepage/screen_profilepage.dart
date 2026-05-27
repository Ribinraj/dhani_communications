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
//             content: Text(context.tr('profile_updated_successfully')),
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
//         _buildInfoRow(context.tr('mobile_number'), profileData.mobileNumber),
//         _buildInfoRow(context.tr('date_of_birth'), profile?.dateOfBirth ?? '-'),
//         _buildInfoRow(context.tr('date_of_joining'), profile?.dateOfJoining ?? '-'),
//         _buildInfoRow(context.tr('blood_group'), profile?.bloodGroup ?? '-'),
//         _buildInfoRow(context.tr('mothers_name'), profile?.motherName ?? '-'),
//         _buildInfoRow(context.tr('fathers_name'), profile?.fatherName ?? '-'),
//         _buildInfoRow(context.tr('qualification'), profile?.highestQualification ?? '-'),
//         _buildInfoRow(context.tr('marital_status'), profile?.martialStatus ?? '-'),
//         _buildInfoRow(context.tr('number_of_children'), profile?.noOfChildren ?? '-'),
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
//         _buildInfoRow(context.tr('aadhar_number'), profile?.adhaarNumber ?? '-'),
//         _buildInfoRow(context.tr('pan_number'), profile?.panNumber ?? '-'),
//         _buildInfoRow(context.tr('passport_number'), profile?.passportNumber ?? '-'),
//         _buildInfoRow(context.tr('uan_epf_number'), profile?.uanEpf ?? '-'),
//         _buildInfoRow(context.tr('dl_number'), profile?.drivingLicenseNumber ?? '-'),
//         _buildInfoRow(context.tr('esic_number'), profile?.esicNumber ?? '-'),
//       ],
//     );
//   }

//   Widget _buildInsuranceSection(ProfileData profileData) {
//     final profile = profileData.profile;
//     return _buildSection(
//       title: 'Insurance Details',
//       icon: Icons.security_rounded,
//       children: [
//         _buildInfoRow(context.tr('personal_insurance'), profile?.personalInsurance ?? '-'),
//         _buildInfoRow(context.tr('health_insurance'), profile?.healthInsurance ?? '-'),
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
//         _buildInfoRow(context.tr('headquarters'), profile?.headQuarterName ?? '-'),
//         _buildInfoRow(context.tr('leave_balance'), profile?.leaveBalance ?? '-'),
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
import 'package:dhani_communications/core/pushnotification_controller.dart';
import 'package:dhani_communications/features/auth/models/profile_model.dart';
import 'package:dhani_communications/features/auth/blocs/profile_bloc/profile_bloc.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_dashboard.dart/widgets/paint.dart';
import 'package:dhani_communications/features/auth/pages/screen_profilepage/widgets/profile_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dhani_communications/core/appconstants.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';
import 'package:dhani_communications/features/dashboard/blocs/bottom_navigation_bloc/bottom_navigation_bloc.dart';
import 'package:dhani_communications/core/localization/app_localization.dart';

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
            content: Text(context.tr('profile_updated_successfully')),
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
                text: context.tr('logout'),
                weight: FontWeight.bold,
                color: Appcolors.kblackcolor,
              ),
            ],
          ),
          content: TextStyles.body(
            text: context.tr('are_you_sure_you_want_to_logout'),
            color: Appcolors.kgreyColor,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: TextStyles.medium(
                text: context.tr('cancel'),
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
                text: context.tr('logout'),
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
    // 1) Delete FCM token from server & device (must happen BEFORE clearing auth)
    await PushNotifications.instance.deleteDeviceToken();

    // 2) Clear all stored session data (preserves FCM token if needed)
    await LocalStorage.clearAll();

    if (mounted) {
      // 3) Reset bottom navigation index to 0 (Dashboard) before logout
      context.read<BottomNavigationBloc>().add(
        NavigateToPageEvent(pageIndex: 0),
      );
      // 4) Navigate to login and clear navigation stack
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
                    toolbarHeight:
                        MediaQuery.of(context).padding.top +
                        ResponsiveUtils.hp(.5) +
                        ResponsiveUtils.hp(3) +
                        ResponsiveUtils.hp(.6),
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
            text: context.tr('failed_to_load_profile'),
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
              text: context.tr('retry'),
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
        _buildLanguageSection(),
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
                        text: context.tr('my_profile'),
                        weight: FontWeight.bold,
                        color: Appcolors.kblackcolor,
                        overflow: TextOverflow.ellipsis,
                      ),
                      TextStyles.caption(
                        text: context.tr('personal_information'),
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
      title: context.tr('personal_information_2'),
      icon: Icons.person_outline_rounded,
      children: [
        _buildInfoRow(context.tr('mobile_number'), profileData.mobileNumber),
        _buildInfoRow(context.tr('date_of_birth'), profile?.dateOfBirth ?? '-'),
        _buildInfoRow(
          context.tr('date_of_joining'),
          profile?.dateOfJoining ?? '-',
        ),
        _buildInfoRow(context.tr('blood_group'), profile?.bloodGroup ?? '-'),
        _buildInfoRow(context.tr('mothers_name'), profile?.motherName ?? '-'),
        _buildInfoRow(context.tr('fathers_name'), profile?.fatherName ?? '-'),
        _buildInfoRow(
          context.tr('qualification'),
          profile?.highestQualification ?? '-',
        ),
        _buildInfoRow(
          context.tr('marital_status'),
          profile?.martialStatus ?? '-',
        ),
        _buildInfoRow(
          context.tr('number_of_children'),
          profile?.noOfChildren ?? '-',
        ),
        _buildInfoRow(
          context.tr('height'),
          profile?.height != null ? '${profile!.height} cm' : '-',
        ),
        _buildInfoRow(
          context.tr('weight'),
          profile?.weight != null ? '${profile!.weight} kg' : '-',
        ),
      ],
    );
  }

  Widget _buildIdentificationSection(ProfileData profileData) {
    final profile = profileData.profile;
    return _buildSection(
      title: context.tr('identification_details'),
      icon: Icons.badge_rounded,
      children: [
        _buildInfoRow(
          context.tr('aadhar_number'),
          profile?.adhaarNumber ?? '-',
        ),
        _buildInfoRow(context.tr('pan_number'), profile?.panNumber ?? '-'),
        _buildInfoRow(
          context.tr('passport_number'),
          profile?.passportNumber ?? '-',
        ),
        _buildInfoRow(context.tr('uan_epf_number'), profile?.uanEpf ?? '-'),
        _buildInfoRow(
          context.tr('dl_number'),
          profile?.drivingLicenseNumber ?? '-',
        ),
        _buildInfoRow(context.tr('esic_number'), profile?.esicNumber ?? '-'),
      ],
    );
  }

  Widget _buildInsuranceSection(ProfileData profileData) {
    final profile = profileData.profile;
    return _buildSection(
      title: context.tr('insurance_details'),
      icon: Icons.security_rounded,
      children: [
        _buildInfoRow(
          context.tr('personal_insurance'),
          profile?.personalInsurance ?? '-',
        ),
        _buildInfoRow(
          context.tr('health_insurance'),
          profile?.healthInsurance ?? '-',
        ),
        _buildInfoRow(
          context.tr('accidental_insurance'),
          profile?.accidentalInsurance ?? '-',
        ),
        _buildInfoRow(context.tr('pmjjby_436'), profile?.pmjjby436 ?? '-'),
        _buildInfoRow(context.tr('pmsbi_20'), profile?.pmsbi20 ?? '-'),
        _buildInfoRow(context.tr('pai_sbi_1000'), profile?.paiSbi1000 ?? '-'),
        _buildInfoRow(context.tr('pai_sbi_500'), profile?.paiSbi500 ?? '-'),
      ],
    );
  }

  Widget _buildOtherDetailsSection(ProfileData profileData) {
    final profile = profileData.profile;
    return _buildSection(
      title: context.tr('other_details'),
      icon: Icons.info_outline_rounded,
      children: [
        _buildInfoRow(
          context.tr('headquarters'),
          profile?.headQuarterName ?? '-',
        ),
        _buildInfoRow(
          context.tr('leave_balance'),
          profile?.leaveBalance ?? '-',
        ),
      ],
    );
  }

  Widget _buildAddressSection(ProfileData profileData) {
    final profile = profileData.profile;
    return _buildSection(
      title: context.tr('address_information'),
      icon: Icons.location_on_outlined,
      children: [
        _buildInfoRow(
          context.tr('present_address'),
          profile?.presentAddress ?? '-',
          isMultiline: true,
        ),
        _buildInfoRow(
          context.tr('permanent_address'),
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
                        text: context.tr('logout'),
                        weight: FontWeight.bold,
                        color: Appcolors.kblackcolor,
                      ),
                      ResponsiveSizedBox.height5,
                      TextStyles.caption(
                        text: context.tr('sign_out_from_your_account'),
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

  Widget _buildLanguageSection() {
    final currentLanguageCode = AppLocalization.instance.languageCode;
    final currentLanguageName = switch (currentLanguageCode) {
      'hi' => context.tr('hindi'),
      'gu' => context.tr('gujarati'),
      _ => context.tr('english'),
    };

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
          onTap: _showLanguageDialog,
          borderRadius: BorderRadiusStyles.kradius15(),
          child: Padding(
            padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
                  decoration: BoxDecoration(
                    color: Appcolors.kprimarycolor.withOpacity(0.1),
                    borderRadius: BorderRadiusStyles.kradius10(),
                  ),
                  child: Icon(
                    Icons.language_rounded,
                    color: Appcolors.kprimarycolor,
                    size: ResponsiveUtils.sp(6),
                  ),
                ),
                ResponsiveSizedBox.width(4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextStyles.subheadline(
                        text: context.tr('language'),
                        weight: FontWeight.bold,
                        color: Appcolors.kblackcolor,
                      ),
                      ResponsiveSizedBox.height5,
                      TextStyles.caption(
                        text: currentLanguageName,
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

  void _showLanguageDialog() {
    final currentLanguageCode = AppLocalization.instance.languageCode;

    showModalBottomSheet(
      context: context,
      backgroundColor: Appcolors.kwhitecolor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ResponsiveUtils.borderRadius(5)),
          topRight: Radius.circular(ResponsiveUtils.borderRadius(5)),
        ),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextStyles.subheadline(
                text: context.tr('select_language'),
                weight: FontWeight.bold,
                color: Appcolors.kblackcolor,
              ),
              ResponsiveSizedBox.height20,
              _buildLanguageOption(
                languageCode: 'en',
                title: context.tr('english'),
                isSelected: currentLanguageCode == 'en',
              ),
              _buildLanguageOption(
                languageCode: 'hi',
                title: context.tr('hindi'),
                isSelected: currentLanguageCode == 'hi',
              ),
              _buildLanguageOption(
                languageCode: 'gu',
                title: context.tr('gujarati'),
                isSelected: currentLanguageCode == 'gu',
              ),
              ResponsiveSizedBox.height20,
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption({
    required String languageCode,
    required String title,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () async {
        Navigator.pop(context);
        await AppLocalization.instance.changeLanguage(languageCode);
      },
      borderRadius: BorderRadiusStyles.kradius10(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.hp(1.5)),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected
                  ? Appcolors.kprimarycolor
                  : Appcolors.kgreyColor,
            ),
            ResponsiveSizedBox.width(3),
            TextStyles.medium(
              text: title,
              weight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: Appcolors.kblackcolor,
            ),
          ],
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
