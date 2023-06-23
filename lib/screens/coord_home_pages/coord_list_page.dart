import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:pra_tvi_web/controller/box_controller.dart';
import 'package:pra_tvi_web/core/color_constants.dart';
import 'package:pra_tvi_web/widgets/custom_appbar.dart';
import 'package:resize/resize.dart';
import 'package:url_launcher/link.dart';

class CoordListPage extends StatefulWidget {
  const CoordListPage({Key? key}) : super(key: key);

  @override
  State<CoordListPage> createState() => _CoordListPageState();
}

class _CoordListPageState extends State<CoordListPage> {
  final boxes = Get.find<BoxController>();

  String busNo = '';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final list = <String>[];
    for (var i in boxes.busData.values.toList()) {
      for (var j in i) {
        list.add(j['name']!);
      }
    }
    final busses = boxes.getBusList();
    final notCheckedIn = <Map<String, String>>[];
    for (var i in boxes.familyData) {
      if (!list.contains(i['name'])) {
        notCheckedIn.add(i);
      }
    }

    return Scaffold(
      appBar: CustomAppBar.customAppBar(
        'Guests checked in...',
        backEnabled: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await boxes.getBusData();
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.all(13.sp),
            width: screenSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GetBuilder(
                  init: boxes,
                  id: 'busData',
                  builder: (ctr) => TypeAheadField(
                    animationStart: 0,
                    animationDuration: Duration.zero,
                    textFieldConfiguration: TextFieldConfiguration(
                      autofocus: false,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: AppColors().darkGreen,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Guest Search',
                        labelStyle: TextStyle(
                          fontSize: 15.sp,
                          color: AppColors().darkGreen,
                        ),
                        counterText: '',
                        hintText: 'Search guest',
                        hintStyle: TextStyle(
                          fontSize: 15.sp,
                          color: AppColors().darkGreen,
                        ),
                        border: OutlineInputBorder(
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
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.sp),
                          borderSide: BorderSide(
                            width: 1.sp,
                            color: AppColors().darkGreen,
                          ),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      cursorColor: AppColors().darkGreen,
                      maxLength: 30,
                      maxLines: 1,
                    ),
                    suggestionsBoxDecoration: SuggestionsBoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    suggestionsCallback: (pattern) {
                      return boxes.familyData.where((element) =>
                          element['name']!.toLowerCase().contains(pattern));
                    },
                    itemBuilder: (ctx, guest) => Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.sp),
                      height: 40.sp,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.sp),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 2.5.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            guest['name']!,
                            style: TextStyle(
                              fontSize: 15.sp,
                              decoration: TextDecoration.none,
                              color: AppColors().darkGreen,
                            ),
                          ),
                          list.contains(guest['name']!)
                              ? Text(
                                  'Checked In',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    decoration: TextDecoration.none,
                                    color: AppColors().darkGreen,
                                  ),
                                )
                              : Link(
                                  uri: Uri.parse('tel://${guest['number']}'),
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
                    onSuggestionSelected: (suggestion) {},
                  ),
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
                if (busNo != '')
                  SizedBox(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: boxes.busData[busNo]!.length,
                      itemBuilder: (ctx, index) => Container(
                        width: screenSize.width,
                        padding: EdgeInsets.symmetric(
                          vertical: 5.sp,
                          horizontal: 10.sp,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.sp),
                          color: Colors.white,
                        ),
                        margin: EdgeInsets.only(bottom: 5.sp),
                        child: Text(
                          boxes.busData[busNo]![index]['name']!,
                          style: TextStyle(
                            fontSize: 15.sp,
                            decoration: TextDecoration.none,
                            color: AppColors().darkGreen,
                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  height: 10.sp,
                ),
                SizedBox(
                  width: screenSize.width,
                  child: Text(
                    'Guests not checked in',
                    style: TextStyle(
                      color: AppColors().darkGreen,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: notCheckedIn.length,
                  itemBuilder: (ctx, index) => Container(
                    width: screenSize.width,
                    padding: EdgeInsets.symmetric(
                      vertical: 5.sp,
                      horizontal: 10.sp,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.sp),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.only(bottom: 5.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          notCheckedIn[index]['name']!,
                          style: TextStyle(
                            fontSize: 15.sp,
                            decoration: TextDecoration.none,
                            color: AppColors().darkGreen,
                          ),
                        ),
                        Link(
                          uri: Uri.parse(
                              'tel://${notCheckedIn[index]['number']}'),
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
      ),
    );
  }
}
