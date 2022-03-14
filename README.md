[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
![GitHub](https://img.shields.io/github/license/CodenicCoders/dash_slide_puzzle)

Prepare to fight Dash in a no-holds-barred Slider Puzzle! Strategically use various skills to turn the tides in your favor.

This is a slide puzzle game created for the Flutter Puzzle Hack. A hackathon where developers are challenged to push their creativity and create the most visually appealing slide puzzle game using Flutter!

For more info on the Flutter Puzzle Hack, see https://flutter.dev/events/puzzle-hack.

<img width="792" alt="cover" src="https://user-images.githubusercontent.com/12520299/158085197-5b2a463b-dbda-4f18-9a1a-4bf1d46cf4f7.png">

## Features

This game allows you to:

- race with a bot in completing a slide puzzle.
- customize the game theme.
- customize your personal Dash and your opponent's Dash avatar.
- preview the Dash animator.

## "Try it out" links

**Apple App Store (Recommended for Apple Users)**

https://apps.apple.com/us/app/dash-slide-puzzle/id1612604096

**Google Play Store (Recommended for Android Users)**

https://play.google.com/store/apps/details?id=com.orga.dash_slide_puzzle

**Web**

https://slidepuzzle.codenic.dev

## Getting started

### flutter pub get

To get started, you need to call `flutter pub get`. However, since this application uses a [code architecture](#about-the-code-architecture) with multiple submodules, you need to call `flutter pub get` in each of those modules. To simplify this process, just go to the project root folder, then execute:

For Mac or Linux:
```bash
tool/prebuild.sh
```

For Windows:
```bash
tool\prebuild.bat
```

### Generating app localization

App localization is stored in the `{root}/modules/presentation` submodule. To re-generate localization, navigate to the project root folder, then type:

For Mac or Linux:
```bash
tool/gen-l10n.sh
```

For Windows:
```bash
tool\gen-l10n.bat
```

## About the code architecture

This app is made up of multiple modules:
- presentation – Handles UI and user interaction
- application – Defines the use cases and orchestrates the data flow between the presentation and infrastructure
- domain – Contains core business rules and objects
- infrastructure – The app logic implementation

The code structure of the app is my take on the [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) which is heavily influenced by [Reso Coder](https://resocoder.com).

This uses my [codenic_bloc_use_case](https://pub.dev/packages/codenic_bloc_use_case) package to facilitate `use cases` within the application.
> `codenic_bloc_use_case` is an extension of the [bloc](https://pub.dev/packages/bloc) package that revolves around `Cubits` to create use cases with less boilerplate code.

To know more about the architecture, you can check out my Notion article – [Clean Architecture for Flutter](https://dominicorga.notion.site/Clean-Architecture-for-Flutter-cd1b2a9f1c6440eda1e67818b755d946).

## About the puzzle solver algorithm

The app uses 3 variants of the A* search algorithm for solving the opponent Dash's puzzle. This enables Dash to solve the puzzle EFFICIENTLY and FAST by following the technique presented by Bruno Marotta in his article [How to solve ANY slide puzzle regardless of its size](https://www.kopf.com.br/kaplof/how-to-solve-any-slide-puzzle-regardless-of-its-size/) for the most part.

To know more, you can read the code documentation for the `puzzle solver` here:
https://github.com/CodenicCoders/dash_slide_puzzle/tree/master/modules/infrastructure/lib/services/puzzle_service/puzzle_solver

For a printed demo of the search results, visit `test/puzzle_service_impl_test.dart` then uncomment and run the test group `demo`.
https://github.com/CodenicCoders/dash_slide_puzzle/blob/master/modules/infrastructure/test/puzzle_service_impl_test.dart

## About Me

To know more about this and my other projects, feel free to visit my portfolio at https://dominicorga.codenic.dev.
