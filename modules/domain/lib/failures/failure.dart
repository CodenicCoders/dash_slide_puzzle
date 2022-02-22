import 'package:equatable/equatable.dart';

/// {@template Failure}
///
/// The base failure object returned when an exception occurrs.
///
/// Failures are adapters for exceptions to decouple the presentation layer
/// from the infra layer.
///
/// {@endtemplate}
class Failure with EquatableMixin {
  /// {@macro Failure}
  const Failure({this.message = "Something went wrong! We're looking into it"});

  /// User-friendly message often displayed to the user.
  ///
  /// Keep this message less than or equal to 60 characters.
  final String message;

  @override
  List<Object> get props => [message];
}
