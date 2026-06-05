import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
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
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
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
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('uk')
  ];

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Shared expenses, settled.'**
  String get splashTagline;

  /// No description provided for @homeCurrentParty.
  ///
  /// In en, this message translates to:
  /// **'Current party'**
  String get homeCurrentParty;

  /// No description provided for @homeNewParty.
  ///
  /// In en, this message translates to:
  /// **'New Party'**
  String get homeNewParty;

  /// No description provided for @homeSavedParties.
  ///
  /// In en, this message translates to:
  /// **'Saved parties'**
  String get homeSavedParties;

  /// No description provided for @homeSavedEmpty.
  ///
  /// In en, this message translates to:
  /// **'Saved calculations will appear here.'**
  String get homeSavedEmpty;

  /// No description provided for @participantsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 participant} other{{count} participants}}'**
  String participantsCount(int count);

  /// No description provided for @expensesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No expenses} =1{1 expense} other{{count} expenses}}'**
  String expensesCount(int count);

  /// No description provided for @editPartyTitle.
  ///
  /// In en, this message translates to:
  /// **'NEW PARTY'**
  String get editPartyTitle;

  /// No description provided for @partyNameHint.
  ///
  /// In en, this message translates to:
  /// **'Party name'**
  String get partyNameHint;

  /// No description provided for @participantsSection.
  ///
  /// In en, this message translates to:
  /// **'PARTICIPANTS'**
  String get participantsSection;

  /// No description provided for @noParticipants.
  ///
  /// In en, this message translates to:
  /// **'No participants yet.'**
  String get noParticipants;

  /// No description provided for @addParticipant.
  ///
  /// In en, this message translates to:
  /// **'Add Participant'**
  String get addParticipant;

  /// No description provided for @addAction.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addAction;

  /// No description provided for @nextAction.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextAction;

  /// No description provided for @splitForAll.
  ///
  /// In en, this message translates to:
  /// **'For all'**
  String get splitForAll;

  /// No description provided for @splitForSome.
  ///
  /// In en, this message translates to:
  /// **'For {count}'**
  String splitForSome(int count);

  /// No description provided for @payerLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid by'**
  String get payerLabel;

  /// No description provided for @payerRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose who paid'**
  String get payerRequired;

  /// No description provided for @payerTitle.
  ///
  /// In en, this message translates to:
  /// **'Who paid?'**
  String get payerTitle;

  /// No description provided for @splitTitle.
  ///
  /// In en, this message translates to:
  /// **'Split among'**
  String get splitTitle;

  /// No description provided for @doneAction.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneAction;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingStart;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @calculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calculate;

  /// No description provided for @participantTitleNew.
  ///
  /// In en, this message translates to:
  /// **'NEW PARTICIPANT'**
  String get participantTitleNew;

  /// No description provided for @participantTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'PARTICIPANT'**
  String get participantTitleEdit;

  /// No description provided for @participantNameHint.
  ///
  /// In en, this message translates to:
  /// **'Participant name'**
  String get participantNameHint;

  /// No description provided for @expensesSection.
  ///
  /// In en, this message translates to:
  /// **'EXPENSES'**
  String get expensesSection;

  /// No description provided for @noExpenses.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet.'**
  String get noExpenses;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @expenseTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get expenseTitleHint;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @amountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a positive amount'**
  String get amountInvalid;

  /// No description provided for @deleteParticipantTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete participant?'**
  String get deleteParticipantTitle;

  /// No description provided for @deleteParticipantMessage.
  ///
  /// In en, this message translates to:
  /// **'All expenses will be removed.'**
  String get deleteParticipantMessage;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @calculationTitle.
  ///
  /// In en, this message translates to:
  /// **'CALCULATION'**
  String get calculationTitle;

  /// No description provided for @participantsLabel.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participantsLabel;

  /// No description provided for @perPerson.
  ///
  /// In en, this message translates to:
  /// **'Per person'**
  String get perPerson;

  /// No description provided for @settledUp.
  ///
  /// In en, this message translates to:
  /// **'Everyone is settled up.'**
  String get settledUp;

  /// No description provided for @newPartyDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Start a new party?'**
  String get newPartyDialogTitle;

  /// No description provided for @newPartyDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Current draft will be deleted.'**
  String get newPartyDialogMessage;

  /// No description provided for @deleteCalculationTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete calculation?'**
  String get deleteCalculationTitle;

  /// No description provided for @deleteCalculationMessage.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteCalculationMessage;

  /// No description provided for @untitledParty.
  ///
  /// In en, this message translates to:
  /// **'Untitled party'**
  String get untitledParty;

  /// No description provided for @shareTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get shareTotal;

  /// No description provided for @sharePerPerson.
  ///
  /// In en, this message translates to:
  /// **'Per Person'**
  String get sharePerPerson;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @infoTitle.
  ///
  /// In en, this message translates to:
  /// **'INFORMATION'**
  String get infoTitle;

  /// No description provided for @aboutItem.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutItem;

  /// No description provided for @privacyItem.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyItem;

  /// No description provided for @termsItem.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsItem;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLabel(String version);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
