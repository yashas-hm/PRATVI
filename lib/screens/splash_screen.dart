import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pratvi/controller/box_controller.dart';
import 'package:pratvi/controller/controller.dart';
import 'package:pratvi/core/app_constants.dart';
import 'package:pratvi/core/color_constants.dart';
import 'package:pratvi/core/shared_preferences.dart';
import 'package:pratvi/helpers/app_helpers.dart';
import 'package:pratvi/screens/coord_home_screen.dart';
import 'package:pratvi/screens/home_screen.dart';
import 'package:pratvi/screens/login_screen.dart';
import 'package:resize/resize.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animation;
  late Animation<double> _fadeInFadeOut;
  late Animation<double> _zoomIn;
  bool loading = false;

  @override
  void initState() {
    animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1).animate(animation);
    _zoomIn = Tween<double>(begin: 1 / 5, end: 1).animate(animation);

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: AppColors().pink));
    animation.addListener(() async {
      if (animation.isCompleted) {
        setState(() {
          loading = true;
        });
        Future.delayed(const Duration(milliseconds: 500), () async {
          await AppHelpers.initialise();

          final controller = Get.find<Controller>();
          await controller.initialise();
          final boxController = Get.find<BoxController>();
          await boxController.updateCache();
          await boxController.getBusData();
          await boxController.taxiList();

          SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(statusBarColor: AppColors().lightGreen));
          if (!controller.loggedIn) {
            Get.off(
                  () => const LoginScreen(),
            );
          } else {
            if (AppSharedPreferences.getLoginNumber == '120223' || AppSharedPreferences.getLoginNumber == '080501') {
              controller.index = 0;
              Get.off(
                    () => CoordHomeScreen(),
              );
            }else{
              Get.off(
                    () => HomeScreen(),
              );
            }
          }
        });
      }
    });
    animation.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _splash(context);
  }

  Widget _splash(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: screenSize.height,
        width: screenSize.width,
        padding: EdgeInsets.all(20.sp),
        color: AppColors().pink,
        child: Stack(
          children: [
            Center(
              child: FadeTransition(
                opacity: _fadeInFadeOut,
                child: ScaleTransition(
                  scale: _zoomIn,
                  child: Container(
                    height: 150.sp,
                    width: 150.sp,
                    padding: EdgeInsets.all(10.sp),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F5E8),
                      borderRadius: BorderRadius.all(
                        Radius.circular(13.sp),
                      ),
                    ),
                    child: SvgPicture.asset(
                      AppConstants.appLogo,
                    ),
                  ),
                ),
              ),
            ),
            if (loading)
              const Align(
                alignment: Alignment.bottomCenter,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
          ],
        ),
      ),
    );
  }
}
