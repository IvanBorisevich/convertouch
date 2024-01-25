import 'dart:async';
import 'dart:developer';

import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/model/refreshing_job_result_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_params_refreshing_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_start_job_model.dart';
import 'package:convertouch/domain/repositories/network_data_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/refresh_conversion_params_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';
import 'package:rxdart/rxdart.dart';

class StartJobUseCase extends UseCase<InputStartJobModel, RefreshingJobModel> {
  final NetworkDataRepository networkDataRepository;
  final RefreshConversionParamsUseCase refreshConversionParamsUseCase;

  const StartJobUseCase({
    required this.networkDataRepository,
    required this.refreshConversionParamsUseCase,
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
          if (input.job.selectedDataSource == null) {
            jobProgressController.add(
              const RefreshingJobResultModel.finish(),
            );
            return;
          }

          final refreshedData = ObjectUtils.tryGet(
            await networkDataRepository.refreshForGroup(
              unitGroupId: input.job.unitGroup.id!,
              dataSource: input.job.selectedDataSource!,
              refreshableDataPart: input.job.refreshableDataPart,
            ),
          );

          InputConversionModel? refreshedConversionParams;

          if (input.conversionParamsToBeRefreshed != null) {
            refreshedConversionParams = ObjectUtils.tryGet(
              await refreshConversionParamsUseCase.execute(
                InputConversionParamsRefreshingModel(
                  conversionParamsToBeRefreshed:
                      input.conversionParamsToBeRefreshed!,
                  refreshableDataPart: input.job.refreshableDataPart,
                  refreshedData: refreshedData,
                ),
              ),
            );
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
}
