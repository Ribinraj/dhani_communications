import 'dart:ui';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:flutter/material.dart';

class HomeBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = Appcolors.kprimarycolor.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.08),
      ResponsiveUtils.wp(25),
      paint1,
    );

    final paint2 = Paint()
      ..color = Appcolors.ksecondarycolor.withOpacity(0.09)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.12),
      ResponsiveUtils.wp(17.5),
      paint2,
    );

    final paint3 = Paint()
      ..color = Appcolors.kprimarycolor.withOpacity(0.09)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.85);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.8,
      size.width * 0.5,
      size.height * 0.85,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.9,
      size.width,
      size.height * 0.85,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint3);

    final dotPaint = Paint()
      ..color = Appcolors.kbordercolor.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.4),
      ResponsiveUtils.wp(1.5),
      dotPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.3),
      ResponsiveUtils.wp(2),
      dotPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.7),
      ResponsiveUtils.wp(1.75),
      dotPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.6),
      ResponsiveUtils.wp(1.25),
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}