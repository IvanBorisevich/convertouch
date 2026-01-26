import 'package:convertouch/presentation/bloc/common/tooltip/tooltip_bloc.dart';
import 'package:convertouch/presentation/bloc/common/tooltip/tooltip_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_tooltip/super_tooltip.dart';

class ConvertouchTooltip extends StatefulWidget {
  final Widget content;
  final FocusNode focusNode;
  final SuperTooltipController? controller;
  final Color backgroundColor;
  final TooltipDirection tooltipDirection;
  final Widget child;

  const ConvertouchTooltip({
    required this.content,
    required this.focusNode,
    this.controller,
    required this.backgroundColor,
    this.tooltipDirection = TooltipDirection.down,
    required this.child,
    super.key,
  });

  @override
  State createState() => _ConvertouchTooltipState();
}

class _ConvertouchTooltipState extends State<ConvertouchTooltip> {
  late final SuperTooltipController _controller;

  @override
  void initState() {
    _controller = widget.controller ?? SuperTooltipController();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConvertouchTooltipBloc, ConvertouchTooltipState>(
      listener: (_, tooltipState) async {
        if (tooltipState is TooltipHidden || !widget.focusNode.hasFocus) {
          if (_controller.isVisible) {
            await _controller.hideTooltip();
          }
        } else if (tooltipState is TooltipVisible && !_controller.isVisible) {
          await _controller.showTooltip();
        }
      },
      child: SuperTooltip(
        controller: _controller,
        popupDirection: widget.tooltipDirection,
        hasShadow: false,
        arrowTipDistance: 20,
        arrowTipRadius: 2,
        arrowLength: 5,
        arrowBaseWidth: 10,
        minimumOutsideMargin: 10,
        showBarrier: false,
        backgroundColor: widget.backgroundColor,
        borderColor: widget.backgroundColor,
        content: widget.content,
        child: widget.child,
      ),
    );
  }
}
