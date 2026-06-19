import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_states.dart';
import 'package:convertouch/presentation/controller/conversion_controller.dart';
import 'package:convertouch/presentation/controller/navigation_controller.dart';
import 'package:convertouch/presentation/controller/refreshing_job_controller.dart';
import 'package:convertouch/presentation/ui/model/refresh_button_view_model.dart';
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

    return BlocSelector<ConversionBloc, ConversionState,
        RefreshButtonViewModel?>(
      selector: (state) {
        if (state is ConversionBuilt) {
          return RefreshButtonViewModel(
            params: state.conversion.params?.active,
            srcUnit: state.conversion.srcUnitValue?.unit,
            unitGroupName: state.conversion.unitGroup.name,
          );
        }

        return null;
      },
      builder: (_, viewModel) {
        if (viewModel == null) {
          return const SizedBox.shrink();
        }

        return refreshingJobsBlocBuilder(
          builderFunc: (jobsState) {
            return ConvertouchProgressButton(
              visible: visible,
              determinate: determinate,
              radius: 28,
              margin: const EdgeInsets.only(right: 7),
              colors: refreshButtonColor,
              buttonWidget: ConvertouchFloatingActionButton.refresh(
                disabled: disabled,
                onClick: () {
                  refreshingJobController.startRefreshingJob(
                    context,
                    unitGroupName: viewModel.unitGroupName,
                    params: viewModel.params,
                    srcUnit: viewModel.srcUnit,
                    jobExecutionMode:
                        JobExecutionMode.continueAlreadyRunningJobIfAny,
                  );
                },
                colorScheme: refreshButtonColor,
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
                  unitGroupName: viewModel.unitGroupName,
                  paramSetName: viewModel.params?.paramSet.name,
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
                  unitGroupName: viewModel.unitGroupName,
                  paramSetName: viewModel.params?.paramSet.name,
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
                  unitGroupName: viewModel.unitGroupName,
                  paramSetName: viewModel.params?.paramSet.name,
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
                    viewModel.unitGroupName,
                    viewModel.params?.paramSet.name,
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
