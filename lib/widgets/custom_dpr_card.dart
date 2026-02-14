import 'dart:math';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:dhani_communications/data/models/dpr_model.dart';
import 'package:flutter/material.dart';

/// A reusable card widget to display DPR details with a circular progress indicator.
/// Shows SIC badge, description, UOM, SCQ, and completion percentage.
class CustomDprCard extends StatelessWidget {
  final DprModel dpr;
  final VoidCallback? onTap;
  final bool showArrow;

  const CustomDprCard({
    super.key,
    required this.dpr,
    this.onTap,
    this.showArrow = true,
  });

  Color _getPercentageColor(int percentage) {
    if (percentage >= 100) {
      return Colors.green;
    } else if (percentage >= 75) {
      return Colors.teal;
    } else if (percentage >= 50) {
      return Colors.orange;
    } else if (percentage >= 25) {
      return Colors.amber;
    } else {
      return Colors.red;
    }
  }

  String _formatCompleted(String completed) {
    final value = double.tryParse(completed) ?? 0;
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final percentage = dpr.percentageCompleted;
    final percentageColor = _getPercentageColor(percentage);

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
          child: Row(
            children: [
              // Circular Progress Indicator
              SizedBox(
                width: ResponsiveUtils.wp(18),
                height: ResponsiveUtils.wp(18),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background circle
                    SizedBox(
                      width: ResponsiveUtils.wp(18),
                      height: ResponsiveUtils.wp(18),
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 6,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Appcolors.kgreyColor.withOpacity(0.2),
                        ),
                      ),
                    ),
                    // Progress circle
                    SizedBox(
                      width: ResponsiveUtils.wp(18),
                      height: ResponsiveUtils.wp(18),
                      child: CircularProgressIndicator(
                        value: min(percentage / 100, 1.0),
                        strokeWidth: 6,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          percentageColor,
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    // Percentage text
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextStyles.headline(
                          text: '$percentage',
                          weight: FontWeight.bold,
                          color: percentageColor,
                        ),
                        TextStyles.caption(
                          text: '%',
                          weight: FontWeight.w600,
                          color: percentageColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ResponsiveSizedBox.width(4),
              // DPR Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SIC Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.wp(2.5),
                        vertical: ResponsiveUtils.hp(0.5),
                      ),
                      decoration: BoxDecoration(
                        color: Appcolors.kprimarycolor.withOpacity(0.1),
                        borderRadius: BorderRadiusStyles.kradius5(),
                      ),
                      child: TextStyles.caption(
                        text: 'SIC: ${dpr.sic}',
                        weight: FontWeight.w600,
                        color: Appcolors.kprimarycolor,
                      ),
                    ),
                    ResponsiveSizedBox.height10,
                    // Description - Title
                    TextStyles.subheadline(
                      text: dpr.description,
                      weight: FontWeight.bold,
                      color: Appcolors.kblackcolor,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    ResponsiveSizedBox.height5,
                    // UOM and SCQ
                    Row(
                      children: [
                        _buildInfoChip(
                          icon: Icons.straighten,
                          label: 'UOM',
                          value: dpr.uom,
                        ),
                        ResponsiveSizedBox.width(3),
                        _buildInfoChip(
                          icon: Icons.inventory_2_outlined,
                          label: 'SCQ',
                          value: dpr.scq,
                        ),
                      ],
                    ),
                    ResponsiveSizedBox.height5,
                    // Completed
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: ResponsiveUtils.sp(4),
                          color: Colors.green,
                        ),
                        ResponsiveSizedBox.width(1.5),
                        TextStyles.caption(
                          text: 'Completed: ${_formatCompleted(dpr.completed)}',
                          weight: FontWeight.w600,
                          color: Appcolors.kblackcolor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Arrow icon (optional)
              if (showArrow)
                Icon(
                  Icons.chevron_right_rounded,
                  color: Appcolors.kgreyColor,
                  size: ResponsiveUtils.sp(6),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: ResponsiveUtils.sp(3.5), color: Appcolors.kgreyColor),
        ResponsiveSizedBox.width(1),
        TextStyles.caption(text: '$label: $value', color: Appcolors.kgreyColor),
      ],
    );
  }
}
