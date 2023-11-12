import 'package:convertouch/presentation/pages/style/colors.dart';
import 'package:flutter/material.dart';

const MenuItemColorVariation defaultMenuItemColor = MenuItemColorVariation();
const TextBoxColorVariation defaultTextBoxColor = TextBoxColorVariation();
const ScaffoldColorVariation defaultScaffoldColor = ScaffoldColorVariation();
const SearchBarColorVariation defaultSearchBarColor = SearchBarColorVariation();
const SideMenuColorVariation defaultSideMenuColor = SideMenuColorVariation();


abstract class ConvertouchColorVariation {
  const ConvertouchColorVariation();
}

class MenuItemColorVariation extends ConvertouchColorVariation {
  final Color border;
  final Color background;
  final Color content;

  const MenuItemColorVariation({
    this.border = noColor,
    this.background = noColor,
    this.content = noColor,
  });
}

class TextBoxColorVariation extends ConvertouchColorVariation {
  final Color border;
  final Color content;
  final Color label;

  const TextBoxColorVariation({
    this.border = noColor,
    this.content = noColor,
    this.label = noColor,
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
