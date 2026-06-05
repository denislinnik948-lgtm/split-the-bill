// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get splashTagline => 'Shared expenses, settled.';

  @override
  String get homeCurrentParty => 'Current party';

  @override
  String get homeNewParty => 'New Party';

  @override
  String get homeSavedParties => 'Saved parties';

  @override
  String get homeSavedEmpty => 'Saved calculations will appear here.';

  @override
  String participantsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count participants',
      one: '1 participant',
    );
    return '$_temp0';
  }

  @override
  String expensesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count expenses',
      one: '1 expense',
      zero: 'No expenses',
    );
    return '$_temp0';
  }

  @override
  String get editPartyTitle => 'NEW PARTY';

  @override
  String get partyNameHint => 'Party name';

  @override
  String get participantsSection => 'PARTICIPANTS';

  @override
  String get noParticipants => 'No participants yet.';

  @override
  String get addParticipant => 'Add Participant';

  @override
  String get addAction => 'Add';

  @override
  String get nextAction => 'Next';

  @override
  String get splitForAll => 'For all';

  @override
  String splitForSome(int count) {
    return 'For $count';
  }

  @override
  String get payerLabel => 'Paid by';

  @override
  String get payerRequired => 'Choose who paid';

  @override
  String get payerTitle => 'Who paid?';

  @override
  String get splitTitle => 'Split among';

  @override
  String get doneAction => 'Done';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get total => 'Total';

  @override
  String get calculate => 'Calculate';

  @override
  String get participantTitleNew => 'NEW PARTICIPANT';

  @override
  String get participantTitleEdit => 'PARTICIPANT';

  @override
  String get participantNameHint => 'Participant name';

  @override
  String get expensesSection => 'EXPENSES';

  @override
  String get noExpenses => 'No expenses yet.';

  @override
  String get addExpense => 'Add Expense';

  @override
  String get save => 'Save';

  @override
  String get expenseTitleHint => 'Title';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get amountInvalid => 'Enter a positive amount';

  @override
  String get deleteParticipantTitle => 'Delete participant?';

  @override
  String get deleteParticipantMessage => 'All expenses will be removed.';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get create => 'Create';

  @override
  String get calculationTitle => 'CALCULATION';

  @override
  String get participantsLabel => 'Participants';

  @override
  String get perPerson => 'Per person';

  @override
  String get settledUp => 'Everyone is settled up.';

  @override
  String get newPartyDialogTitle => 'Start a new party?';

  @override
  String get newPartyDialogMessage => 'Current draft will be deleted.';

  @override
  String get deleteCalculationTitle => 'Delete calculation?';

  @override
  String get deleteCalculationMessage => 'This action cannot be undone.';

  @override
  String get untitledParty => 'Untitled party';

  @override
  String get shareTotal => 'Total';

  @override
  String get sharePerPerson => 'Per Person';

  @override
  String get copied => 'Copied';

  @override
  String get infoTitle => 'INFORMATION';

  @override
  String get aboutItem => 'About';

  @override
  String get privacyItem => 'Privacy Policy';

  @override
  String get termsItem => 'Terms of Use';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }
}
