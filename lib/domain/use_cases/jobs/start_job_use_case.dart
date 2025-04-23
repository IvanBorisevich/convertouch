import 'dart:async';
import 'dart:developer';

import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/model/job_result_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
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
          input.copyWith(
            alreadyRunning: const Patchable(true),
          ),
        );
      }

      jobProgressController = _startJob(
        onExecute: () async {
          return onExecute(input.params);
        },
        onSuccess: (result) {
          if (result != null) {
            input.onSuccess?.call(result);
          }
        },
        onError: input.onError,
      );

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

  StreamController<JobResultModel> _startJob({
    required Future<R?> Function() onExecute,
    void Function(ConvertouchException)? onError,
    void Function(R?)? onSuccess,
  }) {
    late final BehaviorSubject<JobResultModel> jobProgressController;
    jobProgressController = BehaviorSubject<JobResultModel>(
      onListen: () async {
        await Future.sync(() async {
          _addToController(
            controller: jobProgressController,
            result: const JobResultModel.start(),
          );
          R? result = await onExecute.call();

          _addToController(
            controller: jobProgressController,
            result: const JobResultModel.finish(),
          );
          return result;
        }).then((result) {
          log("onComplete callback function calling");
          onSuccess?.call(result);
        }).catchError((err) {
          log("onError callback function calling: $err");
          jobProgressController.addError(err);
          onError?.call(err);
        }).whenComplete(() async {
          log("whenComplete callback function calling");
          if (!jobProgressController.isClosed) {
            log("whenComplete: closing the stream controller");
            await jobProgressController.close();
          }
        });
      },
    );

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

  Future<R?> onExecute(P? params);
}
