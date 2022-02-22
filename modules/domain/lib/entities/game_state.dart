import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';

enum GameStatus {
  notStarted,
  initializing,
  shuffling,
  playing,
  playerWon,
  botWon,
}

class GameState with EquatableMixin {
  GameState({
    this.status = GameStatus.notStarted,
    Puzzle? initialPuzzle,
    Puzzle? playerPuzzle,
    Puzzle? botPuzzle,
  })  : playerPuzzle = playerPuzzle ?? Puzzle.defaults(),
        botPuzzle = botPuzzle ?? Puzzle.defaults();

  final GameStatus status;
  final Puzzle playerPuzzle;
  final Puzzle botPuzzle;

  int get puzzleDimension => playerPuzzle.dimension;

  GameState copyWith({
    GameStatus? status,
    Puzzle? playerPuzzle,
    Puzzle? botPuzzle,
  }) {
    return GameState(
      status: status ?? this.status,
      playerPuzzle: playerPuzzle ?? this.playerPuzzle,
      botPuzzle: botPuzzle ?? this.botPuzzle,
    );
  }

  @override
  List<Object> get props => [status, playerPuzzle, botPuzzle];
}
