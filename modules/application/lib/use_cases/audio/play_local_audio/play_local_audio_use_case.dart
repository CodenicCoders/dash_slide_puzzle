import 'package:domain/domain.dart';

/// {@template PlayLocalAudioUseCase}
///
/// A use case for playing an audio file stored locally.
///
/// See [AudioService.playLocalAudio].
///
/// {@endtemplate}
class PlayLocalAudioUseCase
    extends Runner<PlayLocalAudioParams, Failure, void> {
  /// {@macro PlayLocalAudioUseCase}
  PlayLocalAudioUseCase({required AudioService audioService})
      : _audioService = audioService;

  final AudioService _audioService;

  @override
  Future<Either<Failure, void>> onCall(PlayLocalAudioParams params) =>
      _audioService.playLocalAudio(
        localFilePath: params.audioFilePath,
        audioPlayerChannel: params.audioPlayerChannel,
      );
}

/// {@template PlayLocalAudioParams}
///
/// The parameters for the [PlayLocalAudioUseCase].
///
/// {@endtemplate}
class PlayLocalAudioParams with EquatableMixin {
  /// {@macro PlayLocalAudioParams}
  const PlayLocalAudioParams({
    required this.audioFilePath,
    required this.audioPlayerChannel,
  });

  /// The path to the audio file to play.
  final String audioFilePath;

  /// The audio player channel to use.
  final dynamic audioPlayerChannel;

  @override
  List<Object?> get props => [audioFilePath];
}
