import 'package:flutter/material.dart';

class MultiColor {
  static const MultiColor none = MultiColor.only(Colors.transparent);

  final Color _regular;
  final Color? _selected;
  final Color? _focused;
  final Color? _disabled;
  final Color? _warning;
  final Color? _error;

  const MultiColor({
    required Color regular,
    Color? selected,
    Color? focused,
    Color? disabled,
    Color? warning,
    Color? error,
  })  : _regular = regular,
        _selected = selected,
        _focused = focused,
        _disabled = disabled,
        _warning = warning,
        _error = error;

  const MultiColor.only(Color color)
      : this(
          regular: color,
        );

  Color get regular => _regular;

  Color get disabled => _disabled ?? _regular;

  Color get focused => _focused ?? _regular;

  Color get selected => _selected ?? _regular;

  Color get warning => _warning ?? _regular;

  Color get error => _error ?? _regular;
}
