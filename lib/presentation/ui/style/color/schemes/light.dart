import 'package:convertouch/presentation/ui/style/color/model/app_color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/model/multi_color.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:flutter/material.dart';

const colorSchemeLight = AppColorScheme(
  notification: _notification,
  page: _page,
  searchBox: _searchBox,
  errorInfoBox: _errorInfoBox,
  unitGroupsPageFloatingButton: _unitGroupsPageFloatingButton,
  unitGroupsMenu: _unitGroupsMenu,
  unitGroupDetailsInputBox: _unitGroupDetailsTextBox,
  unitsPageFloatingButton: _unitsPageFloatingButton,
  unitsMenu: _unitsMenu,
  unitDetailsInputBox: _unitDetailsTextBox,
  conversionPageFloatingButton: _conversionPageFloatingButton,
  conversionItem: _conversionItem,
  refreshFloatingButton: _refreshFloatingButton,
  removalFloatingButton: _removalFloatingButton,
  paramSetPanel: _paramSetPanel,
  settingGroup: _settingGroup,
);

const _notification = NotificationColorScheme(
  background: MultiColor.only(Color(0xFF384867)),
  foreground: MultiColor(
    regular: Color(0xFFA3D4FF),
    warning: Color(0xFFEADFB8),
    error: Color(0xFFFFAAAA),
  ),
  action: MultiColor.only(Color(0xFFB6D5F6)),
);

const _page = PageColorScheme(
  appBar: WidgetColorScheme(
    background: MultiColor.only(Color(0xff7f9dec)),
    foreground: MultiColor.only(Color(0xFF1D5180)),
  ),
  body: WidgetColorScheme(
    background: MultiColor.only(Color(0xffe8efff)),
    foreground: MultiColor.only(Color(0xFF426F99)),
  ),
  bottomBar: WidgetColorScheme(
    background: MultiColor.only(Color(0xff7f9dec)),
    foreground: MultiColor(
      regular: Color(0xFF1D5180),
      selected: Color(0xFF1C3750),
      disabled: Color(0xFFA0C4F5),
    ),
  ),
);

const _searchBox = SearchBoxColorScheme(
  inputBox: InputBoxColorScheme(
    textBox: TextBoxColorScheme(
      background: MultiColor.only(Color(0xFFF6F9FF)),
      foreground: MultiColor.only(Color(0xFF426F99)),
      hint: MultiColor.only(Color(0xFF5C93C7)),
      tooltip: _notification,
    ),
    divider: MultiColor(
      regular: Color(0xFFBAD2EC),
      focused: Color(0xFF233B50),
      disabled: Color(0xFF90A8C0),
    ),
  ),
  viewModeButton: WidgetColorScheme(
    background: MultiColor.only(Color(0xffc1d7ff)),
    foreground: MultiColor.only(Color(0xFF4D79A1)),
  ),
);

const _errorInfoBox = WidgetColorScheme(
  background: MultiColor.only(Color(0xFFBCD6FF)),
  foreground: MultiColor.only(Color(0xFF426F99)),
);

const _unitGroupsPageFloatingButton = WidgetColorScheme(
  background: MultiColor.only(Color(0xFF6A69D5)),
  foreground: MultiColor.only(Color(0xFFDEE9FF)),
);

const _unitGroupsMenu = MenuViewColorScheme(
  noItemsInfoBox: WidgetColorScheme(
    foreground: MultiColor.only(Color(0xFF45459A)),
  ),
  menuItem: MenuItemColorScheme(
    border: MultiColor(
      regular: Color(0xffc6d7fd),
      selected: Color(0xFF535D91),
    ),
    background: MultiColor(
      regular: Color(0xffc6d7fd),
      selected: Color(0xff9db3ea),
    ),
    titleBackground: MultiColor(
      regular: Color(0xffb8caf6),
      selected: Color(0xffaabce8),
    ),
    matchBackground: MultiColor.only(Color(0xff9aafe0)),
    matchForeground: MultiColor.only(Color(0xFF1E1E3D)),
    foreground: MultiColor(
      regular: Color(0xFF303073),
      selected: Color(0xFF303073),
    ),
    divider: MultiColor(
      regular: Color(0xFF353D69),
      selected: Color(0xFF303073),
    ),
    checkBox: WidgetColorScheme(
      border: MultiColor(
        regular: Color(0xFF303073),
      ),
      background: MultiColor(
        regular: Color(0xffe8efff),
        selected: Color(0xFF303073),
      ),
      foreground: MultiColor(
        regular: Colors.transparent,
        selected: Colors.white,
      ),
    ),
    modeIcon: WidgetColorScheme(
      border: MultiColor(
        regular: Color(0xffaebfe7),
      ),
      background: MultiColor(
        regular: Color(0xffaebfe7),
      ),
      foreground: MultiColor(
        regular: Color(0xFF303073),
      ),
    ),
  ),
);

const _unitGroupDetailsTextBox = InputBoxColorScheme(
  textBox: TextBoxColorScheme(
    border: MultiColor(
      regular: Color(0xFF6766D3),
      disabled: Color(0xFF6160BE),
    ),
    foreground: MultiColor(
      regular: Color(0xFF4544AB),
      disabled: Color(0xFF414194),
    ),
    hint: MultiColor(
      regular: Color(0xFF7574E1),
    ),
    label: MultiColor(
      regular: Color(0xFF6766D3),
      disabled: Color(0xFF6160BE),
    ),
  ),
);

const _unitsPageFloatingButton = WidgetColorScheme(
  background: MultiColor.only(Color(0xFF5189BE)),
  foreground: MultiColor.only(Color(0xFFDEE9FF)),
);

const _unitsMenu = MenuViewColorScheme(
  noItemsInfoBox: WidgetColorScheme(
    foreground: MultiColor.only(Color(0xFF3B6083)),
  ),
  menuItem: MenuItemColorScheme(
    border: MultiColor(
      regular: Color(0xFFAAC9F1),
      disabled: Color(0xAEB1CFF5),
    ),
    background: MultiColor(
      regular: Color(0xFFAAC9F1),
      disabled: Color(0x9EBFD8FA),
    ),
    titleBackground: MultiColor(
      regular: Color(0xFF99C1EF),
      disabled: Color(0x9EB1CBEF),
    ),
    matchBackground: MultiColor.only(Color(0xFF80ADE7)),
    matchForeground: MultiColor.only(Color(0xFF264E72)),
    foreground: MultiColor(
      regular: Color(0xFF2C6396),
      disabled: Color(0xB25086BB),
    ),
    divider: MultiColor(
      regular: Color(0xFF2C6396),
      disabled: Color(0xB2366C9F),
    ),
    checkBox: WidgetColorScheme(
      border: MultiColor(
        regular: Color(0xFF467CAD),
      ),
      background: MultiColor(
        regular: Color(0xffe8efff),
        selected: Color(0xFF467CAD),
      ),
      foreground: MultiColor(
        regular: Colors.transparent,
        selected: Colors.white,
      ),
    ),
    modeIcon: WidgetColorScheme(
      border: MultiColor(
        regular: Color(0xFF96B5DC),
      ),
      background: MultiColor(
        regular: Color(0xFF96B5DC),
      ),
      foreground: MultiColor(
        regular: Color(0xFF2C6396),
      ),
    ),
  ),
);

const _unitDetailsTextBox = InputBoxColorScheme(
  textBox: TextBoxColorScheme(
    border: MultiColor(
      regular: Color(0xFF4F7498),
      focused: Color(0xFF233B50),
      disabled: Color(0xFF90A8C0),
    ),
    foreground: MultiColor(
      regular: Color(0xBE143656),
      disabled: Color(0xFF90A8C0),
    ),
    hint: MultiColor(
      regular: Color(0xFF799BBB),
      disabled: Color(0xBE73ACE5),
    ),
  ),
);

const _conversionPageFloatingButton = WidgetColorScheme(
  background: MultiColor.only(Color(0xFF3F74A8)),
  foreground: MultiColor.only(Color(0xFFF5F7FF)),
);

const _conversionItemTextBox = TextBoxColorScheme(
  background: MultiColor.only(Color(0xffe8efff)),
  border: MultiColor(
    regular: Color(0xFF4F7498),
    focused: Color(0xFF233B50),
    disabled: Color(0xFF90A8C0),
  ),
  foreground: MultiColor(
    regular: Color(0xBE143656),
    disabled: Color(0xFF90A8C0),
  ),
  hint: MultiColor(
    regular: Color(0xFF799BBB),
    disabled: Color(0xBE73ACE5),
  ),
  label: MultiColor(
    regular: Color(0xFF2C6396),
    disabled: Color(0xFF3F72A1),
  ),
  tooltip: _notification,
);

const _conversionItem = ConversionItemColorScheme(
  inputBox: InputBoxColorScheme(
    textBox: _conversionItemTextBox,
    dropdown: DropdownColorScheme(
      background: MultiColor.only(Color(0xffabc4fd)),
      foreground: MultiColor.only(Color(0xFF1D578C)),
      search: _conversionItemTextBox,
    ),
    divider: MultiColor(
      regular: Color(0xFFBAD2EC),
      focused: Color(0xFF233B50),
      disabled: Color(0xFF90A8C0),
    ),
  ),
  background: MultiColor.only(Color(0xffe7f2ff)),
  unitButton: MultiColor.only(Color(0xFF2C6396)),
  prefixWidget: MultiColor(
    regular: Color(0xFF7799B9),
    selected: Color(0xFF2C6396),
  ),
);

const _refreshFloatingButton = WidgetColorScheme(
  border: MultiColor(
    regular: Color(0xFF2095B7),
  ),
  foreground: MultiColor(
    regular: Color(0xFFE8E8FF),
    selected: Color(0xFF2095B7),
  ),
  background: MultiColor.only(Color(0xFF2095B7)),
);

const _removalFloatingButton = WidgetColorScheme(
  border: MultiColor.only(Color(0xFFFCFEFF)),
  background: MultiColor.only(Color(0xFFD36422)),
  foreground: MultiColor.only(Color(0xFFDEE9FF)),
);

const _paramSetPanel = ParamSetPanelColorScheme(
  tab: WidgetColorScheme(
    background: MultiColor(
      regular: Color(0xffdae5ff),
    ),
    foreground: MultiColor(
      regular: Color(0xFF2D6698),
    ),
  ),
  toolset: WidgetColorScheme(
    background: MultiColor.only(Color(0xffc6d6ff)),
    foreground: MultiColor(
      regular: Color(0xFF235475),
      disabled: Color(0xFF97B0C7),
    ),
  ),
  removalIcon: MultiColor.only(Color(0xFFB6441C)),
  footer: WidgetColorScheme(
    background: MultiColor.only(Color(0xffabbff3)),
    foreground: MultiColor.only(Color(0xFF6C9CC9)),
  ),
  paramItem: _conversionItem,
);

const _settingGroup = SettingGroupColorScheme(
  viewTitle: WidgetColorScheme(
    foreground: MultiColor.only(Color(0xFF426F99)),
  ),
  divider: MultiColor.only(Color(0xffe8efff)),
  settingItem: SettingItemColorScheme(
    background: MultiColor(
      regular: Color(0xFFDBE6FF),
      selected: Color(0xFFE5ECFF),
      disabled: Color(0xFFE5ECFF),
    ),
    foreground: MultiColor(
      regular: Color(0xFF345F87),
    ),
    selectedValue: MultiColor(
      regular: Color(0xFF517FAA),
    ),
    switcher: SwitcherColorScheme(
      thumb: WidgetColorScheme(
        background: MultiColor(
          regular: Color(0xFF426F99),
          disabled: Color(0xFF94B4D2),
        ),
      ),
      track: WidgetColorScheme(
        border: MultiColor(
          regular: Color(0xFF426F99),
          selected: Colors.transparent,
          disabled: Color(0xFF94B4D2),
        ),
        background: MultiColor(
          regular: Colors.transparent,
          selected: Color(0xFFAEC3F1),
          disabled: Color(0xFF94B4D2),
        ),
      ),
    ),
  ),
);
