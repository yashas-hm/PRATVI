import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pra_tvi_web/controller/controller.dart';
import 'package:pra_tvi_web/core/app_constants.dart';
import 'package:pra_tvi_web/core/description_data.dart';
import 'package:pra_tvi_web/core/shared_preferences.dart';
import 'package:pra_tvi_web/helpers/app_helpers.dart';
import 'package:pra_tvi_web/helpers/snackbar_helper.dart';
import 'package:pra_tvi_web/models/family_model.dart';
import 'package:pra_tvi_web/models/route_model.dart';

class FirebaseHelper {
  final authInstance = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  final controller = Get.find<Controller>();

  Future<bool> login(String number) async {
    final collection = await firestoreInstance
        .collection(AppConstants.userCollection)
        .get();

    for(var doc in collection.docs){
      final famNo = doc.id;
      final docData = doc.data();
      final famNos = AppHelpers.dynamicToString(docData['familyNumber']);
      if(famNos.contains(number)){
        controller.family = FamilyModel.fromJson(docData);
        AppSharedPreferences.setLoggedIn = true;
        AppSharedPreferences.setLoginNumber = famNo;
        return true;
      }
    }

    SnackBarHelper.errorMsg(
        msg: 'Please check number again. Family info not found.');
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

  Future<List<Map<String, String>>> getTaxi() async {
    final doc = await firestoreInstance
        .collection('taxi')
        .doc(AppSharedPreferences.getLoginNumber)
        .get();
    final list = <Map<String, String>>[];
    if (doc.exists) {
      final data = doc.data()!['taxi'];

      for (var i in data) {
        list.add({
          'name': i['name'],
          'taxiNo': i['taxiNo'],
          'driverNo': i['driverNo'],
          'driverName': i['driverName'],
        });
      }
      return list;
    }
    return [];
  }

  Future<void> createTaxi(
    String famNo,
    String pass,
    String driverNo,
    String driverName,
    String taxiNo,
  ) async {
    final data = await firestoreInstance.collection('taxi').doc(famNo).get();
    if (data.exists) {
      await firestoreInstance.collection('taxi').doc(famNo).update({
        'taxi': FieldValue.arrayUnion([
          {
            'name': pass,
            'driverName': driverName,
            'driverNo': driverNo,
            'taxiNo': taxiNo,
          }
        ]),
      });
    } else {
      await firestoreInstance.collection('taxi').doc(famNo).set({
        'taxi': [
          {
            'name': pass,
            'driverName': driverName,
            'driverNo': driverNo,
            'taxiNo': taxiNo,
          }
        ]
      });
    }
  }

  Future<List<String>> getDriverNos() async {
    final cache = firestoreInstance.collection('cacheControl').doc('bus');
    final data = await cache.get();
    final a = data.data();
    return AppHelpers.dynamicToString(a!['driverNo']);
  }

  Future<List<Map<String, String>>> getCoordinators() async {
    final cache = await firestoreInstance
        .collection('cacheControl')
        .doc('coordinators')
        .get();
    final list = <Map<String, String>>[];
    final data = cache.data()!['coordinators'];
    for (var i in data) {
      list.add({'name': i['name'], 'number': i['number']});
    }
    return list;
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

  Future<void> changeBusStatus(String bus, int status, int plan) async {
    final doc = firestoreInstance.collection('today').doc(plan.toString());
    if (status == 0) {
      doc.update({
        Descriptions.busStatus[0]: FieldValue.arrayUnion([bus]),
        Descriptions.busStatus[1]: FieldValue.arrayRemove([bus]),
        Descriptions.busStatus[2]: FieldValue.arrayRemove([bus]),
      });
    } else if (status == 1) {
      doc.update({
        Descriptions.busStatus[0]: FieldValue.arrayRemove([bus]),
        Descriptions.busStatus[1]: FieldValue.arrayUnion([bus]),
        Descriptions.busStatus[2]: FieldValue.arrayRemove([bus]),
      });
    } else if (status == 2) {
      doc.update({
        Descriptions.busStatus[0]: FieldValue.arrayRemove([bus]),
        Descriptions.busStatus[1]: FieldValue.arrayRemove([bus]),
        Descriptions.busStatus[2]: FieldValue.arrayUnion([bus]),
      });
    }
  }

  Future<Map<String, List<Map<String, String>>>> getBusFamData(int plan) async {
    final doc =
        await firestoreInstance.collection('today').doc(plan.toString()).get();
    Map<String, List<Map<String, String>>> list = {};
    if (doc.data() != null) {
      final data = doc.data()!;
      for (var i in data.keys.toList()) {
        if (!Descriptions.busStatus.contains(i)) {
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
    data['coordinators'] = json['coordinators'].toDate();
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
    list.add(RouteModel('12/02/2023', '11:30 AM', '', ''));
    list.add(RouteModel('12/02/2023', '03:00 PM', '', ''));
    return list;
  }
}
