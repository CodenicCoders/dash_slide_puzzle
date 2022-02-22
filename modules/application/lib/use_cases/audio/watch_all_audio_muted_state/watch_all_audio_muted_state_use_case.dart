import 'package:domain/domain.dart';

/// {@template WatchAllAudioMutedStateUseCase}
///
/// A use case for watching whether all audios are muted or not.
///
/// See [AudioService.watchAllMutedState].
///
/// {@endtemplate}
class WatchAllAudioMutedStateUseCase extends Watcher<void, Failure,
    VerboseStream<Failure, bool>, Failure, bool> {
  /// {@macro WatchAllAudioMutedStateUseCase}
  WatchAllAudioMutedStateUseCase({required AudioService audioService})
      : _audioService = audioService;

  final AudioService _audioService;

  @override
  bool get rightEvent => super.rightEvent ?? false;

  @override
  Future<Either<Failure, VerboseStream<Failure, bool>>> onCall(void params) =>
      _audioService.watchAllMutedState();
}
