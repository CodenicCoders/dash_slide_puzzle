import 'package:domain/domain.dart';

/// {@template UnmuteAllAudioUseCase}
///
/// A use case for muting all audio players.
///
/// See [AudioService.unmuteAll].
///
/// {@endtemplate}
class UnmuteAllAudioUseCase extends Runner<void, Failure, void> {
  /// {@macro UnmuteAllAudioUseCase}
  UnmuteAllAudioUseCase({required AudioService audioService})
      : _audioService = audioService;

  final AudioService _audioService;

  @override
  Future<Either<Failure, void>> onCall(void params) =>
      _audioService.unmuteAll();
}
