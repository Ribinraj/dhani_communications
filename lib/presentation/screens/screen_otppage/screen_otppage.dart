import 'package:dhani_communications/core/appconstants.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'dart:async';



class OtpPage extends StatefulWidget {
  final String phoneNumber;

  const OtpPage({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  
  int _remainingSeconds = 60;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Auto-focus on OTP field when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _otpFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  void _startTimer() {
    _canResend = false;
    _remainingSeconds = 60;
    _timer?.cancel();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  void _resendOtp() {
    if (_canResend) {
      // Implement resend OTP logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP resent successfully!'),
          backgroundColor: Appcolors.ksecondarycolor,
        ),
      );
      _startTimer();
    }
  }

  void _verifyOtp() {
    if (_otpController.text.length == 6) {
      // // Implement OTP verification logic here
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Verifying OTP: ${_otpController.text}'),
      //     backgroundColor: Appcolors.kprimarycolor,
      //   ),
      // );
      
      // Navigate to next screen on success
     context.push(
  '/main',
  extra: '+91 9876543210',
);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter complete OTP'),
          backgroundColor: Appcolors.kredcolor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Pinput theme
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Appcolors.kblackcolor,
      ),
      decoration: BoxDecoration(
        color: Appcolors.kwhitecolor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Appcolors.kbordercolor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Appcolors.kwhitecolor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Appcolors.kprimarycolor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Appcolors.kprimarycolor.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Appcolors.kprimarycolor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Appcolors.kprimarycolor,
          width: 2,
        ),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Appcolors.kwhitecolor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Appcolors.kredcolor,
          width: 2,
        ),
      ),
    );

    return Scaffold(
   
      body: Stack(
        children: [
          // Custom Paint Background
          CustomPaint(
            painter: OtpBackgroundPainter(),
            size: Size(screenWidth, screenHeight),
          ),

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.02),

                    // Back Button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Appcolors.kblackcolor,
                        ),
                      ),
                    ),


                        Center(
                                            
                              // Uncomment below to use your actual logo
                              child: Image.asset(
                                Appconstants.applogo,
                             height: ResponsiveUtils.hp(30),
                              ),
                            ),


                    // Title
                    const Text(
                      'OTP Verification',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Appcolors.kblackcolor,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Subtitle with phone number
                    Text(
                      'Enter the 6-digit code sent to',
                      style: TextStyle(
                        fontSize: 15,
                        color: Appcolors.kgreyColor.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.phoneNumber,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Appcolors.kprimarycolor,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.05),

                    // OTP Input Field
                    Pinput(
                      controller: _otpController,
                      focusNode: _otpFocusNode,
                      length: 6,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      errorPinTheme: errorPinTheme,
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: true,
                      cursor: Container(
                        width: 2,
                        height: 30,
                        color: Appcolors.kprimarycolor,
                      ),
                      onCompleted: (pin) {
                        // Auto verify when all digits are entered
                        _verifyOtp();
                      },
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // Timer and Resend Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _canResend
                              ? "Didn't receive code?"
                              : 'Resend code in ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Appcolors.kgreyColor.withOpacity(0.8),
                          ),
                        ),
                        if (!_canResend) ...[
                          Text(
                            '00:${_remainingSeconds.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Appcolors.kprimarycolor,
                            ),
                          ),
                        ] else ...[
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: _resendOtp,
                            child: const Text(
                              'Resend',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Appcolors.kprimarycolor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // Verify Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _verifyOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Appcolors.kprimarycolor,
                          foregroundColor: Appcolors.kwhitecolor,
                          elevation: 3,
                          shadowColor: Appcolors.kprimarycolor.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Verify OTP',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Help Text
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Appcolors.kprimarycolor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: Appcolors.kprimarycolor.withOpacity(0.8),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Make sure to check your messages for the OTP code',
                              style: TextStyle(
                                fontSize: 12,
                                color: Appcolors.kgreyColor.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Paint for Background Design
class OtpBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Top Left Circle
    final paint1 = Paint()
      ..color = Appcolors.kbordercolor.withOpacity(0.12)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.12),
      100,
      paint1,
    );

    // Top Right Decorative Shape
    final paint2 = Paint()
      ..color = Appcolors.kprimarycolor.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width, 0);
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.15,
      size.width * 0.7,
      size.height * 0.25,
    );
    path.lineTo(size.width, size.height * 0.3);
    path.close();
    canvas.drawPath(path, paint2);

    // Bottom Right Circle
    final paint3 = Paint()
      ..color = Appcolors.ksecondarycolor.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.75),
      80,
      paint3,
    );

    // Bottom Left Curve
    final paint4 = Paint()
      ..color = Appcolors.kprimarycolor.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height);
    path2.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.85,
      size.width * 0.4,
      size.height * 0.9,
    );
    path2.lineTo(0, size.height * 0.9);
    path2.close();
    canvas.drawPath(path2, paint4);

    // Decorative dots
    final dotPaint = Paint()
      ..color = Appcolors.kbordercolor.withOpacity(0.25)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.25, size.height * 0.35), 6, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.75, size.height * 0.5), 8, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.65), 7, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}