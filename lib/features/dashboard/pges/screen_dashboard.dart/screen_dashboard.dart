import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dhani_communications/core/constants.dart';
import 'package:dhani_communications/core/local_storages.dart';
import 'package:dhani_communications/features/auth/blocs/profile_bloc/profile_bloc.dart';
import 'package:dhani_communications/features/dashboard/models/update_model.dart';
import 'package:dhani_communications/features/dashboard/blocs/updates_bloc/updates_bloc.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_dashboard.dart/widgets/paint.dart';
import 'package:flutter/material.dart';
import 'package:dhani_communications/core/appconstants.dart';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:dhani_communications/core/localization/app_localization.dart';

class ScreenDashboardpage extends StatefulWidget {
  const ScreenDashboardpage({super.key});

  @override
  State<ScreenDashboardpage> createState() => _HomePageState();
}

class _HomePageState extends State<ScreenDashboardpage>
    with SingleTickerProviderStateMixin {
  int _currentCarouselIndex = 0;
  bool _isFabOpen = false;
  String _userName = 'User';
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  late Animation<double> _fabRotationAnimation;
  late Animation<double> _fabScaleAnimation;

  @override
  void initState() {
    super.initState();
    context.read<UpdatesBloc>().add(FetchUpdatesEvent());
    context.read<ProfileBloc>().add(FetchProfileEvent());
    _loadUserName();

    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeOutCubic,
    );
    _fabRotationAnimation = Tween<double>(begin: 0.0, end: 0.625).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
    _fabScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeOut),
    );
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

  Future<void> _loadUserName() async {
    final name = await LocalStorage.getUserName();
    if (name.isNotEmpty && mounted) {
      setState(() {
        _userName = name;
      });
    }
  }

  final List<Map<String, dynamic>> gridOptions = [
    {
      'iconPath': Appconstants.attenedence,
      'labelKey': 'attendance',
      'color': Color(0xFF6C63FF),
      'route': '/employeeattendencepage',
    },
    {
      'iconPath': Appconstants.contractlabours,
      'labelKey': 'contract_labors',
      'color': Color(0xFF00D9FF),
      'route': '/labourattendencepage',
    },
    {
      'iconPath': Appconstants.expenses,
      'labelKey': 'expenses',
      'color': Color(0xFFFF6584),
      'route': '/expensespage',
    },
    {
      'iconPath': Appconstants.machinery,
      'labelKey': 'machinery_hire',
      'color': Color(0xFF4CAF50),
      'route': '/machinehiringpage',
    },
    {
      'iconPath': Appconstants.cashbalance,
      'labelKey': 'cash_balance',
      'color': Color(0xFFFF9800),
      'route': '/cashbalancepage',
    },
    {
      'iconPath': Appconstants.leaves,
      'labelKey': 'leaves',
      'color': Color(0xFF9C27B0),
      'route': '/leavespage',
    },
    {
      'iconPath': Appconstants.projectdpr,
      'labelKey': 'project_dpr',
      'color': Color(0xFF00BCD4),
      'route': '/projectdprpage',
    },
    {
      'iconPath': Appconstants.vehicles,
      'labelKey': 'vehicles',
      'color': Color(0xFF795548),
      'route': '/vehiclespage',
    },
    {
      'iconPath': Appconstants.assets,
      'labelKey': 'company_assets',
      'color': Color(0xFFE91E63),
      'route': '/assetspage',
    },
    {
      'iconPath': Appconstants.inventory,
      'labelKey': 'project_inventory',
      'color': Color(0xFF3F51B5),
      'route': '/inventorypage',
    },
    {
      'iconPath': Appconstants.requests,
      'labelKey': 'requests',
      'color': Color(0xFF607D8B),
      'route': '/requestspage',
    },
  ];

  final List<Map<String, dynamic>> fabOptions = [
    {
      'iconify': Mdi.account_clock,
      'labelKey': 'daily_attendance',
      'color': Color(0xFF6C63FF),
      'useIconify': true,
      'route': '/dailyattendencepage',
    },
    {
      'iconify': Mdi.account_group,
      'labelKey': 'labour_attendance',
      'color': Color(0xFF00D9FF),
      'useIconify': true,
      'route': '/labourAttendencemarkingpage',
    },
    {
      'icon': Icons.precision_manufacturing_rounded,
      'labelKey': 'new_machinery_hire',
      'color': Color(0xFFFF6584),
      'useIconify': false,
      'route': '/newmachinehirepage',
    },
    {
      'iconify': Mdi.cash_register,
      'labelKey': 'daily_expenditure',
      'color': Color(0xFF4CAF50),
      'useIconify': true,
      'route': '/newexpensepage',
    },
    {
      'iconify': Mdi.calendar_remove,
      'labelKey': 'leave_application',
      'color': Color(0xFFFF9800),
      'useIconify': true,
      'route': '/leaveapplicationpage',
    },
    {
      'iconify': Mdi.chart_line,
      'labelKey': 'daily_progress_dpr',
      'color': Color(0xFF9C27B0),
      'useIconify': true,
      'route': '/dprprogress',
    },
    {
      'iconify': Mdi.file_document_edit,
      'labelKey': 'request',
      'color': Color(0xFFE91E63),
      'useIconify': true,
      'route': '/newrequestpage',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccessState) {
          final name = state.profile.employeeName.trim();
          if (name.isNotEmpty && name != _userName) {
            setState(() {
              _userName = name;
            });
          }
        }
      },
      child: Scaffold(
        backgroundColor: Appcolors.kwhitecolor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Appcolors.kwhitecolor,
          elevation: 2,
          shadowColor: Appcolors.kgreyColor.withAlpha(25),
          title: Row(
            children: [
              Image.asset(Appconstants.applogo, height: ResponsiveUtils.hp(5)),
              ResponsiveSizedBox.width(3),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextStyles.subheadline(
                      text: 'Hello, $_userName',
                      weight: FontWeight.bold,
                      color: Appcolors.kblackcolor,
                      overflow: TextOverflow.ellipsis,
                    ),
                    TextStyles.caption(
                      text: context.tr('welcome_back'),
                      color: Appcolors.kgreyColor.withAlpha(178),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
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
        body: Stack(
          children: [
            // Custom Paint Background
            CustomPaint(
              painter: HomeBackgroundPainter(),
              size: Size(screenWidth, screenHeight),
            ),
            // Main Scrollable Content
            SingleChildScrollView(
              child: Column(
                children: [
                  ResponsiveSizedBox.height20,
                  _buildCarouselSlider(),
                  ResponsiveSizedBox.height(2.5),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.wp(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextStyles.subheadline(
                          text: context.tr('quick_access'),
                          weight: FontWeight.bold,
                          color: Appcolors.kblackcolor,
                        ),
                        ResponsiveSizedBox.height15,
                        _buildGridView(),
                      ],
                    ),
                  ),
                  ResponsiveSizedBox.height(15),
                ],
              ),
            ),
            // Backdrop with blur when FAB is open
            if (_isFabOpen)
              AnimatedOpacity(
                opacity: _isFabOpen ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: GestureDetector(
                  onTap: _toggleFab,
                  child: Container(
                    color: Colors.black.withAlpha(153),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
            // Multi-Action FAB Options
            ...List.generate(fabOptions.length, (index) {
              final option = fabOptions[index];
              final reversedIndex = fabOptions.length - 1 - index;
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                right: ResponsiveUtils.wp(4),
                bottom: _isFabOpen
                    ? ResponsiveUtils.hp(22.5) +
                          (reversedIndex * ResponsiveUtils.hp(9))
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
                      label: context.tr(option['labelKey']),
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
            context.push(route);
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
                color: color.withAlpha(76),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextStyles.medium(
                text: label,
                weight: FontWeight.w600,
                color: color,
              ),
              ResponsiveSizedBox.width(3),
              Container(
                padding: EdgeInsets.all(ResponsiveUtils.wp(2.5)),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withAlpha(102),
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

  Widget _buildCarouselSlider() {
    return BlocBuilder<UpdatesBloc, UpdatesState>(
      builder: (context, state) {
        if (state is UpdatesLoadingState) {
          return _buildCarouselShimmer();
        } else if (state is UpdatesErrorState) {
          return _buildCarouselError(state.message);
        } else if (state is UpdatesSuccessState) {
          if (state.updates.isEmpty) {
            return _buildEmptyCarousel();
          }
          return _buildCarouselContent(state.updates);
        }
        return _buildCarouselShimmer();
      },
    );
  }

  Widget _buildCarouselShimmer() {
    return Column(
      children: [
        Container(
          height: ResponsiveUtils.hp(20),
          margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.wp(4)),
          decoration: BoxDecoration(
            color: Appcolors.kgreyColor.withAlpha(51),
            borderRadius: BorderRadiusStyles.kradius15(),
          ),
          child: Center(
            child: CircularProgressIndicator(color: Appcolors.kprimarycolor),
          ),
        ),
        ResponsiveSizedBox.height10,
      ],
    );
  }

  Widget _buildCarouselError(String message) {
    return Column(
      children: [
        Container(
          height: ResponsiveUtils.hp(20),
          margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.wp(4)),
          decoration: BoxDecoration(
            color: Appcolors.kgreyColor.withAlpha(25),
            borderRadius: BorderRadiusStyles.kradius15(),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Appcolors.kgreyColor,
                  size: ResponsiveUtils.sp(8),
                ),
                ResponsiveSizedBox.height10,
                TextStyles.caption(
                  text: context.tr('failed_to_load_updates'),
                  color: Appcolors.kgreyColor,
                ),
                ResponsiveSizedBox.height10,
                TextButton(
                  onPressed: () {
                    context.read<UpdatesBloc>().add(FetchUpdatesEvent());
                  },
                  child: TextStyles.caption(
                    text: context.tr('retry'),
                    color: Appcolors.kprimarycolor,
                    weight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        ResponsiveSizedBox.height10,
      ],
    );
  }

  Widget _buildEmptyCarousel() {
    return Column(
      children: [
        Container(
          height: ResponsiveUtils.hp(20),
          margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.wp(4)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Appcolors.kprimarycolor,
                Appcolors.kprimarycolor.withAlpha(178),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadiusStyles.kradius15(),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextStyles.headline(
                  text: context.tr('welcome_to_dhani'),
                  weight: FontWeight.bold,
                  color: Appcolors.kwhitecolor,
                ),
                ResponsiveSizedBox.height10,
                TextStyles.medium(
                  text: context.tr('your_trusted_communication_partner'),
                  color: Appcolors.kwhitecolor.withAlpha(229),
                ),
              ],
            ),
          ),
        ),
        ResponsiveSizedBox.height10,
      ],
    );
  }

  Widget _buildCarouselContent(List<UpdateModel> updates) {
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
          items: updates.map((update) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.wp(1.25),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusStyles.kradius15(),
                    boxShadow: [
                      BoxShadow(
                        color: Appcolors.kgreyColor.withAlpha(76),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadiusStyles.kradius15(),
                    child: _buildCarouselImage(update.picture),
                  ),
                );
              },
            );
          }).toList(),
        ),
        ResponsiveSizedBox.height10,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: updates.asMap().entries.map((entry) {
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
                    : Appcolors.kgreyColor.withAlpha(76),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCarouselImage(String picture) {
    if (picture.startsWith('data:image') || _isBase64(picture)) {
      try {
        String base64String = picture;
        if (picture.contains(',')) {
          base64String = picture.split(',').last;
        }
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholderImage();
          },
        );
      } catch (e) {
        return _buildPlaceholderImage();
      }
    } else {
      return Image.network(
        picture,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              color: Appcolors.kprimarycolor,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage();
        },
      );
    }
  }

  bool _isBase64(String str) {
    try {
      base64Decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Appcolors.kprimarycolor.withAlpha(25),
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Appcolors.kgreyColor,
          size: ResponsiveUtils.sp(8),
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: EdgeInsets.zero,
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
            context.push(option['route']);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Appcolors.kwhitecolor,
              borderRadius: BorderRadiusStyles.kradius15(),
              boxShadow: [
                BoxShadow(
                  color: Appcolors.kgreyColor.withAlpha(25),
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
                    color: (option['color'] as Color).withAlpha(25),
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
                    text: context.tr(option['labelKey']),
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
