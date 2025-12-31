import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:dhani_communications/core/appconstants.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';


class ScreenDashboardpage extends StatefulWidget {
  const ScreenDashboardpage({super.key});

  @override
  State<ScreenDashboardpage> createState() => _HomePageState();
}

class _HomePageState extends State<ScreenDashboardpage> {
  int _currentCarouselIndex = 0;

  // Carousel items
  final List<Map<String, dynamic>> carouselItems = [
    {
      'title': 'Welcome to Dhani',
      'subtitle': 'Your trusted communication partner',
      'color': Appcolors.kprimarycolor,
    },
    {
      'title': 'Stay Connected',
      'subtitle': 'Seamless communication experience',
      'color': Appcolors.ksecondarycolor,
    },
    {
      'title': 'Explore More',
      'subtitle': 'Discover amazing features',
      'color': Appcolors.kprimarycolor.withOpacity(0.8),
    },
  ];

  // Grid options
  final List<Map<String, dynamic>> gridOptions = [
    {'icon': Icons.message, 'label': 'Attendance', 'color': Color(0xFF6C63FF)},
    {'icon': Icons.call, 'label': 'Contract Labors', 'color': Color(0xFF00D9FF)},
    {'icon': Icons.video_call, 'label': 'Expenses', 'color': Color(0xFFFF6584)},
    {'icon': Icons.contacts, 'label': 'Machinery Hire', 'color': Color(0xFF4CAF50)},
    {'icon': Icons.settings, 'label': 'Cash Balance', 'color': Color(0xFFFF9800)},
    {'icon': Icons.notifications, 'label': 'Leaves', 'color': Color(0xFF9C27B0)},
    {'icon': Icons.payment, 'label': 'Project DPR', 'color': Color(0xFF00BCD4)},
    {'icon': Icons.history, 'label': 'Vehicles', 'color': Color(0xFF795548)},
    {'icon': Icons.support_agent, 'label': 'Company Assets', 'color': Color(0xFFE91E63)},
    {'icon': Icons.share, 'label': 'Project Inventory', 'color': Color(0xFF3F51B5)},
    {'icon': Icons.more_horiz, 'label': 'Requests', 'color': Color(0xFF607D8B)},
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Custom Paint Background
          CustomPaint(
            painter: HomeBackgroundPainter(),
            size: Size(screenWidth, screenHeight),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // App Bar
                _buildAppBar(),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: ResponsiveUtils.hp(2)),

                        // Carousel Slider
                        _buildCarouselSlider(),

                        SizedBox(height: ResponsiveUtils.hp(3)),

                        // Grid View Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Quick Access',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Appcolors.kblackcolor,
                                ),
                              ),
                              SizedBox(height: ResponsiveUtils.hp(2)),
                              _buildGridView(),
                            ],
                          ),
                        ),

                        SizedBox(height: ResponsiveUtils.hp(3)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Appcolors.kwhitecolor.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Appcolors.kgreyColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                Appconstants.applogo,
                height: ResponsiveUtils.hp(5),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hello, User',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Appcolors.kblackcolor,
                    ),
                  ),
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 12,
                      color: Appcolors.kgreyColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
            color: Appcolors.kprimarycolor,
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselSlider() {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: ResponsiveUtils.hp(20),
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            enlargeCenterPage: true,
            viewportFraction: 0.85,
            onPageChanged: (index, reason) {
              setState(() {
                _currentCarouselIndex = index;
              });
            },
          ),
          items: carouselItems.map((item) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        item['color'],
                        item['color'].withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: item['color'].withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Appcolors.kwhitecolor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['subtitle'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Appcolors.kwhitecolor.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        // Carousel Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: carouselItems.asMap().entries.map((entry) {
            return Container(
              width: _currentCarouselIndex == entry.key ? 24 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentCarouselIndex == entry.key
                    ? Appcolors.kprimarycolor
                    : Appcolors.kgreyColor.withOpacity(0.3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: gridOptions.length,
      itemBuilder: (context, index) {
        final option = gridOptions[index];
        return GestureDetector(
          onTap: () {
            // Handle option tap
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${option['label']} tapped'),
                duration: const Duration(milliseconds: 800),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Appcolors.kwhitecolor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Appcolors.kgreyColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: option['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    option['icon'],
                    size: 32,
                    color: option['color'],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  option['label'],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Appcolors.kblackcolor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Custom Paint for Background Design
class HomeBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Top Right Circle
    final paint1 = Paint()
      ..color = Appcolors.kprimarycolor.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.08),
      100,
      paint1,
    );

    // Top Left Small Circle
    final paint2 = Paint()
      ..color = Appcolors.ksecondarycolor.withOpacity(0.09)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.12),
      70,
      paint2,
    );

    // Bottom Wave
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

    // Decorative dots
    final dotPaint = Paint()
      ..color = Appcolors.kbordercolor.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.4), 6, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.3), 8, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.7), 7, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.6), 5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}