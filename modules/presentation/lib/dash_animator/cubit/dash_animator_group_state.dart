part of 'dash_animator_group_cubit.dart';

class DashAnimatorGroupState with EquatableMixin {
  const DashAnimatorGroupState(
      {required this.playerDashAttire, required this.botDashAttire});

  factory DashAnimatorGroupState.generate() => DashAnimatorGroupState(
        playerDashAttire: DashAttire.generate([DashBody.wizardRobe]),
        botDashAttire: DashAttire.generate([DashBody.wizardRobe]),
      );

  final DashAttire playerDashAttire;
  final DashAttire botDashAttire;

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

class DashAttire with EquatableMixin {
  const DashAttire({required this.dashBody, required this.dashDevice});

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

  final DashBody dashBody;
  final DashDevice dashDevice;

  DashAttire randomize() =>
      DashAttire.generate([dashBody, DashBody.wizardRobe], [dashDevice]);

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
