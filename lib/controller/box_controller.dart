import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pratvi/core/description_data.dart';
import 'package:pratvi/helpers/firebase_helper.dart';
import 'package:pratvi/models/family_model.dart';
import 'package:pratvi/models/route_model.dart';

class BoxController extends GetxController {
  late final Box<RouteModel> routesBox;
  late final Box cacheControl;
  late final Box dataBox;
  late List<Map<String, String>> familyData;
  late Map<String, List<Map<String, String>>> busData;
  late Map<String, List<String>> busStatus;
  int plan = 0;

  String getBusStatusString(String bus) {
    if (Descriptions.busStatus[0].contains(bus)) {
      return Descriptions.busStatus[0];
    } else if (Descriptions.busStatus[1].contains(bus)) {
      return Descriptions.busStatus[1];
    } else if (Descriptions.busStatus[2].contains(bus)) {
      return Descriptions.busStatus[2];
    }
    return 'waiting';
  }

  Future<void> initialiseHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(RouteModelAdapter());
    routesBox = await Hive.openBox('routes');
    cacheControl = await Hive.openBox('cacheControl');
    dataBox = await Hive.openBox('dataBox');
  }

  Future<void> updateCache() async {
    final data = await FirebaseHelper().getCache();
    plan = data['todayPlan'];
    if (cacheControl.isEmpty ||
        !cacheControl.containsKey('routes') ||
        !cacheControl.containsKey('bus') ||
        routesBox.isEmpty) {
      await getRoutes();
      await getBusses();
      cacheControl.put('routes', data['routes']);
      cacheControl.put('bus', data['bus']);
    }

    if (cacheControl.get('routes')!.compareTo(data['routes']!) < 0) {
      cacheControl.delete('routes');
      cacheControl.put('routes', data['routes']!);
      await getRoutes();
    }

    if (cacheControl.get('bus')!.compareTo(data['bus']) < 0) {
      cacheControl.delete('bus');
      cacheControl.put('bus', data['bus']);
      await getBusses();
    }
  }

  Future<void> busFamData() async {
    busData = await FirebaseHelper().getBusFamData(plan);
    for (var i in dataBox.get('busNo')) {
      if (busData[i] == null) {
        busData[i] = [];
      }
    }
  }

  Future<void> getBusData() async {
    await busFamData();
    await getBusStatus();
    update(['busData']);
  }

  Future<void> getFamilyData() async {
    familyData = await FirebaseHelper().getFamData();
  }

  Future<void> getBusses() async {
    dataBox.delete('busNo');
    final data = await FirebaseHelper().getBusses();
    dataBox.put('busNo', data);
  }

  Future<void> getBusStatus() async {
    busStatus = await FirebaseHelper().getBusStatus(plan);
  }

  Future<void> getRoutes() async {
    routesBox.clear();
    final data = await FirebaseHelper().getRoutes();
    for (var i in data) {
      routesBox.add(i);
    }
  }

  List<String> getList(FamilyModel family) {
    final list = <String>[];
    for (var i in busData.values.toList()) {
      for (var j in i) {
        int index =
            family.familyNumber.indexWhere((element) => element == j['number']);
        list.add(family.familyName[index]);
      }
    }
    return list;
  }
}
