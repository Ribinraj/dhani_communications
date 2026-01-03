
// // import 'package:dhani_communications/presentation/blocs/bottom_navigation_bloc/bottom_navigation_bloc.dart';
// // import 'package:dhani_communications/presentation/screens/screen_approvelpage/screen_approvelpage.dart';
// // import 'package:dhani_communications/presentation/screens/screen_dashboard.dart/screen_dashboard.dart';
// // import 'package:dhani_communications/presentation/screens/screen_profilepage/screen_profilepage.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';


// // class ScreenMainPage extends StatefulWidget {
// //   const ScreenMainPage({super.key});

// //   @override
// //   State<ScreenMainPage> createState() => _ScreenMainPageState();
// // }

// // class _ScreenMainPageState extends State<ScreenMainPage> {
// //   final List<Widget> _pages = [
// // ScreenDashboardpage(),
// // ScreenApprovelpage(),
// // ScreenProfilepage()
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
// //       builder: (context, state) {
// //         return 
// //          Scaffold(
            
// //             body: _pages[state.currentPageIndex],
// //             bottomNavigationBar: BottomNavigationWidget(
// //               onTap: (index) {
// //                 context.read<BottomNavigationBloc>().add(
// //                   NavigateToPageEvent(pageIndex: index),
// //                 );
// //               },
// //             ),
// //           );
        
// //       },
// //     );
// //   }
// // }
// import 'package:dhani_communications/presentation/blocs/bottom_navigation_bloc/bottom_navigation_bloc.dart';
// import 'package:dhani_communications/presentation/screens/screen_approvelpage/screen_approvelpage.dart';

// import 'package:dhani_communications/presentation/screens/screen_bottombar/widgets/custom_nav.dart';
// import 'package:dhani_communications/presentation/screens/screen_dashboard.dart/screen_dashboard.dart';
// import 'package:dhani_communications/presentation/screens/screen_profilepage/screen_profilepage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ScreenMainPage extends StatefulWidget {
//   const ScreenMainPage({super.key});

//   @override
//   State<ScreenMainPage> createState() => _ScreenMainPageState();
// }

// class _ScreenMainPageState extends State<ScreenMainPage> {
//   final List<Widget> _pages = [
//     ScreenDashboardpage(),
//     ScreenApprovelpage(),
//     ScreenProfilepage()
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
//       builder: (context, state) {
//         return Scaffold(
//           body: _pages[state.currentPageIndex],
//           bottomNavigationBar: AnimatedBottomNavigationWidget(
//             onTap: (index) {
//               context.read<BottomNavigationBloc>().add(
//                     NavigateToPageEvent(pageIndex: index),
//                   );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
///////////////////////////
import 'package:dhani_communications/presentation/blocs/bottom_navigation_bloc/bottom_navigation_bloc.dart';
import 'package:dhani_communications/presentation/screens/screen_approvelpage/screen_approvelpage.dart';
import 'package:dhani_communications/presentation/screens/screen_bottombar/widgets/custom_nav.dart';
import 'package:dhani_communications/presentation/screens/screen_dashboard.dart/screen_dashboard.dart';
import 'package:dhani_communications/presentation/screens/screen_profilepage/screen_profilepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenMainPage extends StatefulWidget {
  const ScreenMainPage({super.key});

  @override
  State<ScreenMainPage> createState() => _ScreenMainPageState();
}

class _ScreenMainPageState extends State<ScreenMainPage> {
  final List<Widget> _pages = [
    ScreenDashboardpage(),
  ScreenApprovalsPage(),
    ScreenProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true, // This is crucial - extends body behind bottom bar
          body: _pages[state.currentPageIndex],
          bottomNavigationBar: AnimatedBottomNavigationWidget(
            onTap: (index) {
              context.read<BottomNavigationBloc>().add(
                    NavigateToPageEvent(pageIndex: index),
                  );
            },
          ),
        );
      },
    );
  }
}