import 'package:convertouch/presentation/bloc/common/input_validation/input_validation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/input_validation/input_validation_events.dart';
import 'package:convertouch/presentation/bloc/common/input_validation/input_validation_states.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_states.dart';
import 'package:convertouch/presentation/bloc/common/tooltip/tooltip_bloc.dart';
import 'package:convertouch/presentation/bloc/common/tooltip/tooltip_events.dart';
import 'package:convertouch/presentation/bloc/common/tooltip/tooltip_states.dart';
import 'package:convertouch/presentation/ui/widgets/tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_tooltip/super_tooltip.dart';

class InputValidationWrapper extends StatefulWidget {
  final FocusNode focusNode;
  final Widget child;
  final Color tooltipBackgroundColor;
  final Color tooltipForegroundColor;
  final TooltipDirection tooltipDirection;

  const InputValidationWrapper({
    required this.focusNode,
    required this.tooltipBackgroundColor,
    required this.tooltipForegroundColor,
    this.tooltipDirection = TooltipDirection.down,
    required this.child,
    super.key,
  });

  @override
  State<InputValidationWrapper> createState() => _InputValidationWrapperState();
}

class _InputValidationWrapperState extends State<InputValidationWrapper> {
  final _tooltipController = SuperTooltipController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<NavigationBloc, NavigationState>(
          listener: (_, navigationState) {
            widget.focusNode.unfocus();

            BlocProvider.of<InputValidationBloc>(context).add(
              const ResetValidation(),
            );
          },
        ),
        BlocListener<InputValidationBloc, InputValidationState>(
          listener: (_, validationState) {
            BlocProvider.of<ConvertouchTooltipBloc>(context).add(
              validationState is InputValidationErrorState
                  ? const ShowTooltip()
                  : const HideTooltip(),
            );
          },
        ),
        BlocListener<ConvertouchTooltipBloc, ConvertouchTooltipState>(
          listener: (_, tooltipState) async {
            if (tooltipState is TooltipHidden || !widget.focusNode.hasFocus) {
              if (_tooltipController.isVisible) {
                await _tooltipController.hideTooltip();
              }
            } else if (tooltipState is TooltipVisible &&
                !_tooltipController.isVisible) {
              await _tooltipController.showTooltip();
            }
          },
        ),
      ],
      child: ConvertouchTooltip(
        controller: _tooltipController,
        backgroundColor: widget.tooltipBackgroundColor,
        tooltipDirection: widget.tooltipDirection,
        content: BlocBuilder<InputValidationBloc, InputValidationState>(
          builder: (_, validationState) {
            if (validationState is InputValidationErrorState) {
              return Text(
                validationState.errorMessage,
                style: TextStyle(
                  color: widget.tooltipForegroundColor,
                  fontWeight: FontWeight.w500,
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _tooltipController.dispose();
    super.dispose();
  }
}
