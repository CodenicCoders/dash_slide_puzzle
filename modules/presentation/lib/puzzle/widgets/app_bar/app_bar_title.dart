import 'package:flutter/material.dart';
import 'package:presentation/assets/assets.dart';
import 'package:simple_shadow/simple_shadow.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SimpleShadow(
            offset: Offset.zero,
            child: Image.asset(LogoAssets.flutter, scale: 6),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SimpleShadow(offset: Offset.zero, child: const Text('Dash')),
              SimpleShadow(
                offset: Offset.zero,
                child: const Text('Slide Puzzle'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
