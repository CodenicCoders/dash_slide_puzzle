import 'package:domain/domain.dart';

/// Contains all the possible status of game.
enum GameStatus {
  /// A status wherein the game has not started yet.
  notStarted,

  /// A status that the game is being initialized.
  initializing,

  /// A status the the puzzles are being shuffled.
  shuffling,

  /// A status the the game is in progress.
  playing,

  /// A status that the player has won.
  playerWon,

  /// A status that the bot has won.
  botWon,
}

/// {@template GameState}
///
/// A class containing the state of the game.
///
/// {@endtemplate}
class GameState with EquatableMixin {
  /// {@macro GameState}
  GameState({
    this.status = GameStatus.notStarted,
    Puzzle? playerPuzzle,
    Puzzle? botPuzzle,
  })  : playerPuzzle = playerPuzzle ?? Puzzle.defaults(),
        botPuzzle = botPuzzle ?? Puzzle.defaults();

  /// The status of the game.
  final GameStatus status;

  /// The player's puzzle.
  final Puzzle playerPuzzle;

  /// The bot's puzzle.
  final Puzzle botPuzzle;

  /// The dimension of the player and the bot puzzles.
  int get puzzleDimension => playerPuzzle.dimension;

  /// Creates a copy of this [GameState] but with the given fields
  /// replaced with the new values.
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
