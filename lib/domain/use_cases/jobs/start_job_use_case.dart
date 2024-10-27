import 'dart:async';
import 'dart:developer';

import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/model/job_result_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';
import 'package:rxdart/rxdart.dart';

abstract class StartJobUseCase<P, R>
    extends UseCase<JobModel<P, R>, JobModel<P, R>> {
  const StartJobUseCase();

  @override
  Future<Either<ConvertouchException, JobModel<P, R>>> execute(
    JobModel<P, R> input,
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

      jobProgressController = _createJobProgressStream(
        jobFunc: (jobProgressController) async {
          if (!jobProgressController.isClosed) {
            jobProgressController.add(const JobResultModel.start());
          } else {
            log("On start: stream controller is already closed");
            return null;
          }

          R? result = await onExecute(input.params);

          if (!jobProgressController.isClosed) {
            log("Add finish result to the stream");
            jobProgressController.add(
              const JobResultModel.finish(),
            );
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

  StreamController<JobResultModel> _createJobProgressStream({
    required Future<R?> Function(
      StreamController<JobResultModel>,
    ) jobFunc,
    Future<void> Function(R?)? onComplete,
  }) {
    late final BehaviorSubject<JobResultModel> jobProgressController;
    jobProgressController = BehaviorSubject<JobResultModel>(
      onListen: () async {
        await jobFunc.call(jobProgressController).then((result) async {
          log("onComplete callback function calling");
          await onComplete?.call(result);
        }).catchError((err) {
          log("onError callback function calling: $err");
          jobProgressController.addError(err);
        }).whenComplete(() async {
          if (!jobProgressController.isClosed) {
            await jobProgressController.close();
          }
        });
      },
    );

    return jobProgressController;
  }

  Future<R?> onExecute(P? params);
}
