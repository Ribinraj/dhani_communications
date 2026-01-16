
import 'dart:math' as math;
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/presentation/screens/screen_dashboard.dart/widgets/paint.dart';
import 'package:flutter/material.dart';
import 'package:dhani_communications/core/appconstants.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

class ScreenDashboardpage extends StatefulWidget {
  const ScreenDashboardpage({super.key});

  @override
  State<ScreenDashboardpage> createState() => _HomePageState();
}

class _HomePageState extends State<ScreenDashboardpage>
    with SingleTickerProviderStateMixin {
  int _currentCarouselIndex = 0;
  bool _isFabOpen = false;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  late Animation<double> _fabRotationAnimation;
  late Animation<double> _fabScaleAnimation;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeOutCubic,
    );
    _fabRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.625,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));
    _fabScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _toggleFab() {
    setState(() {
      _isFabOpen = !_isFabOpen;
      if (_isFabOpen) {
        _fabAnimationController.forward();
      } else {
        _fabAnimationController.reverse();
      }
    });
  }

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
    {
      'iconPath': Appconstants.attenedence,
      'label': 'Attendance',
      'color': Color(0xFF6C63FF),
    },
    {
      'iconPath': Appconstants.contractlabours,
      'label': 'Contract Labors',
      'color': Color(0xFF00D9FF),
    },
    {
      'iconPath': Appconstants.expenses,
      'label': 'Expenses',
      'color': Color(0xFFFF6584),
    },
    {
      'iconPath': Appconstants.machinery,
      'label': 'Machinery Hire',
      'color': Color(0xFF4CAF50),
    },
    {
      'iconPath': Appconstants.cashbalance,
      'label': 'Cash Balance',
      'color': Color(0xFFFF9800),
    },
    {
      'iconPath': Appconstants.leaves,
      'label': 'Leaves',
      'color': Color(0xFF9C27B0),
    },
    {
      'iconPath': Appconstants.projectdpr,
      'label': 'Project DPR',
      'color': Color(0xFF00BCD4),
    },
    {
      'iconPath': Appconstants.vehicles,
      'label': 'Vehicles',
      'color': Color(0xFF795548),
    },
    {
      'iconPath': Appconstants.assets,
      'label': 'Company Assets',
      'color': Color(0xFFE91E63),
    },
    {
      'iconPath': Appconstants.inventory,
      'label': 'Project Inventory',
      'color': Color(0xFF3F51B5),
    },
    {
      'iconPath': Appconstants.requests,
      'label': 'Requests',
      'color': Color(0xFF607D8B),
    },
  ];

// FAB options data with Iconify icons
  final List<Map<String, dynamic>> fabOptions = [
    {
      'iconify': Mdi.account_clock, // Daily Attendance
      'label': 'Daily Attendance',
      'color': Color(0xFF6C63FF),
      'useIconify': true,
      'route': '/dailyattendencepage',
    },
    {
      'iconify': Mdi.account_group, // Labour Attendance
      'label': 'Labour Attendance',
      'color': Color(0xFF00D9FF),
      'useIconify': true,
      'route': '/labourAttendencemarkingpage',
    },
    {
      'icon': Icons.precision_manufacturing_rounded, // Machinery
      'label': 'New Machinery Hire',
      'color': Color(0xFFFF6584),
      'useIconify': false,
      'route': '/newmachinehirepage',
    },
    {
      'iconify': Mdi.cash_register, // Daily Expenditure
      'label': 'Daily Expenditure',
      'color': Color(0xFF4CAF50),
      'useIconify': true,
      'route': '/newexpensepage',
    },
    {
      'iconify': Mdi.calendar_remove, // Leave Application
      'label': 'Leave Application',
      'color': Color(0xFFFF9800),
      'useIconify': true,
      'route':'/leaveapplicationpage',
    },
    {
      'iconify': Mdi.chart_line, // Daily Progress Report
      'label': 'Daily Progress (DPR)',
      'color': Color(0xFF9C27B0),
      'useIconify': true,
      'route': '/dprprogress'
    },
    {
      'iconify': Mdi.file_document_edit, // Request
      'label': 'Request',
      'color': Color(0xFFE91E63),
      'useIconify': true,
      'route': '/newrequestpage'
    },
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
          // Main Scrollable Content
          CustomScrollView(
            slivers: [
              // App Bar - Fixed without back button
              SliverAppBar(
                expandedHeight: 0,
                floating: false,
                pinned: true,
                automaticallyImplyLeading: false,
                backgroundColor: Appcolors.kwhitecolor.withOpacity(0.95),
                elevation: 2,
                shadowColor: Appcolors.kgreyColor.withOpacity(0.1),
                flexibleSpace: _buildAppBar(),
              ),
              // Content
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    ResponsiveSizedBox.height20,
                    // Carousel Slider
                    _buildCarouselSlider(),
                    ResponsiveSizedBox.height(2.5),
                    // Grid View Section
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.wp(4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextStyles.subheadline(
                            text: 'Quick Access',
                            weight: FontWeight.bold,
                            color: Appcolors.kblackcolor,
                          ),
                          ResponsiveSizedBox.height15,
                          _buildGridView(),
                        ],
                      ),
                    ),
                    // Bottom padding for floating nav bar
                    ResponsiveSizedBox.height(15),
                  ],
                ),
              ),
            ],
          ),
          // Backdrop with blur when FAB is open
          if (_isFabOpen)
            AnimatedOpacity(
              opacity: _isFabOpen ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              child: GestureDetector(
                onTap: _toggleFab,
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
          // Multi-Action FAB Options with staggered animation
        // Multi-Action FAB Options with staggered animation
...List.generate(fabOptions.length, (index) {
  final option = fabOptions[index];
  final reversedIndex = fabOptions.length - 1 - index;
  return AnimatedPositioned(
    duration: const Duration(milliseconds: 250),
    curve: Curves.easeOutCubic,
    right: ResponsiveUtils.wp(4),
    bottom: _isFabOpen
        ? ResponsiveUtils.hp(22.5) + (reversedIndex * ResponsiveUtils.hp(9))
        : ResponsiveUtils.hp(11.5),
    child: ScaleTransition(
      scale: CurvedAnimation(
        parent: _fabAnimation,
        curve: Interval(
          index * 0.15,
          1.0,
          curve: Curves.elasticOut,
        ),
      ),
      child: FadeTransition(
        opacity: _fabAnimation,
        child: _buildFabOption(
          icon: option['icon'],
          iconify: option['iconify'],
          label: option['label'],
          color: option['color'],
          useIconify: option['useIconify'] ?? false,
          route: option['route'], 
        ),
      ),
    ),
  );
}),
          // Main FAB
          Positioned(
            right: ResponsiveUtils.wp(4),
            bottom: ResponsiveUtils.hp(15.4),
            child: ScaleTransition(
              scale: _fabScaleAnimation,
              child: FloatingActionButton(
                heroTag: 'main_fab',
                onPressed: _toggleFab,
                backgroundColor: Appcolors.kprimarycolor,
                elevation: 8,
                child: AnimatedBuilder(
                  animation: _fabRotationAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _fabRotationAnimation.value * 2 * math.pi,
                      child: Icon(
                        _isFabOpen ? Icons.close_rounded : Icons.add_rounded,
                        color: Colors.white,
                        size: ResponsiveUtils.sp(5),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildFabOption({
  IconData? icon,
  String? iconify,
  required String label,
  required Color color,
  bool useIconify = false,
   String? route,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {
        _toggleFab();
  if (route != null && route.isNotEmpty) {
    context.push(route); // ✅ GO ROUTER NAVIGATION
  }
},
      
      borderRadius: BorderRadiusStyles.kradius15(),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.wp(4),
          vertical: ResponsiveUtils.hp(1.5),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusStyles.kradius15(),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Label
            TextStyles.medium(
              text: label,
              weight: FontWeight.w600,
              color: color,
            ),
            ResponsiveSizedBox.width(3),
            // Icon container
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.wp(2.5)),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: useIconify && iconify != null
                  ? Iconify(
                      iconify,
                      color: Colors.white,
                      size: ResponsiveUtils.sp(5),
                    )
                  : Icon(
                      icon ?? Icons.add,
                      color: Colors.white,
                      size: ResponsiveUtils.sp(5),
                    ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + ResponsiveUtils.hp(1),
        left: ResponsiveUtils.wp(4),
        right: ResponsiveUtils.wp(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Image.asset(
                  Appconstants.applogo,
                  height: ResponsiveUtils.hp(5),
                ),
                ResponsiveSizedBox.width(3),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextStyles.subheadline(
                        text: 'Hello, User',
                        weight: FontWeight.bold,
                        color: Appcolors.kblackcolor,
                        overflow: TextOverflow.ellipsis,
                      ),
                      TextStyles.caption(
                        text: 'Welcome back!',
                        color: Appcolors.kgreyColor.withOpacity(0.7),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              context.push('/notificationpage');
            },
            icon: const Icon(Icons.notifications_outlined),
            color: Appcolors.kprimarycolor,
            iconSize: ResponsiveUtils.sp(6.5),
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
                  margin: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.wp(1.25),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        item['color'],
                        item['color'].withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadiusStyles.kradius15(),
                    boxShadow: [
                      BoxShadow(
                        color: item['color'].withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(ResponsiveUtils.wp(5)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextStyles.headline(
                          text: item['title'],
                          weight: FontWeight.bold,
                          color: Appcolors.kwhitecolor,
                        ),
                        ResponsiveSizedBox.height10,
                        TextStyles.medium(
                          text: item['subtitle'],
                          color: Appcolors.kwhitecolor.withOpacity(0.9),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        ResponsiveSizedBox.height10,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: carouselItems.asMap().entries.map((entry) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentCarouselIndex == entry.key
                  ? ResponsiveUtils.wp(6)
                  : ResponsiveUtils.wp(2),
              height: ResponsiveUtils.hp(1),
              margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.wp(1)),
              decoration: BoxDecoration(
                borderRadius: BorderRadiusStyles.kradius5(),
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
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: ResponsiveUtils.wp(4),
        mainAxisSpacing: ResponsiveUtils.hp(2),
        childAspectRatio: 1,
      ),
      itemCount: gridOptions.length,
      itemBuilder: (context, index) {
        final option = gridOptions[index];
        return GestureDetector(
   onTap: () {
    if (option['label'] == 'Attendance') {
      context.push('/employeeattendencepage');
    } else if (option['label'] == 'Contract Labors') {
      context.push('/labourattendencepage');
    } else if (option['label'] == 'Expenses') {
      context.push('/expensespage');
    } else if (option['label'] == 'Machinery Hire') {
      context.push('/machinehiringpage');
    }
     else if (option['label'] == 'Leaves') {
      context.push( '/leavespage');
    }
     else if (option['label'] == 'Company Assets') {
      context.push( '/assetspage');
    }
         else if (option['label'] == 'Project Inventory') {
      context.push( '/inventorypage');
    }
             else if (option['label'] == 'Requests') {
      context.push( '/requestspage');
    }
  },
          child: Container(
            decoration: BoxDecoration(
              color: Appcolors.kwhitecolor,
              borderRadius: BorderRadiusStyles.kradius15(),
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
                  padding: EdgeInsets.all(ResponsiveUtils.wp(4)),
                  decoration: BoxDecoration(
                    color: option['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    option['iconPath'],
                    height: ResponsiveUtils.hp(4),
                    width: ResponsiveUtils.wp(8),
                    color: option['color'],
                  ),
                ),
                ResponsiveSizedBox.height10,
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.wp(1),
                  ),
                  child: TextStyles.caption(
                    text: option['label'],
                    weight: FontWeight.w600,
                    color: Appcolors.kblackcolor,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

