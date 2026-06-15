import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/job_result_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_dynamic_data_fetch_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:rxdart/rxdart.dart';

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
  final Cron cron;
  final DateTime? completedAt;
  final BehaviorSubject<JobResultModel>? progressController;
  final JobExecutionMode executionMode;
  final void Function(BehaviorSubject<JobResultModel>)? beforeStart;
  final Future<DynamicDataModel?> Function(InputDynamicDataFetchModel? params)?
      onExecute;

  const JobModel({
    this.params,
    this.cron = Cron.never,
    this.completedAt,
    this.progressController,
    this.executionMode = JobExecutionMode.continueAlreadyRunningJobIfAny,
    this.beforeStart,
    this.onExecute,
  }) : super(
          name: "",
          itemType: ItemType.job,
          oob: true,
        );

  JobModel copyWith({
    Patchable<InputDynamicDataFetchModel>? params,
    Patchable<DateTime>? completedAt,
    Patchable<Cron>? cron,
    Patchable<BehaviorSubject<JobResultModel>>? progressController,
  }) {
    return JobModel(
      onExecute: onExecute,
      executionMode: executionMode,
      params: ObjectUtils.patch(this.params, params),
      completedAt: ObjectUtils.patch(this.completedAt, completedAt),
      cron: ObjectUtils.patch(this.cron, cron)!,
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
        'executionMode: $executionMode}';
  }
}
