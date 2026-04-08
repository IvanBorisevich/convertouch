import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/ui/model/conversion_item_model.dart';
import 'package:convertouch/presentation/ui/model/input_box_model.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/conversion_item.dart';
import 'package:convertouch/presentation/ui/widgets/scroll/no_glow_scroll_behavior.dart';
import 'package:dynamic_tabbar/dynamic_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

const double _paramItemHeight = 75;
const double _minBodyHeight = 150;
const double _maxBodyHeight = 255;
const double _tabPanelHeight = 50;
const double _tabHeight = 35;
const double _tabRadius = 15;
const double _footerHeight = 28;
const double _paramsSpacing = 10;

class ConversionParamsView extends StatelessWidget {
  final ConversionParamSetValueBulkModel? params;
  final PanelController panelController;
  final void Function()? onParamSetAdd;
  final void Function(int)? onParamSetSelect;
  final void Function()? onSelectedParamSetRemove;
  final void Function(ConversionParamValueModel)? onParamUnitTap;
  final void Function(ConversionParamValueModel, String?)? onValueChanged;
  final ParamSetPanelColorScheme colors;

  const ConversionParamsView({
    this.params,
    required this.panelController,
    this.onParamSetAdd,
    this.onParamSetSelect,
    this.onSelectedParamSetRemove,
    this.onParamUnitTap,
    this.onValueChanged,
    required this.colors,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final conversionBloc = BlocProvider.of<ConversionBloc>(context);

    if (params == null) {
      return const SizedBox.shrink();
    }

    double paramSetMaxHeight = params!.paramSetValues
            .map((paramSetValue) =>
                paramSetValue.paramValues.length *
                    (_paramItemHeight + _paramsSpacing) +
                _paramsSpacing)
            .maxOrNull ??
        0;

    double bodyHeight = _tabPanelHeight + paramSetMaxHeight;

    if (bodyHeight < _minBodyHeight) {
      bodyHeight = _minBodyHeight;
    } else if (bodyHeight > _maxBodyHeight) {
      bodyHeight = _maxBodyHeight;
    }

    return SlidingUpPanel(
      controller: panelController,
      slideDirection: SlideDirection.DOWN,
      minHeight: _footerHeight,
      maxHeight: _footerHeight + bodyHeight,
      color: colors.body.background.regular,
      boxShadow: null,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      panel: Column(
        children: [
          SizedBox(
            height: bodyHeight,
            child: params!.paramSetValues.isNotEmpty
                ? DynamicTabBarWidget(
                    isScrollable: true,
                    showBackIcon: false,
                    showNextIcon: false,
                    tabAlignment: TabAlignment.center,
                    padding: const EdgeInsets.only(top: 5),
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide.none,
                    ),
                    dividerHeight: 0,
                    dividerColor: Colors.transparent,
                    onAddTabMoveTo: MoveToTab.last,
                    onTabControllerUpdated: (controller) {
                      controller.index = params!.selectedIndex;
                    },
                    onTabChanged: (index) {
                      onParamSetSelect?.call(index ?? 0);
                    },
                    dynamicTabs: params!.paramSetValues
                        .mapIndexed(
                          (index, item) => TabData(
                            index: index,
                            title: Tab(
                              height: _tabHeight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(_tabRadius),
                                  ),
                                  color: index == params!.selectedIndex
                                      ? colors.tabPanel.tab.background.selected
                                      : colors.tabPanel.tab.background.regular,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      item.paramSet.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: index == params!.selectedIndex
                                            ? colors.tabPanel.tab.foreground
                                                .selected
                                            : colors.tabPanel.tab.foreground
                                                .regular,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          params!.selectedParamSetCanBeRemoved,
                                      child: GestureDetector(
                                        onTap: onSelectedParamSetRemove,
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                            left: 7,
                                          ),
                                          color: Colors.transparent,
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.close,
                                            color:
                                                index == params!.selectedIndex
                                                    ? colors.tabPanel.tab
                                                        .foreground.selected
                                                    : colors.tabPanel.tab
                                                        .foreground.regular,
                                            size: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            content: ScrollConfiguration(
                              behavior: NoGlowScrollBehavior(),
                              child: ListView.builder(
                                itemCount: item.paramValues.length,
                                itemBuilder: (context, index) {
                                  var paramItem = item.paramValues[index];

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: _paramsSpacing,
                                    ),
                                    child: Row(
                                      children: [
                                        _param(
                                          paramItem: paramItem,
                                          colors: colors.paramItem,
                                        ),
                                        _calculationSwitcher(
                                          areSwitchersShown:
                                              item.hasMultipleCalculableParams,
                                          paramItem: paramItem,
                                          colors: colors.paramItem,
                                          onTap: () {
                                            conversionBloc.add(
                                              ToggleCalculableParam(
                                                paramId: paramItem.param.id,
                                                paramSetId:
                                                    paramItem.param.paramSetId,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                padding: const EdgeInsets.only(
                                  top: _paramsSpacing,
                                  left: _paramsSpacing,
                                  right: _paramsSpacing,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  )
                : Center(
                    child: TextButton.icon(
                      onPressed: onParamSetAdd,
                      style: TextButton.styleFrom(
                        backgroundColor: colors.tabPanel.tab.background.regular,
                        foregroundColor: colors.tabPanel.tab.foreground.regular,
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text(
                        'Add parameters',
                        style: TextStyle(
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: _footerHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.footer.background.regular,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Container(
                width: 25,
                height: 5,
                decoration: BoxDecoration(
                  color: colors.footer.foreground.regular,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _calculationSwitcher({
    required ConversionParamValueModel paramItem,
    required bool areSwitchersShown,
    required ConversionItemColorScheme colors,
    required void Function()? onTap,
    double width = 30,
    double height = 30,
  }) {
    return Visibility(
      visible: areSwitchersShown,
      child: paramItem.param.calculable
          ? Padding(
              padding: const EdgeInsets.only(left: 9),
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  width: width,
                  height: height,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  child: Icon(
                    Icons.sync_alt_rounded,
                    size: 17,
                    color: paramItem.calculated
                        ? colors.suffixWidget.selected
                        : colors.suffixWidget.regular,
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _param({
    required ConversionParamValueModel paramItem,
    required ConversionItemColorScheme colors,
  }) {
    return Expanded(
      child: ConvertouchConversionItem(
        ConversionItemModel(
          inputBoxModel: InputBoxModel.ofValue(paramItem),
          min: paramItem.min,
          max: paramItem.max,
          unit: paramItem.unitItem,
          draggable: false,
          removable: false,
        ),
        onUnitItemTap: () {
          onParamUnitTap?.call(paramItem);
        },
        onValueChanged: (value) {
          onValueChanged?.call(paramItem, value);
        },
        colors: colors,
      ),
    );
  }
}
