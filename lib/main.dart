import 'package:dash_slide_puzzle/injection_container/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:presentation/presentation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeInjectionContainer();

  runApp(const MainApp());
}
