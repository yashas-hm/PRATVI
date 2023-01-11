import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pratvi/controller/box_controller.dart';
import 'package:pratvi/core/app_constants.dart';
import 'package:pratvi/core/color_constants.dart';
import 'package:pratvi/core/description_data.dart';
import 'package:pratvi/screens/home_pages/today_page.dart';
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

  // final a = Get.find<Controller>();
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
              child: SizedBox(
                height: screenSize.height,
                width: screenSize.width,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(10.sp),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20.sp,
                        ),
                        Container(
                          width: screenSize.width,
                          alignment: Alignment.center,
                          child: Text(
                            Descriptions.event[widget.index],
                            style: TextStyle(
                              fontSize: 55.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.sp,
                        ),
                        Text(
                          '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque in ipsum et turpis venenatis volutpat. Etiam ac ligula quis orci consequat mattis. Suspendisse vestibulum leo augue, eget facilisis urna commodo sit amet. In mollis mauris ultrices, blandit mauris a, rhoncus dolor. Maecenas eleifend diam vehicula sollicitudin commodo. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Duis vitae ligula mi. Pellentesque condimentum odio id lorem dapibus, vitae sollicitudin nisl ultrices. Duis aliquet in leo eu dictum. Vivamus viverra ante ac eleifend venenatis. Integer in nulla nec urna malesuada sagittis malesuada nec erat. In hac habitasse platea dictumst. Duis efficitur elit libero, eget auctor tellus dictum nec.

                            Fusce rhoncus non tortor vitae ultricies. Duis vel suscipit nulla. Duis vestibulum erat pharetra eros pulvinar, nec scelerisque odio pretium. Vestibulum sem augue, elementum at blandit et, rhoncus vitae ex. Donec vel aliquam ex. Phasellus aliquam cursus ultrices. Vivamus efficitur mi turpis. Ut vehicula vitae ipsum a pharetra.

                            Mauris felis metus, dignissim sit amet elit at, interdum blandit neque. Aliquam placerat felis a turpis rhoncus, a condimentum diam sagittis. Nulla tempor nibh nec tortor gravida, quis efficitur lorem finibus. Suspendisse hendrerit ipsum ac ante congue, vitae consequat quam pharetra. In sed ultrices neque, ac sagittis nulla. Donec quis eleifend arcu, quis auctor lorem. Cras dictum dapibus lectus, vel viverra urna efficitur placerat. Donec tempus mollis eros nec lacinia. Sed porta magna nunc, vitae tristique mi faucibus at. Duis rhoncus, sapien lacinia maximus placerat, augue sapien varius risus, dapibus dapibus felis elit vel justo. Etiam quis vestibulum felis. Vestibulum sed pharetra diam.

                        Praesent varius lacinia neque quis laoreet. Fusce lacinia, justo sed faucibus sagittis, sem diam malesuada lacus, id maximus ligula odio non felis. Aenean venenatis sollicitudin nisl in vehicula. Aliquam vehicula felis in dapibus tempor. Sed dolor nisi, finibus id mollis ac, euismod vitae dolor. Cras eleifend lobortis diam, id molestie orci mattis nec. Vestibulum viverra nibh lacus, ornare venenatis ex molestie eget. Ut placerat viverra felis, a suscipit sapien sodales ut. Proin feugiat tortor nisl, a fringilla purus convallis sed. Phasellus felis neque, vestibulum finibus lectus ut, consectetur suscipit lacus. Cras dignissim nibh id nisi aliquam, sodales vehicula libero porttitor.''',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18.sp),
                        ),
                        SizedBox(
                          height: 20.sp,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, index) => RouteItem(
                              index: Descriptions.routeIndex[widget.index]
                                  [index]),
                          itemCount:
                              Descriptions.routeIndex[widget.index].length,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
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
  });

  final int index;
  final controller = Get.find<BoxController>();

  @override
  Widget build(BuildContext context) {
    final route = controller.routesBox.values.toList()[index];
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: screenSize.width,
      margin: EdgeInsets.only(bottom: 10.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trip ${index + 1}',
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
            'Leave At: ${route.time}',
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
                      color: AppColors().darkBlue,
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
                  ))),
        ],
      ),
    );
  }
}
