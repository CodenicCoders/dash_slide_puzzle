import 'dart:math';

import 'package:flutter/material.dart';
import 'package:presentation/dash_animator/widgets/widgets.dart';

class TestAnimationPage extends StatefulWidget {
  const TestAnimationPage({Key? key}) : super(key: key);

  @override
  State<TestAnimationPage> createState() => _TestAnimationPageState();
}

class _TestAnimationPageState extends State<TestAnimationPage> {
  DashAnimationState animationState = DashAnimationState.idle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = min(constraints.maxWidth, constraints.maxHeight);

            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth),
              child: Column(
                children: [
                  Expanded(child: DashAnimator(animationState: animationState)),
                  const SizedBox(height: 60),
                  ElevatedButton(
                    onPressed: () => setState(
                        () => animationState = DashAnimationState.idle),
                    child: Text('idle'),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(
                        () => animationState = DashAnimationState.happy),
                    child: Text('happy'),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(
                        () => animationState = DashAnimationState.excited),
                    child: Text('excited'),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(
                        () => animationState = DashAnimationState.taunt),
                    child: Text('taunt'),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        setState(() => animationState = DashAnimationState.wtf),
                    child: Text('wtf'),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(
                        () => animationState = DashAnimationState.wtfff),
                    child: Text('wtfff'),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(
                        () => animationState = DashAnimationState.loser),
                    child: Text('loser'),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(
                        () => animationState = DashAnimationState.wave),
                    child: Text('wave'),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(
                        () => animationState = DashAnimationState.toss),
                    child: Text('toss'),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(
                        () => animationState = DashAnimationState.spellcast),
                    child: Text('Spellcast'),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(
                        () => animationState = DashAnimationState.wizardTaunt),
                    child: Text('Wizard taunt'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
