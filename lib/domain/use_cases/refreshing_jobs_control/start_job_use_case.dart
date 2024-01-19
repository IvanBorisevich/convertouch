import 'dart:async';

import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

import 'package:rxdart/rxdart.dart';

class StartJobUseCase extends UseCase<RefreshingJobModel, RefreshingJobModel> {
  const StartJobUseCase();

  @override
  Future<Either<Failure, RefreshingJobModel>> execute(
    RefreshingJobModel input,
  ) async {
    int jobId = input.id!;
    StreamController<double>? jobProgressController;

    try {
      jobProgressController = createJobProgressStream(
        (jobProgressController) => Future.forEach(
          List.generate(10, (i) => i + 1),
          (int i) async {
            if (!jobProgressController.isClosed) {
              jobProgressController.add(i / 10);
            }

            await Future.delayed(
              const Duration(seconds: 1),
            );
          },
        ),
      );

      return Right(
        RefreshingJobModel.coalesce(
          input,
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
    Future<void> Function(StreamController) jobLogic,
  ) {
    late final BehaviorSubject<double> jobProgressController;
    jobProgressController = BehaviorSubject<double>(
      onListen: () async {
        await jobLogic.call(jobProgressController);

        await jobProgressController.close();
      }
    );

    return jobProgressController;
  }
}
