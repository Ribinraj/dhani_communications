import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/widgets/date_filter_dialog.dart';
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
      'amount': 'â‚¹12,500',
      'status': 'Approved',
    },
    {
      'toolName': 'Bulldozer',
      'date': '03 Jan 2026',
      'amount': 'â‚¹15,800',
      'status': 'Rejected',
    },
    {
      'toolName': 'Crane',
      'date': '02 Jan 2026',
      'amount': 'â‚¹25,000',
      'status': 'Approved',
    },
    {
      'toolName': 'Concrete Mixer',
      'date': '02 Jan 2026',
      'amount': 'â‚¹8,500',
      'status': 'Approved',
    },
    {
      'toolName': 'Forklift',
      'date': '01 Jan 2026',
      'amount': 'â‚¹6,200',
      'status': 'Rejected',
    },
    {
      'toolName': 'Loader',
      'date': '01 Jan 2026',
      'amount': 'â‚¹11,000',
      'status': 'Approved',
    },
  ];

  // ---------------- FILTER DIALOG ----------------
  // Filter Dialog
  void _showFilterDialog() {
    DateFilterDialog.show(
      context: context,
      title: 'Filter Machinery',
      initialFromDate: _fromDate,
      initialToDate: _toDate,
      onApply: (fromDate, toDate) {
        setState(() {
          _fromDate = fromDate;
          _toDate = toDate;
        });
      },
      onClear: () {
        setState(() {
          _fromDate = null;
          _toDate = null;
        });
      },
    );
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
