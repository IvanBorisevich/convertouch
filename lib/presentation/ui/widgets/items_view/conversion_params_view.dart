import 'dart:math';

import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/input_box/text_box.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/conversion_item.dart';
import 'package:convertouch/presentation/ui/widgets/scroll/no_glow_scroll_behavior.dart';
import 'package:dynamic_tabbar/dynamic_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ConversionParamsView extends StatefulWidget {
  final List<ConversionParamSetValueModel> paramSetValues;
  final void Function()? onParamSetChange;
  final void Function(ConversionParamValueModel)? onParamUnitTap;
  final void Function(ConversionParamValueModel, String)? onValueChanged;
  final ConvertouchUITheme theme;

  const ConversionParamsView({
    this.paramSetValues = const [],
    this.onParamSetChange,
    this.onParamUnitTap,
    this.onValueChanged,
    required this.theme,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ConversionParamsViewState();
}

class _ConversionParamsViewState extends State<ConversionParamsView>
    with TickerProviderStateMixin {
  static const int _toolsetItemsNum = 3;
  static const double _toolsetPanelWidth = 50;
  static const double _toolsetPanelItemHeight = 50;
  static const double _minBodyHeight =
      _toolsetPanelItemHeight * _toolsetItemsNum;
  static const double _maxBodyHeight = 255;
  static const double _tabPanelHeight = 50;
  static const double _footerHeight = 28;
  static const double _paramsSpacing = 10;

  late TabController _controller;
  late final List<ConversionParamSetValueModel> _paramSetValues;

  @override
  void initState() {
    _paramSetValues = widget.paramSetValues;

    _controller = TabController(
      vsync: this,
      length: _paramSetValues.length,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_paramSetValues.isEmpty) {
      return const SizedBox.shrink();
    }

    if (_paramSetValues.length != _controller.length) {
      final oldIndex = _controller.index;
      _controller.dispose();
      _controller = TabController(
        length: _paramSetValues.length,
        initialIndex: max(0, min(oldIndex, _paramSetValues.length - 1)),
        vsync: this,
      );
    }

    ParamSetPanelColorScheme colors = paramSetColors[widget.theme]!;

    Color tabBackgroundColor = colors.tab.background.regular;
    Color tabForegroundColor = colors.tab.foreground.regular;
    Color selectedTabBackgroundColor = colors.tab.background.selected;
    Color toolsetPanelBackgroundColor = colors.toolset.background.regular;
    Color toolsetPanelForegroundColor = colors.toolset.foreground.regular;
    Color toolsetRemovalIconColor = colors.removalIcon.regular;
    Color footerBackgroundColor = colors.footer.background.regular;
    Color footerForegroundColor = colors.footer.foreground.regular;

    double paramSetMaxHeight = 0;

    for (var paramSetValue in _paramSetValues) {
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
                    onTabControllerUpdated: (controller) {},
                    dynamicTabs: _paramSetValues
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
                                        widget.onParamUnitTap?.call(paramItem);
                                      },
                                      onValueChanged: (value) {
                                        widget.onValueChanged
                                            ?.call(paramItem, value);
                                      },
                                      colors:
                                          conversionItemColors[widget.theme]!,
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

                  // TabContainer(
                  //   controller: _controller,
                  //   borderRadius: const BorderRadius.all(Radius.zero),
                  //   color: selectedTabBackgroundColor,
                  //   duration: const Duration(milliseconds: 200),
                  //   tabMinLength: 100,
                  //   tabExtent: _tabPanelHeight,
                  //   tabs: _paramSetValues
                  //       .map(
                  //         (item) => Padding(
                  //           padding: const EdgeInsets.symmetric(horizontal: 14),
                  //           child:
                  //           Text(
                  //             item.paramSet.name,
                  //             maxLines: 1,
                  //             overflow: TextOverflow.ellipsis,
                  //             style: TextStyle(
                  //               color: tabForegroundColor,
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //           ),
                  //         ),
                  //       )
                  //       .toList(),
                  //   children: _paramSetValues
                  //       .map(
                  //         (item) =>
                  //         ScrollConfiguration(
                  //           behavior: NoGlowScrollBehavior(),
                  //           child: ListView.builder(
                  //             itemCount: item.paramValues.length,
                  //             itemBuilder: (context, index) {
                  //               var paramItem = item.paramValues[index];
                  //
                  //               return Padding(
                  //                 padding: const EdgeInsets.only(
                  //                   bottom: _paramsSpacing,
                  //                 ),
                  //                 child: ConvertouchConversionItem(
                  //                   paramItem,
                  //                   controlsVisible: false,
                  //                   itemNameFunc: (item) => item.param.name,
                  //                   unitItemCodeFunc: (item) => item.unit?.code,
                  //                   onTap: () {
                  //                     widget.onParamUnitTap?.call(paramItem);
                  //                   },
                  //                   onValueChanged: (value) {
                  //                     widget.onValueChanged
                  //                         ?.call(paramItem, value);
                  //                   },
                  //                   colors: conversionItemColors[widget.theme]!,
                  //                 ),
                  //               );
                  //             },
                  //             padding: const EdgeInsets.only(
                  //               top: _paramsSpacing,
                  //               left: _paramsSpacing,
                  //               right: _paramsSpacing,
                  //             ),
                  //           ),
                  //         ),
                  //       )
                  //       .toList(),
                  // ),
                ),
                Container(
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
                          onPressed: () {
                            setState(() {
                              _paramSetValues
                                  .add(const ConversionParamSetValueModel(
                                paramSet: ConversionParamSetModel(
                                  id: 1,
                                  name: "Clothing Size by Height",
                                  mandatory: true,
                                  groupId: 10,
                                ),
                                paramValues: [],
                              ));
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: _toolsetPanelItemHeight,
                        child: IconButton(
                          icon: Icon(
                            Icons.remove,
                            color: toolsetPanelForegroundColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _paramSetValues.removeAt(_controller.index);
                            });
                          },
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
                              onPressed: () {
                                setState(() {
                                  _paramSetValues.clear();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
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
