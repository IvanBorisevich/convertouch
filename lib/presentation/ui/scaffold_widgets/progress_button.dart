import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ConvertouchProgressButton extends StatelessWidget {
  final Widget button;
  final Stream<double>? progressStream;
  final void Function()? onProgressIndicatorFinish;
  final void Function()? onProgressIndicatorClick;
  final void Function()? onProgressIndicatorErrorIconClick;
  final double progressIndicatorRadius;
  final double progressIndicatorIconHeight;
  final Color? progressIndicatorColor;
  final Color? progressIndicatorErrorIconColor;

  const ConvertouchProgressButton({
    required this.button,
    required this.progressStream,
    this.onProgressIndicatorFinish,
    this.onProgressIndicatorClick,
    this.onProgressIndicatorErrorIconClick,
    this.progressIndicatorRadius = 25,
    this.progressIndicatorIconHeight = 25,
    this.progressIndicatorColor,
    this.progressIndicatorErrorIconColor = Colors.red,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return progressStream == null
        ? button
        : StreamBuilder<double>(
            stream: progressStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return IconButton(
                  onPressed: onProgressIndicatorErrorIconClick,
                  icon: Icon(
                    Icons.error_outline,
                    color: progressIndicatorErrorIconColor,
                    size: progressIndicatorIconHeight,
                  ),
                );
              } else if (snapshot.data == null) {
                return button;
              } else if (snapshot.connectionState == ConnectionState.done) {
                onProgressIndicatorFinish?.call();
                return button;
              } else {
                return GestureDetector(
                  onTap: onProgressIndicatorClick,
                  child: CircularPercentIndicator(
                    radius: progressIndicatorRadius,
                    lineWidth: 5.0,
                    percent: snapshot.data!,
                    center: Text(
                      "${snapshot.data! * 100}%",
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
                  ),
                );
              }
            },
          );
  }
}
