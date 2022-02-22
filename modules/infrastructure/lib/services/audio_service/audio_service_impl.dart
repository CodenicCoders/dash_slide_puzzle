import 'dart:async';

import 'package:domain/domain.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/subjects.dart';

class AudioServiceImpl implements AudioService {
  AudioServiceImpl({
    required CodenicLogger logger,
    this.maxAudioPlayerChannels = 5,
  }) : _logger = logger;

  final CodenicLogger _logger;
  final int maxAudioPlayerChannels;

  final _lastUsedAudioPlayerChannels = <dynamic>[];
  final _audioPlayers = <dynamic, AudioPlayer>{};

  final _allMutedSubject = BehaviorSubject<bool>()..add(false);

  @override
  Future<Either<Failure, VerboseStream<Failure, bool>>>
      watchAllMutedState() async {
    final verboseStream = VerboseStream<Failure, bool>(
      errorConverter: (error, stackTrace) {
        if (error is Error) throw error;

        return const Failure();
      },
      stream: _allMutedSubject,
    );

    return Right(verboseStream);
  }

  Future<AudioPlayer> _audioPlayer(dynamic audioPlayerChannel) async {
    // Add the [audioPlayerChannel] in [_lastUsedAudioPlayerChannels] at the
    // end of the list
    _lastUsedAudioPlayerChannels
      ..remove(audioPlayerChannel)
      ..add(audioPlayerChannel);

    // Remove and dispose the oldest [audioPlayerChannel] when the the total
    // active [audioPlayerChannel] exceeds [maxAudioPlayerChannels]
    if (_lastUsedAudioPlayerChannels.length > maxAudioPlayerChannels) {
      final dynamic oldestAudioPlayerChannel = _lastUsedAudioPlayerChannels[0];

      final poppedAudioPlayer = _audioPlayers.remove(oldestAudioPlayerChannel);
      unawaited(poppedAudioPlayer?.dispose());

      _lastUsedAudioPlayerChannels.remove(oldestAudioPlayerChannel);
    }

    // Create the [AudioPlayer] for the channel if none has been created yet
    if (!_audioPlayers.containsKey(audioPlayerChannel)) {
      _audioPlayers[audioPlayerChannel] = AudioPlayer();
    }

    final audioPlayer = _audioPlayers[audioPlayerChannel]!;

    // Ensure that the audio player is muted if all audio players are muted

    if (_allMutedSubject.value && audioPlayer.volume > 0) {
      await audioPlayer.setVolume(0);
    }

    return audioPlayer;
  }

  Future<Either<Failure, void>> playLocalAudio({
    required String localFilePath,
    dynamic audioPlayerChannel,
  }) async {
    final messageLog = MessageLog(
      id: '$AudioServiceImpl-playLocalAudio',
      data: <String, dynamic>{
        'localFilePath': localFilePath,
        'audioPlayerChannel': audioPlayerChannel,
      },
    );

    final audioPlayer = await _audioPlayer(audioPlayerChannel);

    await audioPlayer.setAsset(localFilePath);
    await audioPlayer.play();

    _logger.info(
      messageLog
        ..message = 'Success'
        ..data['volume'] = audioPlayer.volume,
    );

    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> muteAll() async {
    final messageLog = MessageLog(id: '$AudioServiceImpl-muteAll');

    await Future.wait([
      for (final audioPlayer in _audioPlayers.values) audioPlayer.setVolume(0)
    ]);

    _allMutedSubject.add(true);

    _logger.info(messageLog..message = 'Success');

    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> unmuteAll() async {
    final messageLog = MessageLog(id: '$AudioServiceImpl-unmuteAll');

    await Future.wait([
      for (final audioPlayer in _audioPlayers.values) audioPlayer.setVolume(1)
    ]);

    _allMutedSubject.add(false);

    _logger.info(messageLog..message = 'Success');

    return const Right(null);
  }
}
