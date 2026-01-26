import 'package:convertouch/presentation/bloc/common/input_validation/input_validation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/input_validation/input_validation_events.dart';
import 'package:convertouch/presentation/bloc/common/input_validation/input_validation_states.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_states.dart';
import 'package:convertouch/presentation/bloc/common/tooltip/tooltip_bloc.dart';
import 'package:convertouch/presentation/bloc/common/tooltip/tooltip_events.dart';
import 'package:convertouch/presentation/ui/widgets/tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_tooltip/super_tooltip.dart';

class InputValidationWrapper extends StatelessWidget {
  final FocusNode focusNode;
  final Widget child;
  final Color tooltipBackgroundColor;
  final Color tooltipForegroundColor;
  final TooltipDirection tooltipDirection;
  final bool resetValidationOnNavigate;

  const InputValidationWrapper({
    required this.focusNode,
    required this.tooltipBackgroundColor,
    required this.tooltipForegroundColor,
    this.tooltipDirection = TooltipDirection.down,
    this.resetValidationOnNavigate = true,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<NavigationBloc, NavigationState>(
          listenWhen: (prev, current) => resetValidationOnNavigate,
          listener: (_, navigationState) {
            focusNode.unfocus();

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
      ],
      child: ConvertouchTooltip(
        focusNode: focusNode,
        backgroundColor: tooltipBackgroundColor,
        tooltipDirection: tooltipDirection,
        content: BlocBuilder<InputValidationBloc, InputValidationState>(
          builder: (_, validationState) {
            if (validationState is InputValidationErrorState) {
              return Text(
                validationState.errorMessage,
                style: TextStyle(
                  color: tooltipForegroundColor,
                  fontWeight: FontWeight.w500,
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
        child: child,
      ),
    );
  }
}
