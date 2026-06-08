import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:flutter/material.dart';

class ConvertouchFailureDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final WidgetColorScheme colors;
  final void Function()? handlerFunc;
  final String? handlerActionName;

  const ConvertouchFailureDialog({
    required this.title,
    required this.content,
    required this.colors,
    this.handlerActionName,
    this.handlerFunc,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          color: colors.foreground.regular,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
        ),
      ),
      contentPadding: const EdgeInsets.only(
        left: 25,
        right: 20,
        top: 20,
      ),
      backgroundColor: colors.background.regular,
      content: content,
      actionsPadding: const EdgeInsets.only(top: 15, bottom: 10, right: 20),
      actions: <Widget>[
        handlerFunc != null
            ? TextButton(
                onPressed: handlerFunc,
                child: Text(
                  handlerActionName ?? 'Try Again',
                  style: TextStyle(
                    color: colors.foreground.regular,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : const SizedBox.shrink(),
        TextButton(
          child: Text(
            'Close',
            style: TextStyle(
              color: colors.foreground.regular,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
