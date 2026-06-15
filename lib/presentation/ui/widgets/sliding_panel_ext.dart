import 'package:convertouch/presentation/bloc/common/sliding_panel_bloc/sliding_panel_bloc.dart';
import 'package:convertouch/presentation/bloc/common/sliding_panel_bloc/sliding_panel_states.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ConvertouchSlidingPanel extends StatefulWidget {
  final Widget content;
  final double minHeight;
  final double maxHeight;
  final SlidingPanelColorScheme colors;
  final PanelState defaultPanelState;
  final void Function()? onPanelSlide;

  const ConvertouchSlidingPanel({
    required this.content,
    required this.minHeight,
    required this.maxHeight,
    required this.colors,
    this.defaultPanelState = PanelState.CLOSED,
    this.onPanelSlide,
    super.key,
  });

  @override
  State<ConvertouchSlidingPanel> createState() =>
      _ConvertouchSlidingPanelState();
}

class _ConvertouchSlidingPanelState extends State<ConvertouchSlidingPanel> {
  late final PanelController _panelController;

  @override
  void initState() {
    super.initState();
    _panelController = PanelController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SlidingPanelBloc, SlidingPanelState>(
      listener: (context, state) async {
        if (state is! SlidingPanelSwitched || !_panelController.isAttached) {
          return;
        }

        if (_panelController.isPanelClosed) {
          await _panelController.open();
        } else {
          await _panelController.close();
        }
      },
      child: SlidingUpPanel(
        controller: _panelController,
        slideDirection: SlideDirection.DOWN,
        defaultPanelState: widget.defaultPanelState,
        minHeight: widget.minHeight,
        maxHeight: widget.maxHeight,
        color: widget.colors.body.background.regular,
        boxShadow: null,
        onPanelSlide: (position) {
          widget.onPanelSlide?.call();
        },
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        panel: widget.content,
      ),
    );
  }
}
