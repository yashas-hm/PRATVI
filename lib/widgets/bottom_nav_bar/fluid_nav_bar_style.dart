import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

@immutable
class FluidNavBarStyle with Diagnosticable {
  final Color? barBackgroundColor;

  final Color? iconBackgroundColor;

  final Color? iconSelectedForegroundColor;

  final Color? iconUnselectedForegroundColor;

  const FluidNavBarStyle({
    this.barBackgroundColor,
    this.iconBackgroundColor,
    this.iconSelectedForegroundColor,
    this.iconUnselectedForegroundColor,
  });
}
