import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class ConvertouchTooltip extends StatelessWidget {
  final Widget content;
  final SuperTooltipController? controller;
  final Color backgroundColor;
  final TooltipDirection tooltipDirection;
  final Widget child;

  const ConvertouchTooltip({
    required this.content,
    this.controller,
    required this.backgroundColor,
    this.tooltipDirection = TooltipDirection.down,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SuperTooltip(
      controller: controller,
      popupDirection: tooltipDirection,
      hasShadow: false,
      arrowTipDistance: 20,
      arrowTipRadius: 2,
      arrowLength: 5,
      arrowBaseWidth: 10,
      minimumOutsideMargin: 10,
      showBarrier: false,
      backgroundColor: backgroundColor,
      borderColor: backgroundColor,
      hideTooltipOnBarrierTap: true,
      content: content,
      child: child,
    );
  }
}
