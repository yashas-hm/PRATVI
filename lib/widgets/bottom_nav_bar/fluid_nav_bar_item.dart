import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'curves.dart';

typedef FluidNavBarButtonTappedCallback = void Function();

class FluidNavBarItem extends StatefulWidget {
  static const nominalExtent = Size(64, 64);

  final String? svgPath;

  final IconData? icon;

  final bool selected;

  final Color selectedForegroundColor;

  final Color unselectedForegroundColor;

  final Color backgroundColor;

  final double scaleFactor;

  final FluidNavBarButtonTappedCallback onTap;

  final double animationFactor;

  final bool image;

  const FluidNavBarItem(
    this.svgPath,
    this.icon,
    this.selected,
    this.onTap,
    this.selectedForegroundColor,
    this.unselectedForegroundColor,
    this.backgroundColor,
    this.scaleFactor,
    this.animationFactor,
  {
      super.key,
      this.image = false,
  })  : assert(scaleFactor >= 1.0),
        assert(svgPath == null || icon == null,
            'Cannot provide both an iconPath and an icon.'),
        assert(!(svgPath == null && icon == null),
            'An iconPath or an icon must be provided.');

  @override
  State createState() {
    // ignore: no_logic_in_create_state
    return _FluidNavBarItemState(selected);
  }
}

class _FluidNavBarItemState extends State<FluidNavBarItem>
    with SingleTickerProviderStateMixin {
  static const double _activeOffset = 16;
  static const double _defaultOffset = 0;
  static const double _iconSize = 25;

  bool _selected;

  late AnimationController _animationController;
  late Animation<double> _activeColorClipAnimation;
  late Animation<double> _yOffsetAnimation;
  late Animation<double> _activatingAnimation;
  late Animation<double> _inactivatingAnimation;

  _FluidNavBarItemState(this._selected);

  @override
  void initState() {
    super.initState();

    double waveRatio = 0.28;
    _animationController = AnimationController(
      duration: Duration(milliseconds: (1600 * widget.animationFactor).toInt()),
      reverseDuration:
          Duration(milliseconds: (1000 * widget.animationFactor).toInt()),
      vsync: this,
    )..addListener(() => setState(() {}));

    _activeColorClipAnimation =
        Tween<double>(begin: 0.0, end: _iconSize).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.25, 0.38, curve: Curves.easeOut),
      reverseCurve: const Interval(0.7, 1.0, curve: Curves.easeInCirc),
    ));

    var animation = CurvedAnimation(
        parent: _animationController, curve: LinearPointCurve(waveRatio, 0.0));

    _yOffsetAnimation = Tween<double>(begin: _defaultOffset, end: _activeOffset)
        .animate(CurvedAnimation(
      parent: animation,
      curve: const ElasticOutCurve(0.38),
      reverseCurve: Curves.easeInCirc,
    ));

    var activatingHalfTween = Tween<double>(begin: 1, end: widget.scaleFactor);
    _activatingAnimation = TweenSequence([
      TweenSequenceItem(tween: activatingHalfTween, weight: 50.0),
      TweenSequenceItem(
          tween: ReverseTween<double>(activatingHalfTween), weight: 50.0),
    ]).animate(CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 0.3),
    ));
    _inactivatingAnimation = ConstantTween<double>(1.0).animate(CurvedAnimation(
      parent: animation,
      curve: const Interval(0.3, 1.0),
    ));

    _startAnimation();
  }

  @override
  void didUpdateWidget(oldWidget) {
    if (oldWidget.selected != _selected) {
      setState(() {
        _selected = widget.selected;
      });
      _startAnimation();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    const ne = FluidNavBarItem.nominalExtent;

    final scaleAnimation =
        _selected ? _activatingAnimation : _inactivatingAnimation;

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: BoxConstraints.tight(ne),
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.all(ne.width / 2 - _iconSize),
          constraints: BoxConstraints.tight(const Size.square(_iconSize * 2)),
          decoration: ShapeDecoration(
            color: widget.backgroundColor,
            shape: const CircleBorder(),
          ),
          transform: Matrix4.translationValues(0, -_yOffsetAnimation.value, 0),
          child: Stack(children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: widget.icon == null
                  ? SvgPicture.asset(
                widget.svgPath!,
                color: widget.unselectedForegroundColor,
                width: _iconSize,
                height: _iconSize * scaleAnimation.value,
                colorBlendMode: BlendMode.srcIn,
              )
                  : Icon(
                      widget.icon,
                      color: widget.unselectedForegroundColor,
                      size: _iconSize * scaleAnimation.value,
                    ),
            ),
            Container(
              alignment: Alignment.center,
              child: ClipRect(
                clipper: _SvgPictureClipper(
                    _activeColorClipAnimation.value * scaleAnimation.value),
                child: widget.icon == null
                    ?  SvgPicture.asset(
                            widget.svgPath!,
                            color: widget.selectedForegroundColor,
                            width: _iconSize,
                            height: _iconSize * scaleAnimation.value,
                            colorBlendMode: BlendMode.srcIn,
                          )
                    : Icon(
                        widget.icon,
                        color: widget.selectedForegroundColor,
                        size: _iconSize * scaleAnimation.value,
                      ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _startAnimation() {
    if (_selected) {
      _animationController.forward();
    } else {
      _animationController.value = 1.0;
      _animationController.reverse();
    }
  }
}

class _SvgPictureClipper extends CustomClipper<Rect> {
  final double height;

  _SvgPictureClipper(this.height);

  @override
  Rect getClip(Size size) {
    return Rect.fromPoints(size.topLeft(Offset.zero),
        size.topRight(Offset.zero) + Offset(0, height));
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
