import 'dart:core';

import 'package:domain/domain.dart';

/// A service for playing audio.
abstract class AudioService {
  /// Plays a locally stored audio referenced by the [localFilePath].
  ///
  /// A specific audio player can be selected via the [audioPlayerChannel].
  ///
  /// If the [localFilePath] does not point to an audio file or
  /// [audioPlayerChannel] does not reference any audio player, then an
  /// [ArgumentError] will be thrown.
  Future<Either<Failure, void>> playLocalAudio({
    required String localFilePath,
    dynamic audioPlayerChannel,
  });

  /// A stream that returns `true` when all audio players are muted. Otherwise, 
  /// `false` is returned.
  Future<Either<Failure, VerboseStream<Failure, bool>>> watchAllMutedState();

  /// Mutes all the audio player channels.
  Future<Either<Failure, void>> muteAll();

  /// Unmutes all the audio player channels.
  Future<Either<Failure, void>> unmuteAll();
}
