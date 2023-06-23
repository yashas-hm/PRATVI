import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pra_tvi_web/core/app_constants.dart';
import 'package:pra_tvi_web/core/color_constants.dart';
import 'package:pra_tvi_web/core/description_data.dart';
import 'package:pra_tvi_web/screens/home_screen.dart';
import 'package:resize/resize.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with TickerProviderStateMixin {
  late final AnimationController rotationAnimController;
  late final AnimationController animController;
  final scrollController = ScrollController();
  bool more = true;
  double scroll = 0.sp;

  @override
  void initState() {
    rotationAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
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

    animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    animController.forward();
    rotationAnimController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    rotationAnimController.dispose();
    animController.dispose();
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
                ).animate(animController),
                child: RotationTransition(
                  turns: Tween(
                    begin: 1.0,
                    end: 0.0,
                  ).animate(rotationAnimController),
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
                ).animate(animController),
                child: RotationTransition(
                  turns: Tween(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(rotationAnimController),
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
              ).animate(animController),
              child: Container(
                margin: EdgeInsets.all(10.sp),
                height: screenSize.height,
                width: screenSize.width,
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20.sp,
                      ),
                      ScaleTransition(
                        scale: Tween(
                          begin: 0.0,
                          end: 1.0,
                        ).animate(animController),
                        child: Container(
                          height: 150.sp,
                          width: 150.sp,
                          padding: EdgeInsets.all(10.sp),
                          child: SvgPicture.asset(
                            AppConstants.appLogo,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.sp,
                      ),
                      Container(
                        width: screenSize.width,
                        alignment: Alignment.center,
                        child: Text(
                          'Welcome to Rutvi & Pranay\'s Wedding',
                          style: TextStyle(
                            fontSize: 45.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'script',
                          ),
                          textAlign: TextAlign.center,
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
                        padding: EdgeInsets.only(
                          top: 10.sp,
                          left: 10.sp,
                          right: 10.sp,
                          bottom: 50.sp,
                        ),
                        child: Text(
                          Descriptions.eventDescription.last,
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
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: more
                    ? () => scrollController.animateTo(
                          scroll += 180.sp,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        )
                    : () => Get.offAll(() => HomeScreen()),
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
                      if (more)
                        Icon(
                          Icons.arrow_downward_rounded,
                          size: 20.sp,
                          color: AppColors().darkGreen,
                        ),
                      Expanded(
                        child: Text(
                          more ? 'More' : 'Next',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
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
