import 'package:application/application.dart' as app;
import 'package:flutter/services.dart';
import 'package:presentation/presentation.dart';
import 'package:rive/rive.dart';

/// {@template PuzzlePreviewButton}
///
/// A floating action button for previewing the player's puzzle in its
/// completed state.
///
/// {@endtemplate}
class PuzzlePreviewButton extends StatefulWidget {
  /// {@macro PuzzlePreviewButton}
  const PuzzlePreviewButton({Key? key}) : super(key: key);

  @override
  State<PuzzlePreviewButton> createState() => _PuzzlePreviewButtonState();
}

class _PuzzlePreviewButtonState extends State<PuzzlePreviewButton> {
  Artboard? _artboard;
  StateMachineController? _stateMachineController;
  SMIInput<double>? _changeThemeSMIInput;

  bool _isAnimationThemeSyncing = false;

  @override
  void initState() {
    super.initState();

    rootBundle.load(PuzzleBoardAnimations.riveFilePath).then((data) {
      final riveFile = RiveFile.import(data);

      _artboard = riveFile.artboardByName('main');

      _stateMachineController =
          StateMachineController.fromArtboard(_artboard!, 'change_theme');

      _changeThemeSMIInput =
          _stateMachineController!.findInput<double>('theme');

      _artboard!.addController(_stateMachineController!);

      setState(() {});

      _syncAnimationTheme();
    });
  }

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
    final shouldPreview =
        context.select<app.PreviewCompletedPuzzleUseCase, bool>(
      (useCase) => useCase.rightValue,
    );

    final size = shouldPreview ? 160.0 : 48.0;

    return BlocListener<app.SwitchThemeUseCase, app.RunnerState>(
      listener: (context, state) => _syncAnimationTheme(),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _artboard != null
            ? Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AnimatedContainer(
                    height: size,
                    width: size,
                    duration: const Duration(milliseconds: 200),
                    child: Stack(
                      children: [
                        Rive(
                          artboard: _artboard!,
                          fit: BoxFit.cover,
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(onTap: _onTap),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ),
    );
  }

  void _onTap() =>
      context.read<app.PreviewCompletedPuzzleUseCase>().run(params: null);
}
