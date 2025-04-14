import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/text_box.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/conversion_item.dart';
import 'package:convertouch/presentation/ui/widgets/scroll/no_glow_scroll_behavior.dart';
import 'package:dynamic_tabbar/dynamic_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ConversionParamsView extends StatelessWidget {
  static const int _toolsetItemsNum = 3;
  static const double _toolsetPanelWidth = 50;
  static const double _toolsetPanelItemHeight = 50;
  static const double _minBodyHeight =
      _toolsetPanelItemHeight * _toolsetItemsNum;
  static const double _maxBodyHeight = 255;
  static const double _tabPanelHeight = 50;
  static const double _footerHeight = 28;
  static const double _paramsSpacing = 10;

  final ConversionParamSetValueBulkModel params;
  final bool paramSetAddingButtonVisible;
  final bool paramSetRemovalButtonVisible;
  final bool paramSetsCleaningButtonVisible;
  final void Function()? onParamSetAdd;
  final void Function(int)? onParamSetSelect;
  final void Function(int)? onParamSetRemove;
  final void Function()? onAllParamSetsRemove;
  final void Function(ConversionParamValueModel)? onParamUnitTap;
  final void Function(ConversionParamValueModel, String)? onValueChanged;
  final ConvertouchUITheme theme;

  const ConversionParamsView({
    required this.params,
    this.paramSetAddingButtonVisible = false,
    this.paramSetRemovalButtonVisible = false,
    this.paramSetsCleaningButtonVisible = false,
    this.onParamSetAdd,
    this.onParamSetSelect,
    this.onParamSetRemove,
    this.onAllParamSetsRemove,
    this.onParamUnitTap,
    this.onValueChanged,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (params.paramSetValues.isEmpty) {
      return const SizedBox.shrink();
    }

    ParamSetPanelColorScheme colors = paramSetColors[theme]!;

    Color tabBackgroundColor = colors.tab.background.regular;
    Color tabForegroundColor = colors.tab.foreground.regular;
    Color toolsetPanelBackgroundColor = colors.toolset.background.regular;
    Color toolsetPanelForegroundColor = colors.toolset.foreground.regular;
    Color toolsetRemovalIconColor = colors.removalIcon.regular;
    Color footerBackgroundColor = colors.footer.background.regular;
    Color footerForegroundColor = colors.footer.foreground.regular;

    double paramSetMaxHeight = 0;

    for (var paramSetValue in params.paramSetValues) {
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
      panel: Column(
        children: [
          SizedBox(
            height: bodyHeight,
            child: Row(
              children: [
                Expanded(
                  child: DynamicTabBarWidget(
                    isScrollable: true,
                    showBackIcon: false,
                    showNextIcon: false,
                    padding: EdgeInsets.zero,
                    indicatorColor: tabForegroundColor,
                    dividerColor: Colors.transparent,
                    onAddTabMoveTo: MoveToTab.last,
                    onTabControllerUpdated: (controller) {
                      controller.index = params.selectedIndex;
                    },
                    onTabChanged: (index) {
                      onParamSetSelect?.call(index ?? 0);
                    },
                    dynamicTabs: params.paramSetValues
                        .mapIndexed(
                          (index, item) => TabData(
                            index: index,
                            title: Tab(
                              child: Text(
                                item.paramSet.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: tabForegroundColor,
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
                                    child: ConvertouchConversionItem(
                                      paramItem,
                                      controlsVisible: false,
                                      itemNameFunc: (item) => item.param.name,
                                      unitItemCodeFunc: (item) =>
                                          item.unit?.code,
                                      onTap: () {
                                        onParamUnitTap?.call(paramItem);
                                      },
                                      onValueChanged: (value) {
                                        onValueChanged?.call(paramItem, value);
                                      },
                                      colors: conversionItemColors[theme]!,
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
                  ),
                ),
                Visibility(
                  visible: paramSetAddingButtonVisible ||
                      paramSetRemovalButtonVisible ||
                      paramSetsCleaningButtonVisible,
                  child: Container(
                    width: _toolsetPanelWidth,
                    height: bodyHeight,
                    decoration: BoxDecoration(
                      color: toolsetPanelBackgroundColor,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: _toolsetPanelItemHeight,
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: toolsetPanelForegroundColor,
                            ),
                            onPressed: paramSetAddingButtonVisible
                                ? () {
                                    onParamSetAdd?.call();
                                  }
                                : null,
                          ),
                        ),
                        SizedBox(
                          height: _toolsetPanelItemHeight,
                          child: IconButton(
                            icon: Icon(
                              Icons.remove,
                              color: toolsetPanelForegroundColor,
                            ),
                            onPressed: paramSetRemovalButtonVisible
                                ? () {
                                    onParamSetRemove
                                        ?.call(params.selectedIndex);
                                  }
                                : null,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: _toolsetPanelItemHeight,
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete_outline_rounded,
                                  color: toolsetRemovalIconColor,
                                ),
                                onPressed: paramSetsCleaningButtonVisible
                                    ? () {
                                        onAllParamSetsRemove?.call();
                                      }
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                color: footerBackgroundColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Container(
                width: 25,
                height: 5,
                decoration: BoxDecoration(
                  color: footerForegroundColor,
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
      color: tabBackgroundColor,
      boxShadow: null,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    );
  }
}
