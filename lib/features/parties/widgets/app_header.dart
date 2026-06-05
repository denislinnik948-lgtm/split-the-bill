import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';

/// A minimal top bar: a back button on the left and optional trailing actions.
/// No title (screen titles are large headings in the body instead).
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    this.onBack,
    this.trailing = const [],
    this.showBack = true,
  });

  final VoidCallback? onBack;
  final List<Widget> trailing;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          if (showBack)
            _HeaderIconButton(
              icon: LucideIcons.arrowLeft,
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            )
          else
            const SizedBox(width: 8),
          const Spacer(),
          ...trailing,
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 22, color: AppColors.primaryText),
      splashRadius: 22,
    );
  }
}

/// A tappable icon for header trailing slots (share, delete, edit).
class HeaderAction extends StatelessWidget {
  const HeaderAction({super.key, required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 22, color: AppColors.primaryText),
      splashRadius: 22,
    );
  }
}
