import 'package:convertouch/presentation/ui/style/color/color_set.dart';
import 'package:convertouch/presentation/ui/style/color/color_state_variation.dart';
import 'package:flutter/material.dart';

abstract class ColorScheme {
  const ColorScheme();
}

class PageColorScheme extends ColorScheme {
  final ColorStateVariation<AppBarColorSet> appBar;
  final BaseColorSet page;
  final ColorStateVariation<AppBarColorSet> bottomBar;
  final SnackBarColorSet snackBar;

  const PageColorScheme({
    required this.appBar,
    required this.page,
    required this.bottomBar,
    required this.snackBar,
  });
}

class SearchBarColorScheme extends ColorScheme {
  final TextBoxColorSet searchBox;
  final ButtonColorSet viewModeButton;

  const SearchBarColorScheme({
    this.searchBox = emptyTextBoxColorSet,
    this.viewModeButton = emptyButtonColorSet,
  });
}

class ConversionItemColorScheme extends ColorScheme {
  final ColorStateVariation<TextBoxColorSet> textBox;
  final ColorStateVariation<BaseColorSet> unitButton;
  final Color handler;

  const ConversionItemColorScheme({
    required this.textBox,
    required this.unitButton,
    required this.handler,
  });
}
