import 'dart:async';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/job_result_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class JobModel<P, R> extends IdNameItemModel {
  final P? params;
  final Cron selectedCron;
  final DateTime? completedAt;
  final StreamController<JobResultModel>? progressController;
  final bool alreadyRunning;
  final void Function(R)? onSuccess;
  final void Function(ConvertouchException)? onError;

  const JobModel({
    this.params,
    this.selectedCron = Cron.never,
    this.completedAt,
    this.progressController,
    this.alreadyRunning = false,
    this.onSuccess,
    this.onError,
  }) : super(
          name: "",
          itemType: ItemType.job,
          oob: true,
        );

  JobModel.coalesce(
    JobModel savedModel, {
    Patchable<P>? params,
    Patchable<DateTime>? completedAt,
    Patchable<Cron>? selectedCron,
    Patchable<StreamController<JobResultModel>>? progressController,
    Patchable<bool>? alreadyRunning,
  }) : this(
          params: ObjectUtils.patch(savedModel.params, params),
          completedAt: ObjectUtils.patch(savedModel.completedAt, completedAt),
          selectedCron:
              ObjectUtils.patch(savedModel.selectedCron, selectedCron)!,
          progressController: ObjectUtils.patch(
              savedModel.progressController, progressController),
          alreadyRunning:
              ObjectUtils.patch(savedModel.alreadyRunning, alreadyRunning)!,
        );

  @override
  List<Object?> get props => [
        params,
        selectedCron,
        completedAt,
        progressController,
        alreadyRunning,
        itemType,
      ];

  static JobModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    return JobModel(
      selectedCron: Cron.valueOf(json["selectedCron"]),
      completedAt: json["lastRefreshTime"] != null
          ? DateTime.parse(json["lastRefreshTime"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "selectedCron": selectedCron.name,
      "lastRefreshTime": completedAt?.toString(),
    };
  }

  @override
  String toString() {
    return 'JobModel{'
        'selectedCron: $selectedCron, '
        'completedAt: $completedAt, '
        'progressController: $progressController}';
  }
}
