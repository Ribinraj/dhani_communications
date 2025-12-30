
// import 'dart:ui';

// import 'package:dhani_communications/core/colors.dart';
// import 'package:dhani_communications/core/responsiveutils.dart';
// import 'package:dhani_communications/presentation/blocs/bottom_navigation_bloc/bottom_navigation_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:iconify_flutter/iconify_flutter.dart';
// import 'package:iconify_flutter/icons/material_symbols.dart';
// import 'package:iconify_flutter/icons/mdi.dart';

// class BottomNavigationWidget extends StatelessWidget {
//   final void Function(int)? onTap;
//   const BottomNavigationWidget({super.key, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
//       builder: (context, state) {
//         return Container(
//           decoration: BoxDecoration(
//             color: Appcolors.kwhitecolor,
//             boxShadow: [
//               BoxShadow(
//                 color: Appcolors.kprimarycolor.withOpacity(0.15),
//                 blurRadius: 12,
//                 offset: const Offset(0, -3),
//               ),
//             ],
//             border: Border(
//               top: BorderSide(
//                 color: Appcolors.kbordercolor.withOpacity(0.3),
//                 width: 2,
//               ),
//             ),
//           ),
//           child: BottomNavigationBar(
//             currentIndex: state.currentPageIndex,
//             onTap: onTap,
//             type: BottomNavigationBarType.fixed,
//             backgroundColor: Appcolors.kwhitecolor,
//             selectedItemColor: Appcolors.kprimarycolor,
//             unselectedItemColor: Appcolors.kgreyColor.withOpacity(0.6),
//             selectedLabelStyle: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 0.3,
//             ),
//             unselectedLabelStyle: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//             ),
//             elevation: 0,
//             items: [
//               // Dashboard
//               BottomNavigationBarItem(
//                 icon: Iconify(
//                   MaterialSymbols.dashboard_outline,
//                   size: ResponsiveUtils.wp(7),
//                   color: Appcolors.kgreyColor.withOpacity(0.6),
//                 ),
//                 activeIcon: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Appcolors.kprimarycolor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Iconify(
//                     MaterialSymbols.dashboard,
//                     size: ResponsiveUtils.wp(7),
//                     color: Appcolors.kprimarycolor,
//                   ),
//                 ),
//                 label: "Dashboard",
//               ),
              
//               // Approvals
//               BottomNavigationBarItem(
//                 icon: Iconify(
//                   Mdi.checkbox_marked_circle_outline,
//                   size: ResponsiveUtils.wp(7),
//                   color: Appcolors.kgreyColor.withOpacity(0.6),
//                 ),
//                 activeIcon: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Appcolors.kprimarycolor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Iconify(
//                     Mdi.checkbox_marked_circle,
//                     size: ResponsiveUtils.wp(7),
//                     color: Appcolors.kprimarycolor,
//                   ),
//                 ),
//                 label: "Approvals",
//               ),
              
//               // Profile
//               BottomNavigationBarItem(
//                 icon: Iconify(
//                   MaterialSymbols.person_outline,
//                   size: ResponsiveUtils.wp(7),
//                   color: Appcolors.kgreyColor.withOpacity(0.6),
//                 ),
//                 activeIcon: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Appcolors.kprimarycolor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Iconify(
//                     MaterialSymbols.person,
//                     size: ResponsiveUtils.wp(7),
//                     color: Appcolors.kprimarycolor,
//                   ),
//                 ),
//                 label: "Profile",
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
import 'dart:ui';
import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:dhani_communications/presentation/blocs/bottom_navigation_bloc/bottom_navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';

class AnimatedBottomNavigationWidget extends StatefulWidget {
  final void Function(int)? onTap;
  const AnimatedBottomNavigationWidget({super.key, required this.onTap});

  @override
  State<AnimatedBottomNavigationWidget> createState() =>
      _AnimatedBottomNavigationWidgetState();
}

class _AnimatedBottomNavigationWidgetState
    extends State<AnimatedBottomNavigationWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _iconControllers;
  late List<Animation<double>> _iconAnimations;
  late List<Animation<double>> _scaleAnimations;

  final List<NavItem> _navItems = [
    NavItem(
      icon: MaterialSymbols.dashboard_outline,
      activeIcon: MaterialSymbols.dashboard,
      label: "Dashboard",
    ),
    NavItem(
      icon: Mdi.checkbox_marked_circle_outline,
      activeIcon: Mdi.checkbox_marked_circle,
      label: "Approvals",
    ),
    NavItem(
      icon: MaterialSymbols.person_outline,
      activeIcon: MaterialSymbols.person,
      label: "Profile",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _iconControllers = List.generate(
      _navItems.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      ),
    );

    _iconAnimations = _iconControllers.map((controller) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    _scaleAnimations = _iconControllers.map((controller) {
      return Tween<double>(begin: 1, end: 1.2).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _iconControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _animateIcon(int index) {
    _iconControllers[index].forward().then((_) {
      _iconControllers[index].reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
      builder: (context, state) {
        final selectedIndex = state.currentPageIndex;
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(7),
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
            decoration: BoxDecoration(
              color: Appcolors.kwhitecolor.withOpacity(0.95),
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Appcolors.kprimarycolor.withOpacity(0.2),
                  offset: const Offset(0, 8),
                  blurRadius: 24,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -2),
                  blurRadius: 8,
                ),
              ],
              border: Border.all(
                color: Appcolors.kbordercolor.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    _navItems.length,
                    (index) {
                      final navItem = _navItems[index];
                      final isSelected = selectedIndex == index;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _animateIcon(index);
                            widget.onTap?.call(index);
                          },
                          child: AnimatedBuilder(
                            animation: _scaleAnimations[index],
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _scaleAnimations[index].value,
                                child: child,
                              );
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Animated indicator bar
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  margin: const EdgeInsets.only(bottom: 8),
                                  height: 3,
                                  width: isSelected
                                      ? ResponsiveUtils.wp(12)
                                      : 0,
                                  decoration: BoxDecoration(
                                    color: Appcolors.kprimarycolor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                // Animated icon container
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  padding: EdgeInsets.all(
                                    isSelected ? 6: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Appcolors.kprimarycolor
                                            .withOpacity(0.1)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: AnimatedBuilder(
                                    animation: _iconAnimations[index],
                                    builder: (context, child) {
                                      return Transform.rotate(
                                        angle:
                                            _iconAnimations[index].value * 0.5,
                                        child: Iconify(
                                          isSelected
                                              ? navItem.activeIcon
                                              : navItem.icon,
                                          size: ResponsiveUtils.wp(7),
                                          color: isSelected
                                              ? Appcolors.kprimarycolor
                                              : Appcolors.kgreyColor
                                                  .withOpacity(0.6),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Animated label
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  style: TextStyle(
                                    fontSize: isSelected ? 11: 7,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? Appcolors.kprimarycolor
                                        : Appcolors.kgreyColor.withOpacity(0.6),
                                    letterSpacing: 0.3,
                                  ),
                                  child: Text(
                                    navItem.label,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class NavItem {
  final String icon;
  final String activeIcon;
  final String label;

  NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}