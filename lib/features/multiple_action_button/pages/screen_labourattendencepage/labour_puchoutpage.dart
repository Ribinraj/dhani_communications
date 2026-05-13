import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:dhani_communications/core/appconstants.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/labor_punchin_bloc/labor_punchin_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/punch_in_list_bloc/punch_in_list_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/models/labor_punchout_request_model.dart';
import 'package:dhani_communications/features/multiple_action_button/models/punch_in_list_model.dart';
import 'package:dhani_communications/widgets/custom_camera.dart';
import 'package:dhani_communications/widgets/custom_formtextfield.dart';
import 'package:dhani_communications/widgets/custom_nondatawidget.dart';
import 'package:dhani_communications/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dhani_communications/core/localization/app_localization.dart';

class LabourPunchOutPage extends StatefulWidget {
  const LabourPunchOutPage({super.key});

  @override
  State<LabourPunchOutPage> createState() => _LabourPunchOutPageState();
}

class _LabourPunchOutPageState extends State<LabourPunchOutPage> {
  final _formKey = GlobalKey<FormState>();
  final _cameraKey = GlobalKey<CustomCameraWidgetState>();
  final _wagesController = TextEditingController();

  PunchInListModel? _selectedLabour;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PunchInListBloc>().add(FetchPunchInListEvent());
    });
  }

  @override
  void dispose() {
    _wagesController.dispose();
    super.dispose();
  }

  void _recordPunchOut() async {
    if (_formKey.currentState!.validate()) {
      // Validate labour selection
      if (_selectedLabour == null) {
        CustomSnackbar.show(
          context: context,
          message: context.tr('please_select_a_punched_in_labour'),
          type: SnackBarType.error,
        );
        return;
      }

      // Validate wages for CASUAL type
      if (_selectedLabour!.laborType == 'CASUAL' &&
          _wagesController.text.trim().isEmpty) {
        CustomSnackbar.show(
          context: context,
          message: context.tr('please_enter_total_wages_paid'),
          type: SnackBarType.error,
        );
        return;
      }

      // Show loading instantly
      setState(() {
        _isProcessing = true;
      });

      try {
        // Capture image
        final capturedImage = await _cameraKey.currentState?.captureImage();

        if (capturedImage == null) {
          setState(() => _isProcessing = false);
          if (mounted) {
            CustomSnackbar.show(
              context: context,
              message: context.tr('failed_to_capture_image_please_try_again'),
              type: SnackBarType.error,
            );
          }
          return;
        }

        // Convert image to base64
        final imageBytes = await capturedImage.readAsBytes();
        final base64Image = base64Encode(imageBytes);

        // Create punch out request model
        final punchOutRequest = LaborPunchOutRequestModel(
          attendanceId: _selectedLabour!.attendanceId,
          punchOutPicture: base64Image,
          wages: _selectedLabour!.laborType == 'CASUAL'
              ? _wagesController.text.trim()
              : null,
        );

        // Dispatch event to bloc
        setState(() => _isProcessing = false);
        if (mounted) {
          context.read<LaborPunchInBloc>().add(
            LaborPunchOutSubmitEvent(punchOut: punchOutRequest),
          );
        }
      } catch (e) {
        setState(() => _isProcessing = false);
        if (mounted) {
          CustomSnackbar.show(
            context: context,
            message: context.trParams('error_message', {'error': e}),
            type: SnackBarType.error,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LaborPunchInBloc, LaborPunchInState>(
      listener: (context, state) {
        if (state is LaborPunchInSuccessState) {
          CustomSnackbar.show(
            context: context,
            message: state.message,
            type: SnackBarType.success,
          );
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) Navigator.pop(context);
          });
        } else if (state is LaborPunchInErrorState) {
          CustomSnackbar.show(
            context: context,
            message: state.message,
            type: SnackBarType.error,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Appcolors.kwhitecolor,

          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Appcolors.kprimarycolor,
              size: ResponsiveUtils.sp(5),
            ),
          ),
          title: TextStyles.title(
            text: context.tr('labour_punch_out'),
            weight: FontWeight.bold,
            color: Appcolors.kblackcolor,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.wp(5),
              vertical: ResponsiveUtils.hp(3),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Camera Section - Back Camera
                  Center(
                    child: CustomCameraWidget(
                      key: _cameraKey,
                      lensDirection: CameraLensDirection.back,
                      onImageCaptured: (image) {
                        debugPrint('Image captured: ${image.path}');
                      },
                      height: ResponsiveUtils.wp(60),
                      width: ResponsiveUtils.wp(60),
                    ),
                  ),

                  SizedBox(height: ResponsiveUtils.hp(4)),

                  // Punched In Labour Dropdown using PunchInListBloc
                  BlocBuilder<PunchInListBloc, PunchInListState>(
                    builder: (context, state) {
                      if (state is PunchInListLoadingState) {
                        return Container(
                          padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Appcolors.kgreyColor.withValues(
                                alpha: 0.3,
                              ),
                            ),
                            borderRadius: BorderRadiusStyles.kradius10(),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: ResponsiveUtils.wp(5),
                                height: ResponsiveUtils.wp(5),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Appcolors.kprimarycolor,
                                ),
                              ),
                              ResponsiveSizedBox.width(3),
                              TextStyles.medium(
                                text: context.tr('loading_punched_in_labours'),
                                color: Appcolors.kgreyColor,
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is PunchInListErrorState) {
                        return NoDataWidget(
                          title: state.message,
                          assetIcon: Appconstants.attenedence,
                          onRefresh: () {
                            context.read<PunchInListBloc>().add(
                              FetchPunchInListEvent(),
                            );
                          },
                        );
                        // return Container(
                        //   padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                        //   decoration: BoxDecoration(
                        //     border: Border.all(
                        //       color: Colors.red.withValues(alpha:0.3),
                        //     ),
                        //     borderRadius: BorderRadiusStyles.kradius10(),
                        //   ),
                        //   child: Row(
                        //     children: [
                        //       Icon(
                        //         Icons.error_outline,
                        //         color: Colors.red,
                        //         size: ResponsiveUtils.sp(5),
                        //       ),
                        //       ResponsiveSizedBox.width(2),
                        //       Expanded(
                        //         child: TextStyles.medium(
                        //           text: state.message,
                        //           color: Colors.red,
                        //         ),
                        //       ),
                        //       TextButton(
                        //         onPressed: () {
                        //           context.read<PunchInListBloc>().add(
                        //             FetchPunchInListEvent(),
                        //           );
                        //         },
                        //         child: TextStyles.medium(
                        //           text: 'Retry',
                        //           color: Appcolors.kprimarycolor,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // );
                      }

                      if (state is PunchInListSuccessState) {
                        final punchInList = state.punchInList;

                        if (punchInList.isEmpty) {
                          return NoDataWidget(
                            title: context.tr('no_punched_in_attendence_available'),
                            assetIcon: Appconstants.attenedence,
                          );
                        }

                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Appcolors.kgreyColor.withValues(
                                alpha: 0.3,
                              ),
                            ),
                            borderRadius: BorderRadiusStyles.kradius10(),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<PunchInListModel>(
                              isExpanded: true,
                              hint: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveUtils.wp(4),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.people_outline,
                                      color: Appcolors.kprimarycolor,
                                      size: ResponsiveUtils.sp(5),
                                    ),
                                    ResponsiveSizedBox.width(3),
                                    TextStyles.medium(
                                      text: context.tr('select_punched_in_labour'),
                                      color: Appcolors.kgreyColor,
                                    ),
                                  ],
                                ),
                              ),
                              value: _selectedLabour,
                              icon: Padding(
                                padding: EdgeInsets.only(
                                  right: ResponsiveUtils.wp(3),
                                ),
                                child: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Appcolors.kprimarycolor,
                                  size: ResponsiveUtils.sp(6),
                                ),
                              ),
                              borderRadius: BorderRadiusStyles.kradius10(),
                              dropdownColor: Appcolors.kwhitecolor,
                              items: punchInList.map((PunchInListModel item) {
                                return DropdownMenuItem<PunchInListModel>(
                                  value: item,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ResponsiveUtils.wp(4),
                                      vertical: ResponsiveUtils.hp(0.5),
                                    ),
                                    child: TextStyles.medium(
                                      text: item.displayLabel,
                                      weight: FontWeight.w600,
                                      color: Appcolors.kblackcolor,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedLabour = value;
                                  // Clear wages when switching labour
                                  _wagesController.clear();
                                });
                              },
                              selectedItemBuilder: (BuildContext context) {
                                return punchInList.map((PunchInListModel item) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ResponsiveUtils.wp(4),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.people_outline,
                                          color: Appcolors.kprimarycolor,
                                          size: ResponsiveUtils.sp(5),
                                        ),
                                        ResponsiveSizedBox.width(3),
                                        Expanded(
                                          child: TextStyles.medium(
                                            text: item.displayLabel,
                                            weight: FontWeight.w600,
                                            color: Appcolors.kblackcolor,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),

                  SizedBox(height: ResponsiveUtils.hp(3)),

                  // Total Wages field - only visible for CASUAL type
                  if (_selectedLabour != null &&
                      _selectedLabour!.laborType == 'CASUAL') ...[
                    CustomFormtextfield(
                      controller: _wagesController,
                      hintText: context.tr('please_enter_total_wages_paid'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter total wages paid';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: ResponsiveUtils.hp(3)),
                  ],

                  SizedBox(height: ResponsiveUtils.hp(1)),

                  // Punch Out Button
                  BlocBuilder<LaborPunchInBloc, LaborPunchInState>(
                    builder: (context, state) {
                      final isSubmitting = state is LaborPunchInLoadingState;
                      final isLoading = _isProcessing || isSubmitting;

                      return SizedBox(
                        width: double.infinity,
                        height: ResponsiveUtils.hp(6.5),
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _recordPunchOut,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F8FDF),
                            disabledBackgroundColor: const Color(
                              0xFF4F8FDF,
                            ).withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveUtils.borderRadius(2.5),
                              ),
                            ),
                            elevation: 3,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(context.tr('punch_out'),
                                  style: TextStyle(
                                    fontSize: ResponsiveUtils.sp(3.5),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
