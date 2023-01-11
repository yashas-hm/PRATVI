import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pratvi/core/color_constants.dart';
import 'package:pratvi/helpers/app_helpers.dart';
import 'package:pratvi/screens/splash_screen.dart';
import 'package:resize/resize.dart';

void main() async{
  await AppHelpers.initialise();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Resize(
      builder: () => GetMaterialApp(
        defaultTransition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 500),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors().darkBlue,
          scaffoldBackgroundColor: AppColors().purple,
          textTheme: Theme.of(context).textTheme.apply(
                fontFamily: 'montserrat',
                bodyColor: AppColors().darkBlue,
                displayColor: AppColors().darkBlue,
              ),
          appBarTheme: AppBarTheme(
            centerTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
              statusBarColor: AppColors().lightBlue,
              statusBarIconBrightness: Brightness.dark,
            ),
            elevation: 0,
            iconTheme: IconThemeData(
              color: AppColors().pink,
            ),
            backgroundColor: AppColors().lightBlue,
          ),
        ).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors().lightBlue,
            primary: AppColors().lightBlue,
          ),
          textSelectionTheme: const TextSelectionThemeData(
            selectionHandleColor: Colors.transparent,
          ),
        ),
        home: const SplashScreen(),
      ),
      allowtextScaling: false,
      size: const Size(390, 844),
    );
  }
}
