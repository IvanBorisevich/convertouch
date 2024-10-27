import 'dart:async';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/job_result_model.dart';

class JobModel<P, R> extends IdNameItemModel {
  final P? params;
  final Cron selectedCron;
  final String? completedAt;
  final StreamController<JobResultModel>? progressController;
  final bool alreadyRunning;
  final Future<void> Function(R?)? onComplete;

  const JobModel({
    this.params,
    this.selectedCron = Cron.never,
    this.completedAt,
    this.progressController,
    this.alreadyRunning = false,
    this.onComplete,
  }) : super(
          name: "",
          itemType: ItemType.job,
          oob: true,
        );

  JobModel.coalesce(
    JobModel savedModel, {
    P? params,
    String? lastRefreshTime,
    Cron? selectedCron,
    StreamController<JobResultModel>? progressController,
    bool? alreadyRunning,
  }) : this(
          params: params ?? savedModel.params,
          completedAt: lastRefreshTime ?? savedModel.completedAt,
          selectedCron: selectedCron ?? savedModel.selectedCron,
          progressController:
              progressController ?? savedModel.progressController,
          alreadyRunning: alreadyRunning ?? savedModel.alreadyRunning,
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
      completedAt: json["lastRefreshTime"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "selectedCron": selectedCron.name,
      "lastRefreshTime": completedAt,
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
