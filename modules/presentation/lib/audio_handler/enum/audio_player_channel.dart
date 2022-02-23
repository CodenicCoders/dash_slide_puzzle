/// All available channels for playing an audio.
///
/// Add more audio player channels here when needed.
enum AudioPlayerChannel {
  /// The audio channel for UI clicks.
  click,

  /// The audio channel used when the puzzle is tapped.
  puzzleTile,

  /// The audio channel shared by the player and bot Dash.
  dashAnimatorGroup,

  /// The audio channel dedicated for the player Dash.
  playerDash,

  /// The audio channel dedicated for the bot Dash.
  botDash,

  /// The audio channel for general game sounds.
  game,

  /// The audio channel when a spell is available.
  spellAvailable,
}
