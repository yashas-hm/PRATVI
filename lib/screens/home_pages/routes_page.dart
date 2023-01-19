import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pratvi/controller/box_controller.dart';
import 'package:pratvi/core/color_constants.dart';
import 'package:pratvi/core/description_data.dart';
import 'package:pratvi/screens/event_screen.dart';
import 'package:pratvi/widgets/custom_appbar.dart';
import 'package:resize/resize.dart';

class RoutePage extends StatelessWidget {
  RoutePage({Key? key}) : super(key: key);

  final controller = Get.find<BoxController>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar.customAppBar(
        'Wedding Itinerary',
        backEnabled: false,
      ),
      body: Container(
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
