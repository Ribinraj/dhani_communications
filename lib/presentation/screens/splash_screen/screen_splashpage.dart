import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

import 'package:dhani_communications/core/appconstants.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _waveController;
  late final AnimationController _logoController;
  late final AnimationController _pulseController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;

  @override
  void initState() {
    super.initState();

    _waveController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat();

    _logoController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))
          ..forward();

    _pulseController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))
          ..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.go('/login');
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
          /// 🌊 Wave Background (release safe)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (_, __) {
                return CustomPaint(
                  painter: WavePainter(animationValue: _waveController.value),
                );
              },
            ),
          ),

          /// ✨ Floating particles
          ...List.generate(
            20,
            (index) => AnimatedParticle(
              delay: index * 0.2,
              color: index.isEven
                  ? Appcolors.kprimarycolor.withOpacity(0.3)
                  : Appcolors.kbordercolor.withOpacity(0.3),
            ),
          ),

          /// 🔥 Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (_, __) {
                    return Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedBuilder(
                              animation: _pulseController,
                              builder: (_, __) {
                                return SizedBox(
                                  width: 150 + (_pulseController.value * 20),
                                  height: 150 + (_pulseController.value * 20),
                                  child: const DecoratedBox(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                );
                              },
                            ),
                            Image.asset(
                              Appconstants.applogo,
                              width: 120,
                              height: 120,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                ResponsiveSizedBox.height20,

                AnimatedBuilder(
                  animation: _logoController,
                  builder: (_, __) {
                    return Opacity(
                      opacity: _logoOpacity.value,
                      child: ShaderMask(
                        blendMode: BlendMode.srcIn,
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
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                ResponsiveSizedBox.height10,

                AnimatedBuilder(
                  animation: _logoController,
                  builder: (_, __) {
                    return Opacity(
                      opacity: _logoOpacity.value * 0.7,
                      child: const Text(
                        'Innovation at your fingertips',
                        style: TextStyle(
                          fontSize: 14,
                          color: Appcolors.kgreyColor,
                        ),
                      ),
                    );
                  },
                ),

                ResponsiveSizedBox.height40,

                const SpinKitWave(
                  color: Appcolors.kprimarycolor,
                  size: 40,
                  type: SpinKitWaveType.center,
                ),
              ],
            ),
          ),

          /// 🔻 Bottom text
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _logoController,
              builder: (_, __) {
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

/// 🌊 Wave Painter (unchanged)
class WavePainter extends CustomPainter {
  final double animationValue;
  WavePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paints = [
      Appcolors.kprimarycolor.withOpacity(0.1),
      Appcolors.kbordercolor.withOpacity(0.08),
      Appcolors.ksecondarycolor.withOpacity(0.06),
    ];

    for (int i = 0; i < paints.length; i++) {
      _drawWave(
        canvas,
        size,
        Paint()..color = paints[i],
        animationValue,
        i * 0.3,
        40 + (i * 10),
      );
    }
  }

  void _drawWave(Canvas canvas, Size size, Paint paint, double value,
      double offset, double height) {
    final path = Path();
    final waveLength = size.width / 2;
    final phase = value * 2 * math.pi;

    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height -
          height -
          height *
              0.5 *
              math.sin((x / waveLength * 2 * math.pi) + phase + offset * 2 * math.pi);
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => true;
}

/// ✨ Particle (unchanged)
class AnimatedParticle extends StatefulWidget {
  final double delay;
  final Color color;
  const AnimatedParticle({super.key, required this.delay, required this.color});

  @override
  State<AnimatedParticle> createState() => _AnimatedParticleState();
}

class _AnimatedParticleState extends State<AnimatedParticle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  double? left;
  double? top;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 3000))
          ..repeat(reverse: true);

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    left ??= (widget.delay * 200) % MediaQuery.of(context).size.width;
    top ??= (widget.delay * 150) % MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return Positioned(
          left: left,
          top: top! + (_animation.value * 100),
          child: Opacity(
            opacity: 0.6 - (_animation.value * 0.4),
            child: Container(
              width: 8 + widget.delay * 2,
              height: 8 + widget.delay * 2,
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
