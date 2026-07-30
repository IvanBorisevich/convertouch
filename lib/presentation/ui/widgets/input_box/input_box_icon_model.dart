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

class InputBoxIconsWrapperModel {
  static const empty = InputBoxIconsWrapperModel();

  final List<InputBoxIconModel> prefixIconsModels;
  final List<InputBoxIconModel> suffixIconsModels;
  final double iconSpacing;
  final double innermostSpacing;
  final double innermostSpacingWithoutDivider;
  final double outermostSpacingWithoutIcons;
  final double outermostSpacingWithIcons;

  const InputBoxIconsWrapperModel({
    this.prefixIconsModels = const [],
    this.suffixIconsModels = const [],
    this.iconSpacing = 5,
    this.innermostSpacing = 7,
    this.innermostSpacingWithoutDivider = 5,
    this.outermostSpacingWithoutIcons = 12,
    this.outermostSpacingWithIcons = 10,
  });

  InputBoxIconsWrapperModel copyWith({
    List<InputBoxIconModel>? prefixIconsModels,
    List<InputBoxIconModel>? suffixIconsModels,
    double? iconSpacing,
    double? innermostSpacing,
    double? innermostSpacingWithoutDivider,
    double? outermostSpacingWithoutIcons,
    double? outermostSpacingWithIcons,
  }) {
    return InputBoxIconsWrapperModel(
      prefixIconsModels: prefixIconsModels ?? this.prefixIconsModels,
      suffixIconsModels: suffixIconsModels ?? this.suffixIconsModels,
      iconSpacing: iconSpacing ?? this.iconSpacing,
      innermostSpacing: innermostSpacing ?? this.innermostSpacing,
      innermostSpacingWithoutDivider:
          innermostSpacingWithoutDivider ?? this.innermostSpacingWithoutDivider,
      outermostSpacingWithoutIcons:
          outermostSpacingWithoutIcons ?? this.outermostSpacingWithoutIcons,
      outermostSpacingWithIcons:
          outermostSpacingWithIcons ?? this.outermostSpacingWithIcons,
    );
  }
}
