import 'dart:io';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// A reusable image picker that shows a bottom sheet with
/// Camera and Gallery options. Works for profile photos and
/// any other single-image pick use case.
class CustomImagePicker {
  /// Shows a bottom sheet with Camera and Gallery options.
  /// Returns a [File] if the user picks/captures an image, or null if cancelled.
  static Future<File?> show(BuildContext context) async {
    // First, show the bottom sheet to get user's choice
    final String? choice = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: ResponsiveUtils.hp(2),
              horizontal: ResponsiveUtils.wp(4),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Appcolors.kgreyColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ResponsiveSizedBox.height20,
                TextStyles.subheadline(
                  text: 'Choose Photo',
                  weight: FontWeight.bold,
                  color: Appcolors.kblackcolor,
                ),
                ResponsiveSizedBox.height5,
                TextStyles.caption(
                  text: 'Select an option to update your photo',
                  color: Appcolors.kgreyColor,
                ),
                ResponsiveSizedBox.height20,

                // Camera option
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Appcolors.kprimarycolor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Appcolors.kprimarycolor,
                    ),
                  ),
                  title: TextStyles.body(
                    text: 'Take a Photo',
                    color: Appcolors.kblackcolor,
                    weight: FontWeight.w500,
                  ),
                  subtitle: TextStyles.medium(
                    text: 'Use camera to capture image',
                    color: Appcolors.kgreyColor,
                  ),
                  onTap: () {
                    Navigator.pop(ctx, 'camera');
                  },
                ),
                ResponsiveSizedBox.height10,

                // Gallery option
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Appcolors.kprimarycolor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.photo_library_rounded,
                      color: Appcolors.kprimarycolor,
                    ),
                  ),
                  title: TextStyles.body(
                    text: 'Choose from Gallery',
                    color: Appcolors.kblackcolor,
                    weight: FontWeight.w500,
                  ),
                  subtitle: TextStyles.medium(
                    text: 'Pick an image from your gallery',
                    color: Appcolors.kgreyColor,
                  ),
                  onTap: () {
                    Navigator.pop(ctx, 'gallery');
                  },
                ),
                ResponsiveSizedBox.height15,
              ],
            ),
          ),
        );
      },
    );

    // If user dismissed without choosing, return null
    if (choice == null) return null;

    // Now perform the actual image picking AFTER the bottom sheet is closed
    if (choice == 'camera') {
      return await _takePhoto();
    } else if (choice == 'gallery') {
      return await _pickFromGallery();
    }

    return null;
  }

  /// Capture an image using the device camera.
  static Future<File?> _takePhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 60,
        preferredCameraDevice: CameraDevice.front,
      );

      if (photo != null) {
        return File(photo.path);
      }
    } catch (e) {
      debugPrint('Error capturing photo: $e');
    }
    return null;
  }

  /// Pick an image from the gallery.
  static Future<File?> _pickFromGallery() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
      );

      if (result != null && result.files.isNotEmpty) {
        final pickedFile = result.files.first;
        if (pickedFile.path != null) {
          return File(pickedFile.path!);
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
    return null;
  }
}
