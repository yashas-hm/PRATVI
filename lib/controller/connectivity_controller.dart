import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ConnectivityController extends GetxController{
  bool hasInternet = true;

  ConnectivityResult connectivityResult = ConnectivityResult.none;

  void listenConnectivity(ConnectivityResult result){
    connectivityResult = result;

    if(result == ConnectivityResult.none){
      Future.delayed(const Duration(seconds: 1), (){
        if(result == ConnectivityResult.none){
          hasInternet = false;
          Get.to(() => Container());
        }
      });
    }

    if((result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) && !hasInternet){
      Get.back();
      hasInternet = true;
    }
  }

  void checkConnectivity(){
    if(!hasInternet){
      Connectivity().checkConnectivity().then((result){
        if((result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) && !hasInternet){
          Get.back();
          hasInternet = true;
        }
      });
    }
  }
}