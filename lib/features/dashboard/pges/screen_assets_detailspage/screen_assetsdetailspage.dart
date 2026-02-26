import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/features/dashboard/models/company_asset_model.dart';
import 'package:flutter/material.dart';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';

class ScreenAssetDetailsPage extends StatelessWidget {
  final CompanyAssetModel? asset;

  const ScreenAssetDetailsPage({super.key, this.asset});

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

  String _formatCurrency(double amount) {
    if (amount >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(2)} Cr';
    } else if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(2)} L';
    } else if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(2)} K';
    } else {
      return '₹${amount.toStringAsFixed(0)}';
    }
  }

  Color _getAssetGroupColor(String assetGroupName) {
    final group = assetGroupName.toLowerCase();
    if (group.contains('laptop')) return Colors.blue;
    if (group.contains('phone') || group.contains('mobile')) return Colors.teal;
    if (group.contains('vehicle') || group.contains('car'))
      return Colors.orange;
    if (group.contains('furniture')) return Colors.brown;
    if (group.contains('electronic')) return Colors.purple;
    return Appcolors.kprimarycolor;
  }

  IconData _getAssetGroupIcon(String assetGroupName) {
    final group = assetGroupName.toLowerCase();
    if (group.contains('laptop')) return Icons.laptop_mac;
    if (group.contains('phone') || group.contains('mobile'))
      return Icons.phone_android;
    if (group.contains('vehicle') || group.contains('car'))
      return Icons.directions_car;
    if (group.contains('furniture')) return Icons.chair;
    if (group.contains('electronic')) return Icons.electrical_services;
    return Icons.inventory_2_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final assetData = asset;

    if (assetData == null) {
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
            text: 'Asset Details',
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
                color: Appcolors.kgreyColor.withOpacity(0.5),
              ),
              ResponsiveSizedBox.height20,
              TextStyles.subheadline(
                text: 'No asset data available',
                color: Appcolors.kgreyColor,
              ),
            ],
          ),
        ),
      );
    }

    final String status = assetData.status;
    final Color assetGroupColor = _getAssetGroupColor(assetData.assetGroupName);

    Color statusColor;
    IconData statusIcon;
    if (status.toUpperCase() == 'ACTIVE') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (status.toUpperCase() == 'INACTIVE') {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
    } else if (status.toUpperCase() == 'UNDER MAINTENANCE' ||
        status.toUpperCase() == 'MAINTENANCE') {
      statusColor = Colors.orange;
      statusIcon = Icons.build_circle;
    } else {
      statusColor = Appcolors.kgreyColor;
      statusIcon = Icons.info;
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
          text: 'Asset Details',
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
            // Asset Image Card
            Container(
              width: double.infinity,
              height: ResponsiveUtils.hp(30),
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
              child: ClipRRect(
                borderRadius: BorderRadiusStyles.kradius15(),
                child: Stack(
                  children: [
                    // Asset Image
                    assetData.picture.isNotEmpty
                        ? Image.network(
                            assetData.picture,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Appcolors.kgreyColor.withOpacity(0.1),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Appcolors.kprimarycolor,
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Appcolors.kgreyColor.withOpacity(0.1),
                                  child: Icon(
                                    _getAssetGroupIcon(
                                      assetData.assetGroupName,
                                    ),
                                    size: ResponsiveUtils.sp(25),
                                    color: Appcolors.kgreyColor.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                ),
                          )
                        : Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Appcolors.kgreyColor.withOpacity(0.1),
                            child: Icon(
                              _getAssetGroupIcon(assetData.assetGroupName),
                              size: ResponsiveUtils.sp(25),
                              color: Appcolors.kgreyColor.withOpacity(0.3),
                            ),
                          ),
                    // Status Badge
                    Positioned(
                      top: ResponsiveUtils.hp(2),
                      right: ResponsiveUtils.wp(4),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.wp(3),
                          vertical: ResponsiveUtils.hp(0.8),
                        ),
                        decoration: BoxDecoration(
                          color: Appcolors.kwhitecolor,
                          borderRadius: BorderRadiusStyles.kradius20(),
                          boxShadow: [
                            BoxShadow(
                              color: Appcolors.kgreyColor.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              statusIcon,
                              color: statusColor,
                              size: ResponsiveUtils.sp(4),
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
                    ),
                    // Asset Group Badge
                    Positioned(
                      top: ResponsiveUtils.hp(2),
                      left: ResponsiveUtils.wp(4),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.wp(3),
                          vertical: ResponsiveUtils.hp(0.8),
                        ),
                        decoration: BoxDecoration(
                          color: assetGroupColor.withOpacity(0.9),
                          borderRadius: BorderRadiusStyles.kradius20(),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getAssetGroupIcon(assetData.assetGroupName),
                              color: Appcolors.kwhitecolor,
                              size: ResponsiveUtils.sp(4),
                            ),
                            ResponsiveSizedBox.width(1.5),
                            TextStyles.medium(
                              text: assetData.assetGroupName.trim(),
                              weight: FontWeight.w600,
                              color: Appcolors.kwhitecolor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ResponsiveSizedBox.height(3),

            // Asset Information Card
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
                    text: 'Asset Information',
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                  ),
                  ResponsiveSizedBox.height20,

                  // Asset Name
                  _buildDetailRow(
                    icon: Icons.label,
                    iconColor: Appcolors.kprimarycolor,
                    label: 'Asset Name',
                    value: assetData.assetName,
                  ),
                  ResponsiveSizedBox.height20,

                  // Approximate Cost
                  _buildDetailRow(
                    icon: Icons.currency_rupee,
                    iconColor: Colors.green,
                    label: 'Approximate Cost',
                    value: _formatCurrency(assetData.approxCost),
                  ),
                  ResponsiveSizedBox.height20,

                  // Asset Group
                  _buildDetailRow(
                    icon: Icons.category,
                    iconColor: assetGroupColor,
                    label: 'Asset Group',
                    value: assetData.assetGroupName.trim(),
                  ),
                  ResponsiveSizedBox.height20,

                  // Make
                  _buildDetailRow(
                    icon: Icons.business,
                    iconColor: Colors.deepPurple,
                    label: 'Make',
                    value: assetData.make.isNotEmpty ? assetData.make : 'N/A',
                  ),
                  ResponsiveSizedBox.height20,

                  // Model
                  _buildDetailRow(
                    icon: Icons.devices,
                    iconColor: Colors.indigo,
                    label: 'Model',
                    value: assetData.model.isNotEmpty ? assetData.model : 'N/A',
                  ),
                  ResponsiveSizedBox.height20,

                  // Year of Purchase
                  _buildDetailRow(
                    icon: Icons.calendar_today,
                    iconColor: Colors.orange,
                    label: 'Year of Purchase',
                    value: assetData.yearOfPurchase.isNotEmpty
                        ? assetData.yearOfPurchase
                        : 'N/A',
                  ),
                  ResponsiveSizedBox.height20,

                  // Quantity & Unit
                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailRow(
                          icon: Icons.inventory,
                          iconColor: Colors.teal,
                          label: 'Quantity',
                          value: assetData.qty.toString(),
                        ),
                      ),
                      ResponsiveSizedBox.width(2),
                      Expanded(
                        child: _buildDetailRow(
                          icon: Icons.straighten,
                          iconColor: Colors.cyan,
                          label: 'Unit',
                          value: assetData.unit.toString(),
                        ),
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height20,

                  // Transaction Date
                  _buildDetailRow(
                    icon: Icons.event,
                    iconColor: Colors.pink,
                    label: 'Transaction Date',
                    value: _formatDate(assetData.transactionDate),
                  ),
                  ResponsiveSizedBox.height20,

                  // Headquarters
                  _buildDetailRow(
                    icon: Icons.location_city,
                    iconColor: Colors.red,
                    label: 'Headquarters',
                    value: assetData.headquarter.isNotEmpty
                        ? assetData.headquarter
                        : 'N/A',
                  ),

                  // Document No (if available)
                  if (assetData.documentNo.isNotEmpty) ...[
                    ResponsiveSizedBox.height20,
                    _buildDetailRow(
                      icon: Icons.document_scanner,
                      iconColor: Colors.blueGrey,
                      label: 'Document No',
                      value: assetData.documentNo,
                    ),
                  ],

                  ResponsiveSizedBox.height20,

                  // Status
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
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
                                color: statusColor.withOpacity(0.1),
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

            // Timestamps Card
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
                          Icons.access_time,
                          color: Colors.blue,
                          size: ResponsiveUtils.sp(5),
                        ),
                      ),
                      ResponsiveSizedBox.width(2),
                      TextStyles.subheadline(
                        text: 'Timestamps',
                        weight: FontWeight.bold,
                        color: Appcolors.kblackcolor,
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height15,
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextStyles.caption(
                              text: 'Created',
                              color: Appcolors.kgreyColor,
                            ),
                            ResponsiveSizedBox.height5,
                            TextStyles.medium(
                              text: _formatDate(assetData.createdDate),
                              weight: FontWeight.w600,
                              color: Appcolors.kblackcolor,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextStyles.caption(
                              text: 'Last Modified',
                              color: Appcolors.kgreyColor,
                            ),
                            ResponsiveSizedBox.height5,
                            TextStyles.medium(
                              text: _formatDate(assetData.lastModifiedDate),
                              weight: FontWeight.w600,
                              color: Appcolors.kblackcolor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ResponsiveSizedBox.height(4),

            // Transfer Asset Button
            SizedBox(
              width: double.infinity,
              height: ResponsiveUtils.hp(6.5),
              child: ElevatedButton(
                onPressed: () {
                  context.push('/assettransferpage', extra: assetData);
                  // Handle transfer asset action
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Transfer Asset: ${assetData.assetName}'),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Appcolors.kprimarycolor,
                  foregroundColor: Appcolors.kwhitecolor,
                  elevation: 3,
                  shadowColor: Appcolors.kprimarycolor.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusStyles.kradius15(),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.swap_horiz_rounded,
                      size: ResponsiveUtils.sp(5.5),
                    ),
                    ResponsiveSizedBox.width(2),
                    TextStyles.body(
                      text: 'Transfer Asset',
                      weight: FontWeight.bold,
                      color: Appcolors.kwhitecolor,
                    ),
                  ],
                ),
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
}
