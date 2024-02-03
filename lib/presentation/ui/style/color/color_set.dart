import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';

const BaseColorSet emptyColorSet = BaseColorSet();
const ButtonColorSet emptyButtonColorSet = ButtonColorSet();
const TextBoxColorSet emptyTextBoxColorSet = TextBoxColorSet();
const SwitcherColorSet emptyRadioColorSet = SwitcherColorSet();

abstract class ColorSet {
  const ColorSet();
}

class BaseColorSet extends ColorSet {
  final Color background;
  final Color foreground;
  final Color border;

  const BaseColorSet({
    this.background = noColor,
    this.foreground = noColor,
    this.border = noColor,
  });
}

class AppBarColorSet extends BaseColorSet {
  const AppBarColorSet({
    super.background,
    super.foreground,
  });
}

class ButtonColorSet extends BaseColorSet {
  const ButtonColorSet({
    super.background,
    super.foreground,
    super.border,
  });
}

class SwitcherColorSet extends ColorSet {
  final BaseColorSet track;
  final Color thumb;

  const SwitcherColorSet({
    this.track = emptyColorSet,
    this.thumb = noColor,
  });
}

class SettingItemColorSet extends BaseColorSet {
  final Color divider;
  final SwitcherColorSet switcher;

  const SettingItemColorSet({
    super.background,
    super.foreground,
    this.divider = noColor,
    this.switcher = emptyRadioColorSet,
  });
}

class TextBoxColorSet extends BaseColorSet {
  final Color label;
  final Color hint;

  const TextBoxColorSet({
    super.background,
    super.foreground,
    super.border,
    this.label = noColor,
    this.hint = noColor,
  });
}
