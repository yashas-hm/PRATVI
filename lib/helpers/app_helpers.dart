import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pratvi/controller/box_controller.dart';
import 'package:pratvi/controller/connectivity_controller.dart';
import 'package:pratvi/controller/controller.dart';
import 'package:pratvi/core/shared_preferences.dart';
import 'package:pratvi/firebase_options.dart';

class AppHelpers {
  static void crashlyticsLog(String error) {
    log(error);
    final message = '$error\n Caused by user id: uid';
    FirebaseCrashlytics.instance.log(message);
  }

  static Future<void> initialise() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final connectivityController = Get.put(ConnectivityController());
    final boxes = Get.put(BoxController());

    Get.put(Controller());

    await boxes.initialiseHive();

    await AppSharedPreferences().initSharedPreferences();

    Connectivity().onConnectivityChanged.listen((result) {
      connectivityController.listenConnectivity(result);
    });
  }

  static List<String> dynamicToString(List<dynamic> list) {
    final listString = <String>[];
    for (var i in list) {
      listString.add(i.toString());
    }
    return listString;
  }

  static String dateFormat(Timestamp data){
    final dateTime = data.toDate();
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  static String timeFormat(Timestamp data){
    final time = data.toDate();
    return DateFormat('hh:mm a').format(time);
  }
}
