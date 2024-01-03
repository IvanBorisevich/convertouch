import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color.dart';
import 'package:flutter/material.dart';

class ConvertouchRefreshingJobItem extends StatelessWidget {
  final RefreshingJobModel item;
  final void Function()? onItemClick;
  final void Function()? onRefreshButtonClick;
  final double itemContainerHeight;
  final double itemButtonHeight;
  final double itemSpacing;
  final ConvertouchUITheme theme;
  final RefreshingJobItemColor? customColors;

  const ConvertouchRefreshingJobItem(
    this.item, {
    this.onItemClick,
    this.onRefreshButtonClick,
    this.itemContainerHeight = 70,
    this.itemButtonHeight = 50,
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
                          text: 'Last executed: '
                              '${item.lastExecutionTime ?? '-'}',
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
                          child: item.dataRefreshingStatus ==
                                  DataRefreshingStatus.on
                              ? Container(
                                  width: 17,
                                  height: 17,
                                  padding: const EdgeInsets.all(10),
                                  child: CircularProgressIndicator(
                                    color:
                                        color.refreshButton.regular.foreground,
                                  ),
                                )
                              // StreamBuilder<int>(
                              //   stream: item.progressStream,
                              //   builder: (context, snapshot) {
                              //     Widget result;
                              //     if (snapshot.hasError) {
                              //       result = const Icon(
                              //         Icons.error_outline,
                              //         color: Colors.red,
                              //         size: 25,
                              //       );
                              //     } else {
                              //       switch (snapshot.connectionState) {
                              //         case ConnectionState.none:
                              //           result = const Icon(
                              //             Icons.info,
                              //             color: Colors.blue,
                              //             size: 25,
                              //           );
                              //         case ConnectionState.waiting:
                              //           result = const SizedBox(
                              //             width: 25,
                              //             height: 25,
                              //             child: CircularProgressIndicator(),
                              //           );
                              //         case ConnectionState.active:
                              //           result = const Icon(
                              //             Icons.check_circle_outline,
                              //             color: Colors.green,
                              //             size: 25,
                              //           );
                              //         case ConnectionState.done:
                              //           result = const Icon(
                              //             Icons.info,
                              //             color: Colors.blue,
                              //             size: 25,
                              //           );
                              //       }
                              //     }
                              //     return result;
                              //   },
                              // )
                              : Icon(
                                  Icons.refresh_rounded,
                                  color: color.refreshButton.regular.foreground,
                                  size: 25,
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
