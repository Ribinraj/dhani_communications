import 'package:dhani_communications/core/constants.dart';
import 'package:flutter/material.dart';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';

class ScreenInventoryDetailPage extends StatefulWidget {
  const ScreenInventoryDetailPage({super.key});

  @override
  State<ScreenInventoryDetailPage> createState() =>
      _ScreenInventoryDetailPageState();
}

class _ScreenInventoryDetailPageState extends State<ScreenInventoryDetailPage> {
  // Sample inventory detail data
  final Map<String, dynamic> inventoryDetail = {
    'itemName': 'Cement Bags - Portland',
    'issuedFrom': 'Main Warehouse',
    'issuedDate': '03 Jan 2026',
    'receivedFrom': 'Site Manager - Rajesh Kumar',
    'quantity': '500',
    'unit': 'Bags',
    'headquarter': 'Mumbai Central Office',
    'projectName': 'Construction Project - Tower B',
    'status': 'Issued',
    'transferDate': '05 Jan 2026',
    'returnDate': '15 Jan 2026',
  };

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Issued':
        return Colors.blue;
      case 'Transferred':
        return Colors.orange;
      case 'Returned':
        return Colors.green;
      case 'Consumed':
        return Colors.purple;
      default:
        return Appcolors.kgreyColor;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Issued':
        return Icons.inventory_2;
      case 'Transferred':
        return Icons.swap_horiz;
      case 'Returned':
        return Icons.assignment_return;
      case 'Consumed':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  void _handleConsume() {
    // Implement consume logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item marked as consumed')),
    );
  }

  void _handleTransfer() {
    // Implement transfer logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transfer initiated')),
    );
  }

  void _handleReturn() {
    // Implement return logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Return process started')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String status = inventoryDetail['status'];
    final Color statusColor = _getStatusColor(status);
    final IconData statusIcon = _getStatusIcon(status);

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
          text: 'Inventory Details',
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
            // Item Information Card
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
                    text: 'Item Information',
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                  ),
                  ResponsiveSizedBox.height20,

                  // Item Name
                  _buildDetailRow(
                    icon: Icons.inventory,
                    iconColor: Appcolors.kprimarycolor,
                    label: 'Item Name',
                    value: inventoryDetail['itemName'],
                  ),
                  ResponsiveSizedBox.height20,

                  // Quantity and Unit Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailRow(
                          icon: Icons.numbers,
                          iconColor: Colors.teal,
                          label: 'Quantity',
                          value: inventoryDetail['quantity'],
                        ),
                      ),
                      ResponsiveSizedBox.width(2),
                      Expanded(
                        child: _buildDetailRow(
                          icon: Icons.scale,
                          iconColor: Colors.indigo,
                          label: 'Unit',
                          value: inventoryDetail['unit'],
                        ),
                      ),
                    ],
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
                                text: status,
                                weight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ResponsiveSizedBox.height(3),

            // Location Information Card
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
                    text: 'Location Information',
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                  ),
                  ResponsiveSizedBox.height20,

                  // Issued From
                  _buildDetailRow(
                    icon: Icons.warehouse,
                    iconColor: Colors.orange,
                    label: 'Issued From',
                    value: inventoryDetail['issuedFrom'],
                  ),
                  ResponsiveSizedBox.height20,

                  // Headquarter
                  _buildDetailRow(
                    icon: Icons.business,
                    iconColor: Colors.purple,
                    label: 'Headquarter',
                    value: inventoryDetail['headquarter'],
                  ),
                  ResponsiveSizedBox.height20,

                  // Project Name
                  _buildDetailRow(
                    icon: Icons.work_outline,
                    iconColor: Colors.blue,
                    label: 'Project Name',
                    value: inventoryDetail['projectName'],
                  ),
                ],
              ),
            ),
            ResponsiveSizedBox.height(3),

            // Transfer Information Card
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
                    text: 'Transfer Information',
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                  ),
                  ResponsiveSizedBox.height20,

                  // Received From
                  _buildDetailRow(
                    icon: Icons.person_outline,
                    iconColor: Colors.teal,
                    label: 'Received From',
                    value: inventoryDetail['receivedFrom'],
                  ),
                  ResponsiveSizedBox.height20,

                  // Issued Date
                  _buildDetailRow(
                    icon: Icons.calendar_today,
                    iconColor: Colors.green,
                    label: 'Issued Date',
                    value: inventoryDetail['issuedDate'],
                  ),
                  ResponsiveSizedBox.height20,

                  // Transfer Date
                  _buildDetailRow(
                    icon: Icons.swap_horiz,
                    iconColor: Colors.orange,
                    label: 'Transfer Date',
                    value: inventoryDetail['transferDate'],
                  ),
                  ResponsiveSizedBox.height20,

                  // Return Date
                  _buildDetailRow(
                    icon: Icons.event_repeat,
                    iconColor: Colors.red,
                    label: 'Return Date',
                    value: inventoryDetail['returnDate'],
                  ),
                ],
              ),
            ),
            ResponsiveSizedBox.height(3),

            // Action Buttons
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
                    text: 'Actions',
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                  ),
                  ResponsiveSizedBox.height20,

                  // Consume Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _handleConsume,
                      icon: const Icon(Icons.check_circle_outline),
                      label: TextStyles.medium(
                        text: 'Consume',
                        weight: FontWeight.w600,
                        color: Appcolors.kwhitecolor,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Appcolors.kwhitecolor,
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveUtils.hp(1.8),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusStyles.kradius10(),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                  ResponsiveSizedBox.height15,

                  // Transfer Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _handleTransfer,
                      icon: const Icon(Icons.swap_horiz),
                      label: TextStyles.medium(
                        text: 'Transfer',
                        weight: FontWeight.w600,
                        color: Appcolors.kwhitecolor,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Appcolors.kwhitecolor,
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveUtils.hp(1.8),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusStyles.kradius10(),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                  ResponsiveSizedBox.height15,

                  // Return Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _handleReturn,
                      icon: const Icon(Icons.assignment_return),
                      label: TextStyles.medium(
                        text: 'Return',
                        weight: FontWeight.w600,
                        color: Appcolors.kwhitecolor,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Appcolors.kwhitecolor,
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveUtils.hp(1.8),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusStyles.kradius10(),
                        ),
                        elevation: 2,
                      ),
                    ),
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