import 'package:domain/domain.dart';

/// {@template MuteAllAudioUseCase}
///
/// A use case for muting all audio players.
///
/// See [AudioService.muteAll].
///
/// {@endtemplate}
class MuteAllAudioUseCase extends Runner<void, Failure, void> {
  /// {@macro MuteAllAudioUseCase}
  MuteAllAudioUseCase({required AudioService audioService})
      : _audioService = audioService;

  final AudioService _audioService;

  @override
  Future<Either<Failure, void>> onCall(void params) => _audioService.muteAll();
}
