import 'package:flutter/material.dart';
import 'package:pratvi/core/color_constants.dart';
import 'package:pratvi/helpers/firebase_helper.dart';
import 'package:pratvi/helpers/snackbar_helper.dart';
import 'package:pratvi/widgets/custom_appbar.dart';
import 'package:resize/resize.dart';

class TaxiPage extends StatefulWidget {
  const TaxiPage({Key? key}) : super(key: key);

  @override
  State<TaxiPage> createState() => _TaxiPageState();
}

class _TaxiPageState extends State<TaxiPage> {
  final formKey = GlobalKey<FormState>();

  String famNo = '';

  String driverNo = '';

  String name = '';

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
                    onChanged: (value) => name = value.toString().trim(),
                    decoration: InputDecoration(
                      labelText: 'Name of passenger',
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
                        name,
                        driverNo,
                        driverName,
                        taxiNo,
                      );
                      formKey.currentState!.reset();
                      SnackBarHelper.successMsg(msg: 'Taxi created Successfully.');
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
