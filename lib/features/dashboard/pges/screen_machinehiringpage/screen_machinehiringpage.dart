import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/widgets/date_filter_dialog.dart';
import 'package:flutter/material.dart';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';

class ScreenMachineHiringPage extends StatefulWidget {
  const ScreenMachineHiringPage({super.key});

  @override
  State<ScreenMachineHiringPage> createState() =>
      _ScreenMachineHiringPageState();
}

class _ScreenMachineHiringPageState extends State<ScreenMachineHiringPage> {
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
    {
      'toolName': 'Compactor',
      'date': '31 Dec 2025',
      'amount': '₹9,300',
      'status': 'Approved',
    },
    {
      'toolName': 'Grader',
      'date': '31 Dec 2025',
      'amount': '₹18,700',
      'status': 'Rejected',
    },
  ];

  void _showFilterDialog() {
    DateFilterDialog.show(
      context: context,
      title: 'Filter Hiring',
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
          text: 'Machine Hiring',
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
      body: hiringList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.construction_rounded,
                    size: ResponsiveUtils.sp(20),
                    color: Appcolors.kgreyColor.withOpacity(0.5),
                  ),
                  ResponsiveSizedBox.height20,
                  TextStyles.subheadline(
                    text: 'No hiring records found',
                    color: Appcolors.kgreyColor,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
              itemCount: hiringList.length,
              itemBuilder: (context, index) {
                final hiring = hiringList[index];
                return GestureDetector(
                  onTap: () {
                    context.push('/machinehiredetailpage');
                  },
                  child: _buildHiringCard(hiring),
                );
              },
            ),
    );
  }

  Widget _buildHiringCard(Map<String, dynamic> hiring) {
    final bool isApproved = hiring['status'] == 'Approved';

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
            // Tool Icon
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
              decoration: BoxDecoration(
                color: Appcolors.kprimarycolor.withOpacity(0.1),
                borderRadius: BorderRadiusStyles.kradius10(),
              ),
              child: Icon(
                Icons.build_circle_rounded,
                size: ResponsiveUtils.sp(10),
                color: Appcolors.kprimarycolor,
              ),
            ),
            ResponsiveSizedBox.width(3),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tool Name
                  TextStyles.subheadline(
                    text: hiring['toolName'],
                    weight: FontWeight.bold,
                    color: Appcolors.kblackcolor,
                    overflow: TextOverflow.ellipsis,
                  ),
                  ResponsiveSizedBox.height5,
                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text: hiring['date'],
                        color: Appcolors.kgreyColor,
                      ),
                    ],
                  ),
                  ResponsiveSizedBox.height5,
                  // Amount
                  Row(
                    children: [
                      Icon(
                        Icons.currency_rupee,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kprimarycolor,
                      ),
                      ResponsiveSizedBox.width(1),
                      TextStyles.medium(
                        text: hiring['amount'],
                        weight: FontWeight.w600,
                        color: Appcolors.kprimarycolor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Status
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
                  decoration: BoxDecoration(
                    color: isApproved
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
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
                  weight: FontWeight.w600,
                  color: isApproved
                      ? Colors.green.shade700
                      : Colors.red.shade700,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
