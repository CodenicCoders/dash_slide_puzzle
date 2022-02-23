import 'dart:async';

import 'package:application/application.dart' as app;
import 'package:flutter/services.dart';
import 'package:presentation/presentation.dart';
import 'package:rive/rive.dart';

/// {@template PuzzleTile}
///
/// The puzzle tile for the [PuzzleBoard].
///
/// {@endtemplate}
class PuzzleTile extends StatefulWidget {
  /// {@macro PuzzleTile}
  const PuzzleTile({
    required this.puzzle,
    required this.tile,
    this.isInteractive = false,
    this.isReactiveToSpells = false,
    Key? key,
  }) : super(key: key);

  /// The puzzle containing the [tile].
  final app.Puzzle puzzle;

  /// The [tile] represented by this widget.
  final app.Tile tile;

  /// If `true`, then the user can tap this tile to move it. Otherwise, if
  /// `false`, then this tile cannot be tapped.
  final bool isInteractive;

  /// If `true`, then this tile will receive a color tint respective to the
  /// active [app.Spell] from [app.WatchActiveSpellStateUseCase]. Otherwise, if
  /// `false` then this tile does not react to the active spell.
  final bool isReactiveToSpells;

  @override
  State<PuzzleTile> createState() => _PuzzleTileState();
}

class _PuzzleTileState extends State<PuzzleTile> {
  Artboard? _artboard;
  StateMachineController? _stateMachineController;
  SMIInput<double>? _changeThemeSMIInput;

  double _scale = 1;

  /// Prevents multiple [_syncAnimationTheme] from executing.
  bool _isAnimationThemeSyncing = false;

  @override
  void initState() {
    super.initState();
    _loadRiveAnimation();
  }

  Future<void> _loadRiveAnimation() async {
    final data = await rootBundle.load(PuzzleBoardAnimations.riveFilePath);

    final riveFile = RiveFile.import(data);

    _artboard = riveFile.artboardByName(
      PuzzleBoardAnimations.tileArtboard(widget.tile.targetPosition),
    );

    _stateMachineController =
        StateMachineController.fromArtboard(_artboard!, 'change_theme');

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
    final isMovable = context.select<app.WatchGameStateUseCase, bool>(
      (useCase) =>
          widget.isInteractive &&
          useCase.rightEvent.status == app.GameStatus.playing,
    );

    return BlocListener<app.SwitchThemeUseCase, app.RunnerState>(
      listener: (context, state) => _syncAnimationTheme(),
      child: AnimatedAlign(
        alignment: FractionalOffset(
          widget.tile.currentPosition.x / (widget.puzzle.dimension - 1),
          widget.tile.currentPosition.y / (widget.puzzle.dimension - 1),
        ),
        duration: const Duration(milliseconds: 300),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.maxWidth / widget.puzzle.dimension * 0.95;

            return GestureDetector(
              onTap: isMovable ? _onMoveTile : null,
              child: MouseRegion(
                onEnter:
                    isMovable ? (event) => setState(() => _scale = 0.9) : null,
                onExit:
                    isMovable ? (event) => setState(() => _scale = 1) : null,
                child: SizedBox.square(
                  dimension: size,
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 300),
                    scale: _scale,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      switchInCurve: Curves.easeOut,
                      transitionBuilder: (child, animation) => ScaleTransition(
                        scale: animation,
                        child: child,
                      ),
                      child: _artboard != null
                          ? widget.isReactiveToSpells
                              ? _SpellTint(child: Rive(artboard: _artboard!))
                              : Rive(artboard: _artboard!)
                          : null,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onMoveTile() {
    context.read<app.MovePlayerTileUseCase>().run(
          params: app.MovePlayerTileParams(
            tileCurrentPosition: widget.tile.currentPosition,
          ),
        );
  }
}

class _SpellTint extends StatelessWidget {
  const _SpellTint({required this.child, Key? key}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final activeSpell =
        context.select<app.WatchActiveSpellStateUseCase, app.Spell?>(
      (useCase) => useCase.rightEvent?.spell,
    );

    final Color? tintColor;

    switch (activeSpell) {
      case app.Spell.slow:
        tintColor = Colors.green.withOpacity(0.54);
        break;
      case app.Spell.stun:
        tintColor = Colors.black54;
        break;
      case app.Spell.timeReversal:
        tintColor = Colors.red.withOpacity(0.54);
        break;
      case null:
        tintColor = null;
        break;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: tintColor != null
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: tintColor,
                  ),
                )
              : null,
        )
      ],
    );
  }
}
