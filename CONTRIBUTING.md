# Contributing to the Package

👍🎉 First off, thanks for taking the time to contribute! 🎉👍

The following is a set of guidelines for contributing to this package. These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

## Proposing a Change

If you intend to change the public API, or make any non-trivial changes to the implementation, we recommend filing an issue. This lets us reach an agreement on your proposal before you put significant effort into it.

If you’re only fixing a bug, it’s fine to submit a pull request right away but we still recommend to file an issue detailing what you’re fixing. This is helpful in case we don’t accept that specific fix but want to keep track of the issue.

## Creating a Pull Request

Before creating a pull request please:

1. Fork the repository and create your branch from `master`.
2. Install all dependencies (`dart pub get`).
3. Squash your commits and ensure you have a meaningful commit message.
4. If you’ve fixed a bug or added code that should be tested, add tests and ensure at 100% test coverage. (`flutter test --coverage --test-randomize-ordering-seed random && genhtml coverage/lcov.info --output=coverage`).
   - Flutter command is used for better reliability
   - You can use [Coverage Gutters](https://marketplace.visualstudio.com/items?itemName=ryanluker.vscode-coverage-gutters) in VSCode to check the coverage report
5. Ensure the test suite passes.
6. If you've changed the public API, make sure to update/add documentation.
7. Format your code (`dart format .`).
8. Analyze your code (`dart analyze --fatal-infos --fatal-warnings .`).
9. Verify you code for perfect Pub score (`pana . --no-warning`).
   - See <https://pub.dev/packages/pana>
10. Create the Pull Request.
11. Verify that all status checks are passing.

While the prerequisites above must be satisfied prior to having your pull request reviewed, the reviewer(s) may ask you to complete additional design work, tests, or other changes before your pull request can be ultimately accepted.

## Getting in Touch

If you want to just ask a question or get feedback on an idea you email at <dominicorga@gmail.com>.

## License

By contributing to Equatable, you agree that your contributions will be licensed under its MIT license.

## Attribution

This contributing guide is adapted from Felix Angelov's [Equatable Package](https://github.com/felangel/equatable), available at <https://github.com/felangel/equatable/blob/master/CONTRIBUTING.md>
