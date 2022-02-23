import 'dart:math';

import 'package:application/application.dart';
import 'package:presentation/presentation.dart';

part 'dash_animator_group_state.dart';

/// {@template DashAnimatorGroupCubit}
///
/// A cubit for managing the state of the Dashes in [DashAnimatorGroup].
///
/// {@endtemplate}
class DashAnimatorGroupCubit extends Cubit<DashAnimatorGroupState> {
  /// {@macro DashAnimatorGroupCubit}
  DashAnimatorGroupCubit() : super(DashAnimatorGroupState.generate());

  /// Generates a random attire for the player Dash.
  void changePlayerDashAttire() => emit(
        state.copyWith(playerDashAttire: state.playerDashAttire.randomize()),
      );

  /// Generates a random attire for the bot Dash.
  void changeBotDashAttire() => emit(
        state.copyWith(botDashAttire: state.botDashAttire.randomize()),
      );
}
