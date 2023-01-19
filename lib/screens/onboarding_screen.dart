import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pratvi/core/app_constants.dart';
import 'package:pratvi/core/color_constants.dart';
import 'package:pratvi/core/description_data.dart';
import 'package:resize/resize.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with TickerProviderStateMixin {
  late final AnimationController rotationAnim;
  late final AnimationController fadeAnim;
  final scrollController = ScrollController();
  bool more = true;
  double scroll = 0.sp;

  @override
  void initState() {
    rotationAnim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

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
              child: Container(
                margin: EdgeInsets.all(10.sp),
                height: screenSize.height,
                width: screenSize.width,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                    width: 100.sp,
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
                              fontSize: 15.sp, fontWeight: FontWeight.w600),
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
