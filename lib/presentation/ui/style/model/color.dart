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

class ButtonColor {
  final ButtonColorVariation regular;
  final ButtonColorVariation inactive;
  final ButtonColorVariation clicked;

  const ButtonColor({
    required this.regular,
    this.inactive = defaultButtonColorVariation,
    this.clicked = defaultButtonColorVariation,
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

class RefreshingJobItemColor {
  final ConvertouchListItemColor jobItem;
  final ButtonColor refreshButton;
  final ButtonColor toggleButton;
  final Color activeStatusLabel;
  final Color notActiveStatusLabel;

  const RefreshingJobItemColor({
    required this.jobItem,
    required this.refreshButton,
    required this.toggleButton,
    required this.activeStatusLabel,
    required this.notActiveStatusLabel,
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


