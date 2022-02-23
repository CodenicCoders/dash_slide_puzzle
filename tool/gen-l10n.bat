:: Regenerates the localization file in the Presentation layer

@echo off

cd modules\presentation && ^
flutter gen-l10n --arb-dir=assets\l10n --output-dir=lib\l10n --no-synthetic-package