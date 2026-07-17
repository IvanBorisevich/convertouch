import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_item/conversion_item_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_item/conversion_item_states.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_states.dart';
import 'package:convertouch/presentation/controller/conversion_controller.dart';
import 'package:convertouch/presentation/controller/param_sets_controller.dart';
import 'package:convertouch/presentation/ui/style/color/colors_factory.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/conversion_param_item.dart';
import 'package:convertouch/presentation/ui/widgets/scroll/no_glow_scroll_behavior.dart';
import 'package:convertouch/presentation/ui/widgets/sliding_panel_ext.dart';
import 'package:convertouch/presentation/ui/widgets/svg_icon.dart';
import 'package:dynamic_tabbar/dynamic_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:timeago/timeago.dart' as timeago;

const double _paramItemHeight = 75;
const double _minBodyHeight = 150;
const double _maxBodyHeight = 255;
const double _tabPanelHeight = 50;
const double _tabHeight = 35;
const double _tabRadius = 15;
const double _footerHeight = 28;
const double _paramsSpacing = 10;
const double _jobInfoBoxHeight = 40;

class ConversionParamsView extends StatelessWidget {
  final int unitGroupId;
  final ConvertouchUITheme theme;

  const ConversionParamsView({
    required this.unitGroupId,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = appColors[theme].paramSetPanel;

    return BlocBuilder<ConversionBloc, ConversionState>(
      buildWhen: (prev, next) {
        return prev != next &&
            next is ConversionBuilt &&
            next.rebuildParams &&
            unitGroupId == next.conversion.unitGroup.id;
      },
      builder: (_, conversionState) {
        if (conversionState is! ConversionBuilt) {
          return const SizedBox.shrink();
        }

        final params = conversionState.conversion.params;

        if (params == null) {
          return const SizedBox.shrink();
        }

        final unitGroup = conversionState.conversion.unitGroup;

        bool paramsVisible = params.active != null;

        double paramSetMaxHeight = paramsVisible
            ? params.active!.paramValues.length *
                    (_paramItemHeight + _paramsSpacing) +
                _paramsSpacing
            : 0;

        double bodyHeight = _tabPanelHeight + paramSetMaxHeight;

        if (bodyHeight < _minBodyHeight) {
          bodyHeight = _minBodyHeight;
        } else if (bodyHeight > _maxBodyHeight) {
          bodyHeight = _maxBodyHeight;
        }

        final tabColors = colors.slidingPanel.tabPanel.tab;

        return refreshingJobsBlocBuilder(
          builderFunc: (jobsState) {
            var job = jobsState.getJob(
              unitGroup.name,
              params.active?.paramSet.name,
            );

            bool jobInfoBoxVisible =
                paramsVisible && job != null && job.completedAt != null;

            return ConvertouchSlidingPanel(
              defaultPanelState:
                  paramsVisible ? PanelState.OPEN : PanelState.CLOSED,
              minHeight: _footerHeight,
              maxHeight: jobInfoBoxVisible
                  ? _footerHeight + bodyHeight + _jobInfoBoxHeight
                  : _footerHeight + bodyHeight,
              colors: colors.slidingPanel,
              onPanelSlide: () {
                FocusScope.of(context).unfocus();
              },
              content: Column(
                children: [
                  SizedBox(
                    height: bodyHeight,
                    child: params.paramSetValues.isNotEmpty
                        ? _paramsView(
                            context,
                            paramSetValues: params.paramSetValues,
                            selectedParamSetIndex: params.selectedIndex,
                            paramsVisible: paramsVisible,
                            removalIconVisible:
                                params.selectedParamSetCanBeRemoved,
                            unitGroupName: unitGroup.name,
                            tabColors: tabColors,
                            colors: colors,
                          )
                        : _initialParamsView(
                            context,
                            colors: tabColors,
                            unitGroupId: unitGroup.id,
                          ),
                  ),
                  jobInfoBoxVisible
                      ? Container(
                          color:
                              colors.slidingPanel.jobInfoBox.background.regular,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          height: _jobInfoBoxHeight,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: colors
                                    .slidingPanel.jobInfoBox.foreground.regular,
                              ),
                              const SizedBox(width: 10),
                              RichText(
                                text: TextSpan(
                                  text: "Last refreshed: ",
                                  style: TextStyle(
                                    letterSpacing: 0,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: quicksandFontFamily,
                                    color: colors.slidingPanel.jobInfoBox
                                        .foreground.regular,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: timeago.format(job.completedAt!),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: _footerHeight,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colors.slidingPanel.footer.background.regular,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Container(
                        width: 25,
                        height: 5,
                        decoration: BoxDecoration(
                          color: colors.slidingPanel.footer.foreground.regular,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _paramsView(
    BuildContext context, {
    required List<ConversionParamSetValueModel> paramSetValues,
    required int selectedParamSetIndex,
    required bool paramsVisible,
    required bool removalIconVisible,
    required String unitGroupName,
    required WidgetColorScheme tabColors,
    required ParamSetPanelColorScheme colors,
  }) {
    return DynamicTabBarWidget(
      isScrollable: true,
      showBackIcon: false,
      showNextIcon: false,
      tabAlignment: TabAlignment.center,
      padding: const EdgeInsets.only(top: _paramsSpacing),
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide.none,
      ),
      dividerHeight: 0,
      dividerColor: Colors.transparent,
      onAddTabMoveTo: MoveToTab.last,
      onTabControllerUpdated: (controller) {
        controller.index = selectedParamSetIndex;
      },
      onTabChanged: (index) {
        conversionController.selectParamSet(
          context,
          index: index ?? 0,
        );
      },
      dynamicTabs: paramSetValues
          .mapIndexed(
            (index, paramSetValue) => TabData(
              index: index,
              title: _tabTitle(
                name: paramSetValue.paramSet.name,
                iconName: paramSetValue.paramSet.iconName,
                isSelected: index == selectedParamSetIndex,
                removable: removalIconVisible,
                colors: tabColors,
                onTabRemove: () {
                  conversionController.removeSelectedParamSet(context);
                },
              ),
              content: paramsVisible
                  ? _tabContent(
                      paramSetValue: paramSetValue,
                      unitGroupName: unitGroupName,
                      colors: colors,
                    )
                  : const SizedBox.shrink(),
            ),
          )
          .toList(),
    );
  }

  Widget _initialParamsView(
    BuildContext context, {
    required int unitGroupId,
    required WidgetColorScheme colors,
  }) {
    return Center(
      child: TextButton.icon(
        onPressed: () {
          paramSetsController.showParametersForAdding(
            context,
            unitGroupId: unitGroupId,
          );
        },
        style: TextButton.styleFrom(
          backgroundColor: colors.background.regular,
          foregroundColor: colors.foreground.regular,
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
    );
  }

  Tab _tabTitle({
    required String name,
    String? iconName,
    void Function()? onTabRemove,
    required bool isSelected,
    required bool removable,
    required WidgetColorScheme colors,
  }) {
    return Tab(
      height: _tabHeight,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(_tabRadius),
          ),
          color: isSelected
              ? colors.background.selected
              : colors.background.regular,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconName != null
                ? ConvertouchSvgIcon(
                    uri: iconName,
                    defaultColor: isSelected
                        ? colors.foreground.selected
                        : colors.foreground.regular,
                    size: 20,
                  )
                : const SizedBox.shrink(),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                horizontal: 7,
              ),
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected
                      ? colors.foreground.selected
                      : colors.foreground.regular,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Visibility(
              visible: removable,
              child: GestureDetector(
                onTap: onTabRemove,
                child: Container(
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.close,
                    color: isSelected
                        ? colors.foreground.selected
                        : colors.foreground.regular,
                    size: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabContent({
    required ConversionParamSetValueModel paramSetValue,
    required String unitGroupName,
    required ParamSetPanelColorScheme colors,
  }) {
    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: ListView.builder(
        itemCount: paramSetValue.paramValues.length,
        itemBuilder: (context, index) {
          final paramValue = paramSetValue.paramValues[index];

          return Padding(
            padding: const EdgeInsets.only(
              bottom: _paramsSpacing,
            ),
            child: BlocBuilder<ConversionParamValueBloc,
                ConversionParamValueState>(
              buildWhen: (prev, next) {
                return prev != next &&
                    (next is ConversionParamValueInitialState ||
                        next.id == paramValue.id);
              },
              builder: (_, itemState) {
                final resultParamValue =
                    itemState is ConversionParamValueInitialState
                        ? paramValue
                        : (itemState.id == paramValue.id
                            ? itemState.value!
                            : paramValue);

                return ConversionParamItem(
                  paramValue: resultParamValue,
                  conversionGroupName: unitGroupName,
                  conversionParams: paramSetValue,
                  calculationSwitchersVisible: true,
                  colors: colors.paramItem,
                  dialogColors: appColors[theme].dialog,
                  theme: theme,
                );
              },
            ),
          );
        },
        padding: const EdgeInsets.only(
          top: _paramsSpacing,
          left: _paramsSpacing,
          right: _paramsSpacing,
        ),
      ),
    );
  }
}
