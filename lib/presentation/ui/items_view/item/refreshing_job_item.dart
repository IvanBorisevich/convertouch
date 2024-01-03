import 'dart:async';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color.dart';
import 'package:flutter/material.dart';

class ConvertouchRefreshingJobItem extends StatelessWidget {
  static const double itemContainerHeight = 70;
  static const double itemButtonHeight = 50;
  static const double itemButtonIconHeight = 25;

  // static final Stream<double> _stream =
  //     Stream.periodic(const Duration(seconds: 1), (i) => i * 10.0).take(10);

  final RefreshingJobModel item;
  final Stream<double>? dataRefreshingProgress;
  final void Function()? onItemClick;
  final void Function()? onRefreshButtonClick;
  final double itemSpacing;
  final ConvertouchUITheme theme;
  final RefreshingJobItemColor? customColors;

  const ConvertouchRefreshingJobItem(
    this.item, {
    this.dataRefreshingProgress,
    this.onItemClick,
    this.onRefreshButtonClick,
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
              color: textColor,
              fontSize: fontSize,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
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
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: itemSpacing),
                      child: Container(
                        width: itemButtonHeight,
                        height: itemButtonHeight,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.refreshButton.regular.background,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: color.refreshButton.regular.border,
                            width: 1,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            onRefreshButtonClick?.call();
                          },
                          child: dataRefreshingProgress != null
                              ? StreamBuilder<double>(
                                  stream: dataRefreshingProgress,
                                  builder: (context, snapshot) {
                                    print("There is progress");
                                    Widget result;
                                    if (snapshot.hasError) {
                                      result = const Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                        size: itemButtonIconHeight,
                                      );
                                    } else {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.none:
                                          result = const Icon(
                                            Icons.info,
                                            color: Colors.blue,
                                            size: itemButtonIconHeight,
                                          );

                                        case ConnectionState.waiting:
                                        case ConnectionState.active:
                                          result = CircularProgressIndicator(
                                            value: snapshot.data,
                                            color: color.refreshButton.regular
                                                .foreground,
                                          );
                                        case ConnectionState.done:
                                          result = const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: itemButtonIconHeight,
                                          );

                                      }
                                    }
                                    return result;
                                  },
                                )
                              : Icon(
                                  Icons.refresh_rounded,
                                  color: color.refreshButton.regular.foreground,
                                  size: itemButtonIconHeight,
                                ),
                        ),
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
