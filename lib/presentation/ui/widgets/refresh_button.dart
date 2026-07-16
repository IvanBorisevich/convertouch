import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_states.dart';
import 'package:convertouch/presentation/controller/conversion_controller.dart';
import 'package:convertouch/presentation/controller/navigation_controller.dart';
import 'package:convertouch/presentation/controller/refreshing_job_controller.dart';
import 'package:convertouch/presentation/ui/style/color/colors_factory.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchRefreshFloatingButton extends StatelessWidget {
  final bool determinate;
  final bool visible;
  final bool disabled;
  final ConvertouchUITheme theme;

  const ConvertouchRefreshFloatingButton({
    this.determinate = false,
    this.visible = true,
    this.disabled = false,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    WidgetColorScheme refreshButtonColor =
        appColors[theme].refreshFloatingButton;

    return BlocBuilder<ConversionBloc, ConversionState>(
      buildWhen: (prev, next) {
        return prev != next && next is ConversionBuilt;
      },
      builder: (_, conversionState) {
        if (conversionState is! ConversionBuilt) {
          return const SizedBox.shrink();
        }

        final params = conversionState.conversion.params?.active;
        final srcUnit = conversionState.conversion.srcUnitValue?.unit;
        final unitGroupName = conversionState.conversion.unitGroup.name;

        return refreshingJobsBlocBuilder(
          builderFunc: (jobsState) {
            return ConvertouchProgressButton(
              visible: visible,
              determinate: determinate,
              radius: 28,
              margin: const EdgeInsets.only(right: 7),
              colors: refreshButtonColor,
              theme: theme,
              initialButtonWidget: ConvertouchFloatingActionButton.refresh(
                disabled: disabled,
                colorScheme: refreshButtonColor,
                onClick: () {
                  refreshingJobController.startRefreshingJob(
                    context,
                    unitGroupName: unitGroupName,
                    params: params,
                    srcUnit: srcUnit,
                    jobExecutionMode:
                        JobExecutionMode.continueAlreadyRunningJobIfAny,
                  );
                },
              ),
              onFetchSuccess: (jobResult) {
                if (jobResult.data != null) {
                  conversionController.updateWithDynamicData(
                    context,
                    data: jobResult.data!,
                  );
                }

                refreshingJobController.stopRefreshingJob(
                  context,
                  unitGroupName: unitGroupName,
                  paramSetName: params?.paramSet.name,
                  onComplete: () {
                    navigationController.showException(
                      context,
                      exception: jobResult.notification!,
                    );
                  },
                );
              },
              onFetchError: (exception) {
                refreshingJobController.stopRefreshingJob(
                  context,
                  unitGroupName: unitGroupName,
                  paramSetName: params?.paramSet.name,
                  stopOnError: true,
                  onComplete: () {
                    navigationController.showException(
                      context,
                      exception: exception,
                    );
                  },
                );
              },
              onProgressIndicatorClick: () {
                refreshingJobController.stopRefreshingJob(
                  context,
                  unitGroupName: unitGroupName,
                  paramSetName: params?.paramSet.name,
                  forceStop: true,
                  onComplete: () {
                    navigationController.showException(
                      context,
                      exception: ConvertouchException(
                        message: "Refreshing stopped",
                        severity: ExceptionSeverity.info,
                        stackTrace: null,
                        dateTime: DateTime.now(),
                      ),
                    );
                  },
                );
              },
              progressStream: jobsState
                  .getJob(
                    unitGroupName,
                    params?.paramSet.name,
                  )
                  ?.progressController
                  ?.stream,
            );
          },
        );
      },
    );
  }
}
