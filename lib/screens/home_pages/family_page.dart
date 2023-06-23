import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pra_tvi_web/controller/box_controller.dart';
import 'package:pra_tvi_web/controller/controller.dart';
import 'package:pra_tvi_web/core/app_constants.dart';
import 'package:pra_tvi_web/core/color_constants.dart';
import 'package:pra_tvi_web/widgets/custom_appbar.dart';
import 'package:resize/resize.dart';
import 'package:url_launcher/link.dart';

class FamilyPage extends StatefulWidget {
  const FamilyPage({Key? key}) : super(key: key);

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> with SingleTickerProviderStateMixin {
  final controller = Get.find<Controller>();

  final boxController = Get.find<BoxController>();

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
    final coordData =
        boxController.coordData();

    return Scaffold(
      appBar: CustomAppBar.customAppBar('Family Details', backEnabled: false),
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
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              width: screenSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.all(13.sp),
                    itemBuilder: (ctx, index) => FamilyItem(
                      name: controller.family.familyName[index],
                      number: controller.family.familyNumber[index],
                      roomNo: controller.family.roomNo[index],
                    ),
                    itemCount: controller.family.familyName.length,
                  ),
                  SizedBox(
                    height: 10.sp,
                  ),
                  Container(
                    width: screenSize.width,
                    alignment: Alignment.center,
                    child: Text(
                      'Coordinator Details',
                      maxLines: 2,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors().darkGreen,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.sp,
                  ),
                  ListView.builder(
                    itemCount: coordData.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.all(13.sp),
                    itemBuilder: (ctx, index) => Container(
                      margin: EdgeInsets.only(bottom: 8.sp),
                      width: screenSize.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              coordData[index]['name'].toString(),
                              maxLines: 2,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors().darkGreen,
                              ),
                            ),
                          ),
                          Link(
                            uri: Uri.parse(
                                'tel://+91${coordData[index]['number']}'),
                            builder: (ctx, link) => InkWell(
                              onTap: link,
                              child: Container(
                                width: 80.sp,
                                height: 30.sp,
                                margin: EdgeInsets.only(left: 5.sp),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.sp)),
                                  color: AppColors().darkGreen,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Call',
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Uri.parse(
// 'tel://+91${controller.family.coordinatorNo}')

class FamilyItem extends StatefulWidget {
  const FamilyItem({
    Key? key,
    required this.name,
    required this.number,
    required this.roomNo,
  }) : super(key: key);

  final String name;
  final String number;
  final String roomNo;

  @override
  State<FamilyItem> createState() => _FamilyItemState();
}

class _FamilyItemState extends State<FamilyItem> {
  bool more = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return InkWell(
      onTap: () => setState(() {
        more = !more;
      }),
      splashColor: AppColors().darkGreen,
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    child: Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Icon(
                  more
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 30.sp,
                  color: AppColors().darkGreen,
                ),
              ],
            ),
            if (more && widget.roomNo != '-1')
              SizedBox(
                height: 5.sp,
              ),
            if (more && widget.roomNo != '-1')
              SizedBox(
                width: screenSize.width,
                child: Text(
                  'Room Number: ${widget.roomNo}',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors().darkGreen,
                  ),
                ),
              ),
            if (more)
              SizedBox(
                height: 5.sp,
              ),
            if (more)
              SizedBox(
                width: screenSize.width,
                child: Text(
                  'Phone Number: +91-${widget.number}',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors().darkGreen,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
