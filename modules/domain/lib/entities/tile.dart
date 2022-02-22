import 'package:domain/entities/position.dart';
import 'package:domain/entities/puzzle.dart';
import 'package:equatable/equatable.dart';

/// {@template Tile}
///
/// A tile within a [Puzzle].
///
/// {@endtemplate}
class Tile with EquatableMixin {
  /// {@macro Tile}
  const Tile({
    required this.currentPosition,
    required this.targetPosition,
    this.isWhitespace = false,
  });

  /// The current position of this tile within a [Puzzle].
  final Position currentPosition;

  /// The target position of this tile within a [Puzzle].
  final Position targetPosition;

  /// Indicates whether this tile is the whitespace tile in a [Puzzle].
  final bool isWhitespace;

  /// Returns `true` when the [currentPosition] has reached the
  /// [targetPosition]. Otherwise, `false` is returned.
  bool get isCompleted => targetPosition == currentPosition;

  /// Calculates the distance between the [currentPosition] and the
  /// [targetPosition].
  double get distanceToTargetPosition =>
      currentPosition.distance(targetPosition);

  /// Creates a copy of this [Tile] but with the given fields replaced with the
  /// new values.
  Tile copyWith({
    Position? currentPosition,
    Position? targetPosition,
    bool? isWhitespace,
  }) {
    return Tile(
      currentPosition: currentPosition ?? this.currentPosition,
      targetPosition: targetPosition ?? this.targetPosition,
      isWhitespace: isWhitespace ?? this.isWhitespace,
    );
  }

  @override
  List<Object> get props => [currentPosition, targetPosition, isWhitespace];
}
