import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/presentation/ui/animation/fade_scale_animation.dart';
import 'package:convertouch/presentation/ui/items_view/item/refreshing_job_item.dart';
import 'package:flutter/material.dart';

class ConvertouchRefreshingJobsView extends StatelessWidget {
  final List<RefreshingJobModel> jobItems;
  final List<int> activeJobIds;
  final void Function(RefreshingJobModel)? onItemClick;
  final void Function(RefreshingJobModel)? onItemRefreshButtonClick;
  final void Function(RefreshingJobModel)? onItemToggleButtonClick;
  final double listTopSpacing;
  final double itemsSpacing;
  final ConvertouchUITheme theme;

  const ConvertouchRefreshingJobsView(
    this.jobItems, {
    required this.activeJobIds,
    this.onItemClick,
    this.onItemRefreshButtonClick,
    this.onItemToggleButtonClick,
    this.listTopSpacing = 2,
    this.itemsSpacing = 10,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
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
                enabled: activeJobIds.contains(item.id),
                onItemClick: () {
                  onItemClick?.call(item);
                },
                onRefreshButtonClick: () {
                  onItemRefreshButtonClick?.call(item);
                },
                onToggleButtonClick: () {
                  onItemToggleButtonClick?.call(item);
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
    });
  }
}
