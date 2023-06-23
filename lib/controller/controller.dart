import 'package:get/get.dart';
import 'package:pra_tvi_web/controller/box_controller.dart';
import 'package:pra_tvi_web/core/app_constants.dart';
import 'package:pra_tvi_web/core/shared_preferences.dart';
import 'package:pra_tvi_web/helpers/firebase_helper.dart';
import 'package:pra_tvi_web/models/family_model.dart';

class Controller extends GetxController {
  bool loggedIn = false;

  FamilyModel family = FamilyModel(
    roomNo: [],
    familyName: [],
    familyNumber: [],
  );

  int index = 1;

  void moveToIndex(int value) {
    index = value;
    update([AppConstants.navBarIndexTag]);
  }

  Future<void> initialise() async {
    loggedIn = AppSharedPreferences.getLoggedIn;
    final box = Get.find<BoxController>();
    if(loggedIn){
      if(AppSharedPreferences.getLoginNumber == '120223' || AppSharedPreferences.getLoginNumber == '080501'){
        await box.getFamilyData();
        await box.getBusData();
        index = 0;
      }else{
        index = 1;
        await FirebaseHelper().getFamilyData();
        await box.taxiList();
      }
    }
  }
}
