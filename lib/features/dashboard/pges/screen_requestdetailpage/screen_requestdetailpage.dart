import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/features/dashboard/models/request_model.dart';
import 'package:flutter/material.dart';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';

class ScreenRequestDetailPage extends StatelessWidget {
  final RequestModel? request;

  const ScreenRequestDetailPage({super.key, this.request});

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      case 'PENDING':
        return Colors.orange;
      default:
        return Appcolors.kgreyColor;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return Icons.done_all;
      case 'REJECTED':
        return Icons.cancel;
      case 'PENDING':
        return Icons.pending;
      default:
        return Icons.info;
    }
  }

  String _formatDate(String rawDate) {
    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) return rawDate;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour = parsed.hour > 12 ? parsed.hour - 12 : parsed.hour;
    final period = parsed.hour >= 12 ? 'PM' : 'AM';
    final minute = parsed.minute.toString().padLeft(2, '0');
    return '${parsed.day.toString().padLeft(2, '0')} '
        '${months[parsed.month - 1]} ${parsed.year}, '
        '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  String _capitalizeFirst(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final status = request?.status ?? '';
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);

    return Scaffold(
      backgroundColor: Appcolors.kwhitecolor,
      appBar: AppBar(
        backgroundColor: Appcolors.kwhitecolor,
        elevation: 2,
        shadowColor: Appcolors.kgreyColor.withValues(alpha: 0.1),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Appcolors.kprimarycolor,
            size: ResponsiveUtils.sp(5),
          ),
        ),
        title: TextStyles.subheadline(
          text: 'Request Details',
          weight: FontWeight.bold,
          color: Appcolors.kblackcolor,
        ),
        centerTitle: true,
      ),
      body: request == null
          ? Center(
              child: TextStyles.subheadline(
                text: 'No request data available',
                color: Appcolors.kgreyColor,
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Request Information Card ──────────────────────────
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                    decoration: BoxDecoration(
                      color: Appcolors.kwhitecolor,
                      borderRadius: BorderRadiusStyles.kradius15(),
                      boxShadow: [
                        BoxShadow(
                          color: Appcolors.kgreyColor.withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextStyles.subheadline(
                          text: 'Request Information',
                          weight: FontWeight.bold,
                          color: Appcolors.kblackcolor,
                        ),
                        ResponsiveSizedBox.height20,

                        // Request ID
                        _buildDetailRow(
                          icon: Icons.tag,
                          iconColor: Appcolors.kprimarycolor,
                          label: 'Request ID',
                          value: '#${request!.requestId}',
                        ),
                        ResponsiveSizedBox.height20,

                        // Category
                        _buildDetailRow(
                          icon: Icons.category,
                          iconColor: Colors.purple,
                          label: 'Category',
                          value: request!.requestCategory,
                        ),
                        ResponsiveSizedBox.height20,

                        // Requested By
                        _buildDetailRow(
                          icon: Icons.person_outline,
                          iconColor: Colors.teal,
                          label: 'Requested By',
                          value: request!.requestedBy,
                        ),
                        ResponsiveSizedBox.height20,

                        // Status
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadiusStyles.kradius10(),
                              ),
                              child: Icon(
                                statusIcon,
                                color: statusColor,
                                size: ResponsiveUtils.sp(5),
                              ),
                            ),
                            ResponsiveSizedBox.width(3),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextStyles.caption(
                                    text: 'Status',
                                    color: Appcolors.kgreyColor,
                                  ),
                                  ResponsiveSizedBox.height5,
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ResponsiveUtils.wp(3),
                                      vertical: ResponsiveUtils.hp(0.6),
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadiusStyles.kradius5(),
                                    ),
                                    child: TextStyles.medium(
                                      text: _capitalizeFirst(status),
                                      weight: FontWeight.w600,
                                      color: statusColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        ResponsiveSizedBox.height20,

                        // Updated By
                        _buildDetailRow(
                          icon: Icons.edit_outlined,
                          iconColor: Colors.indigo,
                          label: 'Updated By',
                          value: request!.updatedBy,
                        ),
                        ResponsiveSizedBox.height20,

                        // Created At
                        _buildDetailRow(
                          icon: Icons.schedule,
                          iconColor: Colors.brown,
                          label: 'Request Created',
                          value: _formatDate(request!.createdAt),
                        ),
                        ResponsiveSizedBox.height20,

                        // Modified At
                        _buildDetailRow(
                          icon: Icons.update,
                          iconColor: Colors.blueGrey,
                          label: 'Last Modified',
                          value: _formatDate(request!.modifiedAt),
                        ),
                      ],
                    ),
                  ),
                  ResponsiveSizedBox.height(3),

                  // ── Notes Card ────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                    decoration: BoxDecoration(
                      color: Appcolors.kwhitecolor,
                      borderRadius: BorderRadiusStyles.kradius15(),
                      boxShadow: [
                        BoxShadow(
                          color: Appcolors.kgreyColor.withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
                              decoration: BoxDecoration(
                                color: Colors.amber.withValues(alpha: 0.1),
                                borderRadius: BorderRadiusStyles.kradius10(),
                              ),
                              child: Icon(
                                Icons.note_alt,
                                color: Colors.amber.shade700,
                                size: ResponsiveUtils.sp(5),
                              ),
                            ),
                            ResponsiveSizedBox.width(2),
                            TextStyles.subheadline(
                              text: 'Notes',
                              weight: FontWeight.bold,
                              color: Appcolors.kblackcolor,
                            ),
                          ],
                        ),
                        ResponsiveSizedBox.height15,
                        TextStyles.medium(
                          text: request!.notes.isEmpty
                              ? 'No notes provided.'
                              : request!.notes,
                          color: Appcolors.kgreyColor,
                        ),
                      ],
                    ),
                  ),
                  ResponsiveSizedBox.height(3),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadiusStyles.kradius10(),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: ResponsiveUtils.sp(5),
          ),
        ),
        ResponsiveSizedBox.width(3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextStyles.caption(
                text: label,
                color: Appcolors.kgreyColor,
              ),
              ResponsiveSizedBox.height5,
              TextStyles.medium(
                text: value,
                weight: FontWeight.w600,
                color: Appcolors.kblackcolor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}