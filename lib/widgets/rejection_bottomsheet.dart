import 'package:flutter/material.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:dhani_communications/widgets/custom_formtextfield.dart';
import 'package:dhani_communications/widgets/custom_snackbar.dart';

/// A common bottom sheet for rejection remarks.
///
/// Usage:
/// ```dart
/// RejectionBottomSheet.show(
///   context: context,
///   title: 'Reject Attendance',
///   subtitle: 'Please provide a reason for rejecting this attendance record.',
///   onReject: (remarks) {
///     // handle rejection with the remarks
///   },
/// );
/// ```
class RejectionBottomSheet {
  static void show({
    required BuildContext context,
    required String title,
    required String subtitle,
    required void Function(String remarks) onReject,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return _RejectionBottomSheetContent(
          title: title,
          subtitle: subtitle,
          onReject: onReject,
        );
      },
    );
  }
}

class _RejectionBottomSheetContent extends StatefulWidget {
  final String title;
  final String subtitle;
  final void Function(String remarks) onReject;

  const _RejectionBottomSheetContent({
    required this.title,
    required this.subtitle,
    required this.onReject,
  });

  @override
  State<_RejectionBottomSheetContent> createState() =>
      _RejectionBottomSheetContentState();
}

class _RejectionBottomSheetContentState
    extends State<_RejectionBottomSheetContent> {
  late final TextEditingController _remarksController;

  @override
  void initState() {
    super.initState();
    _remarksController = TextEditingController();
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Appcolors.kwhitecolor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(ResponsiveUtils.wp(6)),
            topRight: Radius.circular(ResponsiveUtils.wp(6)),
          ),
        ),
        padding: EdgeInsets.all(ResponsiveUtils.wp(6)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: ResponsiveUtils.wp(12),
                  height: ResponsiveUtils.hp(0.5),
                  decoration: BoxDecoration(
                    color: Appcolors.kgreyColor.withOpacity(0.3),
                    borderRadius: BorderRadiusStyles.kradius10(),
                  ),
                ),
              ),
              ResponsiveSizedBox.height20,
              // Title Row
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(ResponsiveUtils.wp(2.5)),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadiusStyles.kradius10(),
                    ),
                    child: Icon(
                      Icons.cancel_rounded,
                      color: Colors.red,
                      size: ResponsiveUtils.sp(6),
                    ),
                  ),
                  ResponsiveSizedBox.width(3),
                  Expanded(
                    child: TextStyles.headline(
                      text: widget.title,
                      weight: FontWeight.bold,
                      color: Appcolors.kblackcolor,
                    ),
                  ),
                ],
              ),
              ResponsiveSizedBox.height15,
              TextStyles.body(
                text: widget.subtitle,
                color: Appcolors.kgreyColor,
              ),
              ResponsiveSizedBox.height20,
              // Remarks text field
              CustomFormtextfield(
                controller: _remarksController,
                hintText: 'Enter rejection remarks',
                maxLines: 3,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(
                    left: ResponsiveUtils.wp(3),
                    bottom: ResponsiveUtils.hp(4),
                  ),
                  child: Icon(
                    Icons.note_alt_outlined,
                    color: Appcolors.kprimarycolor,
                    size: ResponsiveUtils.sp(5),
                  ),
                ),
              ),
              ResponsiveSizedBox.height30,
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveUtils.hp(1.5),
                        ),
                        side: BorderSide(
                          color: Appcolors.kgreyColor,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusStyles.kradius10(),
                        ),
                      ),
                      child: TextStyles.medium(
                        text: 'Cancel',
                        weight: FontWeight.w600,
                        color: Appcolors.kgreyColor,
                      ),
                    ),
                  ),
                  ResponsiveSizedBox.width(3),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_remarksController.text.trim().isEmpty) {
                          CustomSnackbar.show(
                            context: context,
                            message: 'Please enter rejection remarks',
                            type: SnackBarType.info,
                          );
                          return;
                        }
                        final remarks = _remarksController.text.trim();
                        Navigator.pop(context);
                        widget.onReject(remarks);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveUtils.hp(1.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusStyles.kradius10(),
                        ),
                      ),
                      child: TextStyles.medium(
                        text: 'Reject',
                        weight: FontWeight.w600,
                        color: Appcolors.kwhitecolor,
                      ),
                    ),
                  ),
                ],
              ),
              ResponsiveSizedBox.height10,
            ],
          ),
        ),
      ),
    );
  }
}
