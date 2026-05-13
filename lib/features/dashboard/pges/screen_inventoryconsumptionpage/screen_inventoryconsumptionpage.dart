import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:dhani_communications/features/dashboard/models/inventory_consumption_model.dart';
import 'package:dhani_communications/features/dashboard/models/inventory_item_model.dart';
import 'package:dhani_communications/features/dashboard/blocs/inventory_consumption_bloc/inventory_consumption_bloc.dart';
import 'package:dhani_communications/widgets/custom_snackbar.dart';
import 'package:dhani_communications/widgets/custom_textfiield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:dhani_communications/core/localization/app_localization.dart';

class ScreenInventoryConsumptionPage extends StatefulWidget {
  final InventoryItem inventoryItem;

  const ScreenInventoryConsumptionPage({
    super.key,
    required this.inventoryItem,
  });

  @override
  State<ScreenInventoryConsumptionPage> createState() =>
      _ScreenInventoryConsumptionPageState();
}

class _ScreenInventoryConsumptionPageState
    extends State<ScreenInventoryConsumptionPage> {
  final _formKey = GlobalKey<FormState>();
  final _qtyController = TextEditingController();
  final _remarksController = TextEditingController();
  final _dateController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _remarksController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Appcolors.kprimarycolor,
              onPrimary: Appcolors.kwhitecolor,
              surface: Appcolors.kwhitecolor,
              onSurface: Appcolors.kblackcolor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submitConsumption() {
    if (!_formKey.currentState!.validate()) return;

    final inventoryId =
        int.tryParse(widget.inventoryItem.inventoryId ?? '0') ?? 0;
    final qty = double.tryParse(_qtyController.text.trim()) ?? 0;
    final date = _dateController.text.trim();
    final remarks = _remarksController.text.trim();

    final consumptionData = InventoryConsumptionModel(
      inventoryId: inventoryId,
      qty: qty,
      date: date,
      remarks: remarks,
    );

    context.read<InventoryConsumptionBloc>().add(
      InventoryConsumptionButtonClikEvent(inventorydata: consumptionData),
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
          text: context.tr('consume_inventory'),
          weight: FontWeight.bold,
          color: Appcolors.kblackcolor,
        ),
        centerTitle: true,
      ),
      body: BlocListener<InventoryConsumptionBloc, InventoryConsumptionState>(
        listener: (context, state) {
          if (state is InventoryConsumptionSuccessState) {
            CustomSnackbar.show(
              context: context,
              message: state.message,
              type: SnackBarType.success,
            );
            context.pop(true);
          } else if (state is InventoryCunsomptionErrorState) {
            CustomSnackbar.show(
              context: context,
              message: state.message,
              type: SnackBarType.error,
            );
          }
        },
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
                    color: Colors.purple.withValues(alpha: 0.05),
                    borderRadius: BorderRadiusStyles.kradius15(),
                    border: Border.all(
                      color: Colors.purple.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
                        decoration: BoxDecoration(
                          color: Colors.purple.withValues(alpha: 0.1),
                          borderRadius: BorderRadiusStyles.kradius10(),
                        ),
                        child: Icon(
                          Icons.inventory,
                          color: Colors.purple,
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

                // Quantity Field
                TextStyles.medium(
                  text: context.tr('quantity_to_consume'),
                  weight: FontWeight.w600,
                  color: Appcolors.kblackcolor,
                ),
                ResponsiveSizedBox.height10,
                CustomTextField(
                  controller: _qtyController,
                  hintText: context.tr('enter_quantity'),
                  prefixIcon: Icons.numbers,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Quantity is required';
                    }
                    final qty = double.tryParse(value.trim());
                    if (qty == null || qty <= 0) {
                      return 'Enter a valid quantity';
                    }
                    final availableQty = double.tryParse(item.qty ?? '0') ?? 0;
                    if (availableQty > 0 && qty > availableQty) {
                      return 'Quantity exceeds available stock ($availableQty)';
                    }
                    return null;
                  },
                ),
                ResponsiveSizedBox.height(3),

                // Date Field
                TextStyles.medium(
                  text: context.tr('consumption_date'),
                  weight: FontWeight.w600,
                  color: Appcolors.kblackcolor,
                ),
                ResponsiveSizedBox.height10,
                CustomTextField(
                  controller: _dateController,
                  hintText: context.tr('select_date'),
                  prefixIcon: Icons.calendar_today,
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.calendar_month,
                      color: Appcolors.kprimarycolor,
                    ),
                    onPressed: _pickDate,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Date is required';
                    }
                    return null;
                  },
                ),
                ResponsiveSizedBox.height(3),

                // Remarks Field
                TextStyles.medium(
                  text: context.tr('remarks'),
                  weight: FontWeight.w600,
                  color: Appcolors.kblackcolor,
                ),
                ResponsiveSizedBox.height10,
                CustomTextField(
                  controller: _remarksController,
                  hintText: context.tr('enter_remarks_optional'),
                  prefixIcon: Icons.notes,
                  keyboardType: TextInputType.multiline,
                ),
                ResponsiveSizedBox.height(4),

                // Submit Button
                BlocBuilder<
                  InventoryConsumptionBloc,
                  InventoryConsumptionState
                >(
                  builder: (context, state) {
                    final isLoading = state is InventoryConsumptionLoadingState;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submitConsumption,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Appcolors.kwhitecolor,
                          padding: EdgeInsets.symmetric(
                            vertical: ResponsiveUtils.hp(2),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusStyles.kradius10(),
                          ),
                          elevation: 2,
                          disabledBackgroundColor: Colors.purple.withValues(
                            alpha: 0.5,
                          ),
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
                                  const Icon(Icons.check_circle_outline),
                                  SizedBox(width: ResponsiveUtils.wp(2)),
                                  TextStyles.medium(
                                    text: context.tr('submit_consumption'),
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
