#!/bin/sh

# FOR MAC OS AND LINUX SYSTEMS

# This script does the following:
# - Cleans the project
# - Refetches all dependencies

flutter clean
flutter pub get modules/domain
flutter pub get modules/infrastructure
flutter pub get modules/application
flutter pub get modules/presentation
flutter pub get
