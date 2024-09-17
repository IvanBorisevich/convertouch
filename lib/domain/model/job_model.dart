import 'dart:async';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/job_result_model.dart';

class JobModel<R> extends IdNameItemModel {
  final Future<R> Function()? jobFunc;
  final void Function()? beforeStart;
  final void Function(R?)? onComplete;
  final Cron selectedCron;
  final String? lastRefreshTime;
  final StreamController<JobResultModel>? progressController;
  final bool alreadyRunning;

  const JobModel({
    super.name = "",
    required this.jobFunc,
    this.beforeStart,
    this.onComplete,
    required this.selectedCron,
    this.lastRefreshTime,
    this.progressController,
    this.alreadyRunning = false,
    super.itemType = ItemType.job,
    super.oob = true,
  });

  JobModel.coalesce(
    JobModel savedModel, {
    Future<R> Function()? jobFunc,
    void Function()? beforeStart,
    void Function(R?)? onComplete,
    String? lastRefreshTime,
    Cron? selectedCron,
    StreamController<JobResultModel>? progressController,
    bool? alreadyRunning,
  }) : this(
          name: savedModel.name,
          jobFunc: jobFunc ?? savedModel.jobFunc as Future<R> Function()?,
          beforeStart: beforeStart ?? savedModel.beforeStart,
          onComplete: onComplete ?? savedModel.onComplete,
          lastRefreshTime: lastRefreshTime ?? savedModel.lastRefreshTime,
          selectedCron: selectedCron ?? savedModel.selectedCron,
          progressController:
              progressController ?? savedModel.progressController,
          alreadyRunning: alreadyRunning ?? savedModel.alreadyRunning,
        );

  @override
  List<Object?> get props => [
        name,
        jobFunc,
        beforeStart,
        onComplete,
        selectedCron,
        lastRefreshTime,
        progressController,
        alreadyRunning,
        itemType,
      ];

  static JobModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    return JobModel(
      name: json["name"],
      jobFunc: null,
      selectedCron: Cron.valueOf(json["selectedCron"]),
      lastRefreshTime: json["lastRefreshTime"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "selectedCron": selectedCron.name,
      "lastRefreshTime": lastRefreshTime,
    };
  }

  @override
  String toString() {
    return 'JobModel{'
        'name: $name, '
        'selectedCron: $selectedCron, '
        'lastRefreshTime: $lastRefreshTime, '
        'progressController: $progressController}';
  }
}
