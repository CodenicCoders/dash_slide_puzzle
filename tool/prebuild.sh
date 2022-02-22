#!/bin/sh

# Cleans and refetches all dependencies in preparation for an app build.

flutter clean
flutter pub get modules/domain
flutter pub get modules/infrastructure
flutter pub get modules/application
flutter pub get modules/presentation
flutter pub get