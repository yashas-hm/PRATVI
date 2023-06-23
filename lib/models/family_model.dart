import 'package:pra_tvi_web/helpers/app_helpers.dart';

class FamilyModel {
  List<String> roomNo;

  List<String> familyName;

  List<String> familyNumber;

  FamilyModel({
    required this.familyName,
    required this.familyNumber,
    required this.roomNo,
  });

  static FamilyModel fromJson(Map<String, dynamic> json) {
    return FamilyModel(
      roomNo: AppHelpers.dynamicToString(json['roomNo']),
      familyName: AppHelpers.dynamicToString(json['familyName']),
      familyNumber: AppHelpers.dynamicToString(json['familyNumber']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomNo': roomNo,
      'familyName': familyName,
      'familyNumber': familyNumber,
    };
  }
}
