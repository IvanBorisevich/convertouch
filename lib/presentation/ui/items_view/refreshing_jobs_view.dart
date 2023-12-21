import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/presentation/ui/animation/fade_scale_animation.dart';
import 'package:convertouch/presentation/ui/items_view/item/refreshing_job_item.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:flutter/material.dart';

class ConvertouchRefreshingJobsView extends StatelessWidget {
  final List<RefreshingJobModel> items;
  final void Function(RefreshingJobModel)? onItemTap;
  final double listTopSpacing;
  final double itemsSpacing;
  final ConvertouchUITheme theme;

  const ConvertouchRefreshingJobsView(
    this.items, {
    this.onItemTap,
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
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ConvertouchFadeScaleAnimation(
              child: ConvertouchRefreshingJobItem(
                items[index],
                color: refreshingJobsColors[theme]!.regular,
              ),
            );
          },
          separatorBuilder: (context, index) => Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              itemsSpacing,
              itemsSpacing,
              itemsSpacing,
              index == items.length - 1 ? itemsSpacing : 0,
            ),
          ),
        ),
      );
    });
  }
}
