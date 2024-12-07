import 'dart:developer';

import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/job_result_model.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ConvertouchProgressButton extends StatelessWidget {
  final Widget buttonWidget;
  final Stream<JobResultModel>? progressStream;
  final double radius;
  final bool determinate;
  final bool visible;
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
    this.visible = true,
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
                    if (snapshot.data!.progressPercent != 1.0) {
                      onProgressIndicatorInterrupt?.call();
                    }
                    return buttonWidget;
                  } else {
                    return GestureDetector(
                      onTap: () {
                        if (onProgressIndicatorClick != null) {
                          onProgressIndicatorClick!.call();
                        } else {
                          onProgressIndicatorInterrupt?.call();
                        }
                      },
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
      ),
    );
  }
}
