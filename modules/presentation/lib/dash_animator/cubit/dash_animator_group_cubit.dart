import 'dart:math';

import 'package:application/application.dart';
import 'package:presentation/presentation.dart';

part 'dash_animator_group_state.dart';

class DashAnimatorGroupCubit extends Cubit<DashAnimatorGroupState> {
  DashAnimatorGroupCubit() : super(DashAnimatorGroupState.generate());

  void changePlayerDashAttire() => emit(
        state.copyWith(playerDashAttire: state.playerDashAttire.randomize()),
      );

  void changeBotDashAttire() => emit(
        state.copyWith(botDashAttire: state.botDashAttire.randomize()),
      );
}
