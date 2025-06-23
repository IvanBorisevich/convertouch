import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class ConvertouchTooltip extends StatelessWidget {
  final String? text;
  final SuperTooltipController? controller;
  final SeverityColorScheme colors;
  final ExceptionSeverity severity;
  final Widget child;

  const ConvertouchTooltip({
    required this.text,
    this.controller,
    required this.colors,
    this.severity = ExceptionSeverity.warning,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (text == null) {
      return child;
    }

    Color foreground;
    switch (severity) {
      case ExceptionSeverity.info:
        foreground = colors.foregroundInfo.regular;
        break;
      case ExceptionSeverity.warning:
        foreground = colors.foregroundWarning.regular;
        break;
      case ExceptionSeverity.error:
        foreground = colors.foregroundError.regular;
        break;
    }

    return SuperTooltip(
      controller: controller,
      hasShadow: false,
      arrowTipDistance: 20,
      arrowTipRadius: 2,
      arrowLength: 5,
      arrowBaseWidth: 10,
      showBarrier: false,
      backgroundColor: colors.background.regular,
      borderColor: colors.background.regular,
      content: Text(
        text!,
        style: TextStyle(
          color: foreground,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: child,
    );
  }
}
