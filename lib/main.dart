import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/network_services.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:dhani_communications/domain/repositories/authrepo.dart';
import 'package:dhani_communications/presentation/blocs/bottom_navigation_bloc/bottom_navigation_bloc.dart';
import 'package:dhani_communications/presentation/blocs/send_otp_bloc/send_otp_bloc.dart';
import 'package:dhani_communications/presentation/blocs/verify_otp_bloc/verify_otp_bloc.dart';
import 'package:dhani_communications/widgets/app_router.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils().init(context);
        final dio = DioClient.create(context);
    final authrepo = Authrepo(dio);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BottomNavigationBloc()),
        BlocProvider(create: (context) => SendOtpBloc(repository: authrepo)),
          BlocProvider(create: (context) =>VerifyOtpBloc(repository: authrepo)),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
          ),
          fontFamily: 'Helvetica',
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          scaffoldBackgroundColor: Appcolors.kwhitecolor,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
