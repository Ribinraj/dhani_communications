import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:dhani_communications/widgets/custom_snackbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

/// A reusable gallery-only attachment picker widget.
/// Supports images (jpg, jpeg, png, gif) and PDF files.
/// Unlike the expense page, this does NOT include camera capture.
class CustomGalleryPicker extends StatelessWidget {
  final List<PlatformFile> attachedFiles;
  final Function(List<PlatformFile>) onFilesChanged;
  final String buttonText;
  final List<String>? allowedExtensions;
  final bool allowMultiple;

  const CustomGalleryPicker({
    super.key,
    required this.attachedFiles,
    required this.onFilesChanged,
    this.buttonText = 'Add Attachment',
    this.allowedExtensions,
    this.allowMultiple = true,
  });

  Future<void> _pickFromGallery(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: allowMultiple,
        type: FileType.custom,
        allowedExtensions:
            allowedExtensions ?? ['pdf', 'jpg', 'jpeg', 'png', 'gif'],
      );

      if (result != null) {
        List<PlatformFile> updatedFiles = List.from(attachedFiles);
        updatedFiles.addAll(result.files);
        onFilesChanged(updatedFiles);

        if (context.mounted) {
          CustomSnackbar.show(
            context: context,
            message: '${result.files.length} file(s) attached successfully!',
            type: SnackBarType.success,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackbar.show(
          context: context,
          message: 'Error picking files',
          type: SnackBarType.error,
        );
      }
    }
  }

  void _removeFile(int index) {
    List<PlatformFile> updatedFiles = List.from(attachedFiles);
    updatedFiles.removeAt(index);
    onFilesChanged(updatedFiles);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Attachments Header with Add Button
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.wp(4),
            vertical: ResponsiveUtils.hp(1.7),
          ),
          decoration: BoxDecoration(
            color: Appcolors.kwhitecolor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: Appcolors.kbordercolor),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextStyles.medium(
                  text: 'Attachments',
                  color: Appcolors.kprimarycolor,
                  weight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () => _pickFromGallery(context),
                child: Icon(
                  Icons.add,
                  color: Appcolors.kprimarycolor,
                  size: ResponsiveUtils.sp(6),
                ),
              ),
            ],
          ),
        ),

        // Attached Files List
        if (attachedFiles.isNotEmpty) ...[
          ResponsiveSizedBox.height10,
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
            decoration: BoxDecoration(
              color: Appcolors.kwhitecolor,
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.borderRadius(2.5),
              ),
              border: Border.all(color: Appcolors.kbordercolor, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...attachedFiles.asMap().entries.map((entry) {
                  int index = entry.key;
                  PlatformFile file = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(bottom: ResponsiveUtils.hp(1)),
                    child: Row(
                      children: [
                        Icon(
                          _getFileIcon(file.extension),
                          color: Appcolors.kprimarycolor,
                          size: ResponsiveUtils.sp(5),
                        ),
                        ResponsiveSizedBox.width10,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextStyles.caption(
                                text: file.name,
                                color: Appcolors.kblackcolor,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (file.size > 0) ...[
                                SizedBox(height: ResponsiveUtils.hp(0.3)),
                                TextStyles.caption(
                                  text: _formatFileSize(file.size),
                                  color: Appcolors.kgreyColor,
                                  weight: FontWeight.w400,
                                ),
                              ],
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Appcolors.kredcolor,
                          ),
                          onPressed: () => _removeFile(index),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ],
    );
  }

  IconData _getFileIcon(String? extension) {
    if (extension == null) return Icons.insert_drive_file;

    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
