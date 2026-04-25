import 'dart:async';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/job_result_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:timeago/timeago.dart' as timeago;

class JobModel<P, R> extends IdNameItemModel {
  final P? params;
  final Cron selectedCron;
  final DateTime? completedAt;
  final String? completedAgo;
  final StreamController<JobResultModel>? progressController;
  final bool alreadyRunning;
  final void Function(R)? onSuccess;
  final void Function(ConvertouchException)? onError;

  const JobModel({
    this.params,
    this.selectedCron = Cron.never,
    this.completedAt,
    this.completedAgo,
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
    Patchable<String>? completedAtStr,
    Patchable<Cron>? selectedCron,
    Patchable<StreamController<JobResultModel>>? progressController,
    Patchable<bool>? alreadyRunning,
  }) {
    return JobModel(
      params: ObjectUtils.patch(this.params, params),
      completedAt: ObjectUtils.patch(this.completedAt, completedAt),
      completedAgo: ObjectUtils.patch(this.completedAgo, completedAtStr),
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
        completedAgo,
        alreadyRunning,
        itemType,
      ];


  static JobModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    DateTime? completedAt =
        ObjectUtils.isNotNullOrEmpty(json["lastRefreshTime"])
            ? DateTime.parse(json["lastRefreshTime"])
            : (ObjectUtils.isNotNullOrEmpty(json["completedAt"])
                ? DateTime.parse(json["completedAt"])
                : null);

    return JobModel(
      selectedCron: Cron.valueOf(json["selectedCron"]),
      completedAt: completedAt,
      completedAgo: json["completedAgo"] ??
          (completedAt != null ? timeago.format(completedAt) : null),
    );
  }

  @override
  Map<String, dynamic> toJson({bool removeNulls = true}) {
    var result = {
      "selectedCron": selectedCron.name,
      "completedAt": completedAt?.toString(),
      "completedAtStr": completedAgo,
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
        'completedAgo: $completedAgo, '
        'progressController: $progressController, '
        'alreadyRunning: $alreadyRunning}';
  }
}
