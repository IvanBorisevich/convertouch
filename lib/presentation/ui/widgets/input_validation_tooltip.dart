import 'package:convertouch/presentation/bloc/common/input_validation/input_validation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/input_validation/input_validation_states.dart';
import 'package:convertouch/presentation/bloc/common/tooltip/tooltip_bloc.dart';
import 'package:convertouch/presentation/bloc/common/tooltip/tooltip_events.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_tooltip/super_tooltip.dart';

class InputValidationTooltip extends StatelessWidget {
  final FocusNode focusNode;
  final Widget child;
  final TooltipDirection tooltipDirection;
  final NotificationColorScheme colors;

  const InputValidationTooltip({
    required Key validationKey,
    required this.focusNode,
    required this.colors,
    this.tooltipDirection = TooltipDirection.down,
    required this.child,
  }) : super(key: validationKey);

  @override
  Widget build(BuildContext context) {
    return BlocListener<InputValidationBloc, InputValidationState>(
      listenWhen: (prev, next) => next.key == key,
      listener: (_, validationState) {
        print(
            "${DateTime.now()} [validation bloc listener] Sending tooltip event with key: $key");

        BlocProvider.of<ConvertouchTooltipBloc>(context).add(
          validationState is InputValidationErrorState
              ? ShowTooltip(key: key)
              : HideTooltip(key: key),
        );
      },
      child: ConvertouchTooltip(
        key: key,
        focusNode: focusNode,
        backgroundColor: colors.background.regular,
        tooltipDirection: tooltipDirection,
        content: BlocBuilder<InputValidationBloc, InputValidationState>(
          builder: (_, validationState) {
            if (validationState is InputValidationErrorState) {
              return Text(
                validationState.errorMessage,
                style: TextStyle(
                  color: colors.foreground.warning,
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
