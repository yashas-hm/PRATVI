import 'package:pratvi/helpers/app_helpers.dart';

class FamilyModel {
  List<String> roomNo;

  List<String> familyName;

  List<String> familyNumber;

  String driverNumber;

  String coordinatorNo;

  String driverName;

  String coordinatorName;

  String busNumber;

  FamilyModel({
    required this.familyName,
    required this.familyNumber,
    required this.roomNo,
    required this.driverName,
    required this.driverNumber,
    required this.coordinatorName,
    required this.coordinatorNo,
    required this.busNumber,
  });

  static FamilyModel fromJson(Map<String, dynamic> json) {
    return FamilyModel(
      roomNo: AppHelpers.dynamicToString(json['roomNo']),
      familyName: AppHelpers.dynamicToString(json['familyName']),
      familyNumber: AppHelpers.dynamicToString(json['familyNumber']),
      driverName: json['driverName'],
      driverNumber: json['driverNumber'],
      coordinatorName: json['coordinatorName'],
      coordinatorNo: json['coordinatorNo'],
      busNumber: json['busNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomNo': roomNo,
      'familyName': familyName,
      'familyNumber': familyNumber,
      'driverName': driverName,
      'driverNumber': driverNumber,
      'coordinatorName': coordinatorName,
      'coordinatorNo': coordinatorNo,
      'busNumber': busNumber,
    };
  }
}
