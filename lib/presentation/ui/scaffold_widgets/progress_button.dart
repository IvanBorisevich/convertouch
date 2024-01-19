import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ConvertouchProgressButton extends StatelessWidget {
  final Widget buttonWidget;
  final Stream<double>? progressStream;
  final double radius;
  final void Function()? onProgressIndicatorFinish;
  final void Function()? onProgressIndicatorClick;
  final void Function()? onProgressIndicatorErrorIconClick;
  final EdgeInsets? margin;
  final Color? progressIndicatorColor;
  final Color? progressIndicatorErrorIconColor;

  const ConvertouchProgressButton({
    required this.buttonWidget,
    required this.progressStream,
    this.radius = 25,
    this.onProgressIndicatorFinish,
    this.onProgressIndicatorClick,
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
          : StreamBuilder<double>(
              stream: progressStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return IconButton(
                    onPressed: onProgressIndicatorErrorIconClick,
                    icon: Icon(
                      Icons.error_outline,
                      color: progressIndicatorErrorIconColor,
                      size: radius,
                    ),
                  );
                } else if (snapshot.data == null) {
                  return buttonWidget;
                } else if (snapshot.connectionState == ConnectionState.done) {
                  onProgressIndicatorFinish?.call();
                  return buttonWidget;
                } else {
                  return GestureDetector(
                    onTap: onProgressIndicatorClick,
                    child: CircularPercentIndicator(
                      radius: radius,
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
            ),
    );
  }
}
