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
  final VoidCallback? onAnalyzeTap;
  final VoidCallback? onChatMiaTap;
  final VoidCallback? onARTap;
  final VoidCallback? onClosetTap;
  final VoidCallback? onDiscoverTap;

  const QuickActionGrid({
    super.key,
    this.onAnalyzeTap,
    this.onChatMiaTap,
    this.onARTap,
    this.onClosetTap,
    this.onDiscoverTap,
  });

  List<QuickActionItem> get _items => [
    QuickActionItem(
      label: 'Scent\nMatch',
      imagePath: 'assets/images/scent.png',
      iconColor: AppColors.accentCyan,
      onTap: onAnalyzeTap,
    ),
    QuickActionItem(
      label: 'Discover',
      imagePath: 'assets/images/discover.png',
      iconColor: const Color(0xFF7DD3FC),
      onTap: onDiscoverTap,
    ),
    QuickActionItem(
      label: 'AR Mode',
      imagePath: 'assets/images/ar.png',
      iconColor: AppColors.accentCyan,
      onTap: onARTap,
    ),
    QuickActionItem(
      label: 'ChatMia',
      imagePath: 'assets/images/chat_mia.png',
      iconColor: AppColors.accentGold,
      onTap: onChatMiaTap,
    ),
    QuickActionItem(
      label: 'My Closet',
      imagePath: 'assets/images/closet.png',
      iconColor: AppColors.accentOrange,
      onTap: onClosetTap,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (int i = 0; i < _items.length; i++) ...[
            _QuickActionButton(item: _items[i]),
            if (i != _items.length - 1) const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final QuickActionItem item;
  const _QuickActionButton({required this.item});

  @override
  Widget build(BuildContext context) {
    const iconSize = 40.0;
    return SizedBox(
      width: 70,
      height: 96,
      child: GestureDetector(
        onTap: item.onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: iconSize,
              height: iconSize,
              child: item.imagePath != null
                  ? Image.asset(
                      item.imagePath!,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image_not_supported_rounded,
                          color: item.iconColor ?? AppColors.accentCyan,
                          size: iconSize,
                        );
                      },
                    )
                  : Icon(
                      item.icon ?? Icons.circle_rounded,
                      color: item.iconColor ?? AppColors.accentCyan,
                      size: iconSize,
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              item.label,
              style: AppTextStyles.iconLabel.copyWith(fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
