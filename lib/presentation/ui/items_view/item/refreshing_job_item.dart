import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/presentation/ui/style/model/color_variation.dart';
import 'package:flutter/material.dart';

class ConvertouchRefreshingJobItem extends StatelessWidget {
  final RefreshingJobModel item;
  final double itemContainerHeight;
  final double itemSpacing;
  final ListItemColorVariation color;

  const ConvertouchRefreshingJobItem(
    this.item, {
    this.itemContainerHeight = 60,
    this.itemSpacing = 8,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemContainerHeight,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: itemSpacing),
            child: Container(
              width: itemContainerHeight,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: color.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: color.border,
                  width: 1,
                ),
              ),
              child: IconButton(
                icon: const Icon(Icons.not_started_outlined),
                onPressed: () {},
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: color.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: color.border,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 9, top: 5),
                      child: Text(
                        item.name,
                        style: TextStyle(
                          fontFamily: quicksandFontFamily,
                          fontWeight: FontWeight.w700,
                          color: color.content,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, top: 4),
                      child: Text(
                        'Refreshable part: ${item.dataRefreshType}',
                        style: TextStyle(
                          fontFamily: quicksandFontFamily,
                          fontWeight: FontWeight.w500,
                          color: color.content,
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Cron: ${item.cronDescription}',
                        style: TextStyle(
                          fontFamily: quicksandFontFamily,
                          fontWeight: FontWeight.w500,
                          color: color.content,
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
