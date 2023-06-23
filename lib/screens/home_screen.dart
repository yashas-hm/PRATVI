import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pra_tvi_web/controller/controller.dart';
import 'package:pra_tvi_web/core/app_constants.dart';
import 'package:pra_tvi_web/core/color_constants.dart';
import 'package:pra_tvi_web/screens/home_pages/family_page.dart';
import 'package:pra_tvi_web/screens/home_pages/routes_page.dart';
import 'package:pra_tvi_web/screens/home_pages/today_page.dart';
import 'package:pra_tvi_web/widgets/bottom_nav_bar/fluid_nav_bar.dart';
import 'package:pra_tvi_web/widgets/bottom_nav_bar/fluid_nav_bar_icon.dart';
import 'package:pra_tvi_web/widgets/bottom_nav_bar/fluid_nav_bar_style.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final controller = Get.find<Controller>();

  Widget pages(int index) {
    switch (index) {
      case 2:
        return const TodayPage();
      case 1:
        return const RoutePage();
      case 0:
        return const FamilyPage();
      default:
        return const RoutePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: null,
      body: SizedBox(
        height: screenSize.height,
        width: screenSize.width,
        child: Stack(
          children: [
            GetBuilder(
              init: controller,
              id: AppConstants.navBarIndexTag,
              builder: (ctr) => pages(controller.index),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FluidNavBar(
                defaultIndex: controller.index,
                animationFactor: 0.5,
                style: FluidNavBarStyle(
                  iconBackgroundColor: AppColors().lightGreen,
                  barBackgroundColor: AppColors().lightGreen,
                  iconSelectedForegroundColor: AppColors().pink,
                  iconUnselectedForegroundColor: AppColors().pink,
                ),
                icons: [
                  FluidNavBarIcon(
                    svgPath: AppConstants.familyInfoIcon,
                  ),
                  FluidNavBarIcon(
                    svgPath: AppConstants.routeIcon,
                  ),
                  FluidNavBarIcon(
                    svgPath: AppConstants.todayIcon,
                  ),
                ],
                onChange: (index) => controller.moveToIndex(index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
