part of 'dash_animator_group_cubit.dart';

/// {@template DashAnimatorGroupState}
///
/// The state class for the [DashAnimatorGroupCubit].
///
/// {@endtemplate}
class DashAnimatorGroupState with EquatableMixin {
  /// {@macro DashAnimatorGroupState}
  const DashAnimatorGroupState({
    required this.playerDashAttire,
    required this.botDashAttire,
  });

  /// Creates a [DashAnimatorGroupState] with default values.
  factory DashAnimatorGroupState.generate() => DashAnimatorGroupState(
        playerDashAttire: DashAttire.generate([DashBody.wizardRobe]),
        botDashAttire: DashAttire.generate([DashBody.wizardRobe]),
      );

  /// The attire of the player Dash.
  final DashAttire playerDashAttire;

  /// The attire of the bot Dash.
  final DashAttire botDashAttire;

  /// Creates a copy of this [DashAnimatorGroupState] but with the given fields
  /// replaced with the new values.
  DashAnimatorGroupState copyWith({
    DashAttire? playerDashAttire,
    DashAttire? botDashAttire,
  }) {
    return DashAnimatorGroupState(
      playerDashAttire: playerDashAttire ?? this.playerDashAttire,
      botDashAttire: botDashAttire ?? this.botDashAttire,
    );
  }

  @override
  List<Object> get props => [playerDashAttire, botDashAttire];
}

/// {@template DashAttire}
///
/// A class containing Dash's accessories such as its clothing and device.
///
/// {@endtemplate}
class DashAttire with EquatableMixin {
  /// {@macro DashAttire}
  const DashAttire({required this.dashBody, required this.dashDevice});

  /// Creates a [DashAttire] with default values.
  factory DashAttire.generate([
    List<DashBody>? excludedDashBodies,
    List<DashDevice>? excludedDashDevices,
  ]) {
    final dashBody = _randomizeDashBody(excludedDashBodies);
    final dashDevice = _randomizedDashDevice(excludedDashDevices);

    return DashAttire(dashBody: dashBody, dashDevice: dashDevice);
  }

  static DashBody _randomizeDashBody([List<DashBody>? excludedDashBodies]) =>
      _randomize(DashBody.values, excludedDashBodies);

  static DashDevice _randomizedDashDevice([
    List<DashDevice>? excludedDashDevices,
  ]) =>
      _randomize(DashDevice.values, excludedDashDevices);

  static T _randomize<T extends Object?>(
    List<T> objects,
    List<T>? excludedObjects,
  ) {
    final objectsCopy = objects.toList();

    if (excludedObjects != null && excludedObjects.isNotEmpty) {
      objectsCopy.removeWhere((obj) => excludedObjects.contains(obj));
    }

    final randomIndex = Random().nextInt(objectsCopy.length);
    return objectsCopy[randomIndex];
  }

  /// The clothing of Dash.
  final DashBody dashBody;

  /// The device of Dash.
  final DashDevice dashDevice;

  /// Creates a randomized [DashAttire] with non-repeating clothing and device.
  DashAttire randomize() =>
      DashAttire.generate([dashBody, DashBody.wizardRobe], [dashDevice]);

  /// Creates a copy of this [DashAttire] but with the given fields
  /// replaced with the new values.
  DashAttire copyWith({
    DashBody? dashBody,
    DashDevice? dashDevice,
  }) {
    return DashAttire(
      dashBody: dashBody ?? this.dashBody,
      dashDevice: dashDevice ?? this.dashDevice,
    );
  }

  @override
  List<Object> get props => [dashBody, dashDevice];
}
