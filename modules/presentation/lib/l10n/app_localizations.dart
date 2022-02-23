
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations returned
/// by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en')
  ];

  /// The app title displayed in the app bar
  ///
  /// In en, this message translates to:
  /// **'Dash\nSlide Puzzle'**
  String get appTitle;

  /// The general text title displayed in the share dialog
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get shareTitleGeneral;

  /// The text title displayed in the share dialog when the user lost
  ///
  /// In en, this message translates to:
  /// **'Better luck next time!'**
  String get shareTitleLost;

  /// The text title displayed in the share dialog when the user has won
  ///
  /// In en, this message translates to:
  /// **'You won!'**
  String get shareTitleWon;

  /// The description displayed in the share dialog
  ///
  /// In en, this message translates to:
  /// **'Share this puzzle to challenge your friends and see if they have what it takes to beat Dash'**
  String get shareDescription;

  /// The tooltip shown in the dropdown menu button
  ///
  /// In en, this message translates to:
  /// **'Show menu'**
  String get showMenuTooltip;

  /// The title for the keyboard shortcuts menu item
  ///
  /// In en, this message translates to:
  /// **'keyboard shortcuts'**
  String get keyboardShortcutsMenuItem;

  /// The title for the Dash animator preview menu item
  ///
  /// In en, this message translates to:
  /// **'Dash animator preview'**
  String get dashAnimatorPreviewMenuItem;

  /// The title for the tutorial menu item
  ///
  /// In en, this message translates to:
  /// **'Youtube tutorial'**
  String get tutorialMenuItem;

  /// The title for the Dash customization keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Customize Dash'**
  String get customizeDashKeyboardShortcutTitle;

  /// The title for the enemy Dash customization keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Customize enemy Dash'**
  String get customizeEnemyDashKeyboardShortcutTitle;

  /// The title for the theme change keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Change theme'**
  String get changeThemeKeyboardShortcutTitle;

  /// They keyboard shortcut symbol for theme changing
  ///
  /// In en, this message translates to:
  /// **'/'**
  String get changeThemeKeyboardShortcutKey;

  /// The title for the volume control keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'On/off volume'**
  String get volumeKeyboardShortcutTitle;

  /// They keyboard shortcut symbol for the volume control
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get volumeKeyboardShortcutKey;

  /// No description provided for @viewPuzzleReferenceKeyboardShortcutTitle.
  ///
  /// In en, this message translates to:
  /// **'View puzzle reference'**
  String get viewPuzzleReferenceKeyboardShortcutTitle;

  /// They keyboard shortcut symbol for viewing the puzzle reference
  ///
  /// In en, this message translates to:
  /// **'Z'**
  String get viewPuzzleReferenceKeyboardShortcutKey;

  /// The title for the game action keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Start/restart game'**
  String get gameActionKeyboardShortcutTitle;

  /// They keyboard shortcut symbol for starting or restarting the game
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get gameActionKeyboardShortcutKey;

  /// The title for in-game shortcuts keys in the keyboard shortcut dialog
  ///
  /// In en, this message translates to:
  /// **'In Game'**
  String get inGameKeyboardShortcutsTitle;

  /// The title for the tile upward move keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Move tile upward'**
  String get moveTileUpwardKeyboardShortcutTitle;

  /// The title for the tile downward move keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Move tile downward'**
  String get moveTileDownwardKeyboardShortcutTitle;

  /// The title for the tile left move keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Move tile to the left'**
  String get moveTileToTheLeftKeyboardShortcutTitle;

  /// The title for the tile right move keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Move tile to the right'**
  String get moveTileToTheRightKeyboardShortcutTitle;

  /// The title for the cast spell keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Cast spell'**
  String get castSpellKeyboardShortcutTitle;

  /// They keyboard shortcut symbol for casting a spell
  ///
  /// In en, this message translates to:
  /// **'Space'**
  String get castSpellKeyboardShortcutKey;

  /// The title for Dash Animator Preview shortcuts keys in the keyboard shortcut dialog
  ///
  /// In en, this message translates to:
  /// **'In Dash Animator Preview'**
  String get inDashAnimatorPreviewKeyboardShortcutsTitle;

  /// The title for Dash's idle pose keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Idle'**
  String get dashIdlePoseKeyboardShortcutTitle;

  /// They keyboard shortcut symbol for Dash's idle pose
  ///
  /// In en, this message translates to:
  /// **'`'**
  String get dashIdlePoseKeyboardShortcutKey;

  /// The title for Dash's happy pose keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get dashHappyPoseKeyboardShortcutTitle;

  /// They keyboard shortcut symbol for Dash's happy pose
  ///
  /// In en, this message translates to:
  /// **'1'**
  String get dashHappyPoseKeyboardShortcutKey;

  /// The title for Dash's toss pose keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Toss'**
  String get dashTossPoseKeyboardShortcutTitle;

  /// They keyboard shortcut symbol for Dash's toss pose
  ///
  /// In en, this message translates to:
  /// **'2'**
  String get dashTossPoseKeyboardShortcutKey;

  /// The title for Dash's taunt pose keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Taunt'**
  String get dashTauntPoseKeyboardShortcutTitle;

  /// They keyboard shortcut symbol for Dash's taunt pose
  ///
  /// In en, this message translates to:
  /// **'3'**
  String get dashTauntPoseKeyboardShortcutKey;

  /// The title for Dash's excited pose keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Excited'**
  String get dashExcitedPoseKeyboardShortcutTitle;

  /// They keyboard shortcut symbol for Dash's excited pose
  ///
  /// In en, this message translates to:
  /// **'4'**
  String get dashExcitedPoseKeyboardShortcutKey;

  /// The title for Dash's skepticism pose keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Skepticism'**
  String get dashSkepticismPoseKeyboardShortcutTitle;

  /// They keyboard shortcut symbol for Dash's skepticism pose
  ///
  /// In en, this message translates to:
  /// **'5'**
  String get dashSkepticismPoseKeyboardShortcutKey;

  /// The title for Dash's shocked pose keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Shocked'**
  String get dashShockedPoseKeyboardShortcutTitle;

  /// They keyboard shortcut symbol for Dash's shocked pose
  ///
  /// In en, this message translates to:
  /// **'6'**
  String get dashShockedPoseKeyboardShortcutKey;

  /// The title for Dash's lost pose keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Loser'**
  String get dashLostPoseKeyboardShortcutTitle;

  /// They keyboard shortcut symbol for Dash's lost pose
  ///
  /// In en, this message translates to:
  /// **'7'**
  String get dashLostPoseKeyboardShortcutKey;

  /// The title for Dash's wave pose keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Wave'**
  String get dashWavePoseKeyboardShortcutTitle;

  /// They keyboard shortcut symbol for Dash's wave pose
  ///
  /// In en, this message translates to:
  /// **'8'**
  String get dashWavePoseKeyboardShortcutKey;

  /// The title for Dash's spellcasting pose keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Spellcast'**
  String get dashCastSpellPoseKeyboardShortcutTitle;

  /// They keyboard shortcut symbol for Dash's spellcasting pose
  ///
  /// In en, this message translates to:
  /// **'9'**
  String get dashCastSpellPoseKeyboardShortcutKey;

  /// The title for Dash's wizard taunt pose keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Wizard taunt'**
  String get dashWizardTauntPoseKeyboardShortcutTitle;

  /// They keyboard shortcut symbol for Dash's wizard taunt pose
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get dashWizardTauntPoseKeyboardShortcutKey;

  /// The title for Dash's attire customization keyboard shortcut in the Dash animator preview
  ///
  /// In en, this message translates to:
  /// **'Customize Dash'**
  String get customizeDashAttireKeyboardShortcutTitle;

  /// They keyboard shortcut symbol for customizing Dash's attire in the Dash animator preview
  ///
  /// In en, this message translates to:
  /// **'Space'**
  String get customizeDashAttireKeyboardShortcutKey;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
