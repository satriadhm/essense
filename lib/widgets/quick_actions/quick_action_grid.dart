import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class QuickActionItem {
  final String label;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  const QuickActionItem({
    required this.label,
    required this.icon,
    this.iconColor,
    this.onTap,
  });
}

class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({super.key});

  static final List<QuickActionItem> _items = [
    QuickActionItem(
      label: 'Analyzer',
      icon: Icons.insights_rounded,
      iconColor: AppColors.accentBlue,
    ),
    QuickActionItem(
      label: 'Chat Mia!',
      icon: Icons.chat_bubble_rounded,
      iconColor: const Color(0xFF60A5FA),
    ),
    QuickActionItem(
      label: 'Augmented\nReality',
      icon: Icons.view_in_ar_rounded,
      iconColor: AppColors.accentPurple,
    ),
    QuickActionItem(
      label: 'Your Closet',
      icon: Icons.layers_rounded,
      iconColor: const Color(0xFF7DD3FC),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (int i = 0; i < _items.length; i++)
          Flexible(
            flex: 1,
            child: _QuickActionButton(item: _items[i]),
          ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final QuickActionItem item;
  const _QuickActionButton({required this.item});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = (constraints.maxWidth - 8).clamp(48.0, 72.0);
        return GestureDetector(
          onTap: item.onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: size,
                height: size,
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(AppRadius.icon),
              border: Border.all(color: AppColors.cardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: (item.iconColor ?? AppColors.accentPurple)
                      .withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
                padding: EdgeInsets.all((size * 0.17).clamp(8.0, 12.0)),
                child: Icon(
                  item.icon,
                  color: item.iconColor ?? AppColors.accentPurple,
                  size: (size * 0.44).clamp(24.0, 32.0),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.label,
                style: AppTextStyles.iconLabel,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
