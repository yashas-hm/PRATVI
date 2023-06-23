import 'package:hive/hive.dart';
import 'package:pra_tvi_web/helpers/app_helpers.dart';

part 'hive_adapter/route_model.g.dart';

@HiveType(typeId: 1)
class RouteModel {
  @HiveField(0)
  String date;

  @HiveField(1)
  String time;

  @HiveField(2)
  String trip;

  @HiveField(3)
  String details;

  RouteModel(
    this.date,
    this.time,
    this.trip,
    this.details,
  );

  static RouteModel fromJson(Map<String, dynamic> json) {
    return RouteModel(
      AppHelpers.dateFormat(json['date']),
      AppHelpers.timeFormat(json['date']),
      json['trip'],
      json['details'],
    );
  }
}
