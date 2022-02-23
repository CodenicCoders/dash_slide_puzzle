import 'package:get_it/get_it.dart';

export 'package:flutter/material.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:get_it/get_it.dart';

export 'assets/assets.dart';
export 'audio_handler/audio_handler.dart';
export 'background_handler/background_handler.dart';
export 'constants/constants.dart';
export 'dash_animator/dash_animator.dart';
export 'helpers/helpers.dart';
export 'l10n/app_localizations.dart';
export 'main_app.dart';
export 'puzzle/puzzle.dart';
export 'spell_handler/spell_handler.dart';
export 'themes/themes.dart';

/// Provides access to all service components of the system.
final serviceLocator = GetIt.instance;
