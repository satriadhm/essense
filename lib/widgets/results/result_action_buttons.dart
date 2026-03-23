import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class ResultActionButtons extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onOverride;

  const ResultActionButtons({
    super.key,
    required this.onAccept,
    required this.onOverride,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            AppColors.bgDeep,
            AppColors.bgDeep.withValues(alpha: 0.92),
            AppColors.bgDeep.withValues(alpha: 0.00),
          ],
          stops: const [0, 0.65, 1],
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        20,
        AppSpacing.screenHorizontal,
        20 + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        children: [
          Expanded(
            child: _TapScaleButton(
              onPressed: onAccept,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.analysisDarkBlue,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.analysisDarkBlue.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Accept & Spray',
                  style: TextStyle(
                    fontSize: 18 / 2 * 2,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _TapScaleButton(
              onPressed: onOverride,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.accentCyan.withValues(alpha: 0.8),
                    width: 1.2,
                  ),
                  color: AppColors.bgDeep.withValues(alpha: 0.55),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Override',
                  style: TextStyle(
                    fontSize: 18 / 2 * 2,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TapScaleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;

  const _TapScaleButton({required this.child, required this.onPressed});

  @override
  State<_TapScaleButton> createState() => _TapScaleButtonState();
}

class _TapScaleButtonState extends State<_TapScaleButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scale = Tween<double>(
      begin: 1,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapCancel: () => _controller.reverse(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}
