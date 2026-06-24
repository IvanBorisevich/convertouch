import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_states.dart';
import 'package:convertouch/presentation/bloc/common/tooltip/tooltip_bloc.dart';
import 'package:convertouch/presentation/bloc/common/tooltip/tooltip_states.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/mixin/focus_node_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_tooltip/super_tooltip.dart';

class ConvertouchTooltip extends StatefulWidget {
  final Widget content;
  final FocusNode? focusNode;
  final SuperTooltipController? controller;
  final Color backgroundColor;
  final TooltipDirection tooltipDirection;
  final bool closeOnNavigate;
  final double verticalOffset;
  final Widget child;

  const ConvertouchTooltip({
    required this.content,
    this.focusNode,
    this.controller,
    required this.backgroundColor,
    this.tooltipDirection = TooltipDirection.down,
    this.closeOnNavigate = true,
    this.verticalOffset = 0,
    required this.child,
    super.key,
  });

  @override
  State createState() => _ConvertouchTooltipState();
}

class _ConvertouchTooltipState extends State<ConvertouchTooltip>
    with FocusNodeMixin {
  late final FocusNode _focusNode;
  late final SuperTooltipController _controller;

  late void Function() _focusListener;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? SuperTooltipController();

    _focusNode = initOrGetFocusNode(initial: widget.focusNode);
    _focusListener = addFocusListener(
      focusNode: _focusNode,
      onFocusLeft: () async {
        if (_controller.isVisible) {
          await _controller.hideTooltip();
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    if (widget.focusNode == null) {
      disposeFocusNode(
        focusNode: _focusNode,
        listener: _focusListener,
      );
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<NavigationBloc, NavigationState>(
          listenWhen: (prev, current) =>
              prev != current && widget.closeOnNavigate && _focusNode.hasFocus,
          listener: (_, navigationState) {
            _focusNode.unfocus();
          },
        ),
        BlocListener<ConvertouchTooltipBloc, ConvertouchTooltipState>(
          listenWhen: (prev, current) => current.key == widget.key,
          listener: (_, tooltipState) async {
            if (tooltipState is TooltipHidden && _controller.isVisible) {
              await _controller.hideTooltip();
            } else if (tooltipState is TooltipVisible &&
                !_controller.isVisible) {
              await _controller.showTooltip();
            }
          },
        ),
      ],
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
        verticalOffset: widget.verticalOffset,
        backgroundColor: widget.backgroundColor,
        borderColor: widget.backgroundColor,
        content: widget.content,
        child: widget.child,
      ),
    );
  }
}
