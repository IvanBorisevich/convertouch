import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:flutter/material.dart';

const ListItemColorVariation defaultListItemColor = ListItemColorVariation();
const TextBoxColorVariation defaultTextBoxColor = TextBoxColorVariation();
const ScaffoldColorVariation defaultScaffoldColor = ScaffoldColorVariation();
const SearchBarColorVariation defaultSearchBarColor = SearchBarColorVariation();
const SideMenuColorVariation defaultSideMenuColor = SideMenuColorVariation();
const SwitcherColorVariation defaultSwitcherColor = SwitcherColorVariation();

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

class SideMenuColorVariation extends ConvertouchColorVariation {
  final Color backgroundColor;
  final Color headerColor;
  final Color contentColor;
  final Color activeSwitcherColor;
  final Color footerDividerColor;

  const SideMenuColorVariation({
    this.backgroundColor = noColor,
    this.headerColor = noColor,
    this.contentColor = noColor,
    this.activeSwitcherColor = noColor,
    this.footerDividerColor = noColor,
  });
}

class FloatingButtonColorVariation extends ConvertouchColorVariation {
  final Color background;
  final Color foreground;

  const FloatingButtonColorVariation({
    this.background = noColor,
    this.foreground = noColor,
  });
}

class SwitcherColorVariation extends ConvertouchColorVariation {
  final Color thumb;
  final Color track;

  const SwitcherColorVariation({
    this.thumb = noColor,
    this.track = noColor,
  });
}
