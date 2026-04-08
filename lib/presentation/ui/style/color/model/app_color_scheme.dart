import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';

class AppColorScheme {
  // common
  final NotificationColorScheme notification;
  final PageColorScheme page;
  final DropdownColorScheme popupMenu;
  final SearchBoxColorScheme searchBox;
  final WidgetColorScheme errorInfoBox;

  // unit group pages
  final WidgetColorScheme unitGroupsPageFloatingButton;
  final MenuViewColorScheme unitGroupsMenu;
  final InputBoxColorScheme unitGroupDetailsInputBox;

  // unit pages
  final WidgetColorScheme unitsPageFloatingButton;
  final MenuViewColorScheme unitsMenu;
  final InputBoxColorScheme unitDetailsInputBox;

  // conversion pages
  final WidgetColorScheme conversionPageFloatingButton;
  final ConversionItemColorScheme conversionItem;
  final WidgetColorScheme refreshFloatingButton;
  final WidgetColorScheme removalFloatingButton;
  final ParamSetPanelColorScheme paramSetPanel;

  // settings page
  final SettingGroupColorScheme settingGroup;

  const AppColorScheme({
    required this.notification,
    required this.page,
    required this.popupMenu,
    required this.searchBox,
    required this.errorInfoBox,
    required this.unitGroupsPageFloatingButton,
    required this.unitGroupsMenu,
    required this.unitGroupDetailsInputBox,
    required this.unitsPageFloatingButton,
    required this.unitsMenu,
    required this.unitDetailsInputBox,
    required this.conversionPageFloatingButton,
    required this.conversionItem,
    required this.refreshFloatingButton,
    required this.removalFloatingButton,
    required this.paramSetPanel,
    required this.settingGroup,
  });
}
