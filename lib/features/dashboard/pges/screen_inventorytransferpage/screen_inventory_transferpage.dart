import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:dhani_communications/features/dashboard/models/employees_model.dart';
import 'package:dhani_communications/features/dashboard/models/inventory_item_model.dart';
import 'package:dhani_communications/features/dashboard/models/inventory_transfer_model.dart';

import 'package:dhani_communications/features/dashboard/blocs/employees_bloc/employees_bloc.dart';
import 'package:dhani_communications/features/dashboard/blocs/inventory_transfer_bloc/inventory_transfer_bloc.dart';
import 'package:dhani_communications/widgets/custom_snackbar.dart';
import 'package:dhani_communications/widgets/custom_textfiield.dart';
import 'package:dhani_communications/widgets/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ScreenInventoryTransferPage extends StatefulWidget {
  final InventoryItem inventoryItem;

  const ScreenInventoryTransferPage({super.key, required this.inventoryItem});

  @override
  State<ScreenInventoryTransferPage> createState() =>
      _ScreenInventoryTransferPageState();
}

class _ScreenInventoryTransferPageState
    extends State<ScreenInventoryTransferPage> {
  final _formKey = GlobalKey<FormState>();
  final _remarksController = TextEditingController();

  String? _selectedEmployeeId;
  String? _selectedEmployeeName;
  List<EmployeeModel> _employees = [];

  @override
  void initState() {
    super.initState();
    // Fetch employees when screen loads
    context.read<EmployeesBloc>().add(EmployeesFetchingInitialEvent());
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  void _submitTransfer() {
    if (!_formKey.currentState!.validate()) return;

    final inventoryId =
        int.tryParse(widget.inventoryItem.inventoryId ?? '0') ?? 0;
    final remarks = _remarksController.text.trim();

    final transferData = InventoryTransferModel(
      inventoryId: inventoryId,
      transferTo: _selectedEmployeeId!,
      transferRemarks: remarks,
    );

    context.read<InventoryTransferBloc>().add(
      InventoryTransferButtonClickEvent(transferData: transferData),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.inventoryItem;

    return Scaffold(
      backgroundColor: Appcolors.kwhitecolor,
      appBar: AppBar(
        backgroundColor: Appcolors.kwhitecolor,
        elevation: 2,
        shadowColor: Appcolors.kgreyColor.withValues(alpha: 0.1),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Appcolors.kprimarycolor,
            size: ResponsiveUtils.sp(5),
          ),
        ),
        title: TextStyles.subheadline(
          text: 'Transfer Inventory',
          weight: FontWeight.bold,
          color: Appcolors.kblackcolor,
        ),
        centerTitle: true,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<EmployeesBloc, EmployeesState>(
            listener: (context, state) {
              if (state is EmployeesSuccessState) {
                setState(() {
                  _employees = state.employees;
                });
              } else if (state is EmployeesErrorState) {
                CustomSnackbar.show(
                  context: context,
                  message: state.error,
                  type: SnackBarType.error,
                );
              }
            },
          ),
          BlocListener<InventoryTransferBloc, InventoryTransferState>(
            listener: (context, state) {
              if (state is InventoryTransferSuccessState) {
                CustomSnackbar.show(
                  context: context,
                  message: state.message,
                  type: SnackBarType.success,
                );
                context.pop(true);
              } else if (state is InventoryTransferErrorState) {
                CustomSnackbar.show(
                  context: context,
                  message: state.message,
                  type: SnackBarType.error,
                );
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item Info Summary Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                  decoration: BoxDecoration(
                    color: Appcolors.kpurplecolor.withValues(alpha: 0.05),
                    borderRadius: BorderRadiusStyles.kradius15(),
                    border: Border.all(
                      color: Appcolors.kpurplecolor.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
                        decoration: BoxDecoration(
                          color: Appcolors.kpurplecolor.withValues(alpha: 0.1),
                          borderRadius: BorderRadiusStyles.kradius10(),
                        ),
                        child: Icon(
                          Icons.inventory,
                          color: Appcolors.kpurplecolor,
                          size: ResponsiveUtils.sp(6),
                        ),
                      ),
                      ResponsiveSizedBox.width(3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextStyles.medium(
                              text: item.itemName ?? 'N/A',
                              weight: FontWeight.bold,
                              color: Appcolors.kblackcolor,
                            ),
                            ResponsiveSizedBox.height5,
                            TextStyles.caption(
                              text:
                                  'Available: ${item.qty ?? 'N/A'} ${item.unit ?? ''}',
                              color: Appcolors.kgreyColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ResponsiveSizedBox.height(3),

                // Transfer To Dropdown
                TextStyles.medium(
                  text: 'Transfer To',
                  weight: FontWeight.w600,
                  color: Appcolors.kblackcolor,
                ),
                ResponsiveSizedBox.height10,
                BlocBuilder<EmployeesBloc, EmployeesState>(
                  builder: (context, state) {
                    if (state is EmployeesLoadingState) {
                      return Container(
                        padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            ResponsiveUtils.borderRadius(2.5),
                          ),
                          border: Border.all(
                            color: Appcolors.kbordercolor,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              height: ResponsiveUtils.sp(4),
                              width: ResponsiveUtils.sp(4),
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: ResponsiveUtils.wp(3)),
                            TextStyles.caption(
                              text: 'Loading employees...',
                              color: Appcolors.kgreyColor,
                            ),
                          ],
                        ),
                      );
                    }

                    if (_employees.isEmpty) {
                      return Container(
                        padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            ResponsiveUtils.borderRadius(2.5),
                          ),
                          border: Border.all(
                            color: Colors.red.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: ResponsiveUtils.sp(5),
                            ),
                            SizedBox(width: ResponsiveUtils.wp(3)),
                            Expanded(
                              child: TextStyles.caption(
                                text: 'No employees available',
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return CustomDropdown(
                      value: _selectedEmployeeName,
                      hint: 'Select employee',
                      items: _employees.map((e) => e.employeeName).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedEmployeeName = value;
                          _selectedEmployeeId = _employees
                              .firstWhere((e) => e.employeeName == value)
                              .employeeId;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select an employee';
                        }
                        return null;
                      },
                    );
                  },
                ),
                ResponsiveSizedBox.height(3),

                // Quantity Field - Commented out as not needed for transfer
                // TextStyles.medium(
                //   text: 'Quantity to Transfer',
                //   weight: FontWeight.w600,
                //   color: Appcolors.kblackcolor,
                // ),
                // ResponsiveSizedBox.height10,
                // CustomTextField(
                //   controller: _qtyController,
                //   hintText: 'Enter quantity',
                //   prefixIcon: Icons.numbers,
                //   keyboardType: const TextInputType.numberWithOptions(
                //     decimal: true,
                //   ),
                //   inputFormatters: [
                //     FilteringTextInputFormatter.allow(
                //       RegExp(r'^\d+\.?\d{0,2}'),
                //     ),
                //   ],
                //   validator: (value) {
                //     if (value == null || value.trim().isEmpty) {
                //       return 'Quantity is required';
                //     }
                //     final qty = double.tryParse(value.trim());
                //     if (qty == null || qty <= 0) {
                //       return 'Enter a valid quantity';
                //     }
                //     final availableQty = double.tryParse(item.qty ?? '0') ?? 0;
                //     if (availableQty > 0 && qty > availableQty) {
                //       return 'Quantity exceeds available stock ($availableQty)';
                //     }
                //     return null;
                //   },
                // ),
                // ResponsiveSizedBox.height(3),

                // Remarks Field
                TextStyles.medium(
                  text: 'Remarks',
                  weight: FontWeight.w600,
                  color: Appcolors.kblackcolor,
                ),
                ResponsiveSizedBox.height10,
                CustomTextField(
                  controller: _remarksController,
                  hintText: 'Enter remarks (optional)',
                  prefixIcon: Icons.notes,
                  keyboardType: TextInputType.multiline,
                ),
                ResponsiveSizedBox.height(4),

                // Transfer Button
                BlocBuilder<InventoryTransferBloc, InventoryTransferState>(
                  builder: (context, state) {
                    final isLoading = state is InventoryTransferLoadingState;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submitTransfer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Appcolors.kpurplecolor,
                          foregroundColor: Appcolors.kwhitecolor,
                          padding: EdgeInsets.symmetric(
                            vertical: ResponsiveUtils.hp(2),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusStyles.kradius10(),
                          ),
                          elevation: 2,
                          disabledBackgroundColor: Appcolors.kpurplecolor
                              .withValues(alpha: 0.5),
                        ),
                        child: isLoading
                            ? SizedBox(
                                height: ResponsiveUtils.sp(5),
                                width: ResponsiveUtils.sp(5),
                                child: const CircularProgressIndicator(
                                  color: Appcolors.kwhitecolor,
                                  strokeWidth: 2,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.send_outlined),
                                  SizedBox(width: ResponsiveUtils.wp(2)),
                                  TextStyles.medium(
                                    text: 'Initiate Transfer',
                                    weight: FontWeight.w600,
                                    color: Appcolors.kwhitecolor,
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                ),
                ResponsiveSizedBox.height(3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
