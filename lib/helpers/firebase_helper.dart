import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pratvi/controller/controller.dart';
import 'package:pratvi/core/app_constants.dart';
import 'package:pratvi/core/description_data.dart';
import 'package:pratvi/core/shared_preferences.dart';
import 'package:pratvi/helpers/app_helpers.dart';
import 'package:pratvi/helpers/snackbar_helper.dart';
import 'package:pratvi/models/family_model.dart';
import 'package:pratvi/models/route_model.dart';

class FirebaseHelper {
  final authInstance = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  final controller = Get.find<Controller>();

  Future<bool> login(String number) async {
    final loggedIn = await firestoreInstance
        .collection(AppConstants.userCollection)
        .doc(number)
        .get();

    if (loggedIn.exists) {
      controller.family = FamilyModel.fromJson(loggedIn.data()!);
      AppSharedPreferences.setLoggedIn = true;
      AppSharedPreferences.setLoginNumber = number;
      return true;
    } else {
      SnackBarHelper.errorMsg(
          msg: 'Please check number again. Family info not found.');
    }
    return false;
  }

  Future<void> getFamilyData() async {
    final number = AppSharedPreferences.getLoginNumber;
    final loggedIn = await firestoreInstance
        .collection(AppConstants.userCollection)
        .doc(number)
        .get();
    controller.family = FamilyModel.fromJson(loggedIn.data()!);
  }

  Future<List<String>> getBusses() async {
    final cache = firestoreInstance.collection('cacheControl').doc('bus');
    final data = await cache.get();
    final a = data.data();
    return AppHelpers.dynamicToString(a!['busNo']);
  }

  Future<void> checkIn(
    String tripNo,
    String busNo,
    List<Map<String, String>> data,
  ) async {
    await firestoreInstance.collection('today').doc(tripNo).update({
      busNo: FieldValue.arrayUnion(data),
    });
  }

  Future<Map<String, List<String>>> getBusStatus(int plan) async {
    final statusMap = {
      Descriptions.busStatus[0]: <String>[],
      Descriptions.busStatus[1]: <String>[],
      Descriptions.busStatus[2]: <String>[],
    };
    final doc =
        await firestoreInstance.collection('today').doc(plan.toString()).get();
    if (doc.data() != null) {
      final Map<String, dynamic> data = doc.data()!;
      statusMap[Descriptions.busStatus[0]] =
          AppHelpers.dynamicToString(data[Descriptions.busStatus[0]]);
      statusMap[Descriptions.busStatus[1]] =
          AppHelpers.dynamicToString(data[Descriptions.busStatus[1]]);
      statusMap[Descriptions.busStatus[2]] =
          AppHelpers.dynamicToString(data[Descriptions.busStatus[2]]);
    }
    return statusMap;
  }

  Future<Map<String, List<Map<String, String>>>> getBusFamData(int plan) async {
    final doc =
        await firestoreInstance.collection('today').doc(plan.toString()).get();
    Map<String, List<Map<String, String>>> list = {};
    if (doc.data() != null) {
      final data = doc.data()!;
      for (var i in data.keys.toList()) {
        final l = <Map<String, String>>[];
        for (var j in data[i]) {
          l.add({
            'name': j['name'],
            'number': j['number'],
          });
        }
        list[i] = l;
      }
    }
    return list;
  }

  Future<List<Map<String, String>>> getFamData() async {
    final list = <Map<String, String>>[];
    final doc = await firestoreInstance
        .collection('cacheControl')
        .doc('familyData')
        .get();
    final data = doc['familyData'];
    for (var i in data) {
      list.add({
        'name': i['name'],
        'number': i['number'],
      });
    }
    return list;
  }

  Future<Map<String, dynamic>> getCache() async {
    final data = <String, dynamic>{};
    final cache =
        await firestoreInstance.collection('cacheControl').doc('cache').get();
    final json = cache.data()!;
    data['routes'] = json['routes'].toDate();
    data['bus'] = json['bus'].toDate();
    data['todayPlan'] = int.parse(json['todayPlan']);
    return data;
  }

  Future<List<RouteModel>> getRoutes() async {
    final list = <RouteModel>[];
    final data = await firestoreInstance
        .collection(AppConstants.routesCollection)
        .orderBy('date')
        .get();
    for (var i in data.docs) {
      list.add(RouteModel.fromJson(i.data()));
    }
    return list;
  }
}
