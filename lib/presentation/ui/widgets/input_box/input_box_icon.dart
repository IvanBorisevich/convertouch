import 'package:flutter/material.dart';

const double _defaultIconWidth = 20;

enum IconType {
  prefix,
  suffix,
}

class InputBoxIconModel {
  final double width;
  final double? height;
  final bool visible;
  final bool hasDivider;
  final Widget Function() builder;
  final void Function()? onTap;

  const InputBoxIconModel.icon({
    this.width = _defaultIconWidth,
    this.height,
    required this.builder,
    this.visible = true,
    this.onTap,
  }) : hasDivider = false;

  const InputBoxIconModel.iconWithDivider({
    this.width = _defaultIconWidth,
    this.height,
    required this.builder,
    this.visible = true,
    this.onTap,
  }) : hasDivider = true;
}
