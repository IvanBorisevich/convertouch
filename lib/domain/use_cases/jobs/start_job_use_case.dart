import 'dart:async';
import 'dart:developer';

import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/model/job_result_model.dart';
import 'package:convertouch/domain/use_cases/jobs/stop_job_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';
import 'package:rxdart/rxdart.dart';

class StartJobUseCase extends UseCase<JobModel, JobModel> {
  final StopJobUseCase stopJobUseCase;

  const StartJobUseCase({
    required this.stopJobUseCase,
  });

  @override
  Future<Either<ConvertouchException, JobModel>> execute(
    JobModel input,
  ) async {
    try {
      if (input.progressController != null &&
          !input.progressController!.isClosed) {
        if (input.executionMode ==
            JobExecutionMode.continueAlreadyRunningJobIfAny) {
          return Left(
            InternalException(
              message: "Job '${input.name}' is running at the moment",
              severity: ExceptionSeverity.info,
              stackTrace: null,
              dateTime: DateTime.now(),
            ),
          );
        } else {
          await stopJobUseCase.execute(
            input.copyWith(
              progressController: const Patchable(null),
            ),
          );
        }
      }

      StreamController<JobResultModel>? jobProgressController =
          _startJob(input);

      return Right(
        input.copyWith(
          progressController: Patchable(jobProgressController),
        ),
      );
    } catch (e, stackTrace) {
      log("Error when starting the job: $e, $stackTrace");

      return Left(
        InternalException(
          message: "Error when starting the job: $e",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  StreamController<JobResultModel> _startJob(JobModel job) {
    final BehaviorSubject<JobResultModel> jobProgressController =
        BehaviorSubject<JobResultModel>();

    () async {
      try {
        log("try block started");

        _addToController(
          controller: jobProgressController,
          result: const JobResultModel.start(),
        );

        job.onStart?.call(jobProgressController);

        DynamicDataModel? result = await job.onExecute?.call(job.params);

        ConvertouchException info = ConvertouchException(
          message: "Refreshed successfully!",
          severity: ExceptionSeverity.info,
          stackTrace: null,
          dateTime: DateTime.now(),
        );

        _addToController(
          controller: jobProgressController,
          result: JobResultModel.finish(result, info: info),
        );

        job.onSuccess?.call(result);

        log("try block finished");
      } catch (err, stackTrace) {
        log("catch block started: $err, $stackTrace");

        ConvertouchException e = err is ConvertouchException
            ? err
            : ConvertouchException(
                message: err.toString(),
                severity: ExceptionSeverity.warning,
                stackTrace: stackTrace,
                dateTime: DateTime.now(),
              );

        _addToController(
          controller: jobProgressController,
          result: JobResultModel.finish(null, info: e),
        );

        job.onError?.call(e);

        log("catch block finished");
      }
    }();

    return jobProgressController;
  }

  void _addToController({
    required BehaviorSubject<JobResultModel> controller,
    required JobResultModel result,
  }) {
    if (controller.isClosed) {
      log("Stream controller has already been closed");
      return;
    }

    controller.add(result);
  }
}
