import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/job_result_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_dynamic_data_fetch_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

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
  final InputDynamicDataFetchModel? params;
  final Cron selectedCron;
  final DateTime? completedAt;
  final StreamController<JobResultModel>? progressController;
  final JobExecutionMode executionMode;
  final void Function(StreamController<JobResultModel>)? onStart;
  final Future<DynamicDataModel?> Function(InputDynamicDataFetchModel? params)?
      onExecute;
  final void Function(DynamicDataModel?)? onSuccess;
  final void Function(ConvertouchException)? onError;

  const JobModel({
    this.params,
    this.selectedCron = Cron.never,
    this.completedAt,
    this.progressController,
    this.executionMode = JobExecutionMode.continueAlreadyRunningJobIfAny,
    this.onStart,
    this.onExecute,
    this.onSuccess,
    this.onError,
  }) : super(
          name: "",
          itemType: ItemType.job,
          oob: true,
        );

  JobModel copyWith({
    Patchable<InputDynamicDataFetchModel>? params,
    Patchable<DateTime>? completedAt,
    Patchable<String>? completedAgo,
    Patchable<Cron>? selectedCron,
    Patchable<StreamController<JobResultModel>>? progressController,
  }) {
    return JobModel(
      onExecute: onExecute,
      executionMode: executionMode,
      params: ObjectUtils.patch(this.params, params),
      completedAt: ObjectUtils.patch(this.completedAt, completedAt),
      selectedCron: ObjectUtils.patch(this.selectedCron, selectedCron)!,
      progressController:
          ObjectUtils.patch(this.progressController, progressController),
    );
  }

  @override
  List<Object?> get props => [
        params,
        selectedCron,
        completedAt,
        progressController,
        itemType,
        executionMode,
      ];

  static JobModel? fromJson(Map<String, dynamic>? json) {
    log("Job deserialization of json: $json");

    if (json == null) {
      return null;
    }

    String? dateStr = json["completedAt"] ?? json["lastRefreshTime"];

    log("date str: $dateStr");

    DateTime? completedAt =
        DateTime.tryParse(json["completedAt"] ?? json["lastRefreshTime"] ?? "");

    var t =  JobModel(
      selectedCron: Cron.valueOf(json["selectedCron"]),
      completedAt: completedAt,
    );

    log("deserialized job: $t");

    return t;
  }

  @override
  Map<String, dynamic> toJson({bool removeNulls = true}) {
    var result = {
      "selectedCron": selectedCron.name,
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
        'selectedCron: $selectedCron, '
        'completedAt: $completedAt, '
        'progressController: $progressController, '
        'executionMode: $executionMode}';
  }
}
