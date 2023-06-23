import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pra_tvi_web/controller/box_controller.dart';
import 'package:pra_tvi_web/core/app_constants.dart';
import 'package:pra_tvi_web/core/color_constants.dart';
import 'package:pra_tvi_web/core/description_data.dart';
import 'package:pra_tvi_web/screens/home_pages/today_page.dart';
import 'package:resize/resize.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen>
    with TickerProviderStateMixin {
  late final AnimationController rotationAnim;
  late final AnimationController fadeAnim;
  final controller = Get.find<BoxController>();
  final scrollController = ScrollController();
  bool more = true;
  double scroll = 0.sp;

  @override
  void initState() {
    rotationAnim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    fadeAnim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => {
          if (scrollController.initialScrollOffset >=
              scrollController.position.maxScrollExtent)
            {
              setState(() {
                more = false;
              })
            }
        });

    scrollController.addListener(() {
      scroll = scrollController.offset;

      if (scrollController.offset >=
          scrollController.position.maxScrollExtent) {
        setState(() {
          more = false;
        });
      } else {
        setState(() {
          more = true;
        });
      }
    });

    fadeAnim.forward();
    rotationAnim.repeat();
    super.initState();
  }

  @override
  void dispose() {
    rotationAnim.dispose();
    fadeAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final route = controller.routesBox.values.toList();

    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              transform: Matrix4.translationValues(
                -screenSize.height / 8,
                -screenSize.height / 8,
                0,
              ),
              alignment: Alignment.topLeft,
              child: FadeTransition(
                opacity: Tween(
                  begin: 0.0,
                  end: 1.0,
                ).animate(fadeAnim),
                child: RotationTransition(
                  turns: Tween(
                    begin: 1.0,
                    end: 0.0,
                  ).animate(rotationAnim),
                  child: SvgPicture.asset(
                    AppConstants.mandala2,
                    height: screenSize.height / 3,
                    width: screenSize.height / 3,
                  ),
                ),
              ),
            ),
            Container(
              transform: Matrix4.translationValues(
                screenSize.width / 2,
                0,
                0,
              ),
              alignment: Alignment.bottomRight,
              child: FadeTransition(
                opacity: Tween(
                  begin: 0.0,
                  end: 1.0,
                ).animate(fadeAnim),
                child: RotationTransition(
                  turns: Tween(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(rotationAnim),
                  child: SvgPicture.asset(
                    AppConstants.mandala1,
                    height: screenSize.height / 2,
                    width: screenSize.height / 2,
                  ),
                ),
              ),
            ),
            FadeTransition(
              opacity: Tween(
                begin: 0.0,
                end: 1.0,
              ).animate(fadeAnim),
              child: Container(
                margin: EdgeInsets.all(10.sp),
                height: screenSize.height,
                width: screenSize.width,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30.sp,
                      ),
                      Container(
                        width: screenSize.width,
                        alignment: Alignment.center,
                        child: Text(
                          Descriptions.event[widget.index],
                          style: TextStyle(
                            fontSize: 45.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'script',
                          ),
                        ),
                      ),
                      Container(
                        width: screenSize.width,
                        alignment: Alignment.center,
                        child: Text(
                          route[Descriptions.routeIndex[widget.index].first]
                              .date,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'script',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      Container(
                        width: screenSize.width,
                        alignment: Alignment.center,
                        child: Text(
                          route[Descriptions.routeIndex[widget.index].first]
                              .time,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'script',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      Container(
                        width: screenSize.width,
                        alignment: Alignment.center,
                        child: Text(
                          Descriptions.venue[widget.index],
                          style: TextStyle(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'script',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.sp,
                      ),
                      Container(
                        width: screenSize.width,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(15.sp),
                        ),
                        padding: EdgeInsets.all(10.sp),
                        child: Text(
                          Descriptions.eventDescription[widget.index],
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20.sp,
                            fontFamily: 'script',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (Descriptions.routeIndex[widget.index].first <= 6)
                        SizedBox(
                          height: 20.sp,
                        ),
                      if (Descriptions.routeIndex[widget.index].first <= 6)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, index) => RouteItem(
                            index: Descriptions.routeIndex[widget.index][index],
                            tripIndex: index,
                          ),
                          itemCount:
                              Descriptions.routeIndex[widget.index].length,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: () => Get.back(result: false),
                child: Container(
                  height: 60.sp,
                  width: 60.sp,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 40.sp,
                    color: AppColors().darkGreen,
                  ),
                ),
              ),
            ),
            if (more)
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () => scrollController.animateTo(
                    scroll += 180.sp,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.sp),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 8.sp, horizontal: 15.sp),
                    margin: EdgeInsets.all(10.sp),
                    alignment: Alignment.center,
                    height: 40.sp,
                    width: 110.sp,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_downward_rounded,
                          size: 20.sp,
                          color: AppColors().darkGreen,
                        ),
                        Text(
                          'More',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class RouteItem extends StatelessWidget {
  RouteItem({
    super.key,
    required this.index,
    required this.tripIndex,
  });

  final int tripIndex;
  final int index;
  final controller = Get.find<BoxController>();

  @override
  Widget build(BuildContext context) {
    final route = controller.routesBox.values.toList()[index];
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: screenSize.width,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15.sp),
      ),
      padding: EdgeInsets.all(10.sp),
      margin: EdgeInsets.only(bottom: 10.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Route ${tripIndex + 1}',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 10.sp,
          ),
          Text(
            route.trip,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 10.sp,
          ),
          Text(
            'Date: ${route.date}',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 10.sp,
          ),
          Text(
            'Time: ${route.time} onwards',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 10.sp,
          ),
          Text(
            route.details,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 10.sp,
          ),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () => Get.to(() => const TodayPage()),
              child: Container(
                height: 40.sp,
                width: 150.sp,
                decoration: BoxDecoration(
                  color: AppColors().darkGreen,
                  borderRadius: BorderRadius.circular(5.sp),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Check In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
