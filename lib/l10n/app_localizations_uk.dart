// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get splashTagline => 'Спільні витрати, без зайвого.';

  @override
  String get homeCurrentParty => 'Поточна тусовка';

  @override
  String get homeNewParty => 'Нова тусовка';

  @override
  String get homeSavedParties => 'Збережені';

  @override
  String get homeSavedEmpty => 'Тут з’являться збережені розрахунки.';

  @override
  String participantsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count учасника',
      many: '$count учасників',
      few: '$count учасники',
      one: '$count учасник',
    );
    return '$_temp0';
  }

  @override
  String expensesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count витрати',
      many: '$count витрат',
      few: '$count витрати',
      one: '$count витрата',
      zero: 'Без витрат',
    );
    return '$_temp0';
  }

  @override
  String get editPartyTitle => 'НОВА ТУСОВКА';

  @override
  String get partyNameHint => 'Назва тусовки';

  @override
  String get participantsSection => 'УЧАСНИКИ';

  @override
  String get noParticipants => 'Поки що немає учасників.';

  @override
  String get addParticipant => 'Додати учасника';

  @override
  String get addAction => 'Додати';

  @override
  String get nextAction => 'Далі';

  @override
  String get splitForAll => 'Для всіх';

  @override
  String splitForSome(int count) {
    return 'Для $count';
  }

  @override
  String get payerLabel => 'Платник';

  @override
  String get payerRequired => 'Оберіть платника';

  @override
  String get payerTitle => 'Хто платив?';

  @override
  String get splitTitle => 'Ділити між';

  @override
  String get doneAction => 'Готово';

  @override
  String get onboardingSkip => 'Пропустити';

  @override
  String get onboardingStart => 'Почати';

  @override
  String get total => 'Разом';

  @override
  String get calculate => 'Розрахувати';

  @override
  String get participantTitleNew => 'НОВИЙ УЧАСНИК';

  @override
  String get participantTitleEdit => 'УЧАСНИК';

  @override
  String get participantNameHint => 'Ім’я учасника';

  @override
  String get expensesSection => 'ВИТРАТИ';

  @override
  String get noExpenses => 'Поки що немає витрат.';

  @override
  String get addExpense => 'Додати витрату';

  @override
  String get save => 'Зберегти';

  @override
  String get expenseTitleHint => 'Назва';

  @override
  String get nameRequired => 'Вкажіть ім’я';

  @override
  String get amountInvalid => 'Введіть додатну суму';

  @override
  String get deleteParticipantTitle => 'Видалити учасника?';

  @override
  String get deleteParticipantMessage => 'Усі витрати буде видалено.';

  @override
  String get delete => 'Видалити';

  @override
  String get cancel => 'Скасувати';

  @override
  String get create => 'Створити';

  @override
  String get calculationTitle => 'РОЗРАХУНОК';

  @override
  String get participantsLabel => 'Учасники';

  @override
  String get perPerson => 'На особу';

  @override
  String get settledUp => 'Усі розрахувалися.';

  @override
  String get newPartyDialogTitle => 'Почати нову тусовку?';

  @override
  String get newPartyDialogMessage => 'Поточну чернетку буде видалено.';

  @override
  String get deleteCalculationTitle => 'Видалити розрахунок?';

  @override
  String get deleteCalculationMessage => 'Цю дію не можна скасувати.';

  @override
  String get untitledParty => 'Без назви';

  @override
  String get shareTotal => 'Разом';

  @override
  String get sharePerPerson => 'На особу';

  @override
  String get copied => 'Скопійовано';

  @override
  String get infoTitle => 'ІНФОРМАЦІЯ';

  @override
  String get aboutItem => 'Про застосунок';

  @override
  String get privacyItem => 'Політика конфіденційності';

  @override
  String get termsItem => 'Умови використання';

  @override
  String versionLabel(String version) {
    return 'Версія $version';
  }
}
