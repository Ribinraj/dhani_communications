import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';



class ScreenLabourattendenceMarkingpage extends StatefulWidget {
  const ScreenLabourattendenceMarkingpage({super.key});

  @override
  State<ScreenLabourattendenceMarkingpage> createState() =>
      _ScreenLabourAttendanceScreenState();
}

class _ScreenLabourAttendanceScreenState
    extends State<ScreenLabourattendenceMarkingpage> {
  void _handlePunchIn() {
context.push('/labourPunchinpage',);
  }

  void _handlePunchOut() {
context.push('/labourPunchoutpage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      appBar:AppBar(
        backgroundColor: Appcolors.kwhitecolor,
        elevation: 2,
        shadowColor: Appcolors.kgreyColor.withOpacity(0.1),
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
        title: TextStyles.subheadline(
          text: 'Labour Attendance',
          weight: FontWeight.bold,
          color: Appcolors.kblackcolor,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveUtils.wp(5)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Punch In Button
              _buildBigAttendanceButton(
                label: 'PUNCH IN',
                icon: Mdi.login_variant,
                gradient: const LinearGradient(
                  colors: [Color(0xFF49CF41), Color(0xFF2ECC71)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onPressed: _handlePunchIn,
              ),

              ResponsiveSizedBox.height30,

              // Punch Out Button
              _buildBigAttendanceButton(
                label: 'PUNCH OUT',
                icon: Mdi.logout_variant,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF5252), Color(0xFFE53935)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onPressed: _handlePunchOut,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBigAttendanceButton({
    required String label,
    required String icon,
    required Gradient gradient,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: ResponsiveUtils.hp(25),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadiusStyles.kradius20(),

        ),
        child: CustomPaint(
          painter: _AttendanceButtonPainter(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Iconify(
                icon,
                size: ResponsiveUtils.sp(20),
                color: Appcolors.kwhitecolor,
              ),
              ResponsiveSizedBox.height20,
              ResponsiveText(
                label,
                sizeFactor: 1.5,
                weight: FontWeight.bold,
                color: Appcolors.kwhitecolor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttendanceButtonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    // Draw decorative circles
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.2),
      size.width * 0.15,
      paint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.8),
      size.width * 0.12,
      paint,
    );

    // Draw decorative arc
    final arcPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawArc(
      Rect.fromLTWH(
        size.width * 0.6,
        -size.height * 0.2,
        size.width * 0.5,
        size.height * 0.5,
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