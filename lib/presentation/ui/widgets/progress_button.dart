import 'dart:developer';

import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/job_result_model.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ConvertouchProgressButton extends StatelessWidget {
  final Widget buttonWidget;
  final Stream<JobResultModel>? progressStream;
  final double radius;
  final bool determinate;
  final bool visible;
  final void Function()? onProgressIndicatorClick;
  final void Function()? onProgressIndicatorErrorIconClick;
  final EdgeInsets? margin;
  final ConvertouchColorScheme colorsInProgress;
  final Color? progressIndicatorErrorIconColor;

  const ConvertouchProgressButton({
    required this.buttonWidget,
    required this.progressStream,
    this.radius = 25,
    this.determinate = false,
    this.visible = true,
    this.onProgressIndicatorClick,
    this.onProgressIndicatorErrorIconClick,
    this.margin,
    required this.colorsInProgress,
    this.progressIndicatorErrorIconColor = Colors.red,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        alignment: Alignment.center,
        margin: margin,
        child: progressStream == null
            ? buttonWidget
            : StreamBuilder<JobResultModel>(
                stream: progressStream,
                builder: (context, snapshot) {
                  log("Connection: ${snapshot.connectionState}, "
                      "data: ${snapshot.data?.progressPercent}");

                  if (snapshot.hasError) {
                    log("Snapshot contains an error: ${snapshot.error}");
                    if (snapshot.error is ConvertouchException) {
                      return buttonWidget;
                    } else {
                      return IconButton(
                        onPressed: onProgressIndicatorErrorIconClick,
                        icon: Icon(
                          Icons.error_outline,
                          color: progressIndicatorErrorIconColor,
                          size: radius,
                        ),
                      );
                    }
                  } else if (snapshot.data == null) {
                    return buttonWidget;
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return buttonWidget;
                  } else {
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
                                  color: colorsInProgress.foreground.selected,
                                ),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor:
                                  colorsInProgress.foreground.selected,
                              animation: true,
                              animateFromLastPercent: true,
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(30)),
                                border: Border.all(
                                  color: colorsInProgress.border.selected,
                                ),
                              ),
                              child: CircularProgressIndicator(
                                value: null,
                                strokeWidth: 3.0,
                                strokeCap: StrokeCap.round,
                                color: colorsInProgress.foreground.selected,
                              ),
                            ),
                    );
                  }
                },
              ),
      ),
    );
  }
}
