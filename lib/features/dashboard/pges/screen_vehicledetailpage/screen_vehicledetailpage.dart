import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:dhani_communications/features/dashboard/blocs/vehicles_bloc/vehicles_bloc.dart';
import 'package:dhani_communications/features/dashboard/models/vehicle_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dhani_communications/core/localization/app_localization.dart';

class ScreenVehicleDetailPage extends StatefulWidget {
  final VehicleModel vehicle;

  const ScreenVehicleDetailPage({super.key, required this.vehicle});

  @override
  State<ScreenVehicleDetailPage> createState() =>
      _ScreenVehicleDetailPageState();
}

class _ScreenVehicleDetailPageState extends State<ScreenVehicleDetailPage> {
  // ── Update form controllers ───────────────────────────────
  final _formKey = GlobalKey<FormState>();
  final _lastServiceKmCtrl = TextEditingController();
  final _lastServiceDateCtrl = TextEditingController();
  final _pucValidityCtrl = TextEditingController();
  final _insuranceValidityCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill from current vehicle data
    _lastServiceKmCtrl.text = widget.vehicle.vehicleLastServiceKm;
    _lastServiceDateCtrl.text =
        _safeDate(widget.vehicle.vehicleLastServiceDate);
    _pucValidityCtrl.text = _safeDate(widget.vehicle.vehiclePucValidity);
    _insuranceValidityCtrl.text =
        _safeDate(widget.vehicle.vehicleInsuranceValidity);
  }

  @override
  void dispose() {
    _lastServiceKmCtrl.dispose();
    _lastServiceDateCtrl.dispose();
    _pucValidityCtrl.dispose();
    _insuranceValidityCtrl.dispose();
    super.dispose();
  }

  // Return empty string for invalid/zero dates
  String _safeDate(String raw) {
    if (raw == '0000-00-00' || raw.isEmpty) return '';
    return raw;
  }

  String _formatDisplay(String raw) {
    if (raw == '0000-00-00' || raw.isEmpty) return '—';
    final d = DateTime.tryParse(raw);
    if (d == null) return raw;
    const m = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${d.day.toString().padLeft(2, '0')} ${m[d.month - 1]} ${d.year}';
  }

  Future<void> _pickDate(TextEditingController ctrl) async {
    DateTime initial = DateTime.now();
    if (ctrl.text.isNotEmpty) {
      initial = DateTime.tryParse(ctrl.text) ?? DateTime.now();
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
    );
    if (picked != null) {
      ctrl.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  void _showUpdateSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return BlocListener<VehiclesBloc, VehiclesState>(
          listener: (ctx, state) {
            if (state is UpdateVehicleSuccessState) {
              Navigator.of(sheetCtx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              // Refresh list
              context.read<VehiclesBloc>().add(FetchVehiclesEvent());
            } else if (state is UpdateVehicleErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: DraggableScrollableSheet(
            initialChildSize: 0.75,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (_, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Appcolors.kwhitecolor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                padding: EdgeInsets.only(
                  left: ResponsiveUtils.wp(5),
                  right: ResponsiveUtils.wp(5),
                  top: ResponsiveUtils.hp(2),
                  bottom: MediaQuery.of(sheetCtx).viewInsets.bottom +
                      ResponsiveUtils.hp(2),
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: ResponsiveUtils.wp(10),
                        height: ResponsiveUtils.hp(0.5),
                        decoration: BoxDecoration(
                          color: Appcolors.kgreyColor.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    ResponsiveSizedBox.height20,
                    TextStyles.subheadline(
                      text: context.tr('update_vehicle'),
                      weight: FontWeight.bold,
                      color: Appcolors.kblackcolor,
                    ),
                    ResponsiveSizedBox.height20,
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Last Service KM
                          _buildTextField(
                            label: 'Last Service KM',
                            controller: _lastServiceKmCtrl,
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.speed,
                            validator: (v) => v == null || v.trim().isEmpty
                                ? 'Required'
                                : null,
                          ),
                          ResponsiveSizedBox.height15,

                          // Last Service Date
                          _buildDateField(
                            label: 'Last Service Date',
                            controller: _lastServiceDateCtrl,
                            prefixIcon: Icons.build_circle_outlined,
                          ),
                          ResponsiveSizedBox.height15,

                          // PUC Validity
                          _buildDateField(
                            label: 'PUC Validity',
                            controller: _pucValidityCtrl,
                            prefixIcon: Icons.verified_outlined,
                          ),
                          ResponsiveSizedBox.height15,

                          // Insurance Validity
                          _buildDateField(
                            label: 'Insurance Validity',
                            controller: _insuranceValidityCtrl,
                            prefixIcon: Icons.shield_outlined,
                          ),
                          ResponsiveSizedBox.height(4),

                          // Submit button
                          BlocBuilder<VehiclesBloc, VehiclesState>(
                            builder: (ctx, state) {
                              final loading =
                                  state is UpdateVehicleLoadingState;
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Appcolors.kprimarycolor,
                                    padding: EdgeInsets.symmetric(
                                      vertical: ResponsiveUtils.hp(1.8),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusStyles.kradius10(),
                                    ),
                                  ),
                                  onPressed: loading
                                      ? null
                                      : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            context
                                                .read<VehiclesBloc>()
                                                .add(UpdateVehicleEvent(
                                              vehicleId: int.tryParse(
                                                      widget.vehicle
                                                          .vehicleId) ??
                                                  0,
                                              vehicleLastServiceKm:
                                                  double.tryParse(
                                                          _lastServiceKmCtrl
                                                              .text
                                                              .trim()) ??
                                                      0,
                                              vehicleLastServiceDate:
                                                  _lastServiceDateCtrl.text
                                                      .trim(),
                                              vehiclePucValidity:
                                                  _pucValidityCtrl.text.trim(),
                                              vehicleInsuranceValidity:
                                                  _insuranceValidityCtrl.text
                                                      .trim(),
                                            ));
                                          }
                                        },
                                  child: loading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2),
                                        )
                                      : TextStyles.subheadline(
                                          text: context.tr('update_vehicle'),
                                          color: Colors.white,
                                          weight: FontWeight.bold,
                                        ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon, color: Appcolors.kprimarycolor),
        border: OutlineInputBorder(
          borderRadius: BorderRadiusStyles.kradius10(),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadiusStyles.kradius10(),
          borderSide: BorderSide(color: Appcolors.kprimarycolor, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    required IconData prefixIcon,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () => _pickDate(controller),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon, color: Appcolors.kprimarycolor),
        suffixIcon: Icon(Icons.calendar_today,
            color: Appcolors.kgreyColor, size: ResponsiveUtils.sp(4.5)),
        border: OutlineInputBorder(
          borderRadius: BorderRadiusStyles.kradius10(),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadiusStyles.kradius10(),
          borderSide: BorderSide(color: Appcolors.kprimarycolor, width: 1.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.vehicle;
    final isTwoWheeler = v.vehicleType.toUpperCase().contains('TWO');
    final typeColor = isTwoWheeler ? Colors.deepOrange : Colors.indigo;
    final typeIcon =
        isTwoWheeler ? Icons.two_wheeler : Icons.directions_car_rounded;

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
          text: context.tr('vehicle_details'),
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
            // ── Header Card ───────────────────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(ResponsiveUtils.wp(5)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [typeColor, typeColor.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadiusStyles.kradius15(),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadiusStyles.kradius10(),
                    ),
                    child: Icon(typeIcon,
                        color: Colors.white, size: ResponsiveUtils.sp(10)),
                  ),
                  ResponsiveSizedBox.width(4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextStyles.subheadline(
                          text: v.vehicleMakeModel,
                          weight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        ResponsiveSizedBox.height5,
                        TextStyles.medium(
                          text: v.vehicleRegNumber.trim(),
                          color: Colors.white.withOpacity(0.9),
                          weight: FontWeight.w600,
                        ),
                        ResponsiveSizedBox.height5,
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUtils.wp(2),
                            vertical: ResponsiveUtils.hp(0.3),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadiusStyles.kradius5(),
                          ),
                          child: TextStyles.caption(
                            text: v.vehicleType,
                            color: Colors.white,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ResponsiveSizedBox.height(3),

            // ── Registration Details ──────────────────────────────
            _SectionCard(
              title: context.tr('registration_details'),
              icon: Icons.article_outlined,
              iconColor: Colors.blue,
              rows: [
                _DetailRow(label: 'Reg. Number', value: v.vehicleRegNumber.trim()),
                _DetailRow(label: 'Reg. Validity', value: _formatDisplay(v.vehicleRegValidity)),
              ],
            ),
            ResponsiveSizedBox.height(2),

            // ── PUC Details ───────────────────────────────────────
            _SectionCard(
              title: context.tr('puc_details'),
              icon: Icons.verified_outlined,
              iconColor: Colors.green,
              rows: [
                _DetailRow(label: 'PUC Number', value: v.vehiclePucNumber),
                _DetailRow(label: 'PUC Validity', value: _formatDisplay(v.vehiclePucValidity)),
              ],
            ),
            ResponsiveSizedBox.height(2),

            // ── Insurance Details ─────────────────────────────────
            _SectionCard(
              title: context.tr('insurance_details'),
              icon: Icons.shield_outlined,
              iconColor: Colors.purple,
              rows: [
                _DetailRow(label: 'Insurance No.', value: v.vehicleInsuranceNumber),
                _DetailRow(label: 'Insurance Validity', value: _formatDisplay(v.vehicleInsuranceValidity)),
              ],
            ),
            ResponsiveSizedBox.height(2),

            // ── Service Details ───────────────────────────────────
            _SectionCard(
              title: context.tr('service_details'),
              icon: Icons.build_circle_outlined,
              iconColor: Colors.orange,
              rows: [
                _DetailRow(label: 'Last Service Date', value: _formatDisplay(v.vehicleLastServiceDate)),
                _DetailRow(label: 'Last Service KM', value: v.vehicleLastServiceKm.isEmpty ? '—' : '${v.vehicleLastServiceKm} km'),
                _DetailRow(label: 'Last Oil Service', value: _formatDisplay(v.vehicleLastOilServiceDate)),
              ],
            ),
            ResponsiveSizedBox.height(3),

            // ── Update Button ─────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Appcolors.kprimarycolor,
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveUtils.hp(1.8),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusStyles.kradius10(),
                  ),
                ),
                icon: const Icon(Icons.edit_outlined, color: Colors.white),
                label: TextStyles.subheadline(
                  text: context.tr('update_vehicle'),
                  color: Colors.white,
                  weight: FontWeight.bold,
                ),
                onPressed: _showUpdateSheet,
              ),
            ),
            ResponsiveSizedBox.height(3),
          ],
        ),
      ),
    );
  }
}

// ── Section card widget ───────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<_DetailRow> rows;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadiusStyles.kradius10(),
                ),
                child: Icon(icon, color: iconColor, size: ResponsiveUtils.sp(5)),
              ),
              ResponsiveSizedBox.width(2),
              TextStyles.subheadline(
                text: title,
                weight: FontWeight.bold,
                color: Appcolors.kblackcolor,
              ),
            ],
          ),
          Divider(
            height: ResponsiveUtils.hp(3),
            color: Appcolors.kgreyColor.withOpacity(0.2),
          ),
          ...rows.map((row) => Padding(
                padding: EdgeInsets.only(bottom: ResponsiveUtils.hp(1.2)),
                child: row,
              )),
        ],
      ),
    );
  }
}

// ── Detail row widget ─────────────────────────────────────────────────────────
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextStyles.caption(
          text: label,
          color: Appcolors.kgreyColor,
        ),
        Flexible(
          child: TextStyles.caption(
            text: value,
            weight: FontWeight.w600,
            color: Appcolors.kblackcolor,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
