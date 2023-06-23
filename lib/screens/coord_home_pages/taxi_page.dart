import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:pra_tvi_web/controller/box_controller.dart';
import 'package:pra_tvi_web/core/color_constants.dart';
import 'package:pra_tvi_web/helpers/firebase_helper.dart';
import 'package:pra_tvi_web/helpers/snackbar_helper.dart';
import 'package:pra_tvi_web/widgets/custom_appbar.dart';
import 'package:resize/resize.dart';

class TaxiPage extends StatefulWidget {
  const TaxiPage({Key? key}) : super(key: key);

  @override
  State<TaxiPage> createState() => _TaxiPageState();
}

class _TaxiPageState extends State<TaxiPage> {
  final formKey = GlobalKey<FormState>();

  final boxes = Get.find<BoxController>();

  final textEditCtr = TextEditingController();

  String famNo = '';

  String driverNo = '';

  String taxiNo = '';

  String driverName = '';

  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.customAppBar(
        'Add Taxi Details',
        backEnabled: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(13.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value.toString().trim().isEmpty ||
                          value.toString().trim() == '') {
                        return 'Enter a value.';
                      }
                      return null;
                    },
                    onChanged: (value) => famNo = value.toString().trim(),
                    decoration: InputDecoration(
                      labelText: 'Family Number',
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
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    maxLength: 15,
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(
                    height: 10.sp,
                  ),
                  TypeAheadFormField(
                    animationStart: 0,
                    animationDuration: Duration.zero,
                    textFieldConfiguration: TextFieldConfiguration(
                      autofocus: false,
                      controller: textEditCtr,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: AppColors().darkGreen,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Passenger Name',
                        labelStyle: TextStyle(
                          fontSize: 15.sp,
                          color: AppColors().darkGreen,
                        ),
                        counterText: '',
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
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      cursorColor: AppColors().darkGreen,
                      maxLength: 50,
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
                      child: Text(
                        guest['name']!,
                        style: TextStyle(
                          fontSize: 15.sp,
                          decoration: TextDecoration.none,
                          color: AppColors().darkGreen,
                        ),
                      ),
                    ),
                    onSuggestionSelected: (suggestion) {
                      textEditCtr.text = suggestion['name']!;
                    },
                    validator: (value) {
                      if (value!.isEmpty || value == '') {
                        return 'Enter name of passenger.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.sp,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.toString().trim().isEmpty ||
                          value.toString().trim() == '') {
                        return 'Enter a value.';
                      }
                      return null;
                    },
                    onChanged: (value) => driverName = value.toString().trim(),
                    decoration: InputDecoration(
                      labelText: 'Driver Name',
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
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    maxLength: 80,
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(
                    height: 10.sp,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.toString().trim().isEmpty ||
                          value.toString().trim() == '') {
                        return 'Enter a value.';
                      }
                      return null;
                    },
                    onChanged: (value) => driverNo = value.toString().trim(),
                    decoration: InputDecoration(
                      labelText: 'Driver Number',
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
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    maxLength: 15,
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(
                    height: 10.sp,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.toString().trim().isEmpty ||
                          value.toString().trim() == '') {
                        return 'Enter a value.';
                      }
                      return null;
                    },
                    onChanged: (value) => taxiNo = value.toString().trim(),
                    decoration: InputDecoration(
                      labelText: 'Taxi Number',
                      labelStyle: TextStyle(
                        color: AppColors().darkGreen,
                      ),
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
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    maxLength: 14,
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      uploading = true;
                    });
                    if (formKey.currentState!.validate()) {
                      await FirebaseHelper().createTaxi(
                        famNo,
                        textEditCtr.text,
                        driverNo,
                        driverName,
                        taxiNo,
                      );
                      formKey.currentState!.reset();
                      SnackBarHelper.successMsg(
                          msg: 'Taxi created Successfully.');
                    }
                    setState(() {
                      uploading = false;
                    });
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
                            'Create Taxi',
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
    );
  }
}
