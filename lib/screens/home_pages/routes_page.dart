import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pra_tvi_web/controller/box_controller.dart';
import 'package:pra_tvi_web/core/app_constants.dart';
import 'package:pra_tvi_web/core/color_constants.dart';
import 'package:pra_tvi_web/core/description_data.dart';
import 'package:pra_tvi_web/screens/event_screen.dart';
import 'package:pra_tvi_web/widgets/custom_appbar.dart';
import 'package:resize/resize.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({Key? key}) : super(key: key);

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage>
    with SingleTickerProviderStateMixin {
  final controller = Get.find<BoxController>();
  late final AnimationController animController;

  @override
  void initState() {
    animController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    animController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar.customAppBar(
        'Wedding Itinerary',
        backEnabled: false,
      ),
      body: Stack(
        children: [
          Container(
            height: screenSize.height,
            width: screenSize.width,
            alignment: Alignment.center,
            child: Opacity(
              opacity: 0.3,
              child: ScaleTransition(
                scale: Tween(
                  begin: 0.5,
                  end: 1.3,
                ).animate(animController),
                child: SvgPicture.asset(
                  AppConstants.appLogo,
                  width: screenSize.width / 1.3,
                ),
              ),
            ),
          ),
          Container(
            height: screenSize.height,
            padding: EdgeInsets.only(
              top: 13.sp,
              right: 13.sp,
              left: 13.sp,
              bottom: 60.sp,
            ),
            width: screenSize.width,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (ctx, index) => EventItem(
                index: index,
              ),
              itemCount: Descriptions.event.length,
            ),
          ),
        ],
      ),
    );
  }
}

class EventItem extends StatelessWidget {
  const EventItem({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => Get.to(() => EventScreen(
            index: index,
          )),
      child: Container(
        width: screenSize.width,
        padding: EdgeInsets.all(10.sp),
        margin: EdgeInsets.only(bottom: 10.sp),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18.sp),
          border: Border.all(
            width: 2.sp,
            color: AppColors().darkGreen,
          ),
        ),
        child: Text(
          Descriptions.event[index],
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
