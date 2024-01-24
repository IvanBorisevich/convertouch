import 'dart:async';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/refreshable_value_model.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_start_job_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/conversion/build_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/refresh_data/refresh_data_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
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
    StreamController<double>? jobProgressController;

    try {
      jobProgressController =
          createJobProgressStream((jobProgressController) async {
        final jobResult = await refreshDataUseCase.execute(input.job);

        if (jobResult.isLeft) {
          jobProgressController.close();
          throw jobResult.left;
        }

        if (input.conversionToRebuild != null) {
          await buildConversionUseCase.execute(input.conversionToRebuild!);
        }
        if (!jobProgressController.isClosed) {
          jobProgressController.add(1.0);
        }
      });

      return Right(
        RefreshingJobModel.coalesce(
          input.job,
          progressController: jobProgressController,
        ),
      );
    } catch (e) {
      jobProgressController?.close();

      return Left(
        InternalFailure("Error when starting the refreshing job "
            "with id = $jobId: $e"),
      );
    }
  }

  StreamController<double> createJobProgressStream(
    Future<void> Function(StreamController<double>) jobFunc,
  ) {
    late final BehaviorSubject<double> jobProgressController;
    jobProgressController = BehaviorSubject<double>(onListen: () async {
      await jobFunc.call(jobProgressController);

      await jobProgressController.close();
    });

    return jobProgressController;
  }

  InputConversionModel refreshInputConversion(
    InputConversionModel inputConversion,
    RefreshableDataPart refreshableDataPart,
    List<dynamic> refreshedData,
  ) {
    ConversionItemModel? srcConversionItem;
    List<UnitModel> targetUnits = [];
    if (refreshableDataPart == RefreshableDataPart.value) {
      srcConversionItem = refreshSourceConversionItem(
        inputConversion.sourceConversionItem,
        refreshedData as List<RefreshableValueModel>,
      );
      targetUnits = inputConversion.targetUnits;
    } else {
      srcConversionItem = inputConversion.sourceConversionItem;
      targetUnits = refreshTargetUnits(
        inputConversion.targetUnits,
        refreshedData as List<UnitModel>,
      );
    }

    return InputConversionModel(
      unitGroup: inputConversion.unitGroup,
      sourceConversionItem: srcConversionItem,
      targetUnits: targetUnits,
    );
  }

  ConversionItemModel? refreshSourceConversionItem(
    ConversionItemModel? srcConversionItem,
    List<RefreshableValueModel> refreshedValues,
  ) {
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

  List<UnitModel> refreshTargetUnits(
    List<UnitModel> currentTargetUnits,
    List<UnitModel> refreshedTargetUnits,
  ) {
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
