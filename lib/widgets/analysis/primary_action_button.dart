import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class PrimaryActionButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double height;

  const PrimaryActionButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.height = 56,
  });

  @override
  State<PrimaryActionButton> createState() => _PrimaryActionButtonState();
}

class _PrimaryActionButtonState extends State<PrimaryActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;
  bool _isPressed = false;

  bool get _canInteract =>
      widget.isEnabled && !widget.isLoading && widget.onPressed != null;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _pressController, curve: Curves.easeOut));
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _pressController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (!_canInteract) return;
    setState(() => _isPressed = true);
    _pressController.forward();
  }

  void _onTapUp(TapUpDetails _) {
    if (!_canInteract) return;
    _pressController.reverse();
    setState(() => _isPressed = false);
    Future<void>.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        widget.onPressed?.call();
      }
    });
  }

  void _onTapCancel() {
    if (!_isPressed) return;
    _pressController.reverse();
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = _canInteract;
    final textColor = enabled ? AppColors.textPrimary : AppColors.textMuted;
    final iconColor = enabled ? AppColors.textPrimary : AppColors.textMuted;

    return GestureDetector(
      onTapDown: enabled ? _onTapDown : null,
      onTapUp: enabled ? _onTapUp : null,
      onTapCancel: enabled ? _onTapCancel : null,
      child: AnimatedBuilder(
        animation: _pressController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(opacity: _opacityAnimation.value, child: child),
          );
        },
        child: Container(
          height: widget.height,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: enabled
                ? AppGradients.analysisPrimaryButton
                : const LinearGradient(
                    colors: [Color(0x806B7280), Color(0x806B7280)],
                  ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: AppColors.analysisPurpleStart.withValues(
                        alpha: _isPressed ? 0.2 : 0.3,
                      ),
                      blurRadius: _isPressed ? 8 : 20,
                      offset: Offset(0, _isPressed ? 4 : 8),
                    ),
                  ]
                : const [],
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(textColor),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, size: 20, color: iconColor),
                        const SizedBox(width: 12),
                      ],
                      Text(
                        widget.text,
                        style: AppTextStyles.buttonLarge.copyWith(
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
