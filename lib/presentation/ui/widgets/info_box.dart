import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';

class ConvertouchInfoBox extends StatelessWidget {
  final Color background;
  final Color? headerColor;
  final String? headerText;
  final double headerFontSize;
  final Color? bodyColor;
  final String? bodyText;
  final double bodyFontSize;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool visible;
  final Widget? child;

  const ConvertouchInfoBox({
    this.background = noColor,
    this.headerColor,
    this.headerText,
    this.headerFontSize = 13,
    this.bodyColor,
    this.bodyText,
    this.bodyFontSize = 18,
    this.padding,
    this.margin,
    this.visible = true,
    this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Container(
        padding: margin,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: padding,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerText != null
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        headerText!,
                        style: TextStyle(
                          fontSize: headerFontSize,
                          fontWeight: FontWeight.w600,
                          color: headerColor,
                        ),
                      ),
                    )
                  : empty(),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (child != null) {
                    return child!;
                  }

                  if (bodyText != null) {
                    return Text(
                      bodyText!,
                      style: TextStyle(
                        fontSize: bodyFontSize,
                        color: bodyColor,
                      ),
                    );
                  }

                  return empty();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
