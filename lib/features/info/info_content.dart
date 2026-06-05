import '../../core/app_info.dart';

/// Long-form copy for the About / Privacy / Terms screens.
///
/// Kept as plain Dart strings (not ARB) because paragraphs read better here and
/// don't fit gen_l10n well. Selected by language code, English as fallback.

String aboutBody(String lang) => lang == 'uk' ? _aboutUk : _aboutEn;
String privacyBody(String lang) => lang == 'uk' ? _privacyUk : _privacyEn;
String termsBody(String lang) => lang == 'uk' ? _termsUk : _termsEn;

const _aboutEn = '''
$kAppName is a minimalist calculator for shared expenses among friends.

Create a party, add who paid for what, and the app instantly works out the fairest set of transfers — the fewest payments needed to settle up.

Everything works offline and is stored only on your device. No accounts, no sign-up, no ads.

Version $kAppVersion
Made with Flutter.''';

const _aboutUk = '''
$kAppName — мінімалістичний калькулятор спільних витрат для друзів.

Створіть тусовку, додайте, хто за що платив — і застосунок миттєво порахує найсправедливіший набір переказів: мінімум платежів, щоб усі розрахувались.

Усе працює офлайн і зберігається лише на вашому пристрої. Без акаунтів, без реєстрації, без реклами.

Версія $kAppVersion
Зроблено на Flutter.''';

const _privacyEn = '''
$kAppName is an offline-first app. It does not collect, store, or transmit any personal data.

The data you enter — party names, participants, expenses and calculations — is stored only on your device, locally. It never leaves your device and is not sent to us or to any third party.

The app has no accounts, no analytics, no advertising and no trackers, and it makes no network requests. It requires no special device permissions.

Because no data is collected, there is nothing for us to access, export, or delete. Deleting the app removes all of its data from your device.

This app is suitable for general audiences.

Questions about this policy: $kSupportEmail

Last updated: 30 May 2026.''';

const _privacyUk = '''
$kAppName — це офлайн-застосунок. Він не збирає, не зберігає й не передає жодних персональних даних.

Дані, які ви вводите — назви тусовок, учасники, витрати й розрахунки — зберігаються лише на вашому пристрої, локально. Вони не залишають пристрій і не надсилаються нам чи будь-яким третім сторонам.

У застосунку немає акаунтів, аналітики, реклами чи трекерів, і він не виконує жодних мережевих запитів. Він не потребує спеціальних дозволів пристрою.

Оскільки дані не збираються, з нашого боку немає до чого отримувати доступ, що експортувати чи видаляти. Видалення застосунку прибирає всі його дані з вашого пристрою.

Застосунок призначений для широкої аудиторії.

Питання щодо політики: $kSupportEmail

Оновлено: 30 травня 2026 р.''';

const _termsEn = '''
By using $kAppName you agree to these terms.

The app helps you split shared expenses and suggests who should pay whom. All calculations are provided for your convenience and for informational purposes only. You are responsible for verifying the amounts and for any actual money transfers between people.

The app is provided “as is”, without warranties of any kind. To the maximum extent permitted by law, the developer is not liable for any losses, disputes, or damages arising from use of the app or reliance on its calculations.

All data is stored locally on your device. You are responsible for your device and your data; uninstalling the app or losing your device may permanently delete your saved calculations.

We may update the app and these terms from time to time.

Last updated: 30 May 2026.''';

const _termsUk = '''
Користуючись $kAppName, ви погоджуєтесь із цими умовами.

Застосунок допомагає ділити спільні витрати та підказує, хто кому має заплатити. Усі розрахунки надаються для зручності та лише в інформаційних цілях. Ви самостійно відповідаєте за перевірку сум і за фактичні перекази коштів між людьми.

Застосунок надається «як є», без жодних гарантій. У межах, дозволених законом, розробник не несе відповідальності за будь-які збитки, спори чи шкоду, що виникли внаслідок використання застосунку чи покладання на його розрахунки.

Усі дані зберігаються локально на вашому пристрої. Ви відповідаєте за свій пристрій і свої дані; видалення застосунку чи втрата пристрою можуть назавжди знищити збережені розрахунки.

Ми можемо час від часу оновлювати застосунок і ці умови.

Оновлено: 30 травня 2026 р.''';
