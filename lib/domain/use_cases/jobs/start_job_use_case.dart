import 'dart:async';
import 'dart:developer';

import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/model/job_result_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_job_stop_model.dart';
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
        }

        await stopJobUseCase.execute(
          InputJobStopModel(
            job: input,
            forceStop: true,
            stopOnError: false,
          ),
        );
      }

      BehaviorSubject<JobResultModel>? jobStreamController = _startJob(input);

      return Right(
        input.copyWith(
          progressController: Patchable(jobStreamController),
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

  BehaviorSubject<JobResultModel> _startJob(JobModel job) {
    final BehaviorSubject<JobResultModel> jobStreamController =
        BehaviorSubject<JobResultModel>();

    job.beforeStart?.call(jobStreamController);

    _addToController(
      controller: jobStreamController,
      result: const JobResultModel.start(),
    );

    () async {
      try {
        log("try block started");

        _addToController(
          controller: jobStreamController,
          result: const JobResultModel.start(),
        );

        DynamicDataModel? result = await job.onExecute?.call(job.params);

        ConvertouchException info = ConvertouchException(
          message: "Refreshed successfully!",
          severity: ExceptionSeverity.info,
          stackTrace: null,
          dateTime: DateTime.now(),
        );

        _addToController(
          controller: jobStreamController,
          result: JobResultModel.finish(result, info: info),
        );

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
          controller: jobStreamController,
          result: JobResultModel.failure(e),
        );

        log("catch block finished");
      }
    }();

    return jobStreamController;
  }

  void _addToController({
    required BehaviorSubject<JobResultModel> controller,
    required JobResultModel result,
  }) {
    if (controller.isClosed) {
      log("Stream controller has already been closed");
      return;
    }

    log("Add result to controller: $result");

    controller.add(result);
  }
}
