import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class DeviceCartridgeCombinedCard extends StatefulWidget {
  final int batteryPercent;
  final int cartridgeVolumePercent;
  final ValueChanged<bool>? onConnectToggle;

  const DeviceCartridgeCombinedCard({
    super.key,
    required this.batteryPercent,
    required this.cartridgeVolumePercent,
    this.onConnectToggle,
  });

  @override
  State<DeviceCartridgeCombinedCard> createState() =>
      _DeviceCartridgeCombinedCardState();
}

class _DeviceCartridgeCombinedCardState
    extends State<DeviceCartridgeCombinedCard> {
  bool _isConnected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      decoration: BoxDecoration(
        gradient: AppGradients.deviceCard,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.borderCyan.withValues(alpha: 0.5)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/images/device.png',
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StatBlock(
                value: widget.batteryPercent,
                label: 'Battery Life',
                color: AppColors.accentOrange,
                valueFontSize: 28,
              ),
              const SizedBox(height: 8),
              _StatBlock(
                value: widget.cartridgeVolumePercent,
                label: 'Cartridge Level',
                color: AppColors.accentGold,
                valueFontSize: 16,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Connect',
                    style: AppTextStyles.cardSub.copyWith(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    height: 28,
                    child: Switch(
                      value: _isConnected,
                      onChanged: (value) {
                        setState(() => _isConnected = value);
                        widget.onConnectToggle?.call(value);
                      },
                      activeThumbColor: Colors.white,
                      activeTrackColor: AppColors.accentOrange,
                      inactiveThumbColor: const Color(0xFF9CA3AF),
                      inactiveTrackColor: const Color(0xFF4B5563),
                      trackOutlineColor: WidgetStateProperty.resolveWith(
                        (states) => Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  final int value;
  final String label;
  final Color color;
  final double valueFontSize;

  const _StatBlock({
    required this.value,
    required this.label,
    required this.color,
    required this.valueFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$value',
                style: AppTextStyles.percentLarge.copyWith(
                  color: color,
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: '%',
                style: AppTextStyles.cardSub.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Text(
          label,
          style: AppTextStyles.cardSub.copyWith(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
