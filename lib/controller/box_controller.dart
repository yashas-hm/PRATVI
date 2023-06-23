import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pra_tvi_web/core/description_data.dart';
import 'package:pra_tvi_web/helpers/firebase_helper.dart';
import 'package:pra_tvi_web/models/family_model.dart';
import 'package:pra_tvi_web/models/route_model.dart';

class BoxController extends GetxController {
  late final Box<RouteModel> routesBox;
  late final Box cacheControl;
  late final Box dataBox;
  late List<Map<String, String>> familyData;
  late Map<String, List<Map<String, String>>> busData;
  late Map<String, List<String>> busStatus;
  late List<Map<String, String>> taxis;
  int plan = 0;

  String getBusStatusString(String bus) {
    if (busStatus[Descriptions.busStatus[0]]!.contains(bus)) {
      return Descriptions.busStatus[0];
    } else if (busStatus[Descriptions.busStatus[1]]!.contains(bus)) {
      return Descriptions.busStatus[1];
    } else if (busStatus[Descriptions.busStatus[2]]!.contains(bus)) {
      return Descriptions.busStatus[2];
    }
    return 'waiting';
  }

  List<String> getBusList(){
    final list = <String>[];
    final data = dataBox.get('busNo')!;
    for(var i in data){
      list.add(i.toString());
    }
    return list;
  }

  List<String> getDriverNoList(){
    final list = <String>[];
    final data = dataBox.get('driverNo')!;
    for(var i in data){
      list.add(i.toString());
    }
    return list;
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
        !cacheControl.containsKey('coordinators') ||
        routesBox.isEmpty) {
      await getRoutes();
      await getBusses();
      await getCoord();
      cacheControl.put('coordinators', data['coordinators']);
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

    if (cacheControl.get('coordinators')!.compareTo(data['coordinators']) < 0) {
      cacheControl.delete('coordinators');
      cacheControl.put('coordinators', data['coordinators']);
      await getCoord();
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

  List<Map<String, String>> coordData(){
    final list = <Map<String, String>>[];
    final data = dataBox.get('coordinators')! as List;
    for(var i in data){
      list.add({
        'name': i['name'],
        'number': i['number']
      });
    }
    return list;
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
    dataBox.delete('driverNo');
    final data = await FirebaseHelper().getBusses();
    final drData = await FirebaseHelper().getDriverNos();
    dataBox.put('busNo', data);
    dataBox.put('driverNo', drData);
  }

  Future<void> getCoord() async{
    dataBox.delete('coordinators');
    final data = await FirebaseHelper().getCoordinators();
    dataBox.put('coordinators', data);
  }

  Future<void> getBusStatus() async {
    busStatus = await FirebaseHelper().getBusStatus(plan);
  }

  Future<void> changeBusStatus(String bus, int status,) async{
    await FirebaseHelper().changeBusStatus(bus, status, plan);
  }

  Future<void> getRoutes() async {
    routesBox.clear();
    final data = await FirebaseHelper().getRoutes();
    for (var i in data) {
      routesBox.add(i);
    }
  }
  Future<void> taxiList() async {
    taxis = await FirebaseHelper().getTaxi();
  }

  List<String> getList(FamilyModel family) {
    final list = <String>[];
    for (var i in busData.values.toList()) {
      for (var j in i) {
        int index =
            family.familyNumber.indexWhere((element) => element == j['number']);
        if(index!=-1){
          list.add(family.familyName[index]);
        }
      }
    }
    return list;
  }
}
