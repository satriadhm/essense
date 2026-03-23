import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class ARButton extends StatefulWidget {
  final VoidCallback onPressed;

  const ARButton({super.key, required this.onPressed});

  @override
  State<ARButton> createState() => _ARButtonState();
}

class _ARButtonState extends State<ARButton>
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        2,
        AppSpacing.screenHorizontal,
        0,
      ),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onPressed();
        },
        onTapCancel: () => _controller.reverse(),
        child: ScaleTransition(
          scale: _scale,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.accentCyan.withValues(alpha: 0.35),
              ),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.06),
                  Colors.white.withValues(alpha: 0.01),
                ],
              ),
            ),
            child: const Center(
              child: Text(
                'Oversee in Augmented Reality',
                style: TextStyle(
                  fontSize: 26 / 2,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFB7A3F8),
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
