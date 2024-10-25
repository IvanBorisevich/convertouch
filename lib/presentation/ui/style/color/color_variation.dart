import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';

class ColorVariation {
  static const ColorVariation none = ColorVariation.only(noColor);

  final Color _regular;
  final Color? _selected;
  final Color? _focused;
  final Color? _disabled;

  const ColorVariation({
    required Color regular,
    Color? selected,
    Color? focused,
    Color? disabled,
  })  : _regular = regular,
        _selected = selected,
        _focused = focused,
        _disabled = disabled;

  const ColorVariation.only(Color color)
      : this(
          regular: color,
        );

  Color get regular => _regular;

  Color get disabled => _disabled ?? _regular;

  Color get focused => _focused ?? _regular;

  Color get selected => _selected ?? _regular;
}
