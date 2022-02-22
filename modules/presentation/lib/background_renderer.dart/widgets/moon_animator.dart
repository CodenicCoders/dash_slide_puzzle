import 'dart:math';

import 'package:application/application.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/assets/assets.dart';

class MoonAnimator extends StatefulWidget {
  const MoonAnimator({Key? key}) : super(key: key);

  @override
  State<MoonAnimator> createState() => _MoonAnimatorState();
}

class _MoonAnimatorState extends State<MoonAnimator>
    with SingleTickerProviderStateMixin {
  late final _rotationAnimation =
      AnimationController(vsync: this, duration: const Duration(seconds: 15))
        ..repeat();

  @override
  void dispose() {
    _rotationAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.select<app.SwitchThemeUseCase, app.ThemeOption>(
      (useCase) => useCase.rightValue,
    );

    final Alignment alignment;
    final double opacity;

    switch (theme) {
      case app.ThemeOption.day:
        alignment = Alignment.bottomCenter;
        opacity = 0;
        break;
      case app.ThemeOption.prevening:
        alignment = Alignment.bottomCenter;
        opacity = 0;
        break;
      case app.ThemeOption.night:
        alignment = Alignment.center;
        opacity = 1;
    }

    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 300),
      child: AnimatedAlign(
        alignment: alignment,
        duration: const Duration(milliseconds: 300),
        child: AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value * 2 * pi,
              child: child,
            );
          },
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Image.asset(BackgroundAssets.moon),
          ),
        ),
      ),
    );
  }
}
