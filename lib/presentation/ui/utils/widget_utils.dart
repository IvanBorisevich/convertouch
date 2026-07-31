import 'package:flutter/material.dart';

Widget wrapInGestureDetector({
  void Function()? onTap,
  required Widget child,
}) {
  return onTap != null
      ? GestureDetector(
          onTap: onTap,
          child: child,
        )
      : child;
}
