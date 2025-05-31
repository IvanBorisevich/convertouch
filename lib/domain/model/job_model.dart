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

  JobModel<P, R> copyWith({
    Patchable<P>? params,
    Patchable<DateTime>? completedAt,
    Patchable<Cron>? selectedCron,
    Patchable<StreamController<JobResultModel>>? progressController,
    Patchable<bool>? alreadyRunning,
  }) {
    return JobModel(
      params: ObjectUtils.patch(this.params, params),
      completedAt: ObjectUtils.patch(this.completedAt, completedAt),
      selectedCron: ObjectUtils.patch(this.selectedCron, selectedCron)!,
      progressController:
          ObjectUtils.patch(this.progressController, progressController),
      alreadyRunning: ObjectUtils.patch(this.alreadyRunning, alreadyRunning)!,
    );
  }

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
      completedAt: ObjectUtils.isNotNullOrEmpty(json["lastRefreshTime"])
          ? DateTime.parse(json["lastRefreshTime"])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson({bool removeNulls = true}) {
    var result = {
      "selectedCron": selectedCron.name,
      "lastRefreshTime": completedAt?.toString(),
    };

    if (removeNulls) {
      result.removeWhere((key, value) => value == null);
    }

    return result;
  }

  @override
  String toString() {
    return 'JobModel{'
        'selectedCron: $selectedCron, '
        'completedAt: $completedAt, '
        'progressController: $progressController}';
  }
}
