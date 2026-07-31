import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/job_result_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_dynamic_data_fetch_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

enum JobStatus {
  created,
  running,
  finalized,
  ;
}

enum JobExecutionMode {
  continueAlreadyRunningJobIfAny,
  startNewJob,
  ;

  static JobExecutionMode? valueOf(dynamic value) {
    if (value is JobExecutionMode) {
      return value;
    }

    return values.firstWhereOrNull((element) => value == element.name);
  }
}

class JobModel extends IdNameItemModel {
  final InputDynamicDataFetchModel params;
  final Cron cron;
  final DateTime? completedAt;
  final StreamController<JobResultModel>? progressController;
  final JobStatus status;
  final JobExecutionMode executionMode;

  const JobModel({
    this.params = InputDynamicDataFetchModel.empty,
    this.cron = Cron.never,
    this.completedAt,
    this.progressController,
    this.status = JobStatus.created,
    this.executionMode = JobExecutionMode.continueAlreadyRunningJobIfAny,
  }) : super(
          name: "",
          itemType: ItemType.job,
          oob: true,
        );

  JobModel copyWith({
    InputDynamicDataFetchModel? params,
    JobStatus? status,
    DateTime? completedAt,
    Cron? cron,
    Patchable<StreamController<JobResultModel>>? progressController,
  }) {
    return JobModel(
      executionMode: executionMode,
      params: params ?? this.params,
      completedAt: completedAt ?? this.completedAt,
      cron: cron ?? this.cron,
      status: status ?? this.status,
      progressController:
          ObjectUtils.patch(this.progressController, progressController),
    );
  }

  @override
  List<Object?> get props => [
        params,
        cron,
        completedAt,
        progressController.hashCode,
        itemType,
        status,
        executionMode,
      ];

  static JobModel? fromJson(Map<String, dynamic>? json) {
    log("Job deserialization of json: $json");

    if (json == null) {
      return null;
    }

    DateTime? completedAt =
        DateTime.tryParse(json["completedAt"] ?? json["lastRefreshTime"] ?? "");

    return JobModel(
      cron: Cron.valueOf(json["selectedCron"]),
      completedAt: completedAt,
    );
  }

  @override
  Map<String, dynamic> toJson({bool removeNulls = true}) {
    var result = {
      "selectedCron": cron.name,
      "completedAt": completedAt?.toString(),
    };

    if (removeNulls) {
      result.removeWhere((key, value) => value == null);
    }

    return result;
  }

  @override
  String toString() {
    return 'JobModel{'
        'params: $params, '
        'selectedCron: $cron, '
        'completedAt: $completedAt, '
        'progressController: $progressController '
        '(${progressController?.hashCode}), '
        'status: $status, '
        'executionMode: $executionMode}';
  }
}
