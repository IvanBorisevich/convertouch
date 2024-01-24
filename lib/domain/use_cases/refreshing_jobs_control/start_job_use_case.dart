import 'dart:async';
import 'dart:developer';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/refreshable_value_model.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/model/refreshing_job_result_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_start_job_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/conversion/build_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/refresh_data/refresh_data_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';
import 'package:rxdart/rxdart.dart';

class StartJobUseCase extends UseCase<InputStartJobModel, RefreshingJobModel> {
  final RefreshDataUseCase refreshDataUseCase;
  final BuildConversionUseCase buildConversionUseCase;

  const StartJobUseCase({
    required this.refreshDataUseCase,
    required this.buildConversionUseCase,
  });

  @override
  Future<Either<Failure, RefreshingJobModel>> execute(
    InputStartJobModel input,
  ) async {
    int jobId = input.job.id!;
    StreamController<RefreshingJobResultModel>? jobProgressController;

    try {
      jobProgressController = createJobProgressStream(
        jobFunc: (jobProgressController) async {
          final refreshedData = ObjectUtils.tryGet(
            await refreshDataUseCase.execute(input.job),
          );

          InputConversionModel? refreshedConversionParams;

          if (input.conversionParamsToRefresh != null) {
            log("Start refreshing conversion params");
            refreshedConversionParams = await _refreshConversionParams(
              input.conversionParamsToRefresh!,
              input.job.refreshableDataPart,
              refreshedData,
            );
            log("Finish refreshing conversion params");
          }

          jobProgressController.add(
            RefreshingJobResultModel.finish(
              refreshedConversionParams: refreshedConversionParams,
            ),
          );
        },
      );

      return Right(
        RefreshingJobModel.coalesce(
          input.job,
          progressController: jobProgressController,
        ),
      );
    } catch (e) {
      log("Close the stream");
      jobProgressController?.close();

      return Left(
        InternalFailure("Error when starting the refreshing job "
            "with id = $jobId: $e"),
      );
    }
  }

  StreamController<RefreshingJobResultModel> createJobProgressStream({
    required Future<void> Function(StreamController<RefreshingJobResultModel>)
        jobFunc,
  }) {
    late final BehaviorSubject<RefreshingJobResultModel> jobProgressController;
    jobProgressController = BehaviorSubject<RefreshingJobResultModel>(
      onListen: () async {
        try {
          jobProgressController.add(const RefreshingJobResultModel.start());
          await jobFunc.call(jobProgressController);
        } finally {
          log("Close the stream");
          await jobProgressController.close();
        }
      },
    );

    return jobProgressController;
  }

  Future<InputConversionModel> _refreshConversionParams(
    InputConversionModel conversionParams,
    RefreshableDataPart refreshableDataPart,
    List<dynamic> refreshedData,
  ) async {
    ConversionItemModel? srcConversionItem;
    List<UnitModel> targetUnits = [];
    if (refreshableDataPart == RefreshableDataPart.value) {
      srcConversionItem = await _refreshSourceConversionItemFromValues(
        conversionParams.sourceConversionItem,
        refreshedData as List<RefreshableValueModel>,
      );
      targetUnits = conversionParams.targetUnits;
    } else {
      srcConversionItem = await _refreshSourceConversionItemFromCoefficients(
        conversionParams.sourceConversionItem,
        refreshedData as List<UnitModel>,
      );

      targetUnits = await _refreshTargetUnits(
        conversionParams.targetUnits,
        refreshedData,
      );
    }

    return InputConversionModel(
      unitGroup: conversionParams.unitGroup,
      sourceConversionItem: srcConversionItem,
      targetUnits: targetUnits,
    );
  }

  Future<ConversionItemModel?> _refreshSourceConversionItemFromValues(
    ConversionItemModel? srcConversionItem,
    List<RefreshableValueModel> refreshedValues,
  ) async {
    if (srcConversionItem == null) {
      return null;
    }

    String defaultValueStr = refreshedValues
        .firstWhere((rv) => srcConversionItem.unit.id! == rv.unitId)
        .value!;

    return ConversionItemModel(
        unit: srcConversionItem.unit,
        value: srcConversionItem.value,
        defaultValue: ValueModel(
          strValue: defaultValueStr,
        ));
  }

  Future<ConversionItemModel?> _refreshSourceConversionItemFromCoefficients(
    ConversionItemModel? srcConversionItem,
    List<UnitModel> refreshedTargetUnits,
  ) async {
    if (srcConversionItem == null) {
      return null;
    }

    UnitModel srcUnit = refreshedTargetUnits
        .firstWhere((unit) => srcConversionItem.unit.id! == unit.id!);

    return ConversionItemModel(
      unit: srcUnit,
      value: srcConversionItem.value,
      defaultValue: srcConversionItem.defaultValue,
    );
  }

  Future<List<UnitModel>> _refreshTargetUnits(
    List<UnitModel> currentTargetUnits,
    List<UnitModel> refreshedTargetUnits,
  ) async {
    Map<int, UnitModel> refreshedTargetUnitsMap = {
      for (var v in refreshedTargetUnits) v.id!: v
    };

    List<UnitModel> result = [];
    for (int i = 0; i < currentTargetUnits.length; i++) {
      int currentTargetUnitId = currentTargetUnits[i].id!;
      if (refreshedTargetUnitsMap.containsKey(currentTargetUnitId)) {
        result.add(refreshedTargetUnitsMap[currentTargetUnitId]!);
      } else {
        result.add(currentTargetUnits[i]);
      }
    }

    return result;
  }
}
