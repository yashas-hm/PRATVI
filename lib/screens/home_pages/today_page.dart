import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pra_tvi_web/controller/box_controller.dart';
import 'package:pra_tvi_web/controller/controller.dart';
import 'package:pra_tvi_web/core/app_constants.dart';
import 'package:pra_tvi_web/core/color_constants.dart';
import 'package:pra_tvi_web/helpers/firebase_helper.dart';
import 'package:pra_tvi_web/helpers/snackbar_helper.dart';
import 'package:pra_tvi_web/widgets/custom_appbar.dart';
import 'package:resize/resize.dart';
import 'package:url_launcher/link.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({Key? key}) : super(key: key);

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage>
    with SingleTickerProviderStateMixin {
  final boxes = Get.find<BoxController>();

  final controller = Get.find<Controller>();

  final Map<String, Map<String, String>> data = {};

  bool uploading = false;

  String busNo = '';

  late final AnimationController animController;

  late final List<String> busses;

  @override
  void initState() {
    animController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    animController.repeat(reverse: true);
    busses = boxes.getBusList();

    for (var i in boxes.taxis) {
      if(!busses.contains(i['taxiNo']!)){
        busses.add(i['taxiNo']!);
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  String getNumber() {
    final driverNos = boxes.getDriverNoList();
    final busses = boxes.getBusList();
    var str = '';
    for (var i = 0; i < busses.length; i++) {
      if (busses[i] == busNo) {
        str = driverNos[i];
      }
    }
    if (str == '') {
      return '1234567890';
    } else {
      return str;
    }
  }

  bool checkTaxi() {
    bool check = false;
    for (var i in boxes.taxis) {
      if (i['taxiNo'] == busNo) {
        check = true;
      }
    }
    return check;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final key = boxes.routesBox.keyAt(boxes.plan - 1);
    final route = boxes.routesBox.get(key)!;
    List<String> checkIns = boxes.getList(controller.family);

    return Scaffold(
      appBar: CustomAppBar.customAppBar(
        'Today\'s Plan',
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
          RefreshIndicator(
            onRefresh: () async {
              await boxes.updateCache();
              await boxes.taxiList();
              busses.clear();
              busses = boxes.dataBox.get('busNo')! as List<String>;
              for (var i in boxes.taxis) {
                if(!busses.contains(i['taxiNo']!)){
                  busses.add(i['taxiNo']!);
                }
              }
              setState(() {});
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                width: screenSize.width,
                padding: EdgeInsets.all(13.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: screenSize.width,
                      child: Text(
                        'Trip ${boxes.plan}',
                        style: TextStyle(
                          color: AppColors().darkGreen,
                          fontWeight: FontWeight.w700,
                          fontSize: 22.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.sp,
                    ),
                    SizedBox(
                      width: screenSize.width,
                      child: Text(
                        route.trip,
                        style: TextStyle(
                          color: AppColors().darkGreen,
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.sp,
                    ),
                    SizedBox(
                      width: screenSize.width,
                      child: Text(
                        route.details,
                        style: TextStyle(
                          color: AppColors().darkGreen,
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.sp,
                    ),
                    SizedBox(
                      width: screenSize.width,
                      child: Text(
                        'Select family members to checkIn:',
                        style: TextStyle(
                          color: AppColors().darkGreen,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) => FamilyRadioItem(
                        name: controller.family.familyName[index],
                        number: controller.family.familyNumber[index],
                        disable: checkIns
                            .contains(controller.family.familyName[index]),
                        onChange: (value) {
                          if (value) {
                            data[controller.family.familyName[index]] = {
                              'name': controller.family.familyName[index],
                              'number': controller.family.familyNumber[index],
                            };
                          } else {
                            data.remove(controller.family.familyName[index]);
                          }
                        },
                      ),
                      itemCount: controller.family.familyName.length,
                    ),
                    SizedBox(
                      height: 10.sp,
                    ),
                    SizedBox(
                      width: screenSize.width,
                      child: Text(
                        'Select bus/taxi number:',
                        style: TextStyle(
                          color: AppColors().darkGreen,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.sp,
                    ),
                    DropdownButtonFormField(
                      items: busses
                          .map<DropdownMenuItem<String>>(
                            (e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(
                                e,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          busNo = value.toString();
                        });
                      },
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.sp),
                          borderSide: BorderSide(
                            width: 1.sp,
                            color: AppColors().darkGreen,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.sp),
                          borderSide: BorderSide(
                            width: 1.sp,
                            color: AppColors().darkGreen,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.sp),
                          borderSide: BorderSide(
                            width: 1.sp,
                            color: AppColors().darkGreen,
                          ),
                        ),
                      ),
                    ),
                    if (busNo != '' && !checkTaxi())
                      SizedBox(
                        height: 10.sp,
                      ),
                    if (busNo != '' && !checkTaxi())
                      SizedBox(
                        width: screenSize.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                'Contact Driver',
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
                              uri: Uri.parse('tel://+91${getNumber()}'),
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
                    SizedBox(
                      height: 10.sp,
                    ),
                    ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: boxes.taxis.length,
                      itemBuilder: (ctx, index) => Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(15.sp),
                        ),
                        padding: EdgeInsets.all(10.sp),
                        margin: EdgeInsets.only(bottom: 10.sp),
                        width: screenSize.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: screenSize.width,
                              child: Text(
                                'Taxi for: ${boxes.taxis[index]['name']}',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.sp,
                            ),
                            SizedBox(
                              width: screenSize.width,
                              child: Text(
                                'Taxi number: ${boxes.taxis[index]['taxiNo']}',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Driver: ${boxes.taxis[index]['driverName']}',
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
                                        'tel://+91${boxes.taxis[index]['driverNo']}'),
                                    builder: (ctx, link) => InkWell(
                                      onTap: link,
                                      child: Container(
                                        width: 80.sp,
                                        height: 30.sp,
                                        margin: EdgeInsets.only(left: 5.sp),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.sp)),
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
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          onTap: () async {
                            if (busNo.isEmpty) {
                              SnackBarHelper.errorMsg(
                                  msg: 'Please select bus number');
                            } else {
                              if (data.isNotEmpty) {
                                setState(() {
                                  uploading = true;
                                });
                                await FirebaseHelper().checkIn(
                                  boxes.plan.toString(),
                                  busNo,
                                  data.values.toList(),
                                );

                                final list = <String>[];
                                list.addAll(checkIns);
                                for (var i in data.values.toList()) {
                                  list.add(i['name']!);
                                }
                                await boxes.busFamData();
                                data.clear();
                                setState(() {
                                  uploading = false;
                                });
                              }
                            }
                          },
                          child: Container(
                            height: 40.sp,
                            width: 150.sp,
                            decoration: BoxDecoration(
                              color: AppColors().darkGreen,
                              borderRadius: BorderRadius.circular(5.sp),
                            ),
                            alignment: Alignment.center,
                            child: uploading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
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
                    ),
                    SizedBox(
                      height: 60.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FamilyRadioItem extends StatefulWidget {
  const FamilyRadioItem({
    Key? key,
    required this.name,
    required this.number,
    required this.onChange,
    this.disable = false,
  }) : super(key: key);

  final String name;
  final String number;
  final Function(bool) onChange;
  final bool disable;

  @override
  State<FamilyRadioItem> createState() => _FamilyRadioItemState();
}

class _FamilyRadioItemState extends State<FamilyRadioItem> {
  bool check = false;

  @override
  void initState() {
    check = widget.disable;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.sp),
      width: screenSize.width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.name,
            style: TextStyle(
              color: AppColors().darkGreen,
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
            ),
          ),
          InkWell(
            onTap: () => widget.disable
                ? null
                : setState(() {
                    check = !check;
                    widget.onChange(check);
                  }),
            child: Container(
              height: 30.sp,
              width: 30.sp,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors().darkGreen,
                  width: 2.sp,
                ),
                borderRadius: BorderRadius.circular(5.sp),
                color: check ? Colors.white : Colors.transparent,
              ),
              child: check
                  ? Icon(
                      Icons.check_rounded,
                      color: AppColors().darkGreen,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
