import 'package:dhani_communications/core/constants.dart';
import 'package:flutter/material.dart';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';

class ScreenAssetDetailsPage extends StatefulWidget {
  const ScreenAssetDetailsPage({super.key});

  @override
  State<ScreenAssetDetailsPage> createState() => _ScreenAssetDetailsPageState();
}

class _ScreenAssetDetailsPageState extends State<ScreenAssetDetailsPage> {
  // Sample asset detail data
  final Map<String, dynamic> assetDetail = {
    'assetImage': 'https://via.placeholder.com/400x300', // Replace with actual asset image
    'assetGroup': 'Electronics',
    'assetName': 'Dell Latitude 7420',
    'make': 'Dell',
    'model': 'Latitude 7420',
    'yearOfPurchase': '2024',
    'quantity': '5',
    'unit': 'Pieces',
    'transactionDate': '15 Dec 2024',
    'approximateCost': '₹85,000',
    'headquarters': 'Bangalore Office',
    'status': 'Active',
  };


  @override
  Widget build(BuildContext context) {
    final String status = assetDetail['status'];

    Color statusColor;
    IconData statusIcon;
    if (status == 'Active') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (status == 'Inactive') {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
    } else if (status == 'Under Maintenance') {
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
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Appcolors.kgreyColor.withOpacity(0.1),
                      child: Icon(
                        Icons.laptop_mac,
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
                    value: assetDetail['assetName'],
                  ),
                  ResponsiveSizedBox.height20,

                  // Approximate Cost
                  _buildDetailRow(
                    icon: Icons.currency_rupee,
                    iconColor: Colors.green,
                    label: 'Approximate Cost',
                    value: assetDetail['approximateCost'],
                  ),
                  ResponsiveSizedBox.height20,

                  // Asset Group
                  _buildDetailRow(
                    icon: Icons.category,
                    iconColor: Appcolors.kprimarycolor,
                    label: 'Asset Group',
                    value: assetDetail['assetGroup'],
                  ),
                  ResponsiveSizedBox.height20,

                  // Make
                  _buildDetailRow(
                    icon: Icons.business,
                    iconColor: Colors.deepPurple,
                    label: 'Make',
                    value: assetDetail['make'],
                  ),
                  ResponsiveSizedBox.height20,

                  // Model
                  _buildDetailRow(
                    icon: Icons.devices,
                    iconColor: Colors.indigo,
                    label: 'Model',
                    value: assetDetail['model'],
                  ),
                  ResponsiveSizedBox.height20,

                  // Year of Purchase
                  _buildDetailRow(
                    icon: Icons.calendar_today,
                    iconColor: Colors.orange,
                    label: 'Year of Purchase',
                    value: assetDetail['yearOfPurchase'],
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
                          value: assetDetail['quantity'],
                        ),
                      ),
                      ResponsiveSizedBox.width(2),
                      Expanded(
                        child: _buildDetailRow(
                          icon: Icons.straighten,
                          iconColor: Colors.cyan,
                          label: 'Unit',
                          value: assetDetail['unit'],
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
                    value: assetDetail['transactionDate'],
                  ),
                  ResponsiveSizedBox.height20,

                  // Headquarters
                  _buildDetailRow(
                    icon: Icons.location_city,
                    iconColor: Colors.red,
                    label: 'Headquarters',
                    value: assetDetail['headquarters'],
                  ),
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
            ResponsiveSizedBox.height(4),

            // Transfer Asset Button
            SizedBox(
              width: double.infinity,
              height: ResponsiveUtils.hp(6.5),
              child: ElevatedButton(
                onPressed: () {
                  // Handle transfer asset action
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Transfer Asset: ${assetDetail['assetName']}'),
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