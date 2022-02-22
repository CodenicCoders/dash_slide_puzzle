import 'package:application/application.dart';

/// A use case for checking whether to preview the completed puzzle.
class PreviewCompletedPuzzleUseCase extends Runner<void, void, bool> {
  @override
  bool get rightValue => super.rightValue ?? false;

  @override
  Future<Either<void, bool>> onCall(void params) async => Right(!rightValue);
}
