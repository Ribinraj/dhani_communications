import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/network_services.dart';
import 'package:dhani_communications/data/models/company_asset_model.dart';
import 'package:dhani_communications/domain/repositories/apprepo.dart';
import 'package:dhani_communications/presentation/blocs/asset_list_bloc/asset_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';

class ScreenAssetsPage extends StatefulWidget {
  const ScreenAssetsPage({super.key});

  @override
  State<ScreenAssetsPage> createState() => _ScreenAssetsPageState();
}

class _ScreenAssetsPageState extends State<ScreenAssetsPage> {
  DateTime? _fromDate;
  DateTime? _toDate;
  late AssetListBloc _assetListBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _assetListBloc = AssetListBloc(
      repository: Apprepo(DioClient.create(context)),
    );
    // Fetch asset list without filters initially
    _assetListBloc.add(FetchAssetListEvent());
  }

  @override
  void dispose() {
    _assetListBloc.close();
    super.dispose();
  }

  void _applyFilter() {
    String? startDateStr;
    String? endDateStr;

    if (_fromDate != null) {
      startDateStr = DateFormat('yyyy-MM-dd').format(_fromDate!);
    }
    if (_toDate != null) {
      endDateStr = DateFormat('yyyy-MM-dd').format(_toDate!);
    }

    _assetListBloc.add(
      FetchAssetListEvent(startDate: startDateStr, endDate: endDateStr),
    );
  }

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
                          lastDate: DateTime(2030),
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
                          lastDate: DateTime(2030),
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
                              _assetListBloc.add(FetchAssetListEvent());
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
                              _applyFilter();
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
                                    borderRadius:
                                        BorderRadiusStyles.kradius10(),
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
                  TextStyles.caption(text: label, color: Appcolors.kgreyColor),
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
      'Dec',
    ];
    return months[month - 1];
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')} ${_getMonthName(date.month)} ${date.year}';
    } catch (e) {
      return dateStr;
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
          text: 'Assets',
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
      body: BlocProvider(
        create: (context) => _assetListBloc,
        child: BlocBuilder<AssetListBloc, AssetListState>(
          bloc: _assetListBloc,
          builder: (context, state) {
            if (state is AssetListLoadingState) {
              return Center(
                child: CircularProgressIndicator(
                  color: Appcolors.kprimarycolor,
                ),
              );
            }

            if (state is AssetListErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: ResponsiveUtils.sp(15),
                      color: Colors.red.withOpacity(0.7),
                    ),
                    ResponsiveSizedBox.height20,
                    TextStyles.subheadline(
                      text: state.message,
                      color: Appcolors.kgreyColor,
                    ),
                    ResponsiveSizedBox.height20,
                    ElevatedButton(
                      onPressed: () {
                        _assetListBloc.add(FetchAssetListEvent());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolors.kprimarycolor,
                      ),
                      child: TextStyles.medium(
                        text: 'Retry',
                        color: Appcolors.kwhitecolor,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is AssetListSuccessState) {
              final assetsList = state.assetsList;

              if (assetsList.isEmpty) {
                return Center(
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
                );
              }

              return RefreshIndicator(
                color: Appcolors.kprimarycolor,
                onRefresh: () async {
                  _applyFilter();
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                  itemCount: assetsList.length,
                  itemBuilder: (context, index) {
                    final asset = assetsList[index];
                    return GestureDetector(
                      onTap: () {
                        context.push('/assetdetailspage', extra: asset);
                      },
                      child: _buildAssetCard(asset),
                    );
                  },
                ),
              );
            }

            // Initial state
            return Center(
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildAssetCard(CompanyAssetModel asset) {
    final String status = asset.status;
    final Color assetGroupColor = _getAssetGroupColor(asset.assetGroupName);

    Color statusColor;
    IconData statusIcon;
    if (status.toUpperCase() == 'ACTIVE') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (status.toUpperCase() == 'INACTIVE') {
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
            // Asset Icon
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
              decoration: BoxDecoration(
                color: assetGroupColor.withOpacity(0.1),
                borderRadius: BorderRadiusStyles.kradius10(),
              ),
              child: Icon(
                _getAssetGroupIcon(asset.assetGroupName),
                color: assetGroupColor,
                size: ResponsiveUtils.sp(7),
              ),
            ),
            ResponsiveSizedBox.width(3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Asset Name
                  TextStyles.subheadline(
                    text: asset.assetName,
                    weight: FontWeight.bold,
                    color: Appcolors.kprimarycolor,
                  ),
                  ResponsiveSizedBox.height5,
                  // Asset Group Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.wp(2.5),
                      vertical: ResponsiveUtils.hp(0.5),
                    ),
                    decoration: BoxDecoration(
                      color: assetGroupColor.withOpacity(0.1),
                      borderRadius: BorderRadiusStyles.kradius5(),
                    ),
                    child: TextStyles.caption(
                      text: asset.assetGroupName.trim(),
                      weight: FontWeight.w600,
                      color: assetGroupColor,
                    ),
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
                          text: '${asset.make} - ${asset.model}',
                          color: Appcolors.kgreyColor,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height5,
                  // Transaction Date
                  Row(
                    children: [
                      Icon(
                        Icons.update,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text: _formatDate(asset.transactionDate),
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
                  color: statusColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
