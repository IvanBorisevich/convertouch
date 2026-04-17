import 'package:convertouch/presentation/ui/style/color/model/app_color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/model/multi_color.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:flutter/material.dart';

const colorSchemeDark = AppColorScheme(
  notification: _notification,
  page: _page,
  popupMenu: _popupMenu,
  searchBox: _searchBox,
  errorInfoBox: _errorInfoBox,
  unitGroupsPageFloatingButton: _unitGroupsPageFloatingButton,
  unitGroupsMenu: _unitGroupsMenu,
  unitGroupDetailsInputBox: _unitGroupDetailsInputBox,
  unitsPageFloatingButton: _unitsPageFloatingButton,
  unitsMenu: _unitsMenu,
  unitDetailsInputBox: _unitDetailsInputBox,
  conversionPageFloatingButton: _conversionPageFloatingButton,
  conversionItem: _conversionItem,
  refreshFloatingButton: _refreshFloatingButton,
  removalFloatingButton: _removalFloatingButton,
  paramSetPanel: _paramSetPanel,
  settingGroup: _settingGroup,
);

const Color pageBackground = Color(0xFF363D48);

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
    background: MultiColor.only(Color(0xFF26292F)),
    foreground: MultiColor.only(Color(0xFFBDCDDA)),
  ),
  body: WidgetColorScheme(
    background: MultiColor.only(pageBackground),
    foreground: MultiColor.only(Color(0xFFCCD7E0)),
  ),
  bottomBar: WidgetColorScheme(
    background: MultiColor.only(Color(0xFF2B2F38)),
    foreground: MultiColor(
      regular: Color(0xFFCCD7E0),
      selected: Color(0xFF85B3D9),
      disabled: Color(0xFF8D8D8D),
    ),
  ),
);

const _popupMenu = DropdownColorScheme(
  background: MultiColor.only(Color(0xFF26292F)),
  foreground: MultiColor.only(Color(0xFFBDCDDA)),
  divider: MultiColor.only(Color(0xFF32363E)),
  icon: MultiColor.only(Color(0xFFBDCDDA)),
  removalItem: MultiColor.only(Color(0xFFD56E41)),
);

const _searchBox = SearchBoxColorScheme(
  inputBox: InputBoxColorScheme(
    textBox: TextBoxColorScheme(
      background: MultiColor.only(Color(0xFF444C59)),
      foreground: MultiColor.only(Color(0xFFCCD7E0)),
      hint: MultiColor.only(Color(0xFF8791A1)),
      tooltip: _notification,
    ),
    divider: MultiColor(
      regular: Color(0xFF506578),
      disabled: Color(0xFF687A8C),
    ),
  ),
  viewModeButton: WidgetColorScheme(
    background: MultiColor.only(Color(0xFF383D46)),
    foreground: MultiColor.only(Color(0xFFCCD7E0)),
  ),
);

const _errorInfoBox = WidgetColorScheme(
  background: MultiColor.only(Color(0xFF3E4A5D)),
  foreground: MultiColor.only(Color(0xFF81B8EC)),
);

const _unitGroupsPageFloatingButton = WidgetColorScheme(
  background: MultiColor.only(Color(0xFF5E63A8)),
  foreground: MultiColor.only(Color(0xFFD1CFD3)),
);

const _unitGroupsMenu = MenuViewColorScheme(
  noItemsInfoBox: WidgetColorScheme(
    foreground: MultiColor.only(Color(0xffa6baee)),
  ),
  menuItem: MenuItemColorScheme(
    border: MultiColor(
      regular: Color(0xff434c60),
      selected: Color(0xffa6baee),
    ),
    background: MultiColor(
      regular: Color(0xff434c60),
      selected: Color(0xff475065),
    ),
    titleBackground: MultiColor(
      regular: Color(0xff4b5369),
      selected: Color(0xff475065),
    ),
    matchBackground: MultiColor.only(Color(0xff626f8c)),
    matchForeground: MultiColor.only(Color(0xffd1ddfc)),
    foreground: MultiColor(
      regular: Color(0xffa6baee),
    ),
    divider: MultiColor(
      regular: Color(0xffa6baee),
      selected: Color(0xffa6baee),
    ),
    checkBox: WidgetColorScheme(
      border: MultiColor(
        regular: Color(0xff849ad2),
      ),
      background: MultiColor(
        regular: pageBackground,
        selected: Color(0xff849ad2),
      ),
      foreground: MultiColor(
        regular: Colors.transparent,
        selected: Colors.white,
      ),
    ),
    modeIcon: WidgetColorScheme(
      border: MultiColor(
        regular: Color(0xff525c72),
      ),
      background: MultiColor(
        regular: Color(0xff525c72),
      ),
      foreground: MultiColor(
        regular: Color(0xffa6baee),
      ),
    ),
  ),
);

const _unitGroupDetailsInputBox = InputBoxColorScheme(
  textBox: TextBoxColorScheme(
    background: MultiColor.only(pageBackground),
    border: MultiColor(
      regular: Color(0xFF8594F1),
      disabled: Color(0x90A5B2FF),
    ),
    foreground: MultiColor(
      regular: Color(0xFFC9D0FD),
      disabled: Color(0x90B3BBEA),
    ),
    hint: MultiColor(
      regular: Color(0xFF8594F1),
    ),
    label: MultiColor(
      regular: Color(0xFF8594F1),
      disabled: Color(0x90A5B2FF),
    ),
  ),
);

const _unitsPageFloatingButton = WidgetColorScheme(
  background: MultiColor.only(Color(0xFF446F96)),
  foreground: MultiColor.only(Color(0xFFD1CFD3)),
);

const _unitsMenu = MenuViewColorScheme(
  noItemsInfoBox: WidgetColorScheme(
    foreground: MultiColor.only(Color(0xFF7DAAD3)),
  ),
  menuItem: MenuItemColorScheme(
    border: MultiColor(
      regular: Color(0xFF435064),
      disabled: Color(0x9B424E62),
    ),
    background: MultiColor(
      regular: Color(0xFF435064),
      disabled: Color(0x9B3C485B),
    ),
    titleBackground: MultiColor(
      regular: Color(0xFF495972),
      disabled: Color(0x9B3F4B5E),
    ),
    matchBackground: MultiColor.only(Color(0xFF5A6C86)),
    matchForeground: MultiColor.only(Color(0xFFA6D5FF)),
    foreground: MultiColor(
      regular: Color(0xFF85B3DC),
      disabled: Color(0x867FACD5),
    ),
    divider: MultiColor(
      regular: Color(0xFF7DAAD3),
      disabled: Color(0x867FACD5),
    ),
    checkBox: WidgetColorScheme(
      border: MultiColor(
        regular: Color(0xFF6F98BD),
      ),
      background: MultiColor(
        regular: pageBackground,
        selected: Color(0xFF6F98BD),
      ),
      foreground: MultiColor(
        regular: Colors.transparent,
        selected: Colors.white,
      ),
    ),
    modeIcon: WidgetColorScheme(
      border: MultiColor(
        regular: Color(0xFF54637A),
      ),
      background: MultiColor(
        regular: Color(0xFF54637A),
      ),
      foreground: MultiColor(
        regular: Color(0xFF85B3DC),
      ),
    ),
  ),
);

const _unitDetailsInputBox = InputBoxColorScheme(
  textBox: TextBoxColorScheme(
    background: MultiColor.only(pageBackground),
    border: MultiColor(
      regular: Color(0xFF84A1BD),
      focused: Color(0xFF98BAD9),
      disabled: Color(0xFF687A8C),
    ),
    foreground: MultiColor(
      regular: Color(0xFFC5DDF3),
      disabled: Color(0xFF687A8C),
    ),
    hint: MultiColor(
      regular: Color(0xFF84A1BD),
      disabled: Color(0xFF7C9EBE),
    ),
    label: MultiColor(
      regular: Color(0xFF84A1BD),
      focused: Color(0xFF98BAD9),
      disabled: Color(0xFF687A8C),
    ),
  ),
);

const _conversionPageFloatingButton = WidgetColorScheme(
  background: MultiColor.only(Color(0xFF4079B0)),
  foreground: MultiColor.only(Color(0xFFDEE0FF)),
);

const _conversionItemTextBox = TextBoxColorScheme(
  background: MultiColor.only(pageBackground),
  border: MultiColor(
    regular: Color(0xFF84A1BD),
    focused: Color(0xFFA1C7EA),
    disabled: Color(0xFF687A8C),
  ),
  foreground: MultiColor(
    regular: Color(0xFFA3C2DE),
    disabled: Color(0xFF687A8C),
  ),
  hint: MultiColor(
    regular: Color(0xFF84A1BD),
    disabled: Color(0xFF7C9EBE),
  ),
  label: MultiColor(
    regular: Color(0xFF63A4E4),
    disabled: Color(0xFF5382B1),
  ),
  tooltip: _notification,
);

const _dropdownSearchBox = TextBoxColorScheme(
  background: MultiColor.only(pageBackground),
  foreground: MultiColor(
    regular: Color(0xFFA3C2DE),
    disabled: Color(0xFF687A8C),
  ),
  hint: MultiColor(
    regular: Color(0xFF84A1BD),
    disabled: Color(0xFF7C9EBE),
  ),
);

const _conversionItem = ConversionItemColorScheme(
  inputBox: InputBoxColorScheme(
    textBox: _conversionItemTextBox,
    dropdown: DropdownColorScheme(
      background: MultiColor.only(Color(0xFF3F4857)),
      foreground: MultiColor.only(Color(0xFFBFD3E3)),
      searchBox: _dropdownSearchBox,
    ),
    divider: MultiColor(
      regular: Color(0xFF506578),
      disabled: Color(0xFF687A8C),
    ),
  ),
  unitButton: MultiColor.only(Color(0xFF63A4E4)),
  prefixWidget: MultiColor(
    regular: Color(0xFF7E9CB7),
    selected: Color(0xFFA6C7E5),
  ),
  suffixWidget: MultiColor(
    regular: Color(0xFF7E9CB7),
    selected: Color(0xFFA6C7E5),
  ),
  removalIcon: MultiColor.only(Color(0xFFD56E41)),
);

const _refreshFloatingButton = WidgetColorScheme(
  border: MultiColor(
    regular: Color(0xFF39889F),
  ),
  foreground: MultiColor(
    regular: Color(0xFFBFEFFF),
    selected: Color(0xFF5BAEC7),
  ),
  background: MultiColor.only(Color(0xFF39889F)),
);

const _removalFloatingButton = WidgetColorScheme(
  border: MultiColor.only(pageBackground),
  background: MultiColor.only(Color(0xFF9D5225)),
  foreground: MultiColor.only(Color(0xFFDEE9FF)),
);

const _paramItemTextBox = TextBoxColorScheme(
  background: MultiColor.only(Color(0xFF323944)),
  border: MultiColor(
    regular: Color(0xFF84A1BD),
    focused: Color(0xFFA1C7EA),
    disabled: Color(0xFF687A8C),
  ),
  foreground: MultiColor(
    regular: Color(0xFFA3C2DE),
    disabled: Color(0xFF687A8C),
  ),
  hint: MultiColor(
    regular: Color(0xFF84A1BD),
    disabled: Color(0xFF7C9EBE),
  ),
  label: MultiColor(
    regular: Color(0xFF63A4E4),
    disabled: Color(0xFF5382B1),
  ),
  tooltip: _notification,
);

const _paramItem = ConversionItemColorScheme(
  inputBox: InputBoxColorScheme(
    textBox: _paramItemTextBox,
    dropdown: DropdownColorScheme(
      background: MultiColor.only(Color(0xFF3F4857)),
      foreground: MultiColor.only(Color(0xFFBFD3E3)),
      searchBox: _dropdownSearchBox,
    ),
    divider: MultiColor(
      regular: Color(0xFF506578),
      disabled: Color(0xFF687A8C),
    ),
  ),
  unitButton: MultiColor.only(Color(0xFF63A4E4)),
  prefixWidget: MultiColor(
    regular: Color(0xFF7E9CB7),
    selected: Color(0xFFA6C7E5),
  ),
  suffixWidget: MultiColor(
    regular: Color(0xFF7E9CB7),
    selected: Color(0xFFA6C7E5),
  ),
  removalIcon: MultiColor.only(Color(0xFFD56E41)),
);

const _paramSetPanel = ParamSetPanelColorScheme(
  slidingPanel: SlidingPanelColorScheme(
    tabPanel: TabPanelColorScheme(
      tab: WidgetColorScheme(
        background: MultiColor(
          regular: Color(0xFF3B4351),
          selected: Color(0xFF6EADE1),
        ),
        foreground: MultiColor(
          regular: Color(0xFF77C1FD),
          selected: Color(0xFF323944),
        ),
      ),
      leadingIcon: WidgetColorScheme(
        foreground: MultiColor(
          regular: Color(0xFFD56E41),
          disabled: Color(0xFF775649),
        ),
      ),
      trailingIcon: WidgetColorScheme(
        foreground: MultiColor(
          regular: Color(0xFF77C1FD),
          disabled: Color(0xFF597891),
        ),
      ),
    ),
    body: WidgetColorScheme(
      background: MultiColor.only(Color(0xFF323944)),
    ),
    footer: WidgetColorScheme(
      background: MultiColor.only(Color(0xFF4C5970)),
      foreground: MultiColor.only(Color(0xFF7083A3)),
    ),
  ),
  paramItem: _paramItem,
);

const _settingGroup = SettingGroupColorScheme(
  viewTitle: WidgetColorScheme(
    foreground: MultiColor.only(Color(0xFFCCD7E0)),
  ),
  divider: MultiColor.only(pageBackground),
  settingItem: SettingItemColorScheme(
    background: MultiColor(
      regular: Color(0xFF3C4450),
      selected: Color(0xFF506394),
      disabled: Color(0xFF506394),
    ),
    foreground: MultiColor(
      regular: Color(0xFFA5CCF1),
    ),
    selectedValue: MultiColor(
      regular: Color(0xFFCCD7E0),
    ),
    switcher: SwitcherColorScheme(
      thumb: WidgetColorScheme(
        background: MultiColor(
          regular: Color(0xFF88A3BD),
          disabled: Color(0xFF94B4D2),
        ),
      ),
      track: WidgetColorScheme(
        border: MultiColor(
          regular: Color(0xFF88A3BD),
          selected: Colors.transparent,
          disabled: Color(0xFF94B4D2),
        ),
        background: MultiColor(
          regular: Colors.transparent,
          selected: Color(0xFF6184A3),
          disabled: Color(0xFF94B4D2),
        ),
      ),
    ),
  ),
);
