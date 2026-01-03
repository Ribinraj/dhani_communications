

import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/presentation/screens/screen_dashboard.dart/widgets/paint.dart';
import 'package:flutter/material.dart';
import 'package:dhani_communications/core/appconstants.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';

class ScreenApprovalsPage extends StatefulWidget {
  const ScreenApprovalsPage({super.key});

  @override
  State<ScreenApprovalsPage> createState() => _ScreenApprovalsPageState();
}

class _ScreenApprovalsPageState extends State<ScreenApprovalsPage> {
  // Approval options
  final List<Map<String, dynamic>> approvalOptions = [
    {
      'iconPath': Appconstants.approveEmployeeAttendance,
      'label': 'Approve Employee Attendance',
      'color': Color(0xFF9C27B0),
      'count': 12,
    },
    {
      'iconPath': Appconstants.approveLabourAttendance,
      'label': 'Approve Labour Attendance',
      'color': Color(0xFFFF6584),
      'count': 8,
    },
    {
      'iconPath': Appconstants.approveEmployeeExpense,
      'label': 'Approve Employee Expenses',
      'color': Color(0xFF607D8B),
      'count': 5,
    },
    {
      'iconPath': Appconstants.approveEmployeeLeaves,
      'label': 'Approve Employee Leaves',
      'color': Color(0xFF00D9FF),
      'count': 3,
    },
    {
      'iconPath': Appconstants.dprreport,
      'label': 'Approve Employee DPR Report',
      'color': Color(0xFF4CAF50),
      'count': 7,
    },
    {
      'iconPath': Appconstants.machinery,
      'label': 'Approve Machine Hire',
      'color': Color(0xFF795548),
      'count': 4,
    },

  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Custom Paint Background - Same as Dashboard
          CustomPaint(
            painter: HomeBackgroundPainter(),
            size: Size(screenWidth, screenHeight),
          ),
          // Main Content
          CustomScrollView(
            slivers: [
              // App Bar - Same design as Dashboard
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
              // Grid Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                  child: Column(
                    children: [
                      ResponsiveSizedBox.height20,
                      GridView.builder(
                        padding: EdgeInsets.all(0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: ResponsiveUtils.wp(4),
                          mainAxisSpacing: ResponsiveUtils.hp(2),
                          childAspectRatio: 1,
                        ),
                        itemCount: approvalOptions.length,
                        itemBuilder: (context, index) {
                          final option = approvalOptions[index];
                          return _buildApprovalCard(option);
                        },
                      ),
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
                        text: 'Approvals',
                        weight: FontWeight.bold,
                        color: Appcolors.kblackcolor,
                        overflow: TextOverflow.ellipsis,
                      ),
                      TextStyles.caption(
                        text: 'Pending requests',
                        color: Appcolors.kgreyColor.withOpacity(0.7),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildApprovalCard(Map<String, dynamic> option) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${option['label']} tapped'),
            duration: const Duration(milliseconds: 800),
            behavior: SnackBarBehavior.floating,
            backgroundColor: option['color'],
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
        decoration: BoxDecoration(
          color: Appcolors.kwhitecolor,
          borderRadius: BorderRadiusStyles.kradius15(),
          boxShadow: [
            BoxShadow(
              color: Appcolors.kgreyColor.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container with badge
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.wp(5)),
              decoration: BoxDecoration(
                color: option['color'].withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                option['iconPath'],
                height: ResponsiveUtils.hp(6),
                width: ResponsiveUtils.wp(12),
                color: option['color'],
              ),
            ),
            ResponsiveSizedBox.height15,
            // Label
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.wp(2)),
              child: TextStyles.medium(
                text: option['label'],
                weight: FontWeight.w600,
                color: Appcolors.kblackcolor,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ResponsiveSizedBox.height10,

          ],
        ),
      ),
    );
  }
}