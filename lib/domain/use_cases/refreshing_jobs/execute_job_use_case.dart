import 'dart:async';
import 'dart:developer';

import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/model/refreshing_job_result_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_rebuild_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_start_job_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';
import 'package:convertouch/domain/repositories/network_data_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/rebuild_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';
import 'package:rxdart/rxdart.dart';

class ExecuteJobUseCase
    extends UseCase<InputExecuteJobModel, RefreshingJobModel> {
  final NetworkDataRepository networkDataRepository;
  final RebuildConversionUseCase rebuildConversionUseCase;

  const ExecuteJobUseCase({
    required this.networkDataRepository,
    required this.rebuildConversionUseCase,
  });

  @override
  Future<Either<ConvertouchException, RefreshingJobModel>> execute(
    InputExecuteJobModel input,
  ) async {
    StreamController<RefreshingJobResultModel>? jobProgressController;

    try {
      if (input.job.selectedDataSource == null) {
        return const Left(
          InternalException(
            message: "No data source found for the job",
            severity: ExceptionSeverity.warning,
            stackTrace: null,
          ),
        );
      }

      final isConnectionAvailable = ObjectUtils.tryGet(
        await networkDataRepository.isConnectionAvailable(),
      );

      if (!isConnectionAvailable) {
        return const Left(
          InternalException(
            message: "Please check an internet connection",
            severity: ExceptionSeverity.warning,
            stackTrace: null,
          ),
        );
      }

      jobProgressController = createJobProgressStream(
        jobFunc: (jobProgressController) async {
          if (!jobProgressController.isClosed) {
            jobProgressController.add(const RefreshingJobResultModel.start());
          } else {
            log("On start: stream controller is already closed");
            return null;
          }

          final refreshedData = ObjectUtils.tryGet(
            await networkDataRepository.refreshForGroup(
              unitGroupName: input.job.unitGroupName,
              dataSource: input.job.selectedDataSource!,
              refreshableDataPart: input.job.refreshableDataPart,
            ),
          );

          OutputConversionModel? rebuiltConversion;

          if (input.conversionToBeRebuilt != null) {
            rebuiltConversion = ObjectUtils.tryGet(
              await rebuildConversionUseCase.execute(
                InputConversionRebuildModel(
                  conversionToBeRebuilt: input.conversionToBeRebuilt!,
                  refreshableDataPart: input.job.refreshableDataPart,
                  refreshedData: refreshedData,
                ),
              ),
            );
          }

          if (!jobProgressController.isClosed) {
            log("Add finish result to the stream");
            jobProgressController.add(
              const RefreshingJobResultModel.finish(),
            );
          } else {
            log("At finish: stream controller is already closed");
          }

          return rebuiltConversion;
        },
        onComplete: input.onJobComplete,
      );

      return Right(
        RefreshingJobModel.coalesce(
          input.job,
          progressController: jobProgressController,
        ),
      );
    } catch (e, stackTrace) {
      log("Closing the stream from use case");
      jobProgressController?.close();

      return Left(
        InternalException(
          message: "Error when starting the refreshing job "
              "'${input.job.name}': $e",
          stackTrace: stackTrace,
        ),
      );
    }
  }

  StreamController<RefreshingJobResultModel> createJobProgressStream({
    required JobProcessFunction jobFunc,
    void Function(OutputConversionModel?)? onComplete,
  }) {
    late final BehaviorSubject<RefreshingJobResultModel> jobProgressController;
    jobProgressController = BehaviorSubject<RefreshingJobResultModel>(
      onListen: () async {
        try {
          await jobFunc.call(jobProgressController).then((rebuiltConversion) {
            if (!jobProgressController.isClosed) {
              log("Closing the stream once job has been completed");
              jobProgressController.close();
              onComplete?.call(rebuiltConversion);
            } else {
              log("After finish: stream controller is already closed");
            }
          });
        } catch (e) {
          log("Closing the stream when error during job execution: $e");
          await jobProgressController.close();
        }
      },
    );

    return jobProgressController;
  }
}

typedef JobProcessFunction = Future<OutputConversionModel?> Function(
    StreamController<RefreshingJobResultModel>);
