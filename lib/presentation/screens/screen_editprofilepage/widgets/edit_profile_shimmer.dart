import 'package:flutter/material.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:dhani_communications/core/constants.dart';

/// Shimmer effect widget for loading states
class ShimmerWidget extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerWidget({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadiusStyles.kradius10(),
            gradient: LinearGradient(
              begin: Alignment(_animation.value, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: [
                Appcolors.kgreyColor.withOpacity(0.1),
                Appcolors.kgreyColor.withOpacity(0.2),
                Appcolors.kgreyColor.withOpacity(0.1),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Edit profile page shimmer loading widget
class EditProfileShimmer extends StatelessWidget {
  const EditProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ResponsiveSizedBox.height20,
          // Profile Picture Editor Shimmer
          _buildProfilePictureShimmer(),
          ResponsiveSizedBox.height30,
          // Form Section Shimmers
          _buildFormSectionShimmer(),
          ResponsiveSizedBox.height20,
          _buildFormSectionShimmer(),
          ResponsiveSizedBox.height20,
          _buildFormSectionShimmer(),
          ResponsiveSizedBox.height20,
          // Save Button Shimmer
          _buildSaveButtonShimmer(),
          ResponsiveSizedBox.height20,
        ],
      ),
    );
  }

  Widget _buildProfilePictureShimmer() {
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
          ShimmerWidget(
            width: ResponsiveUtils.wp(30),
            height: ResponsiveUtils.wp(30),
            borderRadius: BorderRadius.circular(ResponsiveUtils.wp(15)),
          ),
          ResponsiveSizedBox.height15,
          ShimmerWidget(
            width: ResponsiveUtils.wp(45),
            height: ResponsiveUtils.hp(2),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSectionShimmer() {
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
          // Section Header Shimmer
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
                ShimmerWidget(
                  width: ResponsiveUtils.wp(10),
                  height: ResponsiveUtils.wp(10),
                ),
                ResponsiveSizedBox.width(3),
                ShimmerWidget(
                  width: ResponsiveUtils.wp(35),
                  height: ResponsiveUtils.hp(2),
                ),
              ],
            ),
          ),
          // Form Fields Shimmer
          Padding(
            padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
            child: Column(
              children: List.generate(
                4,
                (index) => Padding(
                  padding: EdgeInsets.only(bottom: ResponsiveUtils.hp(2)),
                  child: ShimmerWidget(
                    width: double.infinity,
                    height: ResponsiveUtils.hp(6),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButtonShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.wp(4)),
      child: ShimmerWidget(
        width: double.infinity,
        height: ResponsiveUtils.hp(6),
        borderRadius: BorderRadiusStyles.kradius15(),
      ),
    );
  }
}
