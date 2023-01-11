import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pratvi/controller/box_controller.dart';
import 'package:pratvi/controller/controller.dart';
import 'package:pratvi/core/color_constants.dart';
import 'package:pratvi/helpers/firebase_helper.dart';
import 'package:pratvi/helpers/snackbar_helper.dart';
import 'package:pratvi/widgets/custom_appbar.dart';
import 'package:resize/resize.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({Key? key}) : super(key: key);

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  final boxes = Get.find<BoxController>();

  final controller = Get.find<Controller>();

  final Map<String, Map<String, String>> data = {};

  bool uploading = false;

  String busNo = '';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final key = boxes.routesBox.keyAt(boxes.plan - 1);
    final route = boxes.routesBox.get(key)!;
    List<String> checkIns = boxes.getList(controller.family);
    final busses = boxes.dataBox.get('busNo')! as List<String>;

    return Scaffold(
      appBar: CustomAppBar.customAppBar(
        'Today\'s Plan',
        backEnabled: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await boxes.updateCache();
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: screenSize.height - 90.sp,
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
                      color: AppColors().darkBlue,
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
                      color: AppColors().darkBlue,
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
                      color: AppColors().darkBlue,
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
                      color: AppColors().darkBlue,
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
                    disable: checkIns.contains(controller.family.familyName[index]),
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
                    'Select bus registration number:',
                    style: TextStyle(
                      color: AppColors().darkBlue,
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
                            'Bus No. ${busses.indexOf(e) + 1}',
                            style: TextStyle(
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    busNo = value.toString();
                  },
                  decoration: InputDecoration(
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.sp),
                      borderSide: BorderSide(
                        width: 1.sp,
                        color: AppColors().darkBlue,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.sp),
                      borderSide: BorderSide(
                        width: 1.sp,
                        color: AppColors().darkBlue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.sp),
                      borderSide: BorderSide(
                        width: 1.sp,
                        color: AppColors().darkBlue,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () async {
                        if(busNo.isEmpty){
                          SnackBarHelper.errorMsg(msg: 'Please select bus number');
                        }else{
                          if(data.isNotEmpty){
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
                          color: AppColors().darkBlue,
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
              color: AppColors().darkBlue,
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
                  color: AppColors().darkBlue,
                  width: 2.sp,
                ),
                borderRadius: BorderRadius.circular(5.sp),
                color: check ? Colors.white : Colors.transparent,
              ),
              child: check
                  ? Icon(
                      Icons.check_rounded,
                      color: AppColors().darkBlue,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
