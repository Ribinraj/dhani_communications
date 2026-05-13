import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/new_request_bloc/new_request_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/request_categories_bloc/request_categories_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/models/new_request_model.dart';
import 'package:dhani_communications/features/multiple_action_button/models/request_category_model.dart';
import 'package:dhani_communications/widgets/custom_dropdown.dart';
import 'package:dhani_communications/widgets/custom_formtextfield.dart';
import 'package:dhani_communications/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dhani_communications/core/localization/app_localization.dart';

class ScreenNewRequestPage extends StatefulWidget {
  const ScreenNewRequestPage({super.key});

  @override
  State<ScreenNewRequestPage> createState() => _ScreenNewRequestPageState();
}

class _ScreenNewRequestPageState extends State<ScreenNewRequestPage> {
  final _formKey = GlobalKey<FormState>();

  RequestCategoryModel? selectedRequestCategory;
  final TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RequestCategoriesBloc>().add(FetchRequestCategoriesEvent());
    });
  }

  @override
  void dispose() {
    remarksController.dispose();
    super.dispose();
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      if (selectedRequestCategory == null) {
        CustomSnackbar.show(
          context: context,
          message: context.tr('please_select_request_category'),
          type: SnackBarType.error,
        );
        return;
      }

      final requestCategoryId = int.tryParse(
        selectedRequestCategory!.requestCategoryId,
      );
      if (requestCategoryId == null) {
        CustomSnackbar.show(
          context: context,
          message: context.tr('invalid_request_category_selected'),
          type: SnackBarType.error,
        );
        return;
      }

      final request = NewRequestModel(
        requestCategoryId: requestCategoryId,
        notes: remarksController.text.trim(),
      );

      context.read<NewRequestBloc>().add(
        SubmitNewRequestEvent(request: request),
      );
    }
  }

  Widget _buildDropdownStatus(String message, {VoidCallback? onRetry}) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
      decoration: BoxDecoration(
        border: Border.all(color: Appcolors.kbordercolor),
        borderRadius: BorderRadiusStyles.kradius10(),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextStyles.medium(
              text: message,
              color: Appcolors.kgreyColor,
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: TextStyles.medium(
                text: context.tr('retry'),
                color: Appcolors.kprimarycolor,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Appcolors.kprimarycolor,
            size: ResponsiveUtils.sp(5),
          ),
        ),
        title: TextStyles.title(
          text: context.tr('new_request'),
          weight: FontWeight.bold,
          color: Appcolors.kblackcolor,
        ),
        centerTitle: true,
      ),
      body: BlocListener<NewRequestBloc, NewRequestState>(
        listener: (context, state) {
          if (state is NewRequestSuccessState) {
            CustomSnackbar.show(
              context: context,
              message: state.message,
              type: SnackBarType.success,
            );
            final router = GoRouter.of(context);
            Future.delayed(const Duration(seconds: 1), () {
              if (!mounted) return;
              router.go('/main');
            });
          } else if (state is NewRequestErrorState) {
            CustomSnackbar.show(
              context: context,
              message: state.message,
              type: SnackBarType.error,
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveSizedBox.height20,

                  /// Header text
                  TextStyles.body(
                    text:
                        context.tr('please_fill_the_form_and_submit_your_request_for'),
                    color: Appcolors.kblackcolor,
                    weight: FontWeight.w500,
                    maxLines: 2,
                  ),

                  ResponsiveSizedBox.height30,

                  /// Request Category
                  TextStyles.caption(
                    text: context.tr('request_category'),
                    weight: FontWeight.w600,
                  ),
                  ResponsiveSizedBox.height10,
                  BlocBuilder<RequestCategoriesBloc, RequestCategoriesState>(
                    builder: (context, state) {
                      if (state is RequestCategoriesLoadingState) {
                        return _buildDropdownStatus(
                          'Loading request categories...',
                        );
                      }

                      if (state is RequestCategoriesErrorState) {
                        return _buildDropdownStatus(
                          state.message,
                          onRetry: () {
                            context.read<RequestCategoriesBloc>().add(
                              FetchRequestCategoriesEvent(),
                            );
                          },
                        );
                      }

                      if (state is RequestCategoriesSuccessState) {
                        final categoryNames = state.categories
                            .map((category) => category.categoryName)
                            .where((name) => name.isNotEmpty)
                            .toList();
                        final selectedCategoryName =
                            categoryNames.contains(
                              selectedRequestCategory?.categoryName,
                            )
                            ? selectedRequestCategory?.categoryName
                            : null;

                        if (categoryNames.isEmpty) {
                          return _buildDropdownStatus(
                            'No request categories available',
                          );
                        }

                        return CustomDropdown(
                          value: selectedCategoryName,
                          hint: context.tr('select_request_category'),
                          items: categoryNames,
                          onChanged: (value) {
                            setState(() {
                              selectedRequestCategory = null;
                              for (final category in state.categories) {
                                if (category.categoryName == value) {
                                  selectedRequestCategory = category;
                                  break;
                                }
                              }
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select request category';
                            }
                            return null;
                          },
                        );
                      }

                      return CustomDropdown(
                        value: null,
                        hint: context.tr('select_request_category'),
                        items: [],
                        onChanged: (_) {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select request category';
                          }
                          return null;
                        },
                      );
                    },
                  ),

                  ResponsiveSizedBox.height20,

                  /// Remarks (Optional)
                  TextStyles.caption(
                    text: context.tr('remarks_optional'),
                    weight: FontWeight.w600,
                  ),
                  ResponsiveSizedBox.height10,
                  CustomFormtextfield(
                    controller: remarksController,
                    hintText: context.tr('enter_remarks_2'),
                    maxLines: 4,
                  ),

                  ResponsiveSizedBox.height40,

                  /// Submit Button
                  BlocBuilder<NewRequestBloc, NewRequestState>(
                    builder: (context, state) {
                      final isLoading = state is NewRequestLoadingState;
                      return SizedBox(
                        width: double.infinity,
                        height: ResponsiveUtils.hp(6),
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submitRequest,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Appcolors.kprimarycolor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveUtils.borderRadius(2.5),
                              ),
                            ),
                            elevation: 2,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Appcolors.kwhitecolor,
                                  ),
                                )
                              : TextStyles.body(
                                  text: context.tr('submit_request'),
                                  color: Appcolors.kwhitecolor,
                                  weight: FontWeight.w600,
                                ),
                        ),
                      );
                    },
                  ),

                  ResponsiveSizedBox.height30,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
