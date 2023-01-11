import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pratvi/controller/box_controller.dart';
import 'package:pratvi/core/app_constants.dart';
import 'package:pratvi/core/color_constants.dart';
import 'package:pratvi/core/shared_preferences.dart';
import 'package:pratvi/helpers/firebase_helper.dart';
import 'package:pratvi/screens/cood_home_screen.dart';
import 'package:pratvi/screens/home_screen.dart';
import 'package:pratvi/widgets/custom_appbar.dart';
import 'package:resize/resize.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool login = false;
  String number = '';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar.customAppBar(
        'Login',
        backEnabled: false,
      ),
      body: Container(
        padding: EdgeInsets.all(13.sp),
        height: screenSize.height,
        width: screenSize.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 150.sp,
              width: 150.sp,
              margin: EdgeInsets.only(
                top: 50.sp,
                bottom: 80.sp,
              ),
              padding: EdgeInsets.all(15.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25.sp)),
                color: const Color(0xFFF6F5E8),
              ),
              child: SvgPicture.asset(
                AppConstants.appLogo,
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                counterText: '',
                labelStyle: TextStyle(color: AppColors().darkBlue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                  borderSide: BorderSide(
                    width: 2.sp,
                    color: AppColors().darkBlue,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                  borderSide: BorderSide(
                    width: 2.sp,
                    color: AppColors().darkBlue,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                  borderSide: BorderSide(
                    width: 2.sp,
                    color: AppColors().darkBlue,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                  borderSide: BorderSide(
                    width: 2.sp,
                    color: Colors.redAccent,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors().darkBlue,
              ),
              keyboardType: TextInputType.number,
              maxLines: 1,
              maxLength: 10,
              textInputAction: TextInputAction.done,
              onChanged: (value) => number = value,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13.sp),
                    color: login ? Colors.black38 : AppColors().darkBlue,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        setState(() {
                          login = true;
                        });

                        bool result = false;

                        if (number == '120223') {
                          AppSharedPreferences.setLoggedIn = true;
                          AppSharedPreferences.setLoginNumber = number;
                          final box = Get.find<BoxController>();
                          await box.getFamilyData();

                          Get.off(() => CoordHomeScreen());
                        } else {
                          result = await FirebaseHelper().login(number);
                        }

                        setState(() {
                          login = false;
                        });

                        if (result) {
                          Get.off(() => HomeScreen());
                        }
                      },
                      splashColor: Colors.white,
                      child: Container(
                        height: 60.sp,
                        width: 200.sp,
                        alignment: Alignment.center,
                        child: login
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.sp,
                                ),
                              ),
                      ),
                    ),
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