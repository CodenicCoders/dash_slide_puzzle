import 'package:domain/service_interfaces/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:mocktail/mocktail.dart';

class MockLogger extends Mock implements CodenicLogger {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  group(
    '$AudioServiceImpl',
    () {
      late MockLogger logger;
      late AudioService audioService;

      setUp(() async {
        logger = MockLogger();
        audioService = AudioServiceImpl(logger: logger);
      });

      group(
        'playLocalAudio',
        () {
          test(
            'should play audio',
            () {},
          );
        },
      );
    },
  );
}
