import 'package:dhani_communications/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';

class ScreenApproveMachineryPage extends StatefulWidget {
  const ScreenApproveMachineryPage({super.key});

  @override
  State<ScreenApproveMachineryPage> createState() =>
      _ScreenApproveMachineryPageState();
}

class _ScreenApproveMachineryPageState
    extends State<ScreenApproveMachineryPage> {
  DateTime? _fromDate;
  DateTime? _toDate;

  // Sample machine hiring data
  final List<Map<String, dynamic>> hiringList = [
    {
      'toolName': 'Excavator',
      'date': '03 Jan 2026',
      'amount': '₹12,500',
      'status': 'Approved',
    },
    {
      'toolName': 'Bulldozer',
      'date': '03 Jan 2026',
      'amount': '₹15,800',
      'status': 'Rejected',
    },
    {
      'toolName': 'Crane',
      'date': '02 Jan 2026',
      'amount': '₹25,000',
      'status': 'Approved',
    },
    {
      'toolName': 'Concrete Mixer',
      'date': '02 Jan 2026',
      'amount': '₹8,500',
      'status': 'Approved',
    },
    {
      'toolName': 'Forklift',
      'date': '01 Jan 2026',
      'amount': '₹6,200',
      'status': 'Rejected',
    },
    {
      'toolName': 'Loader',
      'date': '01 Jan 2026',
      'amount': '₹11,000',
      'status': 'Approved',
    },
  ];

  // ---------------- FILTER DIALOG ----------------

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        DateTime? tempFrom = _fromDate;
        DateTime? tempTo = _toDate;

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
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(ResponsiveUtils.wp(2.5)),
                          decoration: BoxDecoration(
                            color: Appcolors.kprimarycolor.withOpacity(0.1),
                            borderRadius: BorderRadiusStyles.kradius10(),
                          ),
                          child: Icon(Icons.filter_list_rounded,
                              color: Appcolors.kprimarycolor),
                        ),
                        ResponsiveSizedBox.width(3),
                        TextStyles.headline(
                          text: 'Filter Hiring',
                          weight: FontWeight.bold,
                        ),
                      ],
                    ),

                    ResponsiveSizedBox.height30,

                    _buildDateSelector(
                      label: "From Date",
                      date: tempFrom,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: tempFrom ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setDialogState(() => tempFrom = picked);
                        }
                      },
                    ),

                    ResponsiveSizedBox.height20,

                    _buildDateSelector(
                      label: "To Date",
                      date: tempTo,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: tempTo ?? DateTime.now(),
                          firstDate: tempFrom ?? DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setDialogState(() => tempTo = picked);
                        }
                      },
                    ),

                    ResponsiveSizedBox.height30,

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
                              side: BorderSide(color: Appcolors.kgreyColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusStyles.kradius10(),
                              ),
                            ),
                            child: TextStyles.medium(
                              text: "Clear",
                              color: Appcolors.kgreyColor,
                            ),
                          ),
                        ),

                        ResponsiveSizedBox.width(3),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _fromDate = tempFrom;
                                _toDate = tempTo;
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Appcolors.kprimarycolor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusStyles.kradius10(),
                              ),
                            ),
                            child: TextStyles.medium(
                              text: "Apply",
                              color: Appcolors.kwhitecolor,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ---------------- DATE PICKER FIELD ----------------

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
          ),
          borderRadius: BorderRadiusStyles.kradius10(),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded,
                color: Appcolors.kprimarycolor),
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
                        ? '${date.day.toString().padLeft(2, '0')} '
                            '${_getMonthName(date.month)} ${date.year}'
                        : "Select date",
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String _getMonthName(int m) {
    const list = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return list[m - 1];
  }

  // ---------------- MAIN UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.kwhitecolor,
      appBar: AppBar(
        backgroundColor: Appcolors.kwhitecolor,
        elevation: 2,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Appcolors.kprimarycolor),
        ),
        title: TextStyles.subheadline(
          text: "Approve Machinery",
          weight: FontWeight.bold,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _showFilterDialog,
            icon: Stack(
              children: [
                Icon(Icons.filter_list_rounded,
                    color: Appcolors.kprimarycolor),
                if (_fromDate != null || _toDate != null)
                  Positioned(
                    right: 0,
                    child: Container(
                      width: ResponsiveUtils.wp(2),
                      height: ResponsiveUtils.wp(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                    ),
                  )
              ],
            ),
          )
        ],
      ),

      // ---------------- LIST ----------------
      body: ListView.builder(
        padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
        itemCount: hiringList.length,
        itemBuilder: (context, index) {
          final hiring = hiringList[index];

          return Slidable(
            key: ValueKey(index),
            startActionPane: ActionPane(
              motion: StretchMotion(),
              extentRatio: 0.25,
              children: [
                CustomSlidableAction(
                  onPressed: (_) {},
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  borderRadius: BorderRadiusStyles.kradius15(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle,
                          size: ResponsiveUtils.sp(8)),
                      ResponsiveSizedBox.height5,
                      TextStyles.caption(
                        text: "Approve",
                        color: Colors.white,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: StretchMotion(),
              extentRatio: 0.25,
              children: [
                CustomSlidableAction(
                  onPressed: (_) {},
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  borderRadius: BorderRadiusStyles.kradius15(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cancel, size: ResponsiveUtils.sp(8)),
                      ResponsiveSizedBox.height5,
                      TextStyles.caption(
                        text: "Reject",
                        color: Colors.white,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
                )
              ],
            ),

            child: GestureDetector(
              onTap: () => context.push('/machinehiredetailpage'),
              child: _buildMachineryCard(hiring),
            ),
          );
        },
      ),
    );
  }

  // ---------------- CARD UI ----------------

  Widget _buildMachineryCard(Map<String, dynamic> hiring) {
    final isApproved = hiring['status'] == "Approved";

    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.hp(2)),
      decoration: BoxDecoration(
        color: Appcolors.kwhitecolor,
        borderRadius: BorderRadiusStyles.kradius15(),
        boxShadow: [
          BoxShadow(
            color: Appcolors.kgreyColor.withOpacity(0.15),
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
              decoration: BoxDecoration(
                color: Appcolors.kprimarycolor.withOpacity(0.1),
                borderRadius: BorderRadiusStyles.kradius10(),
              ),
              child: Icon(Icons.build_circle_rounded,
                  color: Appcolors.kprimarycolor,
                  size: ResponsiveUtils.sp(10)),
            ),

            ResponsiveSizedBox.width(3),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextStyles.subheadline(
                    text: hiring['toolName'],
                    weight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                  ResponsiveSizedBox.height5,

                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          color: Appcolors.kgreyColor,
                          size: ResponsiveUtils.sp(3.5)),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text: hiring['date'],
                        color: Appcolors.kgreyColor,
                      ),
                    ],
                  ),

                  ResponsiveSizedBox.height5,

                  Row(
                    children: [
                      Icon(Icons.currency_rupee,
                          color: Appcolors.kprimarycolor,
                          size: ResponsiveUtils.sp(3.5)),
                      ResponsiveSizedBox.width(1),
                      TextStyles.medium(
                        text: hiring['amount'],
                        color: Appcolors.kprimarycolor,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            ResponsiveSizedBox.width(2),

            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isApproved
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                  ),
                  child: Icon(
                    isApproved ? Icons.check_circle : Icons.cancel,
                    color: isApproved ? Colors.green : Colors.red,
                    size: ResponsiveUtils.sp(6),
                  ),
                ),
                ResponsiveSizedBox.height5,
                TextStyles.caption(
                  text: hiring['status'],
                  color: isApproved ? Colors.green : Colors.red,
                  weight: FontWeight.bold,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
