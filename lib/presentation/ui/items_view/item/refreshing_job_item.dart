import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/presentation/ui/style/model/color_variation.dart';
import 'package:flutter/material.dart';

class ConvertouchRefreshingJobItem extends StatelessWidget {
  final RefreshingJobModel item;
  final double itemContainerHeight;
  final double toggleButtonHeight;
  final double itemSpacing;
  final ListItemColorVariation color;

  const ConvertouchRefreshingJobItem(
    this.item, {
    this.itemContainerHeight = 70,
    this.toggleButtonHeight = 50,
    this.itemSpacing = 7,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemContainerHeight,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: color.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: color.border,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12, top: 7),
                            child: Text(
                              item.name,
                              style: TextStyle(
                                fontFamily: quicksandFontFamily,
                                fontWeight: FontWeight.w700,
                                color: color.content,
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 3, left: 12),
                            child: Text(
                              'Last Refresh: ${item.lastRefreshTime}',
                              style: TextStyle(
                                fontFamily: quicksandFontFamily,
                                fontWeight: FontWeight.w500,
                                color: color.content,
                                fontSize: 11,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _controlButton(
                    icon: Icons.refresh_rounded,
                  ),
                  _controlButton(
                    icon: Icons.power_settings_new_outlined,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    Function()? onClick,
  }) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(right: itemSpacing),
        child: Container(
          width: toggleButtonHeight,
          height: toggleButtonHeight,
          decoration: BoxDecoration(
            color: color.background,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: color.border,
              width: 1,
            ),
          ),
          child: IconButton(
            icon: Icon(
              icon,
              color: color.border,
              size: 23,
            ),
            onPressed: onClick,
          ),
        ),
      ),
    );
  }
}
