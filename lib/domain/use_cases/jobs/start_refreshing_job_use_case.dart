import 'dart:developer';

import 'package:convertouch/domain/model/data_source_model.dart';
import 'package:convertouch/domain/model/network_data_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_data_source_model.dart';
import 'package:convertouch/domain/repositories/data_source_repository.dart';
import 'package:convertouch/domain/repositories/network_repository.dart';
import 'package:convertouch/domain/use_cases/jobs/start_job_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class StartRefreshingJobUseCase
    extends StartJobUseCase<InputDataSourceModel, NetworkDataModel> {
  final NetworkRepository networkRepository;
  final DataSourceRepository dataSourceRepository;

  const StartRefreshingJobUseCase({
    required this.networkRepository,
    required this.dataSourceRepository,
  });

  @override
  Future<NetworkDataModel?> onExecute(InputDataSourceModel? params) async {
    log("Job func start");

    if (params == null) {
      return null;
    }

    DataSourceModel dataSource = ObjectUtils.tryGet(
      await dataSourceRepository.get(
        unitGroupName: params.unitGroupName,
        dataSourceName: params.dataSourceKey,
      ),
    );

    NetworkDataModel networkData = ObjectUtils.tryGet(
      await networkRepository.getRefreshedData(
        unitGroupName: params.unitGroupName,
        dataSource: dataSource,
      ),
    );

    log("Job func finish");

    return networkData;
  }
}
