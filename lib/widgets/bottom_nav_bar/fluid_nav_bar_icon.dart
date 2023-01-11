import 'package:flutter/cupertino.dart';

class FluidNavBarIcon {
  final String? iconPath;

  final String? svgPath;

  final IconData? icon;

  final bool image;

  final Color? selectedForegroundColor;

  final Color? unselectedForegroundColor;

  final Color? backgroundColor;

  final Map<String, dynamic>? extras;

  FluidNavBarIcon({
    this.iconPath,
    this.svgPath,
    this.icon,
    this.selectedForegroundColor,
    this.unselectedForegroundColor,
    this.backgroundColor,
    this.extras,
    this.image = false,
  })  : assert(iconPath == null || svgPath == null || icon == null,
            'Cannot provide both an svgPath and an icon.'),
        assert(iconPath != null || svgPath != null || icon != null,
            'An svgPath or an icon must be provided.');
}
