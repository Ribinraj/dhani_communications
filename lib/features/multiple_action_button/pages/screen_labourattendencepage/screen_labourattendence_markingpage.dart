// import 'package:dhani_communications/core/colors.dart';
// import 'package:dhani_communications/core/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:dhani_communications/core/responsiveutils.dart';
// import 'package:go_router/go_router.dart';
// import 'package:iconify_flutter/iconify_flutter.dart';
// import 'package:iconify_flutter/icons/mdi.dart';

// class ScreenLabourattendenceMarkingpage extends StatefulWidget {
//   const ScreenLabourattendenceMarkingpage({super.key});

//   @override
//   State<ScreenLabourattendenceMarkingpage> createState() =>
//       _ScreenLabourAttendanceScreenState();
// }

// class _ScreenLabourAttendanceScreenState
//     extends State<ScreenLabourattendenceMarkingpage> {
//   void _handlePunchIn() {
//     context.push('/labourPunchinpage');
//   }

//   void _handlePunchOut() {
//     context.push('/labourPunchoutpage');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back_ios_new_rounded,
//             color: Appcolors.kprimarycolor,
//             size: ResponsiveUtils.sp(5),
//           ),
//         ),
//         title: TextStyles.subheadline(
//           text: 'Labour Attendance',
//           weight: FontWeight.bold,
//           color: Appcolors.kblackcolor,
//         ),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(ResponsiveUtils.wp(5)),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Punch In Button
//               _buildBigAttendanceButton(
//                 label: 'PUNCH IN',
//                 icon: Mdi.login_variant,
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF49CF41), Color(0xFF2ECC71)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 onPressed: _handlePunchIn,
//               ),

//               ResponsiveSizedBox.height30,

//               // Punch Out Button
//               _buildBigAttendanceButton(
//                 label: 'PUNCH OUT',
//                 icon: Mdi.logout_variant,
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFFFF5252), Color(0xFFE53935)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 onPressed: _handlePunchOut,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBigAttendanceButton({
//     required String label,
//     required String icon,
//     required Gradient gradient,
//     required VoidCallback onPressed,
//   }) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         width: double.infinity,
//         height: ResponsiveUtils.hp(25),
//         decoration: BoxDecoration(
//           gradient: gradient,
//           borderRadius: BorderRadiusStyles.kradius20(),
//         ),
//         child: CustomPaint(
//           painter: _AttendanceButtonPainter(),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Iconify(
//                 icon,
//                 size: ResponsiveUtils.sp(10),
//                 color: Appcolors.kwhitecolor,
//               ),
//               ResponsiveSizedBox.height20,
//               ResponsiveText(
//                 label,
//                 sizeFactor: 1,
//                 weight: FontWeight.bold,
//                 color: Appcolors.kwhitecolor,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _AttendanceButtonPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white.withValues(alpha: 0.15)
//       ..style = PaintingStyle.fill;

//     // Draw decorative circles
//     canvas.drawCircle(
//       Offset(size.width * 0.1, size.height * 0.2),
//       size.width * 0.15,
//       paint,
//     );

//     canvas.drawCircle(
//       Offset(size.width * 0.9, size.height * 0.8),
//       size.width * 0.12,
//       paint,
//     );

//     // Draw decorative arc
//     final arcPaint = Paint()
//       ..color = Colors.white.withValues(alpha: 0.1)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 3;

//     canvas.drawArc(
//       Rect.fromLTWH(
//         size.width * 0.6,
//         -size.height * 0.2,
//         size.width * 0.5,
//         size.height * 0.5,
//       ),
//       0,
//       3.14,
//       false,
//       arcPaint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:dhani_communications/core/localization/app_localization.dart';

class ScreenLabourattendenceMarkingpage extends StatefulWidget {
  const ScreenLabourattendenceMarkingpage({super.key});

  @override
  State<ScreenLabourattendenceMarkingpage> createState() =>
      _ScreenLabourAttendanceScreenState();
}

class _ScreenLabourAttendanceScreenState
    extends State<ScreenLabourattendenceMarkingpage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handlePunchIn() {
    context.push('/labourPunchinpage');
  }

  void _handlePunchOut() {
    context.push('/labourPunchoutpage');
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning 🌤️';
    if (hour < 17) return 'Good Afternoon ☀️';
    return 'Good Evening 🌙';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final dayName = weekdays[now.weekday - 1];
    final dateStr = '${now.day} ${months[now.month - 1]}, ${now.year}';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Appcolors.kprimarycolor,
            size: ResponsiveUtils.sp(5),
          ),
        ),
        title: TextStyles.subheadline(
          text: context.tr('labour_attendance'),
          weight: FontWeight.bold,
          color: Appcolors.kblackcolor,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.wp(6),
            vertical: ResponsiveUtils.hp(3),
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting + Date Banner
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.wp(5),
                      vertical: ResponsiveUtils.hp(2.5),
                    ),
                    decoration: BoxDecoration(
                      color: Appcolors.kappbarbackgroundcolor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Appcolors.kprimarycolor.withValues(alpha: 0.1),
                          blurRadius: 16,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      border: Border.all(
                        color: Appcolors.kbordercolor.withValues(alpha: 0.3),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getGreeting(),
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.sp(4.2),
                                  fontWeight: FontWeight.w700,
                                  color: Appcolors.kblackcolor,
                                ),
                              ),
                              SizedBox(height: ResponsiveUtils.hp(0.5)),
                              Text(
                                '$dayName, $dateStr',
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.sp(3.2),
                                  color: Appcolors.kblackcolor.withValues(
                                    alpha: 0.5,
                                  ),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Live date badge
                        Container(
                          width: ResponsiveUtils.wp(13),
                          height: ResponsiveUtils.wp(13),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Appcolors.kprimarycolor,
                                Appcolors.kbordercolor,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              '${now.day}',
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(5.5),
                                fontWeight: FontWeight.w900,
                                color: Appcolors.kwhitecolor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: ResponsiveUtils.hp(4)),

                  // Section label
                  Padding(
                    padding: EdgeInsets.only(
                      left: ResponsiveUtils.wp(1),
                      bottom: ResponsiveUtils.hp(1.8),
                    ),
                    child: Text(context.tr('mark_attendance'),
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(4.5),
                        fontWeight: FontWeight.w700,
                        color: Appcolors.kblackcolor.withValues(alpha: 0.75),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  // Punch In Button
                  _buildAttendanceButton(
                    label: 'PUNCH IN',
                    sublabel: 'Mark your arrival',
                    icon: Mdi.login_variant,
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 104, 210, 98),
                        const Color.fromARGB(255, 73, 228, 137),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    accentColor: const Color.fromARGB(255, 77, 181, 72),
                    onPressed: _handlePunchIn,
                  ),

                  SizedBox(height: ResponsiveUtils.hp(2.5)),

                  // Punch Out Button
                  _buildAttendanceButton(
                    label: 'PUNCH OUT',
                    sublabel: 'Mark your departure',
                    icon: Mdi.logout_variant,
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 110, 157, 214),
                        const Color.fromARGB(255, 140, 203, 223),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    accentColor: const Color.fromARGB(255, 88, 133, 188),
                    onPressed: _handlePunchOut,
                  ),

                  SizedBox(height: ResponsiveUtils.hp(4)),

                  // Tip banner
                  _buildTipBanner(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceButton({
    required String label,
    required String sublabel,
    required String icon,
    required Gradient gradient,
    required Color accentColor,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: ResponsiveUtils.hp(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CustomPaint(painter: _AttendanceButtonPainter()),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.wp(6)),
              child: Row(
                children: [
                  Container(
                    width: ResponsiveUtils.wp(14),
                    height: ResponsiveUtils.wp(14),
                    decoration: BoxDecoration(
                      color: Appcolors.kwhitecolor.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Iconify(
                        icon,
                        size: ResponsiveUtils.sp(7),
                        color: Appcolors.kwhitecolor,
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.wp(5)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(5.5),
                          fontWeight: FontWeight.w800,
                          color: Appcolors.kwhitecolor,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.hp(0.5)),
                      Text(
                        sublabel,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(3.2),
                          color: Appcolors.kwhitecolor.withValues(alpha: 0.85),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: ResponsiveUtils.wp(9),
                    height: ResponsiveUtils.wp(9),
                    decoration: BoxDecoration(
                      color: Appcolors.kwhitecolor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Appcolors.kwhitecolor,
                      size: ResponsiveUtils.sp(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.wp(5),
        vertical: ResponsiveUtils.hp(2),
      ),
      decoration: BoxDecoration(
        color: Appcolors.kprimarycolor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Appcolors.kprimarycolor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Appcolors.kprimarycolor,
            size: ResponsiveUtils.sp(5),
          ),
          SizedBox(width: ResponsiveUtils.wp(3)),
          Expanded(
            child: Text(context.tr('tap_punch_in_when_you_arrive_and_punch_out_when'),
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(3.2),
                color: Appcolors.kprimarycolor.withValues(alpha: 0.85),
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceButtonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.2),
      size.width * 0.18,
      paint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.93, size.height * 0.8),
      size.width * 0.1,
      paint,
    );

    final arcPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawArc(
      Rect.fromLTWH(
        size.width * 0.55,
        -size.height * 0.3,
        size.width * 0.6,
        size.height * 0.7,
      ),
      0,
      3.14,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
