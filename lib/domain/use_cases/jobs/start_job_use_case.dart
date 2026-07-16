import 'dart:async';
import 'dart:developer';

import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/model/job_result_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_job_start_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class StartJobUseCase extends UseCase<InputJobStartModel, JobModel> {
  const StartJobUseCase();

  @override
  Future<Either<ConvertouchException, JobModel>> execute(
    InputJobStartModel input,
  ) async {
    final jobStreamController = input.job.progressController;

    if (jobStreamController == null) {
      return Right(input.job);
    }

    try {
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

          DynamicDataModel? result = await input.onExecute.call(
            input.job.params,
          );

          ConvertouchException info = ConvertouchException(
            message: "Refreshed successfully!",
            severity: ExceptionSeverity.info,
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
                );

          _addToController(
            controller: jobStreamController,
            result: JobResultModel.failure(e),
          );

          log("catch block finished");
        }
      }();

      return Right(input.job);
    } catch (e, stackTrace) {
      log("Error when starting the job: $e, $stackTrace");

      return Left(
        ConvertouchException(
          message: "Error when starting the job: $e",
          stackTrace: stackTrace,
        ),
      );
    }
  }

  void _addToController({
    required StreamController<JobResultModel> controller,
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
