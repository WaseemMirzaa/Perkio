import 'package:flutter/material.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/widgets/login_button_widget.dart';
import 'package:slide_to_act/slide_to_act.dart';

import 'dart:math';

import 'package:flutter/material.dart';
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.gradientStartColor,AppColors.gradientEndColor],begin: Alignment.topCenter, end: Alignment.bottomCenter)
          ),

        child: Center(
          child: ListView(
            children: <Widget>[
              Builder(
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ButtonWidget(onSwipe: () {  },text: 'TEST',),
                  );
                },
              ),
              Builder(
                builder: (context) {
                  final GlobalKey<CustomSlideActionState> _key = GlobalKey();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ButtonWidget(onSwipe: () {  },text: 'TEST',check: false,),
                  );
                },
              ),
              Builder(
                builder: (context) {
                  final GlobalKey<CustomSlideActionState> _key = GlobalKey();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SlideAction(
                      key: _key,
                      onSubmit: () {
                        Future.delayed(
                          const Duration(seconds: 1),
                              () => _key.currentState!.reset(),
                        );
                      },
                      innerColor: Colors.black,
                      outerColor: Colors.white,
                    ),
                  );
                },
              ),
              Builder(
                builder: (context) {
                  final GlobalKey<CustomSlideActionState> _key = GlobalKey();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SlideAction(
                      key: _key,
                      onSubmit: () {
                        Future.delayed(
                          const Duration(seconds: 1),
                              () => _key.currentState!.reset(),
                        );
                      },
                      alignment: Alignment.centerRight,
                      child: const Text(
                        'Unlock',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      sliderButtonIcon: const Icon(Icons.lock),
                    ),
                  );
                },
              ),
              Builder(
                builder: (context) {
                  final GlobalKey<CustomSlideActionState> _key = GlobalKey();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SlideAction(
                      key: _key,
                      onSubmit: () {
                        Future.delayed(
                          const Duration(seconds: 1),
                              () => _key.currentState!.reset(),
                        );
                      },
                      height: 100,
                    ),
                  );
                },
              ),
              Builder(
                builder: (context) {
                  final GlobalKey<CustomSlideActionState> _key = GlobalKey();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomSlideAction(
                      key: _key,
                      onSubmit: () {
                        Future.delayed(
                          const Duration(seconds: 1),
                              () => _key.currentState!.reset(),
                        );
                      },
                      sliderButtonIconSize: 48,
                      sliderButtonYOffset: -20,
                    ),
                  );
                },
              ),
              Builder(
                builder: (context) {
                  final GlobalKey<CustomSlideActionState> _key = GlobalKey();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomSlideAction(
                      key: _key,
                      onSubmit: () {
                        Future.delayed(
                          const Duration(seconds: 1),
                              () => _key.currentState!.reset(),
                        );
                      },
                      elevation: 24,
                    ),
                  );
                },
              ),
              Builder(
                builder: (context) {
                  final GlobalKey<CustomSlideActionState> _key = GlobalKey();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomSlideAction(
                      key: _key,
                      onSubmit: () {
                        Future.delayed(
                          const Duration(seconds: 1),
                              () => _key.currentState!.reset(),
                        );
                      },
                      borderRadius: 16,
                      animationDuration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
              Builder(
                builder: (context) {
                  final GlobalKey<CustomSlideActionState> _key = GlobalKey();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomSlideAction(
                      key: _key,
                      onSubmit: () {
                        Future.delayed(
                          const Duration(seconds: 1),
                              () => _key.currentState!.reset(),
                        );
                      },
                      reversed: true,
                    ),
                  );
                },
              ),
              Builder(
                builder: (context) {
                  final GlobalKey<CustomSlideActionState> _key = GlobalKey();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomSlideAction(
                      key: _key,
                      onSubmit: () {
                        Future.delayed(
                          const Duration(seconds: 1),
                              () => _key.currentState!.reset(),
                        );
                      },
                      submittedIcon: const Icon(
                        Icons.done_all,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              Builder(
                builder: (context) {
                  final GlobalKey<CustomSlideActionState> _key = GlobalKey();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomSlideAction(
                      key: _key,
                      onSubmit: () {
                        Future.delayed(
                          const Duration(seconds: 1),
                              () => _key.currentState!.reset(),
                        );
                      },
                    ),
                  );
                },
              ),
              Builder(
                builder: (context) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CustomSlideAction(
                      sliderRotate: false,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class CustomSlideAction extends StatefulWidget {
  final double sliderButtonIconSize;
  final double sliderButtonIconPadding;
  final double sliderButtonYOffset;
  final bool sliderRotate;
  final bool enabled;
  final Widget? child;
  final double height;
  final Color? textColor;
  final Color? innerColor;
  final Color? outerColor;
  final String? text;
  final TextStyle? textStyle;
  final double borderRadius;
  final Future? Function()? onSubmit;
  final double elevation;
  final Widget? sliderButtonIcon;
  final Widget? submittedIcon;
  final Duration animationDuration;
  final bool reversed;
  final Alignment alignment;

  const CustomSlideAction({
    Key? key,
    this.sliderButtonIconSize = 24,
    this.sliderButtonIconPadding = 16,
    this.sliderButtonYOffset = 0,
    this.sliderRotate = true,
    this.enabled = true,
    this.height = 70,
    this.textColor,
    this.innerColor,
    this.outerColor,
    this.borderRadius = 52,
    this.elevation = 6,
    this.animationDuration = const Duration(milliseconds: 300),
    this.reversed = false,
    this.alignment = Alignment.center,
    this.submittedIcon,
    this.onSubmit,
    this.child,
    this.text,
    this.textStyle,
    this.sliderButtonIcon,
  }) : super(key: key);

  @override
  CustomSlideActionState createState() => CustomSlideActionState();
}

class CustomSlideActionState extends State<CustomSlideAction> with TickerProviderStateMixin {
  final GlobalKey _containerKey = GlobalKey();
  final GlobalKey _sliderKey = GlobalKey();
  double _dx = 0;
  double _maxDx = 0;
  double get _progress => _dx == 0 ? 0 : _dx / _maxDx;
  double _endDx = 0;
  double _dz = 1;
  double? _initialContainerWidth, _containerWidth;
  double _checkAnimationDx = 0;
  bool submitted = false;
  late AnimationController _checkAnimationController,
      _shrinkAnimationController,
      _resizeAnimationController,
      _cancelAnimationController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(widget.reversed ? pi : 0),
        child: Container(
          key: _containerKey,
          height: widget.height,
          width: _containerWidth,
          constraints: _containerWidth != null
              ? null
              : BoxConstraints.expand(height: widget.height),
          child: Material(
            elevation: widget.elevation,
            color: widget.outerColor ?? Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: submitted
                ? Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(widget.reversed ? pi : 0),
              child: Center(
                child: Stack(
                  clipBehavior: Clip.antiAlias,
                  children: <Widget>[
                    widget.submittedIcon ??
                        Icon(
                          Icons.done,
                          color: widget.innerColor ??
                              Theme.of(context).primaryIconTheme.color,
                        ),
                    Positioned.fill(
                      right: 0,
                      child: Transform(
                        transform: Matrix4.rotationY(
                            _checkAnimationDx * (pi / 2)),
                        alignment: Alignment.centerRight,
                        child: Container(
                          color: widget.outerColor ??
                              Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
                : Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: <Widget>[
                Opacity(
                  opacity: 1 - 1 * _progress,
                  child: Transform(
                    alignment: Alignment.center,
                    transform:
                    Matrix4.rotationY(widget.reversed ? pi : 0),
                    child: widget.child ??
                        Text(
                          widget.text ?? 'Slide to act',
                          textAlign: TextAlign.center,
                          style: widget.textStyle ??
                              TextStyle(
                                color: widget.textColor ??
                                    Theme.of(context)
                                        .primaryIconTheme
                                        .color,
                                fontSize: 24,
                              ),
                        ),
                  ),
                ),
                Positioned(
                  left: widget.sliderButtonYOffset,
                  child: Transform.scale(
                    scale: _dz,
                    origin: Offset(_dx, 0),
                    child: Transform.translate(
                      offset: Offset(_dx, 0),
                      child: Container(
                        key: _sliderKey,
                        child: GestureDetector(
                          onHorizontalDragUpdate: widget.enabled
                              ? onHorizontalDragUpdate
                              : null,
                          onHorizontalDragEnd: (details) async {
                            _endDx = _dx;
                            if (_progress <= 0.8 ||
                                widget.onSubmit == null) {
                              _cancelAnimation();
                            } else {
                              await _resizeAnimation();
                              await _shrinkAnimation();
                              await _checkAnimation();
                              await widget.onSubmit?.call();
                              await reset();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(
                                  widget.borderRadius),
                              color: widget.innerColor ??
                                  Theme.of(context)
                                      .primaryIconTheme
                                      .color,
                              child: Container(
                                padding: EdgeInsets.all(
                                    widget.sliderButtonIconPadding),
                                child: Transform.rotate(
                                  angle: -2 * pi * _progress, // Full circular rotation
                                  child: Center(
                                    child: widget.sliderButtonIcon ??
                                        Icon(
                                          Icons.arrow_forward,
                                          size:
                                          widget.sliderButtonIconSize,
                                          color: widget.outerColor ??
                                              Theme.of(context)
                                                  .colorScheme.secondary,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dx = (_dx + details.delta.dx).clamp(0.0, _maxDx);
    });
  }

  Future reset() async {
    await _checkAnimationController.reverse();
    submitted = false;
    await _shrinkAnimationController.reverse();
    await _resizeAnimationController.reverse();
    await _cancelAnimation();
  }

  Future _checkAnimation() async {
    _checkAnimationController.reset();

    final animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _checkAnimationController,
      curve: Curves.slowMiddle,
    ));

    animation.addListener(() {
      if (mounted) {
        setState(() {
          _checkAnimationDx = animation.value;
        });
      }
    });
    await _checkAnimationController.forward();
  }

  Future _shrinkAnimation() async {
    _shrinkAnimationController.reset();

    final diff = _initialContainerWidth! - widget.height;
    final animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _shrinkAnimationController,
      curve: Curves.easeOutCirc,
    ));

    animation.addListener(() {
      if (mounted) {
        setState(() {
          _containerWidth = _initialContainerWidth! - (diff * animation.value);
        });
      }
    });

    setState(() {
      submitted = true;
    });
    await _shrinkAnimationController.forward();
  }

  Future _resizeAnimation() async {
    _resizeAnimationController.reset();

    final animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _resizeAnimationController,
      curve: Curves.easeInBack,
    ));

    animation.addListener(() {
      if (mounted) {
        setState(() {
          _dz = 1 - animation.value;
        });
      }
    });
    await _resizeAnimationController.forward();
  }

  Future _cancelAnimation() async {
    _cancelAnimationController.reset();
    final animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _cancelAnimationController,
      curve: Curves.fastOutSlowIn,
    ));

    animation.addListener(() {
      if (mounted) {
        setState(() {
          _dx = (_endDx - (_endDx * animation.value));
        });
      }
    });
    _cancelAnimationController.forward();
  }

  @override
  void initState() {
    super.initState();

    _cancelAnimationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _checkAnimationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _shrinkAnimationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _resizeAnimationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final RenderBox containerBox =
      _containerKey.currentContext!.findRenderObject() as RenderBox;
      _containerWidth = containerBox.size.width;
      _initialContainerWidth = _containerWidth;

      final RenderBox sliderBox =
      _sliderKey.currentContext!.findRenderObject() as RenderBox;
      final sliderWidth = sliderBox.size.width;

      _maxDx = _containerWidth! -
          (sliderWidth / 2) -
          40 -
          widget.sliderButtonYOffset;
    });
  }

  @override
  void dispose() {
    _cancelAnimationController.dispose();
    _checkAnimationController.dispose();
    _shrinkAnimationController.dispose();
    _resizeAnimationController.dispose();
    super.dispose();
  }
}
