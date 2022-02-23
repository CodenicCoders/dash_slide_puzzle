import 'dart:math';

import 'package:presentation/dash_animator/widgets/dash_animator_group/bot_dash_animator.dart';
import 'package:presentation/dash_animator/widgets/dash_animator_group/player_dash_animator.dart';
import 'package:presentation/presentation.dart';

/// {@template DashAnimatorGroup}
///
/// A widget for providing the layout for the [BotDashAnimator] and
/// [PlayerDashAnimator].
///
/// {@endtemplate}
class DashAnimatorGroup extends StatefulWidget {
  /// {@macro DashAnimatorGroup}
  const DashAnimatorGroup({this.areDashAttireCustomizable = true, Key? key})
      : super(key: key);

  /// If `true`, then tapping on the player or bot Dash will customize their
  /// attire. Otherwise, the Dashes are not customizable.
  final bool areDashAttireCustomizable;

  @override
  State<DashAnimatorGroup> createState() => _DashAnimatorGroupState();
}

class _DashAnimatorGroupState extends State<DashAnimatorGroup> {
  /// A reference to the [BotDashAnimator] so that the [PlayerDashAnimator] can
  /// throw objects to it.
  final _botDashAnimatorKey = GlobalKey<DashAnimatorState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width <= Breakpoints.small ? 0 : 32,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: GestureDetector(
                    onTap: widget.areDashAttireCustomizable
                        ? _onPlayerDashTapped
                        : null,
                    child: PlayerDashAnimator(
                      dashAnimatorKey: _botDashAnimatorKey,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: widget.areDashAttireCustomizable
                      ? _onBotDashTapped
                      : null,
                  child: BotDashAnimator(dashAnimatorKey: _botDashAnimatorKey),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Customizes the player Dash's attire when tapped.
  void _onPlayerDashTapped() =>
      context.read<DashAnimatorGroupCubit>().changePlayerDashAttire();

  /// Customized the bot Dash's attire when tapped.
  void _onBotDashTapped() =>
      context.read<DashAnimatorGroupCubit>().changeBotDashAttire();
}
