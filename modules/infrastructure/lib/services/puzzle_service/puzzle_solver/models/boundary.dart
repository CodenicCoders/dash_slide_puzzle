import 'package:domain/domain.dart';

/// {@template Boundary}
///
/// A rectangle boundary created by using two [Position]s for defining the
/// lesser bound and higher bound.
///
/// Comparison between the [lesserBound] and the [higherBound] is done via
/// [Position.compareTo].
///
/// {@endtemplate}
class Boundary with EquatableMixin {
  /// {@macro Boundary}
  Boundary({required this.lesserBound, required this.higherBound})
      : assert(
          lesserBound.compareTo(higherBound) == -1,
          'Lesser bound must be less than the higher bound',
        );

  /// The smallest of the two bounds. This should be less than the
  /// [higherBound].
  final Position lesserBound;

  /// The highest of the two bounds. This should be greater than the
  /// [lesserBound].
  final Position higherBound;

  @override
  List<Object?> get props => [lesserBound, higherBound];
}
