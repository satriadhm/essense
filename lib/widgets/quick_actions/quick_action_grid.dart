import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class QuickActionItem {
  final String label;
  final IconData? icon;
  final String? imagePath;
  final Color? iconColor;
  final VoidCallback? onTap;
  const QuickActionItem({
    required this.label,
    this.icon,
    this.imagePath,
    this.iconColor,
    this.onTap,
  });
}

class QuickActionGrid extends StatelessWidget {
  final VoidCallback? onAnalyzerTap;
  final VoidCallback? onChatMiaTap;
  final VoidCallback? onARTap;
  final VoidCallback? onClosetTap;

  const QuickActionGrid({
    super.key,
    this.onAnalyzerTap,
    this.onChatMiaTap,
    this.onARTap,
    this.onClosetTap,
  });

  List<QuickActionItem> get _items => [
    QuickActionItem(
      label: 'Analyzer',
      imagePath: 'assets/images/analysis.png',
      iconColor: AppColors.accentBlue,
      onTap: onAnalyzerTap,
    ),
    QuickActionItem(
      label: 'Chat Mia!',
      imagePath: 'assets/images/chat_mia.png',
      iconColor: const Color(0xFF60A5FA),
      onTap: onChatMiaTap,
    ),
    QuickActionItem(
      label: 'Augmented\nReality',
      imagePath: 'assets/images/check_cartridge.png',
      iconColor: AppColors.accentPurple,
      onTap: onARTap,
    ),
    QuickActionItem(
      label: 'Your Closet',
      imagePath: 'assets/images/closet.png',
      iconColor: const Color(0xFF7DD3FC),
      onTap: onClosetTap,
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
              SizedBox(
                width: size,
                height: size,
                child: item.imagePath != null
                    ? Image.asset(
                        item.imagePath!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback to icon if image fails to load
                          return Icon(
                            Icons.image_not_supported_rounded,
                            color: item.iconColor ?? AppColors.accentPurple,
                            size: size,
                          );
                        },
                      )
                    : Icon(
                        item.icon ?? Icons.circle_rounded,
                        color: item.iconColor ?? AppColors.accentPurple,
                        size: size,
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
