import 'dart:developer';

import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_data_refresh_model.dart';
import 'package:convertouch/domain/repositories/network_repository.dart';
import 'package:convertouch/domain/use_cases/jobs/start_job_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class StartRefreshingJobUseCase
    extends StartJobUseCase<InputDataRefreshModel, DynamicDataModel> {
  final NetworkRepository networkRepository;

  const StartRefreshingJobUseCase({
    required this.networkRepository,
  });

  @override
  Future<DynamicDataModel?> onExecute(InputDataRefreshModel? input) async {
    log("Job func start");

    if (input == null) {
      return null;
    }

    DynamicDataModel? dynamicDataModel = ObjectUtils.tryGet(
      await networkRepository.fetchData(
        params: input.params,
      ),
    );

    log("Job func finish");

    return dynamicDataModel;
  }
}
