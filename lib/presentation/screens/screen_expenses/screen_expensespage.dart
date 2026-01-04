import 'package:dhani_communications/core/constants.dart';
import 'package:flutter/material.dart';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';

class ScreenEmployeeExpensesPage extends StatefulWidget {
  const ScreenEmployeeExpensesPage({super.key});

  @override
  State<ScreenEmployeeExpensesPage> createState() =>
      _ScreenEmployeeExpensesPageState();
}

class _ScreenEmployeeExpensesPageState
    extends State<ScreenEmployeeExpensesPage> {
  DateTime? _fromDate;
  DateTime? _toDate;

  // Sample expenses data
  final List<Map<String, dynamic>> expensesList = [
    {
      'date': '03 Jan 2026',
      'amount': '₹2,500',
 
      'remarks': 'Client meeting transportation',
      'status': 'Approved',
    },
    {
      'date': '03 Jan 2026',
      'amount': '₹1,250',

      'remarks': 'Team lunch with client',
      'status': 'Pending',
    },
    {
      'date': '02 Jan 2026',
      'amount': '₹5,800',
  
      'remarks': 'Flight tickets for business trip',
      'status': 'Approved',
    },
    {
      'date': '02 Jan 2026',
      'amount': '₹750',
   
      'remarks': 'Office stationery purchase',
      'status': 'Pending',
    },
    {
      'date': '01 Jan 2026',
      'amount': '₹3,200',
   
      'remarks': 'Hotel stay for conference',
      'status': 'Approved',
    },
    {
      'date': '01 Jan 2026',
      'amount': '₹450',
    
      'remarks': 'Breakfast meeting expenses',
      'status': 'Rejected',
    },
    {
      'date': '31 Dec 2025',
      'amount': '₹8,500',
  
      'remarks': 'Cab fare for multiple client visits',
      'status': 'Approved',
    },
    {
      'date': '31 Dec 2025',
      'amount': '₹1,890',

      'remarks': 'Client dinner expenses',
      'status': 'Pending',
    },
  ];

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime? tempFromDate = _fromDate;
        DateTime? tempToDate = _toDate;

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
                    // Dialog Title
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(ResponsiveUtils.wp(2.5)),
                          decoration: BoxDecoration(
                            color: Appcolors.kprimarycolor.withOpacity(0.1),
                            borderRadius: BorderRadiusStyles.kradius10(),
                          ),
                          child: Icon(
                            Icons.filter_list_rounded,
                            color: Appcolors.kprimarycolor,
                            size: ResponsiveUtils.sp(6),
                          ),
                        ),
                        ResponsiveSizedBox.width(3),
                        TextStyles.headline(
                          text: 'Filter Expenses',
                          weight: FontWeight.bold,
                          color: Appcolors.kblackcolor,
                        ),
                      ],
                    ),
                    ResponsiveSizedBox.height30,
                    // From Date
                    _buildDateSelector(
                      label: 'From Date',
                      date: tempFromDate,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: tempFromDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setDialogState(() {
                            tempFromDate = date;
                          });
                        }
                      },
                    ),
                    ResponsiveSizedBox.height20,
                    // To Date
                    _buildDateSelector(
                      label: 'To Date',
                      date: tempToDate,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: tempToDate ?? DateTime.now(),
                          firstDate: tempFromDate ?? DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setDialogState(() {
                            tempToDate = date;
                          });
                        }
                      },
                    ),
                    ResponsiveSizedBox.height30,
                    // Buttons
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
                              padding: EdgeInsets.symmetric(
                                vertical: ResponsiveUtils.hp(1.5),
                              ),
                              side: BorderSide(
                                color: Appcolors.kgreyColor,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusStyles.kradius10(),
                              ),
                            ),
                            child: TextStyles.medium(
                              text: 'Clear',
                              weight: FontWeight.w600,
                              color: Appcolors.kgreyColor,
                            ),
                          ),
                        ),
                        ResponsiveSizedBox.width(3),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _fromDate = tempFromDate;
                                _toDate = tempToDate;
                              });
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Filter applied'),
                                  duration: Duration(milliseconds: 1000),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Appcolors.kprimarycolor,
                                  margin: EdgeInsets.only(
                                    bottom: ResponsiveUtils.hp(2),
                                    left: ResponsiveUtils.wp(4),
                                    right: ResponsiveUtils.wp(4),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusStyles.kradius10(),
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Appcolors.kprimarycolor,
                              padding: EdgeInsets.symmetric(
                                vertical: ResponsiveUtils.hp(1.5),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusStyles.kradius10(),
                              ),
                            ),
                            child: TextStyles.medium(
                              text: 'Apply',
                              weight: FontWeight.w600,
                              color: Appcolors.kwhitecolor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

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
            width: 1.5,
          ),
          borderRadius: BorderRadiusStyles.kradius10(),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              color: Appcolors.kprimarycolor,
              size: ResponsiveUtils.sp(5),
            ),
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
                        ? '${date.day.toString().padLeft(2, '0')} ${_getMonthName(date.month)} ${date.year}'
                        : 'Select date',
                    weight: FontWeight.w600,
                    color: date != null
                        ? Appcolors.kblackcolor
                        : Appcolors.kgreyColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
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
          text: 'Employee Expenses',
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
      body: expensesList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_rounded,
                    size: ResponsiveUtils.sp(20),
                    color: Appcolors.kgreyColor.withOpacity(0.5),
                  ),
                  ResponsiveSizedBox.height20,
                  TextStyles.subheadline(
                    text: 'No expense records found',
                    color: Appcolors.kgreyColor,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
              itemCount: expensesList.length,
              itemBuilder: (context, index) {
                final expense = expensesList[index];
                return GestureDetector(
                  onTap: () {
                    context.push('/expensedetailspage');
                  },
                  child: _buildExpenseCard(expense),
                );
              },
            ),
    );
  }

  Widget _buildExpenseCard(Map<String, dynamic> expense) {
    final String status = expense['status'];
  

    Color statusColor;
    IconData statusIcon;
    if (status == 'Approved') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (status == 'Rejected') {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
    } else {
      statusColor = Colors.orange;
      statusIcon = Icons.pending;
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
                  // Amount
                  TextStyles.headline(
                    text: expense['amount'],
                    weight: FontWeight.bold,
                    color: Appcolors.kprimarycolor,
                  ),
                  ResponsiveSizedBox.height5,
                  // Date and Category
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      TextStyles.caption(
                        text: expense['date'],
                        color: Appcolors.kgreyColor,
                      ),
      
                    ],
                  ),
                  ResponsiveSizedBox.height5,
                  // Remarks
                  Row(
                    children: [
                      Icon(
                        Icons.comment_outlined,
                        size: ResponsiveUtils.sp(3.5),
                        color: Appcolors.kgreyColor,
                      ),
                      ResponsiveSizedBox.width(1.5),
                      Expanded(
                        child: TextStyles.caption(
                          text: expense['remarks'],
                          color: Appcolors.kgreyColor,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
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
                TextStyles.caption(
                  text: status,
                  weight: FontWeight.w600,
            
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:dhani_communications/core/constants.dart';
// import 'package:flutter/material.dart';

// import 'package:dhani_communications/core/colors.dart';
// import 'package:dhani_communications/core/responsiveutils.dart';
// import 'package:go_router/go_router.dart';

// class ScreenEmployeeExpensesPage extends StatefulWidget {
//   const ScreenEmployeeExpensesPage({super.key});

//   @override
//   State<ScreenEmployeeExpensesPage> createState() =>
//       _ScreenEmployeeExpensesPageState();
// }

// class _ScreenEmployeeExpensesPageState
//     extends State<ScreenEmployeeExpensesPage> {
//   DateTime? _fromDate;
//   DateTime? _toDate;

//   // Sample expenses data
//   final List<Map<String, dynamic>> expensesList = [
//     {
//       'date': '03 Jan 2026',
//       'amount': '₹2,500',
//       'category': 'Travel',
//       'remarks': 'Client meeting transportation',
//       'status': 'Approved',
//     },
//     {
//       'date': '03 Jan 2026',
//       'amount': '₹1,250',
//       'category': 'Food',
//       'remarks': 'Team lunch with client',
//       'status': 'Pending',
//     },
//     {
//       'date': '02 Jan 2026',
//       'amount': '₹5,800',
//       'category': 'Travel',
//       'remarks': 'Flight tickets for business trip',
//       'status': 'Approved',
//     },
//     {
//       'date': '02 Jan 2026',
//       'amount': '₹750',
//       'category': 'Supplies',
//       'remarks': 'Office stationery purchase',
//       'status': 'Pending',
//     },
//     {
//       'date': '01 Jan 2026',
//       'amount': '₹3,200',
//       'category': 'Accommodation',
//       'remarks': 'Hotel stay for conference',
//       'status': 'Approved',
//     },
//     {
//       'date': '01 Jan 2026',
//       'amount': '₹450',
//       'category': 'Food',
//       'remarks': 'Breakfast meeting expenses',
//       'status': 'Rejected',
//     },
//     {
//       'date': '31 Dec 2025',
//       'amount': '₹8,500',
//       'category': 'Travel',
//       'remarks': 'Cab fare for multiple client visits',
//       'status': 'Approved',
//     },
//     {
//       'date': '31 Dec 2025',
//       'amount': '₹1,890',
//       'category': 'Entertainment',
//       'remarks': 'Client dinner expenses',
//       'status': 'Pending',
//     },
//   ];

//   void _showFilterDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         DateTime? tempFromDate = _fromDate;
//         DateTime? tempToDate = _toDate;

//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadiusStyles.kradius20(),
//               ),
//               child: Container(
//                 padding: EdgeInsets.all(ResponsiveUtils.wp(6)),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Dialog Title
//                     Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(ResponsiveUtils.wp(2.5)),
//                           decoration: BoxDecoration(
//                             color: Appcolors.kprimarycolor.withOpacity(0.1),
//                             borderRadius: BorderRadiusStyles.kradius10(),
//                           ),
//                           child: Icon(
//                             Icons.filter_list_rounded,
//                             color: Appcolors.kprimarycolor,
//                             size: ResponsiveUtils.sp(6),
//                           ),
//                         ),
//                         ResponsiveSizedBox.width(3),
//                         TextStyles.headline(
//                           text: 'Filter Expenses',
//                           weight: FontWeight.bold,
//                           color: Appcolors.kblackcolor,
//                         ),
//                       ],
//                     ),
//                     ResponsiveSizedBox.height30,
//                     // From Date
//                     _buildDateSelector(
//                       label: 'From Date',
//                       date: tempFromDate,
//                       onTap: () async {
//                         final date = await showDatePicker(
//                           context: context,
//                           initialDate: tempFromDate ?? DateTime.now(),
//                           firstDate: DateTime(2020),
//                           lastDate: DateTime.now(),
//                         );
//                         if (date != null) {
//                           setDialogState(() {
//                             tempFromDate = date;
//                           });
//                         }
//                       },
//                     ),
//                     ResponsiveSizedBox.height20,
//                     // To Date
//                     _buildDateSelector(
//                       label: 'To Date',
//                       date: tempToDate,
//                       onTap: () async {
//                         final date = await showDatePicker(
//                           context: context,
//                           initialDate: tempToDate ?? DateTime.now(),
//                           firstDate: tempFromDate ?? DateTime(2020),
//                           lastDate: DateTime.now(),
//                         );
//                         if (date != null) {
//                           setDialogState(() {
//                             tempToDate = date;
//                           });
//                         }
//                       },
//                     ),
//                     ResponsiveSizedBox.height30,
//                     // Buttons
//                     Row(
//                       children: [
//                         Expanded(
//                           child: OutlinedButton(
//                             onPressed: () {
//                               setState(() {
//                                 _fromDate = null;
//                                 _toDate = null;
//                               });
//                               Navigator.pop(context);
//                             },
//                             style: OutlinedButton.styleFrom(
//                               padding: EdgeInsets.symmetric(
//                                 vertical: ResponsiveUtils.hp(1.5),
//                               ),
//                               side: BorderSide(
//                                 color: Appcolors.kgreyColor,
//                                 width: 1.5,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadiusStyles.kradius10(),
//                               ),
//                             ),
//                             child: TextStyles.medium(
//                               text: 'Clear',
//                               weight: FontWeight.w600,
//                               color: Appcolors.kgreyColor,
//                             ),
//                           ),
//                         ),
//                         ResponsiveSizedBox.width(3),
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               setState(() {
//                                 _fromDate = tempFromDate;
//                                 _toDate = tempToDate;
//                               });
//                               Navigator.pop(context);
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text('Filter applied'),
//                                   duration: Duration(milliseconds: 1000),
//                                   behavior: SnackBarBehavior.floating,
//                                   backgroundColor: Appcolors.kprimarycolor,
//                                   margin: EdgeInsets.only(
//                                     bottom: ResponsiveUtils.hp(2),
//                                     left: ResponsiveUtils.wp(4),
//                                     right: ResponsiveUtils.wp(4),
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadiusStyles.kradius10(),
//                                   ),
//                                 ),
//                               );
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Appcolors.kprimarycolor,
//                               padding: EdgeInsets.symmetric(
//                                 vertical: ResponsiveUtils.hp(1.5),
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadiusStyles.kradius10(),
//                               ),
//                             ),
//                             child: TextStyles.medium(
//                               text: 'Apply',
//                               weight: FontWeight.w600,
//                               color: Appcolors.kwhitecolor,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildDateSelector({
//     required String label,
//     required DateTime? date,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadiusStyles.kradius10(),
//       child: Container(
//         padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: Appcolors.kgreyColor.withOpacity(0.3),
//             width: 1.5,
//           ),
//           borderRadius: BorderRadiusStyles.kradius10(),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               Icons.calendar_today_rounded,
//               color: Appcolors.kprimarycolor,
//               size: ResponsiveUtils.sp(5),
//             ),
//             ResponsiveSizedBox.width(3),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TextStyles.caption(
//                     text: label,
//                     color: Appcolors.kgreyColor,
//                   ),
//                   ResponsiveSizedBox.height5,
//                   TextStyles.medium(
//                     text: date != null
//                         ? '${date.day.toString().padLeft(2, '0')} ${_getMonthName(date.month)} ${date.year}'
//                         : 'Select date',
//                     weight: FontWeight.w600,
//                     color: date != null
//                         ? Appcolors.kblackcolor
//                         : Appcolors.kgreyColor,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _getMonthName(int month) {
//     const months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec'
//     ];
//     return months[month - 1];
//   }

//   Color _getCategoryColor(String category) {
//     switch (category) {
//       case 'Travel':
//         return Colors.blue;
//       case 'Food':
//         return Colors.orange;
//       case 'Accommodation':
//         return Colors.purple;
//       case 'Supplies':
//         return Colors.teal;
//       case 'Entertainment':
//         return Colors.pink;
//       default:
//         return Appcolors.kprimarycolor;
//     }
//   }

//   IconData _getCategoryIcon(String category) {
//     switch (category) {
//       case 'Travel':
//         return Icons.directions_car;
//       case 'Food':
//         return Icons.restaurant;
//       case 'Accommodation':
//         return Icons.hotel;
//       case 'Supplies':
//         return Icons.shopping_bag;
//       case 'Entertainment':
//         return Icons.celebration;
//       default:
//         return Icons.receipt;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Appcolors.kwhitecolor,
//       appBar: AppBar(
//         backgroundColor: Appcolors.kwhitecolor,
//         elevation: 2,
//         shadowColor: Appcolors.kgreyColor.withOpacity(0.1),
//         leading: IconButton(
//           onPressed: () {
//             context.pop();
//           },
//           icon: Icon(
//             Icons.arrow_back_ios_new_rounded,
//             color: Appcolors.kprimarycolor,
//             size: ResponsiveUtils.sp(5),
//           ),
//         ),
//         title: TextStyles.subheadline(
//           text: 'Employee Expenses',
//           weight: FontWeight.bold,
//           color: Appcolors.kblackcolor,
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: _showFilterDialog,
//             icon: Stack(
//               children: [
//                 Icon(
//                   Icons.filter_list_rounded,
//                   color: Appcolors.kprimarycolor,
//                   size: ResponsiveUtils.sp(6),
//                 ),
//                 if (_fromDate != null || _toDate != null)
//                   Positioned(
//                     right: 0,
//                     top: 0,
//                     child: Container(
//                       width: ResponsiveUtils.wp(2),
//                       height: ResponsiveUtils.wp(2),
//                       decoration: BoxDecoration(
//                         color: Colors.red,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       body: expensesList.isEmpty
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.receipt_long_rounded,
//                     size: ResponsiveUtils.sp(20),
//                     color: Appcolors.kgreyColor.withOpacity(0.5),
//                   ),
//                   ResponsiveSizedBox.height20,
//                   TextStyles.subheadline(
//                     text: 'No expense records found',
//                     color: Appcolors.kgreyColor,
//                   ),
//                 ],
//               ),
//             )
//           : ListView.builder(
//               padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
//               itemCount: expensesList.length,
//               itemBuilder: (context, index) {
//                 final expense = expensesList[index];
//                 return GestureDetector(
//                   onTap: () {
//                     context.push('/employeeexpensedetailpage');
//                   },
//                   child: _buildExpenseCard(expense),
//                 );
//               },
//             ),
//     );
//   }

//   Widget _buildExpenseCard(Map<String, dynamic> expense) {
//     final String status = expense['status'];
//     final Color categoryColor = _getCategoryColor(expense['category']);

//     Color statusColor;
//     IconData statusIcon;
//     if (status == 'Approved') {
//       statusColor = Colors.green;
//       statusIcon = Icons.check_circle;
//     } else if (status == 'Rejected') {
//       statusColor = Colors.red;
//       statusIcon = Icons.cancel;
//     } else {
//       statusColor = Colors.orange;
//       statusIcon = Icons.pending;
//     }

//     return Container(
//       margin: EdgeInsets.only(bottom: ResponsiveUtils.hp(2)),
//       decoration: BoxDecoration(
//         color: Appcolors.kwhitecolor,
//         borderRadius: BorderRadiusStyles.kradius15(),
//         boxShadow: [
//           BoxShadow(
//             color: Appcolors.kgreyColor.withOpacity(0.15),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
//         child: Row(
//           children: [
//             // Category Icon
//             Container(
//               padding: EdgeInsets.all(ResponsiveUtils.wp(3)),
//               decoration: BoxDecoration(
//                 color: categoryColor.withOpacity(0.1),
//                 borderRadius: BorderRadiusStyles.kradius10(),
//               ),
//               child: Icon(
//                 _getCategoryIcon(expense['category']),
//                 size: ResponsiveUtils.sp(7),
//                 color: categoryColor,
//               ),
//             ),
//             ResponsiveSizedBox.width(3),
//             // Details
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Amount
//                   TextStyles.headline(
//                     text: expense['amount'],
//                     weight: FontWeight.bold,
//                     color: Appcolors.kprimarycolor,
//                   ),
//                   ResponsiveSizedBox.height5,
//                   // Date and Category
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.calendar_today,
//                         size: ResponsiveUtils.sp(3.5),
//                         color: Appcolors.kgreyColor,
//                       ),
//                       ResponsiveSizedBox.width(1.5),
//                       TextStyles.caption(
//                         text: expense['date'],
//                         color: Appcolors.kgreyColor,
//                       ),
//                       ResponsiveSizedBox.width(2),
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: ResponsiveUtils.wp(2),
//                           vertical: ResponsiveUtils.hp(0.3),
//                         ),
//                         decoration: BoxDecoration(
//                           color: categoryColor.withOpacity(0.1),
//                           borderRadius: BorderRadiusStyles.kradius5(),
//                         ),
//                         child: TextStyles.caption(
//                           text: expense['category'],
//                           weight: FontWeight.w600,
//                           color: categoryColor.shade700,
//                         ),
//                       ),
//                     ],
//                   ),
//                   ResponsiveSizedBox.height5,
//                   // Remarks
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.comment_outlined,
//                         size: ResponsiveUtils.sp(3.5),
//                         color: Appcolors.kgreyColor,
//                       ),
//                       ResponsiveSizedBox.width(1.5),
//                       Expanded(
//                         child: TextStyles.caption(
//                           text: expense['remarks'],
//                           color: Appcolors.kgreyColor,
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 1,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             ResponsiveSizedBox.width(2),
//             // Status
//             Column(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(ResponsiveUtils.wp(2)),
//                   decoration: BoxDecoration(
//                     color: statusColor.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     statusIcon,
//                     color: statusColor,
//                     size: ResponsiveUtils.sp(6),
//                   ),
//                 ),
//                 ResponsiveSizedBox.height5,
//                 TextStyles.caption(
//                   text: status,
//                   weight: FontWeight.w600,
//                   color: statusColor.shade700,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }