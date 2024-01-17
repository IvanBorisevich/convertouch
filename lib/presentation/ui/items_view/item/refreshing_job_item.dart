import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ConvertouchRefreshingJobItem extends StatelessWidget {
  static const double itemContainerHeight = 70;
  static const double itemButtonHeight = 50;
  static const double itemButtonIconHeight = 25;

  final RefreshingJobModel item;
  final void Function()? onItemClick;
  final void Function()? onStartClick;
  final void Function()? onStopClick;
  final void Function()? onFinish;
  final double itemSpacing;
  final ConvertouchUITheme theme;
  final RefreshingJobItemColor? customColors;

  const ConvertouchRefreshingJobItem(
    this.item, {
    this.onItemClick,
    this.onStartClick,
    this.onStopClick,
    this.onFinish,
    this.itemSpacing = 7,
    required this.theme,
    this.customColors,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    RefreshingJobItemColor color =
        customColors ?? refreshingJobItemsColors[theme]!;

    Widget refreshDataButton() {
      return Container(
        width: itemButtonHeight,
        height: itemButtonHeight,
        decoration: BoxDecoration(
          color: color.refreshButton.regular.background,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: color.refreshButton.regular.border,
            width: 1,
          ),
        ),
        child: IconButton(
          onPressed: onStartClick,
          icon: Icon(
            Icons.refresh_rounded,
            color: color.refreshButton.regular.foreground,
            size: itemButtonIconHeight,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onItemClick,
      child: SizedBox(
        height: itemContainerHeight,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: color.jobItem.regular.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: color.jobItem.regular.border,
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
                            text: 'Last refreshed: '
                                '${item.lastRefreshTime ?? '-'}',
                            padding: const EdgeInsets.only(top: 3, left: 12),
                            textColor: color.jobItem.regular.content,
                          ),
                          jobInfoLabel(
                            text: 'Auto refresh: '
                                '${item.cron != null ? item.cron!.name : 'Off'}',
                            padding: const EdgeInsets.only(top: 3, left: 12),
                            textColor: color.jobItem.regular.content,
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: itemSpacing),
                        child: item.progressController?.stream == null
                            ? refreshDataButton()
                            : StreamBuilder<double>(
                                stream: item.progressController?.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: itemButtonIconHeight,
                                    );
                                  } else if (snapshot.data == null) {
                                    return refreshDataButton();
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    onFinish?.call();
                                    return refreshDataButton();
                                  } else {
                                    return GestureDetector(
                                      onTap: onStopClick,
                                      child: CircularPercentIndicator(
                                        radius: itemButtonIconHeight,
                                        lineWidth: 5.0,
                                        percent: snapshot.data!,
                                        center: Text(
                                          "${snapshot.data! * 100}%",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: color.refreshButton.regular
                                                .foreground,
                                          ),
                                        ),
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        progressColor: color
                                            .refreshButton.regular.foreground,
                                        animation: true,
                                        animateFromLastPercent: true,
                                      ),
                                    );
                                  }
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget jobInfoLabel({
  required String text,
  required EdgeInsetsGeometry padding,
  FontWeight fontWeight = FontWeight.w500,
  Alignment alignment = Alignment.centerLeft,
  double fontSize = 11,
  required Color textColor,
  bool visible = true,
}) {
  return Visibility(
    visible: visible,
    child: Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: quicksandFontFamily,
            fontWeight: fontWeight,
            color: textColor,
            fontSize: fontSize,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    ),
  );
}
