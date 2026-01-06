import 'package:dhani_communications/core/constants.dart';
import 'package:flutter/material.dart';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';

class ScreenInventorypage extends StatefulWidget {
  const ScreenInventorypage({super.key});

  @override
  State<ScreenInventorypage> createState() => _ScreenAssetsPageState();
}

class _ScreenAssetsPageState extends State<ScreenInventorypage> {
  DateTime? _fromDate;
  DateTime? _toDate;

  // Sample assets data
  final List<Map<String, dynamic>> assetsList = [
    {
      'assetName': 'Dell Latitude 5520',
      'model': 'LAT-5520-i7',
      'lastUpdated': '03 Jan 2026',
      'status': 'Active',
    },
    {
      'assetName': 'iPhone 14 Pro',
      'model': 'IPHONE14P-256GB',
      'lastUpdated': '03 Jan 2026',
      'status': 'Active',
    },
    {
      'assetName': 'MacBook Pro M2',
      'model': 'MBP-M2-16-512',
      'lastUpdated': '02 Jan 2026',
      'status': 'Active',
    },
    {
      'assetName': 'HP Monitor 27"',
      'model': 'HP-E27-4K',
      'lastUpdated': '02 Jan 2026',
      'status': 'Maintenance',
    },
    {
      'assetName': 'Logitech Keyboard',
      'model': 'MX-KEYS-MINI',
      'lastUpdated': '01 Jan 2026',
      'status': 'Active',
    },
    {
      'assetName': 'Sony Headphones',
      'model': 'WH-1000XM5',
      'lastUpdated': '01 Jan 2026',
      'status': 'Inactive',
    },
    {
      'assetName': 'iPad Air',
      'model': 'IPAD-AIR-5-256',
      'lastUpdated': '31 Dec 2025',
      'status': 'Active',
    },
    {
      'assetName': 'Dell Mouse',
      'model': 'MS5120W',
      'lastUpdated': '31 Dec 2025',
      'status': 'Active',
    },
  ];

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime? tempFromDate = _fromDate;
        DateTime? tempToDate = _toDate;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusStyles.kradius20(),
              ),
              child: Container(
                padding: EdgeInsets.all(ResponsiveUtils.wp(6)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dialog Title
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(ResponsiveUtils.wp(2.5)),
                          decoration: BoxDecoration(
                            color: Appcolors.kprimarycolor.withOpacity(0.1),
                            borderRadius: BorderRadiusStyles.kradius10(),
                          ),
                          child: Icon(
                            Icons.filter_list_rounded,
                            color: Appcolors.kprimarycolor,
                            size: ResponsiveUtils.sp(6),
                          ),
                        ),
                        ResponsiveSizedBox.width(3),
                        TextStyles.headline(
                          text: 'Filter Assets',
                          weight: FontWeight.bold,
                          color: Appcolors.kblackcolor,
                        ),
                      ],
                    ),
                    ResponsiveSizedBox.height30,
                    // From Date
                    _buildDateSelector(
                      label: 'From Date',
                      date: tempFromDate,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: tempFromDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setDialogState(() {
                            tempFromDate = date;
                          });
                        }
                      },
                    ),
                    ResponsiveSizedBox.height20,
                    // To Date
                    _buildDateSelector(
                      label: 'To Date',
                      date: tempToDate,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: tempToDate ?? DateTime.now(),
                          firstDate: tempFromDate ?? DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setDialogState(() {
                            tempToDate = date;
                          });
                        }
                      },
                    ),
                    ResponsiveSizedBox.height30,
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _fromDate = null;
                                _toDate = null;
                              });
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: ResponsiveUtils.hp(1.5),
                              ),
                              side: BorderSide(
                                color: Appcolors.kgreyColor,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusStyles.kradius10(),
                              ),
                            ),
                            child: TextStyles.medium(
                              text: 'Clear',
                              weight: FontWeight.w600,
                              color: Appcolors.kgreyColor,
                            ),
                          ),
                        ),
                        ResponsiveSizedBox.width(3),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _fromDate = tempFromDate;
                                _toDate = tempToDate;
                              });
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Filter applied'),
                                  duration: Duration(milliseconds: 1000),
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
                              padding: EdgeInsets.symmetric(
                                vertical: ResponsiveUtils.hp(1.5),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusStyles.kradius10(),
                              ),
                            ),
                            child: TextStyles.medium(
                              text: 'Apply',
                              weight: FontWeight.w600,
                              color: Appcolors.kwhitecolor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadiusStyles.kradius10(),
      child: Container(
        padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
        decoration: BoxDecoration(
          border: Border.all(
            color: Appcolors.kgreyColor.withOpacity(0.3),
            width: 1.5,
          ),
          borderRadius: BorderRadiusStyles.kradius10(),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              color: Appcolors.kprimarycolor,
              size: ResponsiveUtils.sp(5),
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
                    text: date != null
                        ? '${date.day.toString().padLeft(2, '0')} ${_getMonthName(date.month)} ${date.year}'
                        : 'Select date',
                    weight: FontWeight.w600,
                    color: date != null
                        ? Appcolors.kblackcolor
                        : Appcolors.kgreyColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
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
      'Dec'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
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
          text: 'Inventory',
          weight: FontWeight.bold,
          color: Appcolors.kblackcolor,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _showFilterDialog,
            icon: Stack(
              children: [
                Icon(
                  Icons.filter_list_rounded,
                  color: Appcolors.kprimarycolor,
                  size: ResponsiveUtils.sp(6),
                ),
                if (_fromDate != null || _toDate != null)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: ResponsiveUtils.wp(2),
                      height: ResponsiveUtils.wp(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: assetsList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_rounded,
                    size: ResponsiveUtils.sp(20),
                    color: Appcolors.kgreyColor.withOpacity(0.5),
                  ),
                  ResponsiveSizedBox.height20,
                  TextStyles.subheadline(
                    text: 'No asset records found',
                    color: Appcolors.kgreyColor,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
              itemCount: assetsList.length,
              itemBuilder: (context, index) {
                final asset = assetsList[index];
                return GestureDetector(
                  onTap: () {
                    context.push('/inventorydetailspage');
                  },
                  child: _buildAssetCard(asset),
                );
              },
            ),
    );
  }

  Widget _buildAssetCard(Map<String, dynamic> asset) {
    final String status = asset['status'];

    Color statusColor;
    IconData statusIcon;
    if (status == 'Active') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (status == 'Inactive') {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
    } else {
      statusColor = Colors.orange;
      statusIcon = Icons.build_circle;
    }

    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.hp(2)),
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
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Asset Name
                  TextStyles.subheadline(
                    text: asset['assetName'],
                    weight: FontWeight.bold,
                    color: Appcolors.kprimarycolor,
                  ),
                  ResponsiveSizedBox.height5,
                  // Model
                  Row(
                    children: [
                      Icon(
                        Icons.label_outline,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      Expanded(
                        child: TextStyles.caption(
                          text: asset['model'],
                          color: Appcolors.kgreyColor,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height5,
                  // Last Updated Date
                  Row(
                    children: [
                      Icon(
                        Icons.update,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text: asset['lastUpdated'],
                        color: Appcolors.kgreyColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ResponsiveSizedBox.width(2),
            // Status
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    statusIcon,
                    color: statusColor,
                    size: ResponsiveUtils.sp(6),
                  ),
                ),
                ResponsiveSizedBox.height5,
                TextStyles.caption(
                  text: status,
                  weight: FontWeight.w600,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}