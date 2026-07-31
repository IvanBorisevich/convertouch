import 'dart:async';
import 'dart:developer';

import 'package:async/async.dart';
import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/model/job_result_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_job_start_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_job_start_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class StartJobUseCase extends UseCase<InputJobStartModel, OutputJobStartModel> {
  const StartJobUseCase();

  @override
  Future<Either<ConvertouchException, OutputJobStartModel>> execute(
    InputJobStartModel input,
  ) async {
    if (input.job.progressController == null) {
      return Right(
        OutputJobStartModel(
          job: input.job,
        ),
      );
    }

    try {
      final jobOperation = CancelableOperation<void>.fromFuture(
        _executeJob(input),
        onCancel: () {
          log("The job operation in the group '${input.job.params.groupName}' "
              "has been cancelled");
        },
      );

      return Right(
        OutputJobStartModel(
          job: input.job.copyWith(
            status: JobStatus.running,
          ),
          jobOperation: jobOperation,
        ),
      );
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

  Future<void> _executeJob(InputJobStartModel input) async {
    try {
      log("try block started");

      DynamicDataModel? result = await input.onExecute.call(input.job.params);

      ConvertouchException info = ConvertouchException(
        message: "Refreshed successfully!",
        severity: ExceptionSeverity.info,
      );

      _addToController(
        controller: input.job.progressController!,
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
        controller: input.job.progressController!,
        result: JobResultModel.failure(e),
      );

      log("catch block finished");
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
