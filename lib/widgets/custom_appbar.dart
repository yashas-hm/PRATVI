import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pra_tvi_web/core/color_constants.dart';
import 'package:resize/resize.dart';

class CustomAppBar {
  static AppBar customAppBar(String title, {bool backEnabled = true, Function? backFun}) {
    return AppBar(
      toolbarHeight: 60.sp,
      leading: backEnabled
          ? InkWell(
              onTap: () => backFun ?? Get.back(result: false),
              child: Container(
                height: 60.sp,
                width: 60.sp,
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 20.sp,
                  color: AppColors().pink,
                ),
              ),
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          color: AppColors().pink,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
