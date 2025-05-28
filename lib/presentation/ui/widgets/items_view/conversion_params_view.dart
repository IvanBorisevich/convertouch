import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/text_box.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/conversion_item.dart';
import 'package:convertouch/presentation/ui/widgets/scroll/no_glow_scroll_behavior.dart';
import 'package:dynamic_tabbar/dynamic_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ConversionParamsView extends StatelessWidget {
  static const int _toolsetItemsNum = 3;
  static const double _toolsetPanelWidth = 47;
  static const double _toolsetPanelItemHeight = 50;
  static const double _minBodyHeight =
      _toolsetPanelItemHeight * _toolsetItemsNum;
  static const double _maxBodyHeight = 255;
  static const double _tabPanelHeight = 50;
  static const double _footerHeight = 28;
  static const double _paramsSpacing = 10;

  final ConversionParamSetValueBulkModel? params;
  final PanelController panelController;
  final void Function()? onParamSetAdd;
  final void Function(int)? onParamSetSelect;
  final void Function()? onSelectedParamSetRemove;
  final void Function()? onParamSetsBulkRemove;
  final void Function(ConversionParamValueModel)? onParamUnitTap;
  final void Function(ConversionParamValueModel, String?)? onValueChanged;
  final ConvertouchUITheme theme;

  const ConversionParamsView({
    this.params,
    required this.panelController,
    this.onParamSetAdd,
    this.onParamSetSelect,
    this.onSelectedParamSetRemove,
    this.onParamSetsBulkRemove,
    this.onParamUnitTap,
    this.onValueChanged,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final conversionBloc = BlocProvider.of<ConversionBloc>(context);

    if (params == null) {
      return const SizedBox.shrink();
    }

    ParamSetPanelColorScheme colors = paramSetColors[theme]!;

    double paramSetMaxHeight = 0;

    for (var paramSetValue in params!.paramSetValues) {
      int numOfParams = paramSetValue.paramValues.length;
      double paramSetHeight = numOfParams * ConvertouchTextBox.defaultHeight +
          numOfParams * _paramsSpacing +
          _paramsSpacing;

      if (paramSetHeight > paramSetMaxHeight) {
        paramSetMaxHeight = paramSetHeight;
      }
    }

    double bodyHeight = _tabPanelHeight + paramSetMaxHeight;

    if (bodyHeight < _minBodyHeight) {
      bodyHeight = _minBodyHeight;
    } else if (bodyHeight > _maxBodyHeight) {
      bodyHeight = _maxBodyHeight;
    }

    return SlidingUpPanel(
      controller: panelController,
      panel: Column(
        children: [
          SizedBox(
            height: bodyHeight,
            child: Row(
              children: [
                Expanded(
                  child: params!.paramSetValues.isNotEmpty
                      ? DynamicTabBarWidget(
                          isScrollable: true,
                          showBackIcon: false,
                          showNextIcon: false,
                          tabAlignment: TabAlignment.center,
                          padding: EdgeInsets.zero,
                          indicatorColor: colors.tab.foreground.regular,
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
                                    child: Text(
                                      item.paramSet.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: colors.tab.foreground.regular,
                                        fontWeight: FontWeight.w600,
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
                                                colors: colors,
                                              ),
                                              _calculationSwitcher(
                                                areSwitchersShown: item
                                                    .hasMultipleCalculableParams,
                                                paramItem: paramItem,
                                                colors: colors,
                                                onTap: () {
                                                  conversionBloc.add(
                                                    ToggleCalculableParam(
                                                      paramId:
                                                          paramItem.param.id,
                                                      paramSetId: paramItem
                                                          .param.paramSetId,
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
                          child: Text(
                            "No params added",
                            style: TextStyle(
                              color: colors.tab.foreground.regular,
                            ),
                          ),
                        ),
                ),
                Container(
                  width: _toolsetPanelWidth,
                  height: bodyHeight,
                  decoration: BoxDecoration(
                    color: colors.toolset.background.regular,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: _toolsetPanelItemHeight,
                        child: IconButton(
                          disabledColor: colors.toolset.foreground.disabled,
                          icon: Icon(
                            Icons.add,
                            color: params!.paramSetsCanBeAdded
                                ? colors.toolset.foreground.regular
                                : colors.toolset.foreground.disabled,
                          ),
                          onPressed: params!.paramSetsCanBeAdded
                              ? () {
                                  onParamSetAdd?.call();
                                }
                              : null,
                        ),
                      ),
                      SizedBox(
                        height: _toolsetPanelItemHeight,
                        child: IconButton(
                          disabledColor: colors.toolset.foreground.disabled,
                          icon: Icon(
                            Icons.remove,
                            color: params!.selectedParamSetCanBeRemoved
                                ? colors.toolset.foreground.regular
                                : colors.toolset.foreground.disabled,
                          ),
                          onPressed: params!.selectedParamSetCanBeRemoved
                              ? () {
                                  onSelectedParamSetRemove?.call();
                                }
                              : null,
                        ),
                      ),
                      Visibility(
                        visible: params!.optionalParamSetsExist,
                        child: Expanded(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: _toolsetPanelItemHeight,
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete_outline_rounded,
                                  color: colors.removalIcon.regular,
                                ),
                                onPressed: () {
                                  onParamSetsBulkRemove?.call();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
      slideDirection: SlideDirection.DOWN,
      minHeight: _footerHeight,
      maxHeight: _footerHeight + bodyHeight,
      color: colors.tab.background.regular,
      boxShadow: null,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    );
  }

  Widget _calculationSwitcher({
    required ConversionParamValueModel paramItem,
    required bool areSwitchersShown,
    required ParamSetPanelColorScheme colors,
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
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                    border: Border.all(
                      color: paramItem.calculated
                          ? colors.paramItem.handler.border.selected
                          : colors.paramItem.handler.border.regular,
                    ),
                    color: paramItem.calculated
                        ? colors.paramItem.handler.background.selected
                        : colors.paramItem.handler.background.regular,
                  ),
                  child: Icon(
                    Icons.sync_alt_rounded,
                    size: 17,
                    color: paramItem.calculated
                        ? colors.paramItem.handler.foreground.selected
                        : colors.paramItem.handler.foreground.regular,
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _param({
    required ConversionParamValueModel paramItem,
    required ParamSetPanelColorScheme colors,
  }) {
    return Expanded(
      child: ConvertouchConversionItem(
        paramItem,
        controlsVisible: false,
        itemNameFunc: (item) => item.param.name,
        unitItemCodeFunc: (item) => item.unit?.code,
        onTap: () {
          onParamUnitTap?.call(paramItem);
        },
        onValueChanged: (value) {
          onValueChanged?.call(paramItem, value);
        },
        colors: colors.paramItem,
      ),
    );
  }
}
