import 'package:flutter/material.dart';

class ConvertouchFadeScaleAnimation extends StatefulWidget {
  final Duration duration;
  final bool reverse;
  final Widget child;

  const ConvertouchFadeScaleAnimation({
    this.duration = const Duration(milliseconds: 150),
    this.reverse = false,
    required this.child,
    super.key,
  });

  @override
  State createState() => _ConvertouchFadeScaleAnimationState();
}

class _ConvertouchFadeScaleAnimationState
    extends State<ConvertouchFadeScaleAnimation> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reverse) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    return ScaleTransition(
      scale: _animation,
      child: FadeTransition(
        opacity: _animation,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
