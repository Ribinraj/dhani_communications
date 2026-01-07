import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  final String hint;
  final List<String> items;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  const CustomDropdown({
    super.key,
    this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: ResponsiveUtils.sp(3.5),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.wp(4),
          vertical: ResponsiveUtils.hp(1.8),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.borderRadius(2.5)),
          borderSide: const BorderSide(
            color: Color(0xFF59CBEF),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.borderRadius(2.5)),
          borderSide: const BorderSide(
            color: Color(0xFF59CBEF),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.borderRadius(2.5)),
          borderSide: const BorderSide(
            color: Color(0xFF4F8FDF),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.borderRadius(2.5)),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(3.5),
              color: Colors.black87,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      dropdownColor: Colors.white,
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Color(0xFF4F8FDF),
      ),
    );
  }
}