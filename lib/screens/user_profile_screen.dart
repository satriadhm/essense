import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class UserProfileScreen extends StatelessWidget {
  final bool showBottomNav;

  const UserProfileScreen({super.key, this.showBottomNav = true});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenHorizontal,
              AppSpacing.headerTop + 16,
              AppSpacing.screenHorizontal,
              24,
            ),
            child: Column(
              children: [
                // Avatar
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.accentPurple, AppColors.accentBlue],
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/avatar.png',
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 96,
                        height: 96,
                        color: AppColors.cardBg,
                        child: const Icon(
                          Icons.person_rounded,
                          size: 48,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Monica',
                  style: AppTextStyles.greeting.copyWith(fontSize: 28),
                ),
                const SizedBox(height: 4),
                Text(
                  'Paris, France',
                  style: AppTextStyles.greetingSub.copyWith(
                    fontStyle: FontStyle.normal,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfileTile(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  onTap: () {},
                ),
                _ProfileTile(
                  icon: Icons.notifications_rounded,
                  label: 'Notifications',
                  onTap: () {},
                ),
                _ProfileTile(
                  icon: Icons.favorite_rounded,
                  label: 'Favorites',
                  onTap: () {},
                ),
                _ProfileTile(
                  icon: Icons.history_rounded,
                  label: 'Activity History',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: AppSpacing.navBarHeight + AppSpacing.navBarBottom + 24,
          ),
        ),
      ],
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.cardBg.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(
                color: AppColors.cardBorder.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.textSecondary, size: 22),
                const SizedBox(width: 14),
                Text(
                  label,
                  style: AppTextStyles.cardTitle.copyWith(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
