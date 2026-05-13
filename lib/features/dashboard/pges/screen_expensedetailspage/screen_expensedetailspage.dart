import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/features/dashboard/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';
import 'package:dhani_communications/core/localization/app_localization.dart';

class ScreenExpenseDetailPage extends StatelessWidget {
  final ExpenseModel? expense;

  const ScreenExpenseDetailPage({super.key, this.expense});

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  String _getStatusDisplay(String status) {
    if (status.toUpperCase() == 'APPROVED') return 'Approved';
    if (status.toUpperCase() == 'REJECTED') return 'Rejected';
    return 'Pending';
  }

  bool _isApproved(String status) => status.toUpperCase() == 'APPROVED';
  bool _isRejected(String status) => status.toUpperCase() == 'REJECTED';

  Future<void> _openDocument(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.tr('could_not_open_document')),
              duration: Duration(milliseconds: 1500),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              margin: EdgeInsets.only(
                bottom: ResponsiveUtils.hp(2),
                left: ResponsiveUtils.wp(4),
                right: ResponsiveUtils.wp(4),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusStyles.kradius10(),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.trParams('error_opening_document', {'error': e}),
            ),
            duration: Duration(milliseconds: 1500),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            margin: EdgeInsets.only(
              bottom: ResponsiveUtils.hp(2),
              left: ResponsiveUtils.wp(4),
              right: ResponsiveUtils.wp(4),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusStyles.kradius10(),
            ),
          ),
        );
      }
    }
  }

  String _getDocumentType(String url) {
    final lowerUrl = url.toLowerCase();
    if (lowerUrl.contains('.pdf')) return 'pdf';
    if (lowerUrl.contains('.jpg') ||
        lowerUrl.contains('.jpeg') ||
        lowerUrl.contains('.png')) {
      return 'image';
    }
    if (lowerUrl.contains('.doc') || lowerUrl.contains('.docx')) return 'doc';
    return 'file';
  }

  IconData _getDocumentIcon(String type) {
    switch (type) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'image':
        return Icons.image;
      case 'doc':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getDocumentColor(String type) {
    switch (type) {
      case 'pdf':
        return Colors.red;
      case 'image':
        return Colors.blue;
      case 'doc':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenseData = expense;

    if (expenseData == null) {
      return Scaffold(
        backgroundColor: Appcolors.kwhitecolor,
        appBar: AppBar(
          backgroundColor: Appcolors.kappbarbackgroundcolor,

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
          title: TextStyles.title(
            text: context.tr('expense_details'),
            weight: FontWeight.bold,
            color: Appcolors.kblackcolor,
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: ResponsiveUtils.sp(20),
                color: Appcolors.kgreyColor.withValues(alpha: 0.5),
              ),
              ResponsiveSizedBox.height20,
              TextStyles.title(
                text: context.tr('no_expense_data_available'),
                color: Appcolors.kgreyColor,
              ),
            ],
          ),
        ),
      );
    }

    final String status = _getStatusDisplay(expenseData.status);
    final bool isApproved = _isApproved(expenseData.status);
    final bool isRejected = _isRejected(expenseData.status);

    Color statusColor;
    IconData statusIcon;
    if (isApproved) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (isRejected) {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
    } else {
      statusColor = Colors.orange;
      statusIcon = Icons.pending;
    }

    return Scaffold(
      backgroundColor: Appcolors.kwhitecolor,
      appBar: AppBar(
        backgroundColor: Appcolors.kappbarbackgroundcolor,

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
        //elevation: 0,
        title: TextStyles.title(
          text: context.tr('expense_details'),
          weight: FontWeight.bold,
          color: Appcolors.kblackcolor,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(ResponsiveUtils.wp(6)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Appcolors.kprimarycolor,
                    Appcolors.kprimarycolor.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadiusStyles.kradius15(),
                boxShadow: [
                  BoxShadow(
                    color: Appcolors.kprimarycolor.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextStyles.caption(
                    text: context.tr('total_amount'),
                    color: Appcolors.kwhitecolor.withValues(alpha: 0.9),
                  ),
                  ResponsiveSizedBox.height10,
                  Text(
                    '₹${expenseData.expenseAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(12),
                      fontWeight: FontWeight.bold,
                      color: Appcolors.kwhitecolor,
                    ),
                  ),
                  ResponsiveSizedBox.height10,
                  // Status Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.wp(4),
                      vertical: ResponsiveUtils.hp(0.8),
                    ),
                    decoration: BoxDecoration(
                      color: Appcolors.kwhitecolor,
                      borderRadius: BorderRadiusStyles.kradius20(),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          statusIcon,
                          color: statusColor,
                          size: ResponsiveUtils.sp(4.5),
                        ),
                        ResponsiveSizedBox.width(1.5),
                        TextStyles.medium(
                          text: status,
                          weight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ResponsiveSizedBox.height(3),

            // Details Card
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
                  TextStyles.title(
                    text: context.tr('expense_information'),
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                  ),
                  ResponsiveSizedBox.height20,

                  // Expense ID
                  _buildDetailRow(
                    icon: Icons.badge_rounded,
                    iconColor: Appcolors.kprimarycolor,
                    label: 'Expense ID',
                    value: '#${expenseData.expenseId}',
                  ),
                  ResponsiveSizedBox.height20,

                  // Date
                  _buildDetailRow(
                    icon: Icons.calendar_today,
                    iconColor: Appcolors.kprimarycolor,
                    label: 'Date',
                    value: _formatDate(expenseData.expenseDate),
                  ),
                  ResponsiveSizedBox.height20,

                  // Category
                  if (expenseData.expenseCategoryName.isNotEmpty &&
                      expenseData.expenseCategoryName != '-')
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
                              decoration: BoxDecoration(
                                color: Colors.purple.withValues(alpha: 0.1),
                                borderRadius: BorderRadiusStyles.kradius10(),
                              ),
                              child: Icon(
                                Icons.category_rounded,
                                color: Colors.purple,
                                size: ResponsiveUtils.sp(5),
                              ),
                            ),
                            ResponsiveSizedBox.width(3),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextStyles.caption(
                                    text: context.tr('category'),
                                    color: Appcolors.kgreyColor,
                                  ),
                                  ResponsiveSizedBox.height5,
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ResponsiveUtils.wp(3),
                                      vertical: ResponsiveUtils.hp(0.6),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.purple.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius:
                                          BorderRadiusStyles.kradius5(),
                                    ),
                                    child: TextStyles.medium(
                                      text: expenseData.expenseCategoryName,
                                      weight: FontWeight.w600,
                                      color: Colors.purple.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        ResponsiveSizedBox.height20,
                      ],
                    ),

                  // Approver
                  if (expenseData.approver.isNotEmpty)
                    Column(
                      children: [
                        _buildDetailRow(
                          icon: Icons.person_outline,
                          iconColor: Colors.teal,
                          label: 'Approver',
                          value: expenseData.approver,
                        ),
                        ResponsiveSizedBox.height20,
                      ],
                    ),

                  // Created Date
                  _buildDetailRow(
                    icon: Icons.access_time_rounded,
                    iconColor: Colors.indigo,
                    label: 'Created',
                    value: _formatDate(expenseData.createdDate),
                  ),
                ],
              ),
            ),
            ResponsiveSizedBox.height(3),

            // User Remarks Card
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
                          Icons.comment,
                          color: Colors.amber.shade700,
                          size: ResponsiveUtils.sp(5),
                        ),
                      ),
                      ResponsiveSizedBox.width(2),
                      TextStyles.title(
                        text: context.tr('user_remarks'),
                        weight: FontWeight.bold,
                        color: Appcolors.kblackcolor,
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height15,
                  TextStyles.medium(
                    text: expenseData.userRemarks.isNotEmpty
                        ? expenseData.userRemarks
                        : 'No remarks provided',
                    color: Appcolors.kgreyColor,
                  ),
                ],
              ),
            ),

            // Approver Remarks Card (if available)
            if (expenseData.approverRemarks != null &&
                expenseData.approverRemarks!.isNotEmpty) ...[
              ResponsiveSizedBox.height(3),
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
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadiusStyles.kradius10(),
                          ),
                          child: Icon(
                            Icons.verified_user_rounded,
                            color: Colors.green.shade700,
                            size: ResponsiveUtils.sp(5),
                          ),
                        ),
                        ResponsiveSizedBox.width(2),
                        TextStyles.title(
                          text: context.tr('approver_remarks'),
                          weight: FontWeight.bold,
                          color: Appcolors.kblackcolor,
                        ),
                      ],
                    ),
                    ResponsiveSizedBox.height15,
                    TextStyles.medium(
                      text: expenseData.approverRemarks!,
                      color: Appcolors.kgreyColor,
                    ),
                  ],
                ),
              ),
            ],

            // Documents Card
            if (expenseData.expenseDocuments.isNotEmpty) ...[
              ResponsiveSizedBox.height(3),
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
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadiusStyles.kradius10(),
                          ),
                          child: Icon(
                            Icons.attachment,
                            color: Colors.blue,
                            size: ResponsiveUtils.sp(5),
                          ),
                        ),
                        ResponsiveSizedBox.width(2),
                        TextStyles.title(
                          text: context.tr('documents'),
                          weight: FontWeight.bold,
                          color: Appcolors.kblackcolor,
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUtils.wp(2.5),
                            vertical: ResponsiveUtils.hp(0.5),
                          ),
                          decoration: BoxDecoration(
                            color: Appcolors.kprimarycolor.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadiusStyles.kradius20(),
                          ),
                          child: TextStyles.caption(
                            text:
                                '${expenseData.expenseDocuments.length} files',
                            weight: FontWeight.w600,
                            color: Appcolors.kprimarycolor,
                          ),
                        ),
                      ],
                    ),
                    ResponsiveSizedBox.height15,
                    // Documents List
                    ...List.generate(expenseData.expenseDocuments.length, (
                      index,
                    ) {
                      final document = expenseData.expenseDocuments[index];
                      return _buildDocumentItem(
                        context,
                        document,
                        index,
                        expenseData.expenseDocuments.length,
                      );
                    }),
                  ],
                ),
              ),
            ],
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
      children: [
        Container(
          padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadiusStyles.kradius10(),
          ),
          child: Icon(icon, color: iconColor, size: ResponsiveUtils.sp(5)),
        ),
        ResponsiveSizedBox.width(3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextStyles.caption(text: label, color: Appcolors.kgreyColor),
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

  Widget _buildDocumentItem(
    BuildContext context,
    ExpenseDocument document,
    int index,
    int totalCount,
  ) {
    final docType = _getDocumentType(document.documentUrl);
    final docColor = _getDocumentColor(docType);
    final fileName = document.documentUrl.split('/').last;

    return Container(
      margin: EdgeInsets.only(
        bottom: index < totalCount - 1 ? ResponsiveUtils.hp(1.5) : 0,
      ),
      padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
      decoration: BoxDecoration(
        color: docColor.withValues(alpha: 0.05),
        borderRadius: BorderRadiusStyles.kradius10(),
        border: Border.all(color: docColor.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.wp(2.5)),
            decoration: BoxDecoration(
              color: docColor.withValues(alpha: 0.1),
              borderRadius: BorderRadiusStyles.kradius10(),
            ),
            child: Icon(
              _getDocumentIcon(docType),
              color: docColor,
              size: ResponsiveUtils.sp(6),
            ),
          ),
          ResponsiveSizedBox.width(3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextStyles.medium(
                  text: fileName,
                  weight: FontWeight.w600,
                  color: Appcolors.kblackcolor,
                  overflow: TextOverflow.ellipsis,
                ),
                ResponsiveSizedBox.height5,
                TextStyles.caption(
                  text: docType.toUpperCase(),
                  color: Appcolors.kgreyColor,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              _openDocument(context, document.documentUrl);
            },
            icon: Icon(
              Icons.download_rounded,
              color: docColor,
              size: ResponsiveUtils.sp(5.5),
            ),
          ),
        ],
      ),
    );
  }
}
