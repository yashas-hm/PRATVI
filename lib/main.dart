import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pra_tvi_web/core/color_constants.dart';
import 'package:pra_tvi_web/screens/splash_screen.dart';
import 'package:pra_tvi_web/widgets/dismiss_keyboard.dart';
import 'package:resize/resize.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = WidgetsBinding.instance.window.physicalSize;

    final resize = screenSize.width > screenSize.height
        ? Size(
            screenSize.width,
            screenSize.height,
          )
        : const Size(390, 844);

    return Resize(
      builder: () => DismissKeyboard(
        child: GetMaterialApp(
          defaultTransition: Transition.rightToLeftWithFade,
          transitionDuration: const Duration(milliseconds: 500),
          debugShowCheckedModeBanner: false,
          title: 'PRATVI',
          theme: ThemeData(
            primaryColor: AppColors().darkGreen,
            scaffoldBackgroundColor: AppColors().pink,
            textTheme: Theme.of(context).textTheme.apply(
                  fontFamily: 'montserrat',
                  bodyColor: AppColors().darkGreen,
                  displayColor: AppColors().darkGreen,
                ),
            appBarTheme: AppBarTheme(
              centerTitle: true,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarBrightness: Brightness.light,
                statusBarColor: AppColors().lightGreen,
                statusBarIconBrightness: Brightness.dark,
              ),
              elevation: 0,
              iconTheme: IconThemeData(
                color: AppColors().pink,
              ),
              backgroundColor: AppColors().lightGreen,
            ),
          ).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors().lightGreen,
              primary: AppColors().lightGreen,
            ),
            textSelectionTheme: const TextSelectionThemeData(
              selectionHandleColor: Colors.transparent,
            ),
          ),
          home: const SplashScreen(),
        ),
      ),
      allowtextScaling: false,
      size: resize,
    );
  }
}
