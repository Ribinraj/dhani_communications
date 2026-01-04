import 'package:dhani_communications/core/constants.dart';
import 'package:flutter/material.dart';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';

class ScreenExpenseDetailPage extends StatefulWidget {
  const ScreenExpenseDetailPage({super.key});

  @override
  State<ScreenExpenseDetailPage> createState() =>
      _ScreenExpenseDetailPageState();
}

class _ScreenExpenseDetailPageState extends State<ScreenExpenseDetailPage> {
  // Sample expense detail data
  final Map<String, dynamic> expenseDetail = {
    'date': '03 Jan 2026',
    'projectName': 'Mobile App Development Project',
    'category': 'Travel',
    'amount': '₹2,500',
    'status': 'Approved',
    'approver': 'Rajesh Kumar',
    'userRemarks': 'Travel expenses for client meeting at Mumbai office. Discussed project requirements and timeline with the stakeholders.',
    'documents': [
      {
        'name': 'Invoice_001.pdf',
        'size': '245 KB',
        'type': 'pdf',
      },
      {
        'name': 'Receipt_Travel.jpg',
        'size': '1.2 MB',
        'type': 'image',
      },
      {
        'name': 'Bill_Taxi.pdf',
        'size': '156 KB',
        'type': 'pdf',
      },
    ],
  };

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Travel':
        return Colors.blue;
      case 'Food':
        return Colors.orange;
      case 'Accommodation':
        return Colors.purple;
      case 'Supplies':
        return Colors.teal;
      case 'Entertainment':
        return Colors.pink;
      default:
        return Appcolors.kprimarycolor;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Travel':
        return Icons.directions_car;
      case 'Food':
        return Icons.restaurant;
      case 'Accommodation':
        return Icons.hotel;
      case 'Supplies':
        return Icons.shopping_bag;
      case 'Entertainment':
        return Icons.celebration;
      default:
        return Icons.receipt;
    }
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
        return Appcolors.kgreyColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String status = expenseDetail['status'];
    final Color categoryColor = _getCategoryColor(expenseDetail['category']);

    Color statusColor;
    IconData statusIcon;
    if (status == 'Approved') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (status == 'Rejected') {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
    } else {
      statusColor = Colors.orange;
      statusIcon = Icons.pending;
    }

    return Scaffold(
      backgroundColor: Appcolors.kwhitecolor,
      appBar: AppBar(
        backgroundColor: Appcolors.kwhitecolor,
        elevation: 2,
        shadowColor: Appcolors.kgreyColor.withOpacity(0.1),
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
          text: 'Expense Details',
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
                    Appcolors.kprimarycolor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadiusStyles.kradius15(),
                boxShadow: [
                  BoxShadow(
                    color: Appcolors.kprimarycolor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextStyles.caption(
                    text: 'Total Amount',
                    color: Appcolors.kwhitecolor.withOpacity(0.9),
                  ),
                  ResponsiveSizedBox.height10,
                  Text(
                    expenseDetail['amount'],
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
                    color: Appcolors.kgreyColor.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextStyles.subheadline(
                    text: 'Expense Information',
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                  ),
                  ResponsiveSizedBox.height20,

                  // Date
                  _buildDetailRow(
                    icon: Icons.calendar_today,
                    iconColor: Appcolors.kprimarycolor,
                    label: 'Date',
                    value: expenseDetail['date'],
                  ),
                  ResponsiveSizedBox.height20,

                  // Project Name
                  _buildDetailRow(
                    icon: Icons.work_outline,
                    iconColor: Colors.purple,
                    label: 'Project Name',
                    value: expenseDetail['projectName'],
                  ),
                  ResponsiveSizedBox.height20,

                  // Category
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.1),
                          borderRadius: BorderRadiusStyles.kradius10(),
                        ),
                        child: Icon(
                          _getCategoryIcon(expenseDetail['category']),
                          color: categoryColor,
                          size: ResponsiveUtils.sp(5),
                        ),
                      ),
                      ResponsiveSizedBox.width(3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextStyles.caption(
                              text: 'Category',
                              color: Appcolors.kgreyColor,
                            ),
                            ResponsiveSizedBox.height5,
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveUtils.wp(3),
                                vertical: ResponsiveUtils.hp(0.6),
                              ),
                              decoration: BoxDecoration(
                                color: categoryColor.withOpacity(0.1),
                                borderRadius: BorderRadiusStyles.kradius5(),
                              ),
                              child: TextStyles.medium(
                                text: expenseDetail['category'],
                                weight: FontWeight.w600,
                          
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height20,

                  // Approver
                  _buildDetailRow(
                    icon: Icons.person_outline,
                    iconColor: Colors.teal,
                    label: 'Approver',
                    value: expenseDetail['approver'],
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
                    color: Appcolors.kgreyColor.withOpacity(0.15),
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
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadiusStyles.kradius10(),
                        ),
                        child: Icon(
                          Icons.comment,
                          color: Colors.amber.shade700,
                          size: ResponsiveUtils.sp(5),
                        ),
                      ),
                      ResponsiveSizedBox.width(2),
                      TextStyles.subheadline(
                        text: 'User Remarks',
                        weight: FontWeight.bold,
                        color: Appcolors.kblackcolor,
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height15,
                  TextStyles.medium(
                    text: expenseDetail['userRemarks'],
                    color: Appcolors.kgreyColor,
                
                  ),
                ],
              ),
            ),
            ResponsiveSizedBox.height(3),

            // Documents Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadiusStyles.kradius10(),
                        ),
                        child: Icon(
                          Icons.attachment,
                          color: Colors.blue,
                          size: ResponsiveUtils.sp(5),
                        ),
                      ),
                      ResponsiveSizedBox.width(2),
                      TextStyles.subheadline(
                        text: 'Documents',
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
                          color: Appcolors.kprimarycolor.withOpacity(0.1),
                          borderRadius: BorderRadiusStyles.kradius20(),
                        ),
                        child: TextStyles.caption(
                          text: '${expenseDetail['documents'].length} files',
                          weight: FontWeight.w600,
                          color: Appcolors.kprimarycolor,
                        ),
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height15,
                  // Documents List
                  ...List.generate(
                    expenseDetail['documents'].length,
                    (index) {
                      final document = expenseDetail['documents'][index];
                      return _buildDocumentItem(document, index);
                    },
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
      children: [
        Container(
          padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
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

  Widget _buildDocumentItem(Map<String, dynamic> document, int index) {
    final Color docColor = _getDocumentColor(document['type']);

    return Container(
      margin: EdgeInsets.only(
        bottom: index < expenseDetail['documents'].length - 1
            ? ResponsiveUtils.hp(1.5)
            : 0,
      ),
      padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
      decoration: BoxDecoration(
        color: docColor.withOpacity(0.05),
        borderRadius: BorderRadiusStyles.kradius10(),
        border: Border.all(
          color: docColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.wp(2.5)),
            decoration: BoxDecoration(
              color: docColor.withOpacity(0.1),
              borderRadius: BorderRadiusStyles.kradius10(),
            ),
            child: Icon(
              _getDocumentIcon(document['type']),
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
                  text: document['name'],
                  weight: FontWeight.w600,
                  color: Appcolors.kblackcolor,
                  overflow: TextOverflow.ellipsis,
                ),
                ResponsiveSizedBox.height5,
                TextStyles.caption(
                  text: document['size'],
                  color: Appcolors.kgreyColor,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Handle document download/view
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Opening ${document['name']}'),
                  duration: Duration(milliseconds: 1500),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Appcolors.kprimarycolor,
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