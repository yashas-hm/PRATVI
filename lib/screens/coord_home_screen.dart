import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pra_tvi_web/controller/controller.dart';
import 'package:pra_tvi_web/core/app_constants.dart';
import 'package:pra_tvi_web/core/color_constants.dart';
import 'package:pra_tvi_web/core/shared_preferences.dart';
import 'package:pra_tvi_web/screens/coord_home_pages/bus_stats_page.dart';
import 'package:pra_tvi_web/screens/coord_home_pages/coord_home_page.dart';
import 'package:pra_tvi_web/screens/coord_home_pages/coord_list_page.dart';
import 'package:pra_tvi_web/screens/coord_home_pages/taxi_page.dart';
import 'package:pra_tvi_web/widgets/bottom_nav_bar/fluid_nav_bar.dart';
import 'package:pra_tvi_web/widgets/bottom_nav_bar/fluid_nav_bar_icon.dart';
import 'package:pra_tvi_web/widgets/bottom_nav_bar/fluid_nav_bar_style.dart';

class CoordHomeScreen extends StatelessWidget {
  CoordHomeScreen({Key? key}) : super(key: key);

  final controller = Get.find<Controller>();

  Widget pages(int index) {
    switch (index) {
      case 2:
        return const CoordHomePage();
      case 1:
        return const CoordListPage();
      case 0:
        return const BusStatusPage();
      case 3:
        return const TaxiPage();
      default:
        return const CoordHomePage();
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
                    icon: Icons.directions_bus_filled_outlined,
                  ),
                  FluidNavBarIcon(
                    svgPath: AppConstants.familyInfoIcon,
                  ),
                  FluidNavBarIcon(
                    svgPath: AppConstants.todayIcon,
                  ),
                  if(AppSharedPreferences.getLoginNumber == '080501')
                    FluidNavBarIcon(
                      icon: Icons.local_taxi_outlined,
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
