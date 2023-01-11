import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pratvi/controller/controller.dart';
import 'package:pratvi/core/app_constants.dart';
import 'package:pratvi/core/color_constants.dart';
import 'package:pratvi/screens/cood_home_pages/coord_home_page.dart';
import 'package:pratvi/screens/cood_home_pages/coord_list_page.dart';
import 'package:pratvi/widgets/bottom_nav_bar/fluid_nav_bar.dart';
import 'package:pratvi/widgets/bottom_nav_bar/fluid_nav_bar_icon.dart';
import 'package:pratvi/widgets/bottom_nav_bar/fluid_nav_bar_style.dart';

class CoordHomeScreen extends StatelessWidget {
  CoordHomeScreen({Key? key}) : super(key: key);

  final controller = Get.find<Controller>();

  Widget pages(int index){
    switch(index){
      case 0: return const CoordHomePage();
      case 1: return const CoordListPage();
      default: return const CoordHomePage();
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
                defaultIndex: 0,
                animationFactor: 0.5,
                style: FluidNavBarStyle(
                  iconBackgroundColor: AppColors().lightBlue,
                  barBackgroundColor: AppColors().lightBlue,
                  iconSelectedForegroundColor: AppColors().pink,
                  iconUnselectedForegroundColor: AppColors().pink,
                ),
                icons: [
                  FluidNavBarIcon(
                    svgPath: AppConstants.todayIcon,
                  ),
                  FluidNavBarIcon(
                    svgPath: AppConstants.familyInfoIcon,
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
