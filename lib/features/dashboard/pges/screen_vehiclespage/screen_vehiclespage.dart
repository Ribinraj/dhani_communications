import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:dhani_communications/features/dashboard/blocs/vehicles_bloc/vehicles_bloc.dart';
import 'package:dhani_communications/features/dashboard/models/vehicle_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dhani_communications/core/localization/app_localization.dart';

class ScreenVehiclesPage extends StatefulWidget {
  const ScreenVehiclesPage({super.key});

  @override
  State<ScreenVehiclesPage> createState() => _ScreenVehiclesPageState();
}

class _ScreenVehiclesPageState extends State<ScreenVehiclesPage> {
  @override
  void initState() {
    super.initState();
    context.read<VehiclesBloc>().add(FetchVehiclesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.kwhitecolor,
      appBar: AppBar(
        backgroundColor: Appcolors.kappbarbackgroundcolor,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Appcolors.kprimarycolor,
            size: ResponsiveUtils.sp(5),
          ),
        ),
        title: TextStyles.title(
          text: context.tr('my_vehicles'),
          weight: FontWeight.bold,
          color: Appcolors.kblackcolor,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<VehiclesBloc, VehiclesState>(
        builder: (context, state) {
          if (state is VehiclesLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is VehiclesErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: ResponsiveUtils.sp(20),
                    color: Colors.red.withOpacity(0.4),
                  ),
                  ResponsiveSizedBox.height20,
                  TextStyles.subheadline(
                    text: state.message,
                    color: Appcolors.kgreyColor,
                  ),
                  ResponsiveSizedBox.height20,
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.read<VehiclesBloc>().add(FetchVehiclesEvent()),
                    icon: const Icon(Icons.refresh),
                    label: Text(context.tr('retry')),
                  ),
                ],
              ),
            );
          }

          if (state is VehiclesSuccessState) {
            final vehicles = state.vehicles;
            if (vehicles.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.directions_car_outlined,
                      size: ResponsiveUtils.sp(20),
                      color: Appcolors.kgreyColor.withOpacity(0.5),
                    ),
                    ResponsiveSizedBox.height20,
                    TextStyles.subheadline(
                      text: context.tr('no_vehicles_found'),
                      color: Appcolors.kgreyColor,
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
                return GestureDetector(
                  onTap: () =>
                      context.push('/vehicledetailpage', extra: vehicle),
                  child: _VehicleCard(vehicle: vehicle),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final VehicleModel vehicle;

  const _VehicleCard({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final isTwoWheeler =
        vehicle.vehicleType.toUpperCase().contains('TWO');
    final typeIcon =
        isTwoWheeler ? Icons.two_wheeler : Icons.directions_car_rounded;
    final typeColor = isTwoWheeler ? Colors.deepOrange : Colors.indigo;

    // PUC validity warning
    final pucDate = DateTime.tryParse(vehicle.vehiclePucValidity);
    final isNearExpiry = pucDate != null &&
        pucDate.isBefore(DateTime.now().add(const Duration(days: 30)));

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
            // Vehicle type icon
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
              decoration: BoxDecoration(
                color: typeColor.withOpacity(0.1),
                borderRadius: BorderRadiusStyles.kradius10(),
              ),
              child: Icon(
                typeIcon,
                color: typeColor,
                size: ResponsiveUtils.sp(8),
              ),
            ),
            ResponsiveSizedBox.width(3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Make & Model
                  TextStyles.subheadline(
                    text: vehicle.vehicleMakeModel,
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                  ),
                  ResponsiveSizedBox.height5,
                  // Reg Number
                  Row(
                    children: [
                      Icon(Icons.pin, size: ResponsiveUtils.sp(3.5), color: Appcolors.kgreyColor),
                      ResponsiveSizedBox.width(1),
                      TextStyles.caption(
                        text: vehicle.vehicleRegNumber.trim(),
                        color: Appcolors.kgreyColor,
                        weight: FontWeight.w600,
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height5,
                  // Type chip
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.wp(2),
                          vertical: ResponsiveUtils.hp(0.3),
                        ),
                        decoration: BoxDecoration(
                          color: typeColor.withOpacity(0.1),
                          borderRadius: BorderRadiusStyles.kradius5(),
                        ),
                        child: TextStyles.caption(
                          text: vehicle.vehicleType,
                          color: typeColor,
                          weight: FontWeight.w600,
                        ),
                      ),
                      if (isNearExpiry) ...[
                        ResponsiveSizedBox.width(2),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUtils.wp(2),
                            vertical: ResponsiveUtils.hp(0.3),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadiusStyles.kradius5(),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning_amber_rounded,
                                  color: Colors.red,
                                  size: ResponsiveUtils.sp(3.5)),
                              ResponsiveSizedBox.width(1),
                              TextStyles.caption(
                                text: context.tr('puc_expiring'),
                                color: Colors.red,
                                weight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Appcolors.kgreyColor,
              size: ResponsiveUtils.sp(6),
            ),
          ],
        ),
      ),
    );
  }
}
