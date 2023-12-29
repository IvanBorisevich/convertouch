import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color.dart';
import 'package:convertouch/presentation/ui/style/model/color_variation.dart';
import 'package:flutter/material.dart';

class ConvertouchRefreshingJobItem extends StatelessWidget {
  final RefreshingJobModel item;
  final bool enabled;
  final void Function()? onItemClick;
  final void Function()? onRefreshButtonClick;
  final void Function()? onToggleButtonClick;
  final double itemContainerHeight;
  final double toggleButtonHeight;
  final double itemSpacing;
  final ConvertouchUITheme theme;
  final RefreshingJobItemColor? customColors;

  const ConvertouchRefreshingJobItem(
    this.item, {
    this.enabled = false,
    this.onItemClick,
    this.onRefreshButtonClick,
    this.onToggleButtonClick,
    this.itemContainerHeight = 70,
    this.toggleButtonHeight = 50,
    this.itemSpacing = 7,
    required this.theme,
    this.customColors,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    RefreshingJobItemColor color =
        customColors ?? refreshingJobItemsColors[theme]!;

    Widget jobInfoLabel({
      required String text,
      required EdgeInsetsGeometry padding,
      FontWeight fontWeight = FontWeight.w500,
      double fontSize = 11,
      required Color textColor,
    }) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: padding,
          child: Text(
            text,
            style: TextStyle(
              fontFamily: quicksandFontFamily,
              fontWeight: fontWeight,
              color: enabled ? textColor : textColor.withOpacity(0.5),
              fontSize: fontSize,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      );
    }

    Widget controlButton({
      required IconData icon,
      Function()? onClick,
      required ButtonColorVariation color,
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
                color: color.foreground,
                size: 25,
              ),
              onPressed: onClick,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: itemContainerHeight,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: color.jobItem.regular.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: enabled
                      ? color.jobItem.selected.border
                      : color.jobItem.regular.border,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        jobInfoLabel(
                          text: item.name,
                          padding: const EdgeInsets.only(left: 12, top: 7),
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          textColor: color.jobItem.regular.content,
                        ),
                        jobInfoLabel(
                          text: 'Last Refresh: ${item.lastRefreshTime}',
                          padding: const EdgeInsets.only(top: 3, left: 12),
                          textColor: color.jobItem.regular.content,
                        ),
                        jobInfoLabel(
                          text: enabled ? 'ACTIVE' : 'NOT ACTIVE',
                          padding: const EdgeInsets.only(top: 3, left: 12),
                          fontWeight: FontWeight.w700,
                          textColor: enabled
                              ? color.activeStatusLabel
                              : color.notActiveStatusLabel,
                        ),
                      ],
                    ),
                  ),
                  controlButton(
                    icon: Icons.refresh_rounded,
                    onClick: () {
                      if (enabled) {
                        onRefreshButtonClick?.call();
                      }
                    },
                    color: enabled
                        ? color.refreshButton.regular
                        : color.refreshButton.inactive,
                  ),
                  controlButton(
                    icon: Icons.power_settings_new_outlined,
                    onClick: onToggleButtonClick,
                    color: !enabled
                        ? color.toggleButton.regular
                        : color.toggleButton.clicked,
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
