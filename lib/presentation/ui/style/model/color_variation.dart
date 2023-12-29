import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:flutter/material.dart';

const ListItemColorVariation defaultListItemColor = ListItemColorVariation();
const TextBoxColorVariation defaultTextBoxColor = TextBoxColorVariation();
const ScaffoldColorVariation defaultScaffoldColor = ScaffoldColorVariation();
const SearchBarColorVariation defaultSearchBarColor = SearchBarColorVariation();
const ButtonColorVariation defaultButtonColorVariation = ButtonColorVariation();

abstract class ConvertouchColorVariation {
  const ConvertouchColorVariation();
}

class ListItemColorVariation extends ConvertouchColorVariation {
  final Color border;
  final Color background;
  final Color content;

  const ListItemColorVariation({
    this.border = noColor,
    this.background = noColor,
    this.content = noColor,
  });
}

class TextBoxColorVariation extends ConvertouchColorVariation {
  final Color border;
  final Color content;
  final Color label;
  final Color hint;

  const TextBoxColorVariation({
    this.border = noColor,
    this.content = noColor,
    this.label = noColor,
    this.hint = noColor,
  });
}

class ScaffoldColorVariation extends ConvertouchColorVariation {
  final Color backgroundColor;
  final Color appBarColor;
  final Color appBarFontColor;
  final Color appBarIconColor;
  final Color appBarIconColorDisabled;

  const ScaffoldColorVariation({
    this.backgroundColor = noColor,
    this.appBarColor = noColor,
    this.appBarFontColor = noColor,
    this.appBarIconColor = noColor,
    this.appBarIconColorDisabled = noColor,
  });
}

class SearchBarColorVariation extends ConvertouchColorVariation {
  final Color searchBoxIconColor;
  final Color searchBoxFillColor;
  final Color hintColor;
  final Color textColor;
  final Color viewModeButtonColor;
  final Color viewModeIconColor;

  const SearchBarColorVariation({
    this.searchBoxIconColor = noColor,
    this.searchBoxFillColor = noColor,
    this.hintColor = noColor,
    this.textColor = noColor,
    this.viewModeButtonColor = noColor,
    this.viewModeIconColor = noColor,
  });
}

class ButtonColorVariation extends ConvertouchColorVariation {
  final Color background;
  final Color foreground;
  final Color border;

  const ButtonColorVariation({
    this.background = noColor,
    this.foreground = noColor,
    this.border = noColor,
  });
}
