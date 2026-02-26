import 'package:flutter/material.dart';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:shimmer/shimmer.dart';

class CustomListShimmer extends StatelessWidget {
  /// Number of shimmer cards to show in the list
  final int itemCount;

  const CustomListShimmer({super.key, this.itemCount = 10});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
      itemCount: itemCount,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => _ShimmerCard(),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 237, 237, 237),
      highlightColor: const Color.fromARGB(255, 248, 247, 247),
      child: Container(
        margin: EdgeInsets.only(bottom: ResponsiveUtils.hp(2)),
        decoration: BoxDecoration(
          color: Appcolors.kwhitecolor,
          borderRadius: BorderRadiusStyles.kradius15(),
          boxShadow: [
            BoxShadow(
              color: Appcolors.kgreyColor.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.wp(4),
            vertical: ResponsiveUtils.hp(2),
          ),
          child: Row(
            children: [
              // Circle avatar placeholder
              CircleAvatar(
                radius: ResponsiveUtils.wp(8),
                backgroundColor: Colors.grey.shade300,
              ),
              ResponsiveSizedBox.width(3),
              // Text lines placeholder
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title line
                    Container(
                      height: ResponsiveUtils.hp(2),
                      width: ResponsiveUtils.wp(40),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadiusStyles.kradius5(),
                      ),
                    ),
                    ResponsiveSizedBox.height5,
                    // Date row placeholder
                    Row(
                      children: [
                        Container(
                          height: ResponsiveUtils.hp(1.5),
                          width: ResponsiveUtils.wp(25),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadiusStyles.kradius5(),
                          ),
                        ),
                        ResponsiveSizedBox.width(2),
                        Container(
                          height: ResponsiveUtils.hp(1.5),
                          width: ResponsiveUtils.wp(15),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadiusStyles.kradius5(),
                          ),
                        ),
                      ],
                    ),
                    ResponsiveSizedBox.height5,
                    // Distance + status row placeholder
                    Row(
                      children: [
                        Container(
                          height: ResponsiveUtils.hp(1.5),
                          width: ResponsiveUtils.wp(15),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadiusStyles.kradius5(),
                          ),
                        ),
                        ResponsiveSizedBox.width(3),
                        Container(
                          height: ResponsiveUtils.hp(1.5),
                          width: ResponsiveUtils.wp(15),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadiusStyles.kradius5(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Approval icon placeholder
              Column(
                children: [
                  CircleAvatar(
                    radius: ResponsiveUtils.wp(5),
                    backgroundColor: Colors.grey.shade300,
                  ),
                  ResponsiveSizedBox.height5,
                  Container(
                    height: ResponsiveUtils.hp(1.5),
                    width: ResponsiveUtils.wp(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadiusStyles.kradius5(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
