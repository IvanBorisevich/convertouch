import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/presentation/ui/animation/fade_scale_animation.dart';
import 'package:convertouch/presentation/ui/items_view/item/refreshing_job_item.dart';
import 'package:flutter/material.dart';

class ConvertouchRefreshingJobsView extends StatelessWidget {
  final List<RefreshingJobModel> jobItems;
  final Map<int, Stream<double>?> progressValues;
  final void Function(RefreshingJobModel)? onItemClick;
  final void Function(RefreshingJobModel)? onItemRefreshButtonClick;
  final double listTopSpacing;
  final double itemsSpacing;
  final ConvertouchUITheme theme;

  const ConvertouchRefreshingJobsView(
    this.jobItems, {
    this.progressValues = const {},
    this.onItemClick,
    this.onItemRefreshButtonClick,
    this.listTopSpacing = 2,
    this.itemsSpacing = 10,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: listTopSpacing),
      child: ListView.separated(
        padding: EdgeInsets.all(itemsSpacing),
        itemCount: jobItems.length,
        itemBuilder: (context, index) {
          var item = jobItems[index];
          return ConvertouchFadeScaleAnimation(
            child: ConvertouchRefreshingJobItem(
              item,
              progressValue: progressValues[item.id],
              onItemClick: () {
                onItemClick?.call(item);
              },
              onRefreshButtonClick: () {
                onItemRefreshButtonClick?.call(item);
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
    );
  }
}
