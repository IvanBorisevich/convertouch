import 'package:convertouch/presentation/ui/style/color/model/multi_color.dart';

class WidgetColorScheme {
  static const WidgetColorScheme none = WidgetColorScheme();

  final MultiColor border;
  final MultiColor background;
  final MultiColor foreground;

  const WidgetColorScheme({
    this.border = MultiColor.none,
    this.background = MultiColor.none,
    this.foreground = MultiColor.none,
  });
}

class NotificationColorScheme extends WidgetColorScheme {
  static const NotificationColorScheme none = NotificationColorScheme();

  final MultiColor action;

  const NotificationColorScheme({
    super.border,
    super.background,
    super.foreground,
    this.action = MultiColor.none,
  });
}

class PageColorScheme {
  final WidgetColorScheme appBar;
  final WidgetColorScheme body;
  final WidgetColorScheme bottomBar;

  const PageColorScheme({
    required this.appBar,
    required this.body,
    required this.bottomBar,
  });
}

class TextBoxColorScheme extends WidgetColorScheme {
  static const TextBoxColorScheme none = TextBoxColorScheme();

  final MultiColor hint;
  final MultiColor label;
  final NotificationColorScheme tooltip;

  const TextBoxColorScheme({
    super.border,
    super.background,
    super.foreground,
    this.hint = MultiColor.none,
    this.label = MultiColor.none,
    this.tooltip = NotificationColorScheme.none,
  });
}

class DropdownColorScheme extends WidgetColorScheme {
  static const DropdownColorScheme none = DropdownColorScheme();

  final MultiColor divider;

  const DropdownColorScheme({
    super.border,
    super.background,
    super.foreground,
    this.divider = MultiColor.none,
  });
}

class InputBoxColorScheme {
  final TextBoxColorScheme textBox;
  final DropdownColorScheme dropdown;
  final MultiColor divider;

  const InputBoxColorScheme({
    this.textBox = TextBoxColorScheme.none,
    this.dropdown = DropdownColorScheme.none,
    this.divider = MultiColor.none,
  });
}

class SearchBoxColorScheme {
  final InputBoxColorScheme inputBox;
  final WidgetColorScheme viewModeButton;

  const SearchBoxColorScheme({
    required this.inputBox,
    required this.viewModeButton,
  });
}

class MenuViewColorScheme {
  final MenuItemColorScheme menuItem;
  final WidgetColorScheme noItemsInfoBox;

  const MenuViewColorScheme({
    this.menuItem = MenuItemColorScheme.none,
    this.noItemsInfoBox = WidgetColorScheme.none,
  });
}

class MenuItemColorScheme extends WidgetColorScheme {
  static const MenuItemColorScheme none = MenuItemColorScheme();

  final MultiColor divider;
  final MultiColor titleBackground;
  final WidgetColorScheme modeIcon;
  final WidgetColorScheme checkBox;
  final MultiColor matchBackground;
  final MultiColor matchForeground;

  const MenuItemColorScheme({
    super.border,
    super.background,
    super.foreground,
    this.titleBackground = MultiColor.none,
    this.modeIcon = WidgetColorScheme.none,
    this.checkBox = WidgetColorScheme.none,
    this.divider = MultiColor.none,
    this.matchForeground = MultiColor.none,
    this.matchBackground = MultiColor.none,
  });
}

class ConversionItemColorScheme extends WidgetColorScheme {
  final InputBoxColorScheme inputBox;
  final MultiColor unitButton;
  final MultiColor prefixWidget;
  final MultiColor suffixWidget;
  final MultiColor removalIcon;

  const ConversionItemColorScheme({
    required this.inputBox,
    required this.unitButton,
    this.prefixWidget = MultiColor.none,
    this.suffixWidget = MultiColor.none,
    this.removalIcon = MultiColor.none,
    super.background,
  });
}

class ParamSetPanelColorScheme {
  final WidgetColorScheme tab;
  final WidgetColorScheme toolset;
  final WidgetColorScheme footer;
  final MultiColor removalIcon;
  final ConversionItemColorScheme paramItem;

  const ParamSetPanelColorScheme({
    this.tab = WidgetColorScheme.none,
    this.toolset = WidgetColorScheme.none,
    this.footer = WidgetColorScheme.none,
    this.removalIcon = MultiColor.none,
    required this.paramItem,
  });
}

class SettingGroupColorScheme {
  final WidgetColorScheme viewTitle;
  final MultiColor divider;
  final SettingItemColorScheme settingItem;

  const SettingGroupColorScheme({
    this.viewTitle = WidgetColorScheme.none,
    this.divider = MultiColor.none,
    this.settingItem = SettingItemColorScheme.none,
  });
}

class SwitcherColorScheme {
  static const SwitcherColorScheme none = SwitcherColorScheme();

  final WidgetColorScheme thumb;
  final WidgetColorScheme track;

  const SwitcherColorScheme({
    this.thumb = WidgetColorScheme.none,
    this.track = WidgetColorScheme.none,
  });
}

class SettingItemColorScheme extends WidgetColorScheme {
  static const SettingItemColorScheme none = SettingItemColorScheme();

  final SwitcherColorScheme switcher;
  final MultiColor selectedValue;

  const SettingItemColorScheme({
    super.border,
    super.background,
    super.foreground,
    this.switcher = SwitcherColorScheme.none,
    this.selectedValue = MultiColor.none,
  });
}
