import 'package:convertouch/presentation/ui/style/color/model/app_color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/model/multi_color.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:flutter/material.dart';

const colorSchemeLight = AppColorScheme(
  notification: _notification,
  page: _page,
  popupMenu: _popupMenu,
  searchBox: _searchBox,
  errorInfoBox: _errorInfoBox,
  dialog: _dialog,
  unitGroupsPageFloatingButton: _unitGroupsPageFloatingButton,
  unitGroupsMenu: _unitGroupsMenu,
  unitGroupDetailsInputBox: _unitGroupDetailsInputBox,
  unitsPageFloatingButton: _unitsPageFloatingButton,
  unitsMenu: _unitsMenu,
  unitDetailsInputBox: _unitDetailsInputBox,
  paramsMenu: _paramsMenu,
  conversionPageFloatingButton: _conversionPageFloatingButton,
  conversionItem: _conversionItem,
  refreshFloatingButton: _refreshFloatingButton,
  failureFloatingButton: _failureFloatingButton,
  removalFloatingButton: _removalFloatingButton,
  paramSetPanel: _paramSetPanel,
  settingGroup: _settingGroup,
);

const Color _pageBackground = Color(0xffe8efff);
const Color _warningForeground = Color(0xFFEADFB8);

const _notification = NotificationColorScheme(
  background: MultiColor.only(Color(0xFF384867)),
  foreground: MultiColor(
    regular: Color(0xFFA3D4FF),
    warning: _warningForeground,
    error: Color(0xFFFFAAAA),
  ),
  action: MultiColor.only(Color(0xFFB6D5F6)),
);

const _dropdown = DropdownColorScheme(
  background: MultiColor.only(Color(0xffbccdfa)),
  foreground: MultiColor(
    regular: Color(0xFF1D578C),
    warning: _warningForeground,
  ),
  icon: MultiColor.only(Color(0xFF1060A8)),
  searchBox: _dropdownSearchBox,
  selectedItem: WidgetColorScheme(
    background: MultiColor.only(Color(0xffaabef1)),
    foreground: MultiColor.only(Color(0xFF1D578C)),
  ),
);

const _page = PageColorScheme(
  appBar: WidgetColorScheme(
    background: MultiColor.only(Color(0xff7f9dec)),
    foreground: MultiColor.only(Color(0xFF1D5180)),
  ),
  body: WidgetColorScheme(
    background: MultiColor.only(_pageBackground),
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

const _popupMenu = DropdownColorScheme(
  background: MultiColor.only(Color(0xff7f9dec)),
  foreground: MultiColor.only(Color(0xFF1D5180)),
  divider: MultiColor.only(Color(0xff6c8adc)),
  icon: MultiColor.only(Color(0xFF1D5180)),
  removalItem: MultiColor.only(Color(0xFF7C3D19)),
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

const _dialog = WidgetColorScheme(
  background: MultiColor.only(Color(0xFFDBE6FF)),
  foreground: MultiColor.only(Color(0xFF345F87)),
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
      regular: Color(0xffd5e3ff),
      selected: Color(0xff9db3ea),
    ),
    titleBackground: MultiColor(
      regular: Color(0xffcadcff),
      selected: Color(0xffaabce8),
    ),
    matchBackground: MultiColor.only(Color(0xff687698)),
    matchForeground: MultiColor.only(Color(0xffcadcff)),
    foreground: MultiColor(
      regular: Color(0xFF303073),
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
        regular: _pageBackground,
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

const _unitGroupDetailsInputBox = DetailsItemColorsScheme(
  editable: InputBoxColorScheme(
    textBox: TextBoxColorScheme(
      background: MultiColor.only(_pageBackground),
      border: MultiColor(
        regular: Color(0xFF6766D3),
        disabled: Color(0xFF6160BE),
      ),
      foreground: MultiColor(
        regular: Color(0xFF282771),
        disabled: Color(0xFF454577),
      ),
      hint: MultiColor(
        regular: Color(0xFF7574E1),
      ),
      label: MultiColor(
        regular: Color(0xFF6766D3),
        disabled: Color(0xFF6160BE),
      ),
    ),
  ),
  readonly: InputBoxColorScheme(
    textBox: TextBoxColorScheme(
      background: MultiColor.only(Color(0xFFD9DFFF)),
      border: MultiColor.only(Color(0xFF6766D3)),
      foreground: MultiColor.only(Color(0xFF282771)),
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
      regular: Color(0xFFC3DAFB),
      disabled: Color(0x9EBFD8FA),
    ),
    titleBackground: MultiColor(
      regular: Color(0xFFB3CFF6),
      disabled: Color(0x9EB1CBEF),
    ),
    matchBackground: MultiColor.only(Color(0xFF6186B6)),
    matchForeground: MultiColor.only(Color(0xFFC3DAFB)),
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
        regular: _pageBackground,
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

const _unitDetailsInputBox = DetailsItemColorsScheme(
  editable: InputBoxColorScheme(
    textBox: TextBoxColorScheme(
      background: MultiColor.only(_pageBackground),
      border: MultiColor(
        regular: Color(0xFF4F7498),
        focused: Color(0xFF233B50),
        disabled: Color(0xFF90A8C0),
      ),
      foreground: MultiColor(
        regular: Color(0xBE122C45),
        disabled: Color(0xFF6A87A3),
      ),
      hint: MultiColor(
        regular: Color(0xFF799BBB),
        disabled: Color(0xBE73ACE5),
      ),
      label: MultiColor(
        regular: Color(0xFF4F7498),
        focused: Color(0xFF233B50),
        disabled: Color(0xFF90A8C0),
      ),
    ),
  ),
  readonly: InputBoxColorScheme(
    textBox: TextBoxColorScheme(
      background: MultiColor.only(Color(0xFFDAE6FF)),
      border: MultiColor.only(Color(0xFF4F7498)),
      foreground: MultiColor.only(Color(0xBE122C45)),
    ),
  ),
);

const _paramsMenu = MenuViewColorScheme(
  menuItem: MenuItemColorScheme(
    border: MultiColor(
      regular: Color(0xFFA3D6E3),
      disabled: Color(0xFFB1DBE6),
    ),
    background: MultiColor(
      regular: Color(0xFF8CD1E6),
      disabled: Color(0xFF94D7E8),
    ),
    titleBackground: MultiColor(
      regular: Color(0xFF80C4D8),
      disabled: Color(0xFF84C6D6),
    ),
    matchBackground: MultiColor.only(Color(0xFF53737A)),
    matchForeground: MultiColor.only(Color(0xFFABDFEC)),
    foreground: MultiColor(
      regular: Color(0xFF3C636C),
      disabled: Color(0xFF456870),
    ),
    divider: MultiColor(
      regular: Color(0xFF365F68),
      disabled: Color(0xFF3D626A),
    ),
    checkBox: WidgetColorScheme(
      border: MultiColor(
        regular: Color(0xFF365F68),
      ),
      background: MultiColor(
        regular: _pageBackground,
        selected: Color(0xFF365F68),
      ),
      foreground: MultiColor(
        regular: Colors.transparent,
        selected: Colors.white,
      ),
    ),
  ),
);

const _conversionPageFloatingButton = WidgetColorScheme(
  background: MultiColor.only(Color(0xFF3F74A8)),
  foreground: MultiColor.only(Color(0xFFF5F7FF)),
);

const _conversionItemTextBox = TextBoxColorScheme(
  background: MultiColor.only(_pageBackground),
  border: MultiColor(
    regular: Color(0xFF4F7498),
    focused: Color(0xFF1B2F40),
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
    disabled: Color(0xFF7298BC),
  ),
  tooltip: _notification,
);

const _dropdownSearchBox = TextBoxColorScheme(
  background: MultiColor.only(_pageBackground),
  foreground: MultiColor(
    regular: Color(0xBE143656),
    disabled: Color(0xFF90A8C0),
  ),
  hint: MultiColor(
    regular: Color(0xFF799BBB),
    disabled: Color(0xBE73ACE5),
  ),
);

const _conversionItem = ConversionItemColorScheme(
  inputBox: InputBoxColorScheme(
    textBox: _conversionItemTextBox,
    dropdown: _dropdown,
    divider: MultiColor(
      regular: Color(0xFFBAD2EC),
      disabled: Color(0xFF90A8C0),
    ),
  ),
  unitButton: MultiColor.only(Color(0xFF2C6396)),
  prefixWidget: MultiColor(
    regular: Color(0xFF7799B9),
    selected: Color(0xFF2C6396),
  ),
  suffixWidget: MultiColor(
    regular: Color(0xFF7799B9),
    selected: Color(0xFF2C6396),
  ),
  removalIcon: MultiColor.only(Color(0xFFB6441C)),
);

const _refreshFloatingButton = WidgetColorScheme(
  border: MultiColor(
    regular: Color(0xFF2095B7),
    disabled: Color(0xFF9FBEC8),
  ),
  foreground: MultiColor(
    regular: Color(0xFFE8E8FF),
    disabled: Color(0xFF9FBEC8),
    selected: Color(0xFF2095B7),
  ),
  background: MultiColor(
    regular: Color(0xFF2095B7),
    selected: _pageBackground,
    disabled: _pageBackground,
  ),
);

const _failureFloatingButton = WidgetColorScheme(
  border: MultiColor.only(Color(0xFFAE6A6A)),
  foreground: MultiColor.only(Color(0xFFAE6A6A)),
  background: MultiColor.only(_pageBackground),
);

const _removalFloatingButton = WidgetColorScheme(
  border: MultiColor.only(_pageBackground),
  background: MultiColor.only(Color(0xFFD36422)),
  foreground: MultiColor.only(Color(0xFFDEE9FF)),
);

const _paramItemTextBox = TextBoxColorScheme(
  background: MultiColor.only(Color(0xffd8e3ff)),
  border: MultiColor(
    regular: Color(0xFF4F7498),
    focused: Color(0xFF1B2F40),
    disabled: Color(0xFF90A8C0),
  ),
  foreground: MultiColor(
    regular: Color(0xBE143656),
    disabled: Color(0xFF90A8C0),
    warning: Color(0xFFAF5A3F),
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

const _paramItem = ConversionItemColorScheme(
  inputBox: InputBoxColorScheme(
    textBox: _paramItemTextBox,
    dropdown: _dropdown,
    divider: MultiColor(
      regular: Color(0xFFBAD2EC),
      disabled: Color(0xFF90A8C0),
    ),
  ),
  unitButton: MultiColor.only(Color(0xFF2C6396)),
  prefixWidget: MultiColor(
    regular: Color(0xFF7799B9),
    selected: Color(0xFF2C6396),
  ),
  suffixWidget: MultiColor(
    regular: Color(0xFF7799B9),
    selected: Color(0xFF2C6396),
  ),
  removalIcon: MultiColor.only(Color(0xFFB6441C)),
);

const _paramSetPanel = ParamSetPanelColorScheme(
  slidingPanel: SlidingPanelColorScheme(
    tabPanel: TabPanelColorScheme(
      tab: WidgetColorScheme(
        background: MultiColor(
          regular: Color(0xffb6c8f8),
          selected: Color(0xFF4379AA),
        ),
        foreground: MultiColor(
          regular: Color(0xFF295175),
          selected: Color(0xffe4edff),
        ),
      ),
      leadingIcon: WidgetColorScheme(
        foreground: MultiColor(
          regular: Color(0xFFB6441C),
          disabled: Color(0xFFBF907F),
        ),
      ),
      trailingIcon: WidgetColorScheme(
        foreground: MultiColor(
          regular: Color(0xFF2D6698),
          disabled: Color(0xFF85A2BC),
        ),
      ),
    ),
    body: WidgetColorScheme(
      background: MultiColor.only(Color(0xffd8e3ff)),
    ),
    jobInfoBox: WidgetColorScheme(
      background: MultiColor.only(Color(0xffcddbff)),
      foreground: MultiColor.only(Color(0xFF395E80)),
    ),
    footer: WidgetColorScheme(
      background: MultiColor.only(Color(0xffadc2f6)),
      foreground: MultiColor.only(Color(0xFF6C9CC9)),
    ),
  ),
  paramItem: _paramItem,
);

const _settingGroup = SettingGroupColorScheme(
  viewTitle: WidgetColorScheme(
    foreground: MultiColor.only(Color(0xFF426F99)),
  ),
  divider: MultiColor.only(_pageBackground),
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
