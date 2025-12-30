import 'package:dhani_communications/core/appconstants.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/presentation/screens/screen_loginpage/screen_loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:math' as math;

import 'package:go_router/go_router.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _logoController;
  late AnimationController _pulseController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;

  @override
  void initState() {
    super.initState();

    // Wave animation controller
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Logo animation controller
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Pulse animation controller
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.elasticOut,
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _logoController.forward();

    // Navigate after 3 seconds
  Future.delayed(const Duration(seconds: 3), () {
    if (!mounted) return;
    context.go('/login'); // replaces splash
  });
  }

  @override
  void dispose() {
    _waveController.dispose();
    _logoController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Stack(
        children: [
          // Animated wave background
          AnimatedBuilder(
            animation: _waveController,
            builder: (context, child) {
              return CustomPaint(
                painter: WavePainter(
                  animationValue: _waveController.value,
                ),
                child: Container(),
              );
            },
          ),

          // Floating particles
          ...List.generate(
            20,
            (index) => AnimatedParticle(
              delay: index * 0.2,
              color: index % 2 == 0
                  ? Appcolors.kprimarycolor.withOpacity(0.3)
                  : Appcolors.kbordercolor.withOpacity(0.3),
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with scale and fade animation
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: Stack(
                          children: [
                            // Pulse effect
                            AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                return Center(
                                  child: SizedBox(
                                    width: 150 + (_pulseController.value * 20),
                                    height: 150 + (_pulseController.value * 20),
                                
                                  ),
                                );
                              },
                            ),
                            // Logo placeholder - Replace with your actual logo
                            Center(
                                            
                              // Uncomment below to use your actual logo
                              child: Image.asset(
                                Appconstants.applogo,
                             
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                ResponsiveSizedBox.height20,

                // App name with animation
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoOpacity.value,
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Appcolors.kprimarycolor,
                            Appcolors.kbordercolor,
                            Appcolors.ksecondarycolor,
                          ],
                        ).createShader(bounds),
                        child: const Text(
                          'Dhani Communications',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Appcolors.kwhitecolor,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                ResponsiveSizedBox.height10,

                // Tagline
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoOpacity.value * 0.7,
                      child: const Text(
                        'Innovation at your fingertips',
                        style: TextStyle(
                          fontSize: 14,
                          color: Appcolors.kgreyColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  },
                ),

                ResponsiveSizedBox.height40,

                // SpinKit loading indicator
                SpinKitWave(
                  color: Appcolors.kprimarycolor,
                  size: 40.0,
                  type: SpinKitWaveType.center,
                ),
              ],
            ),
          ),

          // Bottom branding
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _logoController,
              builder: (context, child) {
                return Opacity(
                  opacity: _logoOpacity.value * 0.5,
                  child: const Text(
                    'Powered by Crisant Technologies',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 89, 86, 86),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Custom wave painter
class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = Appcolors.kprimarycolor.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = Appcolors.kbordercolor.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    final paint3 = Paint()
      ..color = Appcolors.ksecondarycolor.withOpacity(0.06)
      ..style = PaintingStyle.fill;

    // Draw three waves
    _drawWave(canvas, size, paint1, animationValue, 0.0, 40);
    _drawWave(canvas, size, paint2, animationValue, 0.3, 50);
    _drawWave(canvas, size, paint3, animationValue, 0.6, 60);
  }

  void _drawWave(Canvas canvas, Size size, Paint paint, double animationValue,
      double offset, double waveHeight) {
    final path = Path();
    final waveLength = size.width / 2;
    final phase = animationValue * 2 * math.pi;

    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height -
          waveHeight * (1 + (animationValue * 0.5)) -
          waveHeight *
              0.5 *
              (1 +
                  math.sin((x / waveLength * 2 * math.pi) + phase + offset * 2 * math.pi));
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
}

// Animated floating particles
class AnimatedParticle extends StatefulWidget {
  final double delay;
  final Color color;

  const AnimatedParticle({
    super.key,
    required this.delay,
    required this.color,
  });

  @override
  State<AnimatedParticle> createState() => _AnimatedParticleState();
}

class _AnimatedParticleState extends State<AnimatedParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double? left;
  double? top;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000 + (widget.delay * 1000).toInt()),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    left ??= (widget.delay * 200) % MediaQuery.of(context).size.width;
    top ??= (widget.delay * 150) % MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: left,
          top: top! + (_animation.value * 100),
          child: Opacity(
            opacity: 0.6 - (_animation.value * 0.4),
            child: Container(
              width: 8 + (widget.delay * 2),
              height: 8 + (widget.delay * 2),
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}