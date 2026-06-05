import 'package:flutter/widgets.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// One onboarding page: an icon, a title and a short description.
class OnboardingPage {
  const OnboardingPage({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;
}

/// The onboarding deck, localized by [languageCode] (English as fallback).
List<OnboardingPage> onboardingPages(String languageCode) =>
    languageCode == 'uk' ? _uk : _en;

const List<OnboardingPage> _en = [
  OnboardingPage(
    icon: LucideIcons.receipt,
    title: 'Split the Bill',
    body: 'Settle shared expenses with friends — no awkward maths, '
        'no arguments.',
  ),
  OnboardingPage(
    icon: LucideIcons.users,
    title: 'Add your crew',
    body: 'Create a party and add everyone who is chipping in.',
  ),
  OnboardingPage(
    icon: LucideIcons.plus,
    title: 'Log expenses',
    body: 'For each expense pick who paid and who it is split between.',
  ),
  OnboardingPage(
    icon: LucideIcons.arrowRight,
    title: 'See who owes whom',
    body: 'Get the smallest set of transfers to settle up. '
        'Everything stays on your device.',
  ),
];

const List<OnboardingPage> _uk = [
  OnboardingPage(
    icon: LucideIcons.receipt,
    title: 'Split the Bill',
    body: 'Діліть спільні витрати з друзями — без незручної математики '
        'й суперечок.',
  ),
  OnboardingPage(
    icon: LucideIcons.users,
    title: 'Додайте компанію',
    body: 'Створіть тусовку та впишіть усіх, хто скидається.',
  ),
  OnboardingPage(
    icon: LucideIcons.plus,
    title: 'Записуйте витрати',
    body: 'Для кожної витрати оберіть, хто платив і між ким ділити.',
  ),
  OnboardingPage(
    icon: LucideIcons.arrowRight,
    title: 'Хто кому винен',
    body: 'Отримайте мінімум переказів, щоб усі розрахувались. '
        'Усе лишається на вашому пристрої.',
  ),
];
