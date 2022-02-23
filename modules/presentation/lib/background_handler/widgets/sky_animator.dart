import 'dart:async';

import 'package:application/application.dart' as app;
import 'package:flutter/services.dart';
import 'package:presentation/presentation.dart';
import 'package:rive/rive.dart';

/// {@template SkyAnimator}
///
/// A widget for creating an animated sky background.
///
/// {@endtemplate}
class SkyAnimator extends StatefulWidget {
  /// {@macro SkyAnimator}
  const SkyAnimator({required this.orientation, Key? key}) : super(key: key);

  /// The orientation of the screen used to determine the appropriate sky
  /// background that will be used.
  final Orientation orientation;

  @override
  State<SkyAnimator> createState() => _SkyAnimatorState();
}

class _SkyAnimatorState extends State<SkyAnimator> {
  Artboard? _artboard;
  StateMachineController? _stateMachineController;
  SMIInput<double>? _changeThemeSMIInput;

  /// Prevents multiple [_syncAnimationTheme] from executing.
  bool _isAnimationThemeSyncing = false;

  @override
  void initState() {
    super.initState();
    _loadRiveAnimation();
  }

  Future<void> _loadRiveAnimation() async {
    final data = await rootBundle.load(SkyAnimations.riveFilePath);

    final riveFile = RiveFile.import(data);

    _artboard = riveFile.artboardByName(
      widget.orientation == Orientation.landscape
          ? SkyAnimations.landscapeArtboard
          : SkyAnimations.portraitArtboard,
    );

    _stateMachineController = StateMachineController.fromArtboard(
      _artboard!,
      'change_theme',
    );

    _changeThemeSMIInput = _stateMachineController!.findInput<double>('theme');

    _artboard!.addController(_stateMachineController!);

    if (!mounted) {
      return;
    }

    setState(() {});

    unawaited(_syncAnimationTheme());
  }

  /// Updates the animation's theme from one state to the next until its theme
  /// is synced with the app's current theme.
  ///
  /// This is done recursively to create a smooth theme transition.
  Future<void> _syncAnimationTheme() async {
    if (_isAnimationThemeSyncing) {
      return;
    }

    if (_changeThemeSMIInput == null) {
      return;
    }

    _isAnimationThemeSyncing = true;
    await syncRiveAnimationTheme(this, _changeThemeSMIInput!);
    _isAnimationThemeSyncing = false;
  }

  @override
  void dispose() {
    _stateMachineController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_artboard == null) {
      return Container();
    }

    return BlocListener<app.SwitchThemeUseCase, app.RunnerState>(
      listener: (context, state) => _syncAnimationTheme(),
      child: Rive(artboard: _artboard!, fit: BoxFit.cover),
    );
  }
}
