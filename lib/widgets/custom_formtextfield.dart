import 'package:flutter/material.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';

class CustomFormtextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool readOnly;
  final int maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;

  const CustomFormtextfield({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      maxLines: maxLines,
      onTap: onTap,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: ResponsiveUtils.sp(3.5),
        ),
        filled: true,
        fillColor: Appcolors.kwhitecolor,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.wp(4),
          vertical: ResponsiveUtils.hp(1.8),
        ),
        border: _border(Appcolors.kbordercolor),
        enabledBorder: _border(Appcolors.kbordercolor),
        focusedBorder: _border(Appcolors.kprimarycolor, width: 2),
        errorBorder: _border(Appcolors.kredcolor),
      ),
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1.5}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        ResponsiveUtils.borderRadius(2.5),
      ),
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }
}
