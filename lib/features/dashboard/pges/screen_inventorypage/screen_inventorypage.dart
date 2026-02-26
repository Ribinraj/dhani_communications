import 'package:dhani_communications/core/appconstants.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/features/dashboard/models/inventory_item_model.dart';
import 'package:dhani_communications/features/dashboard/blocs/get_inventories_bloc/get_inventories_bloc.dart';
import 'package:dhani_communications/widgets/custom_nondatawidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';

class ScreenInventorypage extends StatefulWidget {
  const ScreenInventorypage({super.key});

  @override
  State<ScreenInventorypage> createState() => _ScreenAssetsPageState();
}

class _ScreenAssetsPageState extends State<ScreenInventorypage> {
  @override
  void initState() {
    super.initState();
    context.read<GetInventoriesBloc>().add(GetInventeryInitialFetchingEvent());
  }

  @override
  Widget build(BuildContext context) {
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
          text: 'Inventory',
          weight: FontWeight.bold,
          color: Appcolors.kblackcolor,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<GetInventoriesBloc, GetInventoriesState>(
        builder: (context, state) {
          if (state is GetInventoriesLoadingState) {
            return Center(
              child: CircularProgressIndicator(color: Appcolors.kprimarycolor),
            );
          }

          if (state is GetInventoiesErrorState) {
            return NoDataWidget(
              title: state.error,
              assetIcon: Appconstants.inventory,
            );
          }

          if (state is GetInventoriesSuccessState) {
            final assetsList = state.inventoryitems;

            if (assetsList.isEmpty) {
              return NoDataWidget(
                title: "Inventory is Empty",
                assetIcon: Appconstants.inventory,
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
              itemCount: assetsList.length,
              itemBuilder: (context, index) {
                final asset = assetsList[index];
                return GestureDetector(
                  onTap: () {
                    context.push('/inventorydetailspage', extra: asset);
                  },
                  child: _buildAssetCard(asset),
                );
              },
            );
          }

          return NoDataWidget(
            title: "No Inventory Found",
            assetIcon: Appconstants.inventory,
          );
        },
      ),
    );
  }

  Widget _buildAssetCard(InventoryItem asset) {
    final String status = asset.status ?? 'Unknown';

    Color statusColor;
    IconData statusIcon;
    if (status == 'Active' || status == 'Issued') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (status == 'Inactive' || status == 'Returned') {
      statusColor = Appcolors.kredcolor;
      statusIcon = Icons.cancel;
    } else if (status == 'Transferred') {
      statusColor = Colors.orange;
      statusIcon = Icons.swap_horiz;
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
                    text: asset.itemName ?? 'Unknown Item',
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
                          text: '${asset.qty ?? '0'} ${asset.unit ?? ''}',
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
                        text:
                            asset.lastModifiedDate ??
                            asset.createdDate ??
                            'N/A',
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
                TextStyles.caption(text: status, weight: FontWeight.w600),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
