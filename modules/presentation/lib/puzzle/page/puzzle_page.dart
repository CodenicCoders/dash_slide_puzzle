import 'package:application/application.dart' as app;
import 'package:presentation/presentation.dart';

class PuzzlePage extends StatelessWidget {
  const PuzzlePage();

  @override
  Widget build(BuildContext context) {
    return BlocListener<app.WatchGameStateUseCase, app.WatcherState>(
      listenWhen: (oldState, newState) =>
          newState is app.WatchDataReceived<app.GameState>,
      listener: _onWatchGameState,
      child: PuzzleKeyboardHandler(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const AppBarTitle(),
            actions: const [
              SizedBox(width: 16),
              ShareActionItem(),
              SizedBox(width: 16),
              VolumeActionItem(),
              SizedBox(width: 16),
              MenuButton(),
              SizedBox(width: 16),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: const FloatingActionButtons(),
          body: BackgroundRenderer(
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final gameState =
                      context.watch<app.WatchGameStateUseCase>().rightEvent;

                  if (gameState == null) {
                    return Container();
                  }

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(height: 16),
                        Expanded(child: SpellHandler()),
                        Expanded(
                          flex: 3,
                          child: DashAnimatorGroupControl(),
                        ),
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: PuzzleBoardGroupLayout(),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Center(child: StartGameButton()),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onWatchGameState(BuildContext context, app.WatcherState state) {
    if (state is app.WatchDataReceived<app.GameState>) {
      final gameStatus = state.rightEvent.status;

      if (gameStatus == app.GameStatus.botWon ||
          gameStatus == app.GameStatus.playerWon) {
        ShareAppDialog.show(context: context);
      }
    }
  }
}
