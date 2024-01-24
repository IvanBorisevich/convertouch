import 'dart:developer';

import 'package:convertouch/domain/model/refreshing_job_result_model.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ConvertouchProgressButton extends StatelessWidget {
  final Widget buttonWidget;
  final Stream<RefreshingJobResultModel>? progressStream;
  final double radius;
  final bool determinate;
  final void Function(RefreshingJobResultModel)? onProgressIndicatorFinish;
  final void Function()? onProgressIndicatorClick;
  final void Function()? onProgressIndicatorInterrupt;
  final void Function()? onProgressIndicatorErrorIconClick;
  final EdgeInsets? margin;
  final Color? progressIndicatorColor;
  final Color? progressIndicatorErrorIconColor;

  const ConvertouchProgressButton({
    required this.buttonWidget,
    required this.progressStream,
    this.radius = 25,
    this.determinate = false,
    this.onProgressIndicatorFinish,
    this.onProgressIndicatorClick,
    this.onProgressIndicatorInterrupt,
    this.onProgressIndicatorErrorIconClick,
    this.margin,
    this.progressIndicatorColor,
    this.progressIndicatorErrorIconColor = Colors.red,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      alignment: Alignment.center,
      margin: margin,
      child: progressStream == null
          ? buttonWidget
          : StreamBuilder<RefreshingJobResultModel>(
              stream: progressStream,
              builder: (context, snapshot) {
                log("snapshot connection: ${snapshot.connectionState}");

                if (snapshot.hasError) {
                  log("Snapshot contains an error");
                  return IconButton(
                    onPressed: onProgressIndicatorErrorIconClick,
                    icon: Icon(
                      Icons.error_outline,
                      color: progressIndicatorErrorIconColor,
                      size: radius,
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == null) {
                    log("Snapshot does not contain data");
                    return buttonWidget;
                  }
                  if (snapshot.data!.progressPercent == 1.0) {
                    onProgressIndicatorFinish?.call(snapshot.data!);
                  } else {
                    onProgressIndicatorInterrupt?.call();
                  }
                  return buttonWidget;
                } else {
                  log("Showing progress indicator");
                  return GestureDetector(
                    onTap: onProgressIndicatorClick,
                    child: determinate
                        ? CircularPercentIndicator(
                            radius: radius,
                            lineWidth: 5.0,
                            percent: snapshot.data!.progressPercent,
                            center: Text(
                              "${snapshot.data!.progressPercent * 100}%",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                color: progressIndicatorColor,
                              ),
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: progressIndicatorColor,
                            animation: true,
                            animateFromLastPercent: true,
                          )
                        : CircularProgressIndicator(
                            value: null,
                            strokeWidth: 5.0,
                            color: progressIndicatorColor,
                          ),
                  );
                }
              },
            ),
    );
  }
}
