import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pra_tvi_web/controller/box_controller.dart';
import 'package:pra_tvi_web/core/color_constants.dart';
import 'package:pra_tvi_web/core/shared_preferences.dart';
import 'package:pra_tvi_web/helpers/firebase_helper.dart';
import 'package:pra_tvi_web/helpers/snackbar_helper.dart';
import 'package:pra_tvi_web/screens/login_screen.dart';
import 'package:pra_tvi_web/widgets/input_chip/chips_input.dart';
import 'package:resize/resize.dart';

class CoordHomePage extends StatefulWidget {
  const CoordHomePage({Key? key}) : super(key: key);

  @override
  State<CoordHomePage> createState() => _CoordHomePageState();
}

class _CoordHomePageState extends State<CoordHomePage> {
  final boxes = Get.find<BoxController>();
  String busNo = '';
  final focusNode = FocusNode();

  List<Map<String, String>> families = [];
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final busses = boxes.getBusList();
    final list = <String>[];
    for (var i in boxes.busData.values.toList()) {
      for (var j in i) {
        list.add(j['name']!);
      }
    }

    final notCheckedIn = <Map<String, String>>[];
    for (var i in boxes.familyData) {
      if (!list.contains(i['name'])) {
        notCheckedIn.add(i);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Coordinator Checkin',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        toolbarHeight: 60.sp,
        actions: [
          InkWell(
            onTap: () {
              AppSharedPreferences.setLoggedIn = false;
              Get.offAll(() => const LoginScreen());
            },
            child: Container(
              padding: EdgeInsets.all(10.sp),
              height: 60.sp,
              width: 60.sp,
              child: Icon(
                Icons.logout_rounded,
                size: 25.sp,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await boxes.getBusData();
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: EdgeInsets.all(13.sp),
            height: screenSize.height - 100.sp,
            width: screenSize.width,
            child: Column(
              children: [
                SizedBox(
                  height: 10.sp,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Bus        ',
                      style: TextStyle(
                        color: AppColors().darkGreen,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      'Status',
                      style: TextStyle(
                        color: AppColors().darkGreen,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      'Checkins',
                      style: TextStyle(
                        color: AppColors().darkGreen,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.sp,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, index) => Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        busses[index],
                        style: TextStyle(
                          color: AppColors().darkGreen,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                        ),
                      ),
                      Text(
                        boxes.getBusStatusString(busses[index]),
                        style: TextStyle(
                          color: AppColors().darkGreen,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                        ),
                      ),
                      Text(
                        '  ${boxes.busData[busses[index]]!.length}       ',
                        style: TextStyle(
                          color: AppColors().darkGreen,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  itemCount: busses.length,
                ),
                SizedBox(
                  height: 10.sp,
                ),
                SizedBox(
                  width: screenSize.width,
                  child: Text(
                    'Select bus registration number:',
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
                SizedBox(
                  height: 10.sp,
                ),
                ChipsInput<Map<String, String>>(
                  focusNode: focusNode,
                  initialValue: families,
                  maxChips: 10,
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
                      labelText: 'Select Family Member'),
                  inputType: TextInputType.text,
                  inputAction: TextInputAction.done,
                  chipBuilder: (context, state, data) => InputChip(
                    key: ObjectKey(data),
                    label: Text(data['name']!),
                    onDeleted: () => state.deleteChip(data),
                  ),
                  suggestionBuilder: (context, state, data) => ListTile(
                    key: ObjectKey(data),
                    title: Text(data['name']!),
                    onTap: () => state.selectSuggestion(data),
                  ),
                  findSuggestions: (query) {
                    if (boxes.familyData.isNotEmpty) {
                      if (query.isNotEmpty) {
                        final list = [];
                        for (var i in boxes.busData.values.toList()) {
                          list.addAll(i);
                        }

                        return notCheckedIn
                            .where((element) =>
                                element['name']!
                                    .toLowerCase()
                                    .startsWith(query.toLowerCase()) &&
                                !list.contains(element))
                            .toList();
                      }
                    }

                    return [];
                  },
                  onChanged: (data) {
                    families = data;
                  },
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () async {
                        if (busNo.isEmpty) {
                          SnackBarHelper.errorMsg(
                              msg: 'Please select bus number');
                        } else {
                          if (families.isNotEmpty) {
                            setState(() {
                              uploading = true;
                            });
                            await FirebaseHelper().checkIn(
                              boxes.plan.toString(),
                              busNo,
                              families,
                            );

                            await boxes.getBusData();

                            setState(() {
                              families = [];
                              uploading = false;
                            });
                          } else {
                            SnackBarHelper.errorMsg(msg: 'Select members');
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
                  height: 70.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
