import 'package:convertouch/presentation/ui/style/model/color_variation.dart';
import 'package:flutter/material.dart';

abstract class ConvertouchColor<T extends ConvertouchColorVariation> {
  final T regular;
  final T marked;
  final T selected;
  final T focused;
  final T? switchedOn;
  final T? disabled;

  const ConvertouchColor({
    required this.regular,
    required this.marked,
    required this.selected,
    required this.focused,
    this.switchedOn,
    this.disabled,
  });
}

class ConvertouchListItemColor
    extends ConvertouchColor<ListItemColorVariation> {
  const ConvertouchListItemColor({
    required super.regular,
    super.marked = defaultListItemColor,
    super.selected = defaultListItemColor,
    super.focused = defaultListItemColor,
  });
}

class ConvertouchTextBoxColor extends ConvertouchColor<TextBoxColorVariation> {
  const ConvertouchTextBoxColor({
    required super.regular,
    super.marked = defaultTextBoxColor,
    super.selected = defaultTextBoxColor,
    super.focused = defaultTextBoxColor,
  });
}

class ConvertouchConversionItemColor {
  final ConvertouchTextBoxColor textBox;
  final ConvertouchListItemColor unitButton;
  final Color handlersColor;

  const ConvertouchConversionItemColor({
    required this.textBox,
    required this.unitButton,
    required this.handlersColor,
  });
}

class ConvertouchScaffoldColor
    extends ConvertouchColor<ScaffoldColorVariation> {
  const ConvertouchScaffoldColor({
    required super.regular,
    super.marked = defaultScaffoldColor,
    super.selected = defaultScaffoldColor,
    super.focused = defaultScaffoldColor,
  });
}

class ConvertouchSearchBarColor
    extends ConvertouchColor<SearchBarColorVariation> {
  const ConvertouchSearchBarColor({
    required super.regular,
    super.marked = defaultSearchBarColor,
    super.selected = defaultSearchBarColor,
    super.focused = defaultSearchBarColor,
  });
}

class ConvertouchSideMenuColor
    extends ConvertouchColor<SideMenuColorVariation> {
  const ConvertouchSideMenuColor({
    required super.regular,
    super.marked = defaultSideMenuColor,
    super.selected = defaultSideMenuColor,
    super.focused = defaultSideMenuColor,
  });
}

class ConvertouchSwitcherColor extends ConvertouchColor<SwitcherColorVariation> {
  const ConvertouchSwitcherColor({
    required super.regular,
    super.marked = defaultSwitcherColor,
    super.selected = defaultSwitcherColor,
    super.focused = defaultSwitcherColor,
    super.switchedOn = defaultSwitcherColor,
  });
}
