import 'dart:async';
import 'dart:developer';

import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/model/job_result_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';
import 'package:rxdart/rxdart.dart';

class StartJobUseCase<R> extends UseCase<JobModel<R>, JobModel> {
  const StartJobUseCase();

  @override
  Future<Either<ConvertouchException, JobModel<R>>> execute(
    JobModel<R> input,
  ) async {
    StreamController<JobResultModel>? jobProgressController;

    try {
      if (input.progressController != null &&
          !input.progressController!.isClosed) {
        return Right(
          JobModel.coalesce(
            input,
            alreadyRunning: true,
          ),
        );
      }

      input.beforeStart?.call();

      jobProgressController = createJobProgressStream(
        jobFunc: (jobProgressController) async {
          if (!jobProgressController.isClosed) {
            jobProgressController.add(const JobResultModel.start());
          } else {
            log("On start: stream controller is already closed");
            return null;
          }

          R? result = await input.jobFunc?.call();

          if (!jobProgressController.isClosed) {
            log("Add finish result to the stream");
            jobProgressController.add(
              const JobResultModel.finish(),
            );
          } else {
            log("At finish: stream controller is already closed");
          }
          return result;
        },
        onComplete: input.onComplete,
      );

      return Right(
        JobModel.coalesce(
          input,
          progressController: jobProgressController,
        ),
      );
    } catch (e, stackTrace) {
      log("Closing the stream from use case");
      jobProgressController?.close();

      log("Error when starting the refreshing job '${input.name}': "
          "$e, $stackTrace");

      return Left(
        InternalException(
          message: "Error when starting the refreshing job '${input.name}'",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  StreamController<JobResultModel> createJobProgressStream({
    required Future<R?> Function(StreamController<JobResultModel>) jobFunc,
    void Function(R?)? onComplete,
  }) {
    late final BehaviorSubject<JobResultModel> jobProgressController;
    jobProgressController = BehaviorSubject<JobResultModel>(
      onListen: () async {
        try {
          await jobFunc.call(jobProgressController).then((result) {
            if (!jobProgressController.isClosed) {
              log("Closing the stream once job has been completed");
              jobProgressController.close();
              log("onComplete callback function calling");
              onComplete?.call(result);
            } else {
              log("After finish: stream controller is already closed");
            }
          });
        } catch (e) {
          log("Closing the stream when error during job execution");
          await jobProgressController.close();
        }
      },
    );

    return jobProgressController;
  }
}
