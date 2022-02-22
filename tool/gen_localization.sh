#!/bin/sh

# Regenerates the localization file in the Presentation layer
# Call this within the Presentation layer.

flutter gen-l10n --arb-dir=assets/l10n --output-dir=lib/l10n --no-synthetic-package