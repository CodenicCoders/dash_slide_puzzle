import 'dart:math';

/// An extension for the [Duration] class.
extension DurationExtension on Duration {
  /// Sums this duration and the [other] duration.
  Duration add(Duration other) {
    final totalMicroseconds = inMicroseconds + other.inMicroseconds;
    return Duration(microseconds: totalMicroseconds);
  }

  /// Sums this duration with all the other [durations].
  Duration addAll(Iterable<Duration> durations) {
    final totalMicroseconds = durations.fold<int>(
      inMicroseconds,
      (previousTotal, duration) => previousTotal + duration.inMicroseconds,
    );

    return Duration(microseconds: totalMicroseconds);
  }

  /// Subtracts this duration with the [other] duration.
  ///
  /// If the new [Duration] equates to a negative value, then it will be set to
  /// [Duration.zero].
  Duration subtract(Duration other) {
    final totalMicroseconds = inMicroseconds - other.inMicroseconds;
    return totalMicroseconds < 0
        ? Duration.zero
        : Duration(microseconds: totalMicroseconds);
  }

  /// Subtracts this duration with the other [durations].
  ///
  /// If the new [Duration] equates to a negative value, then it will be set to
  /// [Duration.zero].
  Duration subtractAll(Iterable<Duration> durations) {
    final totalMicroseconds = durations.fold<int>(
      inMicroseconds,
      (previousTotal, duration) => previousTotal - duration.inMicroseconds,
    );

    return totalMicroseconds < 0
        ? Duration.zero
        : Duration(microseconds: totalMicroseconds);
  }

  /// Returns a random [Duration] between this and the [other] duration.
  Duration randomInBetween(Duration other) {
    final durationInMicro = inMicroseconds;
    final durationInMicroOther = other.inMicroseconds;

    final largerValue = max(durationInMicro, durationInMicroOther);
    final smallerValue = min(durationInMicro, durationInMicroOther);

    final newDurationInMicro =
        (largerValue - smallerValue) * Random().nextDouble() + smallerValue;

    return Duration(microseconds: newDurationInMicro.toInt());
  }

  /// Returns the mid [Duration] between this and the [other] duration.
  Duration inBetween(Duration other) {
    final durationInMicro = inMicroseconds;
    final durationInMicroOther = other.inMicroseconds;

    final largerValue = max(durationInMicro, durationInMicroOther);
    final smallerValue = min(durationInMicro, durationInMicroOther);

    final newDurationInMicro = (largerValue - smallerValue) + smallerValue;

    return Duration(microseconds: newDurationInMicro);
  }
}
