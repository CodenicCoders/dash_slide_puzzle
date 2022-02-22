import 'package:codenic_bloc_use_case/codenic_bloc_use_case.dart';

/// An extension for the `dartz` [Either] class.
extension EitherExtension<L, R> on Either<L, R> {

  /// Returns the [R] value.
  /// 
  /// If there is no [R] value, then a [StateError] will be thrown.
  R getRight() => fold((l) => throw StateError(l.toString()), (r) => r);
  
  /// Returns the [L] value.
  /// 
  /// If there is no [L] value, then a [StateError] will be thrown.
  L getLeft() => fold((l) => l, (r) => throw StateError(r.toString()));
}
