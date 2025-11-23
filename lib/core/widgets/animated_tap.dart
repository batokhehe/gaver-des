import 'package:flutter/material.dart';

class AnimatedTap extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const AnimatedTap({super.key, required this.child, required this.onTap});

  @override
  State<AnimatedTap> createState() => _AnimatedTapState();
}

class _AnimatedTapState extends State<AnimatedTap> {
  double scale = 1;

  void _tapDown(_) => setState(() => scale = 0.95);
  void _tapUp(_) => setState(() => scale = 1);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _tapDown,
      onTapCancel: () => setState(() => scale = 1),
      onTapUp: _tapUp,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 120),
        child: widget.child,
      ),
    );
  }
}
