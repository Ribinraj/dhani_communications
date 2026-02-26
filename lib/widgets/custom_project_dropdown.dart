import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:dhani_communications/features/dashboard/models/project_model.dart';
import 'package:flutter/material.dart';

class CustomProjectDropdown extends StatelessWidget {
  final ProjectModel? selectedProject;
  final List<ProjectModel> projects;
  final Function(ProjectModel?) onChanged;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final String? hintText;
  final bool showIcon;
  final bool showLocation;

  const CustomProjectDropdown({
    super.key,
    required this.selectedProject,
    required this.projects,
    required this.onChanged,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.hintText,
    this.showIcon = true,
    this.showLocation = true,
  });

  @override
  Widget build(BuildContext context) {
    // Loading state
    if (isLoading) {
      return Container(
        padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
        decoration: BoxDecoration(
          border: Border.all(color: Appcolors.kgreyColor.withOpacity(0.3)),
          borderRadius: BorderRadiusStyles.kradius10(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: ResponsiveUtils.wp(5),
              height: ResponsiveUtils.wp(5),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Appcolors.kprimarycolor,
              ),
            ),
            ResponsiveSizedBox.width(3),
            TextStyles.medium(
              text: 'Loading projects...',
              color: Appcolors.kgreyColor,
            ),
          ],
        ),
      );
    }

    // Error state
    if (errorMessage != null && errorMessage!.isNotEmpty) {
      return Container(
        padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red.withOpacity(0.3)),
          borderRadius: BorderRadiusStyles.kradius10(),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: ResponsiveUtils.sp(5),
            ),
            ResponsiveSizedBox.width(2),
            Expanded(
              child: TextStyles.medium(text: errorMessage!, color: Colors.red),
            ),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                child: TextStyles.medium(
                  text: 'Retry',
                  color: Appcolors.kprimarycolor,
                ),
              ),
          ],
        ),
      );
    }

    // Empty state
    if (projects.isEmpty) {
      return Container(
        padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
        decoration: BoxDecoration(
          border: Border.all(color: Appcolors.kgreyColor.withOpacity(0.3)),
          borderRadius: BorderRadiusStyles.kradius10(),
        ),
        child: Row(
          children: [
            if (showIcon) ...[
              Icon(
                Icons.business_center_rounded,
                color: Appcolors.kgreyColor,
                size: ResponsiveUtils.sp(5),
              ),
              ResponsiveSizedBox.width(3),
            ],
            TextStyles.medium(
              text: 'No projects available',
              color: Appcolors.kgreyColor,
            ),
          ],
        ),
      );
    }

    // Normal dropdown state
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Appcolors.kbordercolor),
        borderRadius: BorderRadiusStyles.kradius10(),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ProjectModel>(
          isExpanded: true,
          hint: Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.wp(4)),
            child: Row(
              children: [
                if (showIcon) ...[
                  Icon(
                    Icons.business_center_rounded,
                    color: Appcolors.kprimarycolor,
                    size: ResponsiveUtils.sp(5),
                  ),
                  ResponsiveSizedBox.width(3),
                ],
                TextStyles.medium(
                  text: hintText ?? 'Select a project',
                  color: Appcolors.kgreyColor,
                ),
              ],
            ),
          ),
          value: selectedProject,
          icon: Padding(
            padding: EdgeInsets.only(right: ResponsiveUtils.wp(3)),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Appcolors.kprimarycolor,
              size: ResponsiveUtils.sp(6),
            ),
          ),
          borderRadius: BorderRadiusStyles.kradius10(),
          dropdownColor: Appcolors.kwhitecolor,
          items: projects.map((ProjectModel project) {
            return DropdownMenuItem<ProjectModel>(
              value: project,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.wp(4),
                  vertical: ResponsiveUtils.hp(0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextStyles.medium(
                      text: project.projectName,
                      weight: FontWeight.w600,
                      color: Appcolors.kblackcolor,
                    ),
                    if (showLocation &&
                        project.projectLocation.isNotEmpty &&
                        project.projectLocation != '-')
                      TextStyles.caption(
                        text: project.projectLocation,
                        color: Appcolors.kgreyColor,
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          selectedItemBuilder: (BuildContext context) {
            return projects.map((ProjectModel project) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.wp(4),
                ),
                child: Row(
                  children: [
                    if (showIcon) ...[
                      Icon(
                        Icons.business_center_rounded,
                        color: Appcolors.kprimarycolor,
                        size: ResponsiveUtils.sp(5),
                      ),
                      ResponsiveSizedBox.width(3),
                    ],
                    Expanded(
                      child: TextStyles.medium(
                        text: project.projectName,
                        weight: FontWeight.w600,
                        color: Appcolors.kblackcolor,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}
