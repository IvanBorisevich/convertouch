import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ConvertouchSlidingPanel extends StatelessWidget {
  final PanelController panelController;
  final Widget content;
  final double minHeight;
  final double maxHeight;
  final SlidingPanelColorScheme colors;
  final PanelState defaultPanelState;
  final void Function()? onPanelSlide;

  const ConvertouchSlidingPanel({
    required this.panelController,
    required this.content,
    required this.minHeight,
    required this.maxHeight,
    required this.colors,
    this.defaultPanelState = PanelState.CLOSED,
    this.onPanelSlide,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: panelController,
      slideDirection: SlideDirection.DOWN,
      defaultPanelState: defaultPanelState,
      minHeight: minHeight,
      maxHeight: maxHeight,
      color: colors.body.background.regular,
      boxShadow: null,
      onPanelSlide: (position) {
        onPanelSlide?.call();
      },
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      panel: content,
    );
  }
}
