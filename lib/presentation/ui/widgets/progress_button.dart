import 'dart:developer';

import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/job_result_model.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ConvertouchProgressButton extends StatelessWidget {
  final Widget initialButtonWidget;
  final Stream<JobResultModel>? progressStream;
  final double radius;
  final bool determinate;
  final bool visible;
  final void Function()? onProgressIndicatorClick;
  final void Function(JobResultModel)? onFetchSuccess;
  final void Function(ConvertouchException info)? onFetchError;
  final EdgeInsets? margin;
  final WidgetColorScheme colors;
  final ConvertouchUITheme theme;

  const ConvertouchProgressButton({
    required this.initialButtonWidget,
    required this.progressStream,
    this.radius = 25,
    this.determinate = false,
    this.visible = true,
    this.onProgressIndicatorClick,
    this.onFetchSuccess,
    this.onFetchError,
    this.margin,
    required this.colors,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    log("refresh button progressStream: $progressStream");

    return Visibility(
      visible: visible,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        alignment: Alignment.center,
        margin: margin,
        child: progressStream == null
            ? initialButtonWidget
            : StreamBuilder<JobResultModel>(
                stream: progressStream,
                builder: (context, snapshot) {
                  log("Connection: ${snapshot.connectionState}, "
                      "data: ${snapshot.data?.progressPercent}");

                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                                  color: colors.foreground.selected,
                                ),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: colors.foreground.selected,
                              animation: true,
                              animateFromLastPercent: true,
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: colors.background.selected,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(30)),
                                border: Border.all(
                                  color: colors.border.selected,
                                ),
                              ),
                              child: CircularProgressIndicator(
                                value: null,
                                strokeWidth: 3.0,
                                strokeCap: StrokeCap.round,
                                color: colors.foreground.selected,
                              ),
                            ),
                    );
                  } else if (snapshot.hasError) {
                    log("Error received: ${snapshot.error}");
                    onFetchError?.call(
                      snapshot.error is ConvertouchException
                          ? snapshot.error as ConvertouchException
                          : ConvertouchException(
                              message: snapshot.error!.toString(),
                              severity: ExceptionSeverity.warning,
                            ),
                    );

                    return initialButtonWidget;
                  } else {
                    if (snapshot.data!.finished) {
                      log("Data receiving finished successfully");
                      onFetchSuccess?.call(snapshot.data!);
                    } else if (snapshot.data!.failed) {
                      log("Data receiving failed");
                      onFetchError?.call(snapshot.data!.notification!);
                    }

                    return initialButtonWidget;
                  }
                },
              ),
      ),
    );
  }
}
