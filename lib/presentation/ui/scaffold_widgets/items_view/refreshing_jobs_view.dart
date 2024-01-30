import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/model/refreshing_job_result_model.dart';
import 'package:convertouch/presentation/ui/animation/fade_scale_animation.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/items_view/item/refreshing_job_item.dart';
import 'package:flutter/material.dart';

class ConvertouchRefreshingJobsView extends StatelessWidget {
  final List<RefreshingJobModel> jobItems;
  final Map<int, RefreshingJobModel> jobsInProgress;
  final void Function(RefreshingJobModel)? onItemClick;
  final void Function(RefreshingJobModel)? onJobStartClick;
  final void Function(RefreshingJobModel)? onJobStopClick;
  final void Function(
    RefreshingJobModel,
    RefreshingJobResultModel,
  )? onJobFinish;
  final double listTopSpacing;
  final double itemsSpacing;
  final ConvertouchUITheme theme;

  const ConvertouchRefreshingJobsView(
    this.jobItems, {
    this.jobsInProgress = const {},
    this.onItemClick,
    this.onJobStartClick,
    this.onJobStopClick,
    this.onJobFinish,
    this.listTopSpacing = 2,
    this.itemsSpacing = 10,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.only(top: listTopSpacing),
        child: ListView.separated(
          padding: EdgeInsets.all(itemsSpacing),
          itemCount: jobItems.length,
          itemBuilder: (context, index) {
            var jobItem = jobItems[index];
            return ConvertouchFadeScaleAnimation(
              child: ConvertouchRefreshingJobItem(
                jobsInProgress[jobItem.id] ?? jobItem,
                onItemClick: () {
                  onItemClick?.call(jobItem);
                },
                onRefreshButtonClick: () {
                  onJobStartClick?.call(jobItem);
                },
                onOngoingRefreshButtonClick: () {
                  onJobStopClick?.call(jobItem);
                },
                onFinish: (jobResult) {
                  onJobFinish?.call(jobItem, jobResult);
                },
                theme: theme,
              ),
            );
          },
          separatorBuilder: (context, index) => Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              itemsSpacing,
              itemsSpacing,
              itemsSpacing,
              index == jobItems.length - 1 ? itemsSpacing : 0,
            ),
          ),
        ),
      ),
    );
  }
}
