import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:splittrip/features/parties/data/party_repository.dart';
import 'package:splittrip/features/parties/screens/home_screen.dart';
import 'package:splittrip/features/parties/state/parties_controller.dart';

/// Full new flow: New Party → add participants → Next → add an expense →
/// Calculate → Save, against an in-memory repository.
void main() {
  late PartyRepository repo;

  setUp(() => repo = InMemoryPartyRepository());

  Widget app() => ProviderScope(
        overrides: [partyRepositoryProvider.overrideWithValue(repo)],
        child: const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: HomeScreen(),
        ),
      );

  Future<void> addParticipant(WidgetTester tester, String name) async {
    // Participant input is the 2nd field on the participants screen
    // (1st is the party name).
    await tester.enterText(find.byType(TextField).at(1), name);
    await tester.tap(find.byIcon(LucideIcons.plus));
    await tester.pumpAndSettle();
  }

  testWidgets('build a party end to end and save', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    // New party → participants screen.
    await tester.tap(find.text('New Party'));
    await tester.pumpAndSettle();
    expect(find.text('NEW PARTY'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Shashlyky 2026');
    await tester.pumpAndSettle();

    await addParticipant(tester, 'Ann');
    await addParticipant(tester, 'Bob');
    expect(find.text('Ann'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);

    // Next → expenses screen.
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Screen 2 fields: [0] party name, [1] expense title, [2] amount.
    // Add a 600 expense paid by Ann, split among everyone.
    await tester.enterText(find.byType(TextField).at(2), '600');
    await tester.tap(find.text('Paid by')); // empty payer button
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: find.byType(Dialog), matching: find.text('Ann')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save')); // composer save
    await tester.pumpAndSettle();

    expect(find.text('600 ₴'), findsWidgets);

    // Calculate.
    await tester.tap(find.text('Calculate'));
    await tester.pumpAndSettle();

    expect(find.text('CALCULATION'), findsOneWidget);
    // Bob → Ann, 300 ₴.
    expect(find.text('Ann'), findsWidgets);
    expect(find.text('Bob'), findsWidgets);
    expect(find.text('300 ₴'), findsWidgets);

    // Save → back to Home.
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('CALCULATION'), findsNothing);
    expect(find.text('SAVED PARTIES'), findsOneWidget);
    expect(find.text('Shashlyky 2026'), findsOneWidget);

    // Persistence.
    expect(repo.getDraft(), isNull);
    expect(repo.getCompleted().length, 1);
    final saved = repo.getCompleted().single;
    expect(saved.name, 'Shashlyky 2026');
    expect(saved.participants.length, 2);
    expect(saved.expenses.length, 1);
    expect(saved.expenses.single.amount, 600);
  });

  testWidgets('Save without a payer opens the payer picker, then saves',
      (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tester.tap(find.text('New Party'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Trip');
    await tester.pumpAndSettle();
    await addParticipant(tester, 'Ann');
    await addParticipant(tester, 'Bob');

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Enter an amount but deliberately do NOT choose a payer.
    await tester.enterText(find.byType(TextField).at(2), '600');
    await tester.pumpAndSettle();

    // Tapping Save with no payer opens the picker directly (no inline error).
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);
    expect(
      find.descendant(of: find.byType(Dialog), matching: find.text('Ann')),
      findsOneWidget,
    );

    // Choosing a payer closes the picker and completes the save.
    await tester.tap(
      find.descendant(of: find.byType(Dialog), matching: find.text('Ann')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);
    expect(find.text('600 ₴'), findsWidgets);
    expect(repo.getDraft()?.expenses.length, 1);
  });

  testWidgets('starting a new party while a draft exists asks to confirm',
      (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tester.tap(find.text('New Party'));
    await tester.pumpAndSettle();
    expect(find.text('NEW PARTY'), findsOneWidget);

    await tester.tap(find.byIcon(LucideIcons.arrowLeft));
    await tester.pumpAndSettle();
    expect(find.text('CURRENT PARTY'), findsOneWidget);

    await tester.tap(find.text('New Party'));
    await tester.pumpAndSettle();
    expect(find.text('Start a new party?'), findsOneWidget);
    expect(find.text('Current draft will be deleted.'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('NEW PARTY'), findsNothing);
  });
}
