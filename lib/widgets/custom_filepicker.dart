import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:file_picker/file_picker.dart';

class CustomFilePicker extends StatelessWidget {
  final List<PlatformFile> attachedFiles;
  final Function(List<PlatformFile>) onFilesChanged;
  final String buttonText;
  final List<String>? allowedExtensions;
  final bool allowMultiple;

  const CustomFilePicker({
    super.key,
    required this.attachedFiles,
    required this.onFilesChanged,
    this.buttonText = 'Add Attachment',
    this.allowedExtensions,
    this.allowMultiple = true,
  });

  Future<void> _pickFiles(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: allowMultiple,
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions ?? ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
      );

      if (result != null) {
        List<PlatformFile> updatedFiles = List.from(attachedFiles);
        updatedFiles.addAll(result.files);
        onFilesChanged(updatedFiles);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${result.files.length} file(s) attached successfully!'),
            backgroundColor: Appcolors.ksecondarycolor,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error picking files'),
          backgroundColor: Appcolors.kredcolor,
        ),
      );
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
        // Add Attachment Button
        InkWell(
          onTap: () => _pickFiles(context),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.wp(4),
              vertical: ResponsiveUtils.hp(2),
            ),
            decoration: BoxDecoration(
              color: Appcolors.kwhitecolor,
              borderRadius: BorderRadius.circular(ResponsiveUtils.borderRadius(2.5)),
              border: Border.all(
                color: Appcolors.kbordercolor,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.attach_file,
                  color: Appcolors.kprimarycolor,
                ),
                ResponsiveSizedBox.width10,
                TextStyles.body(
                  text: buttonText,
                  color: Appcolors.kprimarycolor,
                  weight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ),
        
        // Display attached files
        if (attachedFiles.isNotEmpty) ...[
          ResponsiveSizedBox.height15,
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
            decoration: BoxDecoration(
              color: Appcolors.kwhitecolor,
              borderRadius: BorderRadius.circular(ResponsiveUtils.borderRadius(2.5)),
              border: Border.all(
                color: Appcolors.kbordercolor,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextStyles.caption(
                  text: 'Attached Files (${attachedFiles.length})',
                  color: Appcolors.kblackcolor,
                  weight: FontWeight.w600,
                ),
                ResponsiveSizedBox.height10,
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
                            Icons.close,
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
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'zip':
      case 'rar':
        return Icons.folder_zip;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}