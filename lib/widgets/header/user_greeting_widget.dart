import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class UserGreetingWidget extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String subtitle;
  const UserGreetingWidget({
    super.key,
    required this.avatarUrl,
    required this.name,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar with subtle glow ring
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.accentPurple, AppColors.accentBlue],
            ),
          ),
          child: ClipOval(
            child: Image.asset(
              avatarUrl,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.cardBg,
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Hi, $name!', style: AppTextStyles.greeting),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextStyles.greetingSub,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
