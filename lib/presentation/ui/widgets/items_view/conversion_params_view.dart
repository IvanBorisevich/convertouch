import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_states.dart';
import 'package:convertouch/presentation/controller/conversion_controller.dart';
import 'package:convertouch/presentation/controller/param_sets_controller.dart';
import 'package:convertouch/presentation/controller/refresh_button_controller.dart';
import 'package:convertouch/presentation/controller/refreshing_job_controller.dart';
import 'package:convertouch/presentation/controller/units_controller.dart';
import 'package:convertouch/presentation/ui/model/conversion_params_view_model.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/conversion_item.dart';
import 'package:convertouch/presentation/ui/widgets/scroll/no_glow_scroll_behavior.dart';
import 'package:convertouch/presentation/ui/widgets/sliding_panel_ext.dart';
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
const double _calculationSuffixIconWidth = 40;
const double _jobInfoBoxHeight = 40;

class ConversionParamsView extends StatelessWidget {
  final ParamSetPanelColorScheme colors;
  final WidgetColorScheme dialogColors;

  const ConversionParamsView({
    required this.colors,
    required this.dialogColors,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ConversionBloc, ConversionState,
        ConversionParamsViewModel?>(
      selector: (state) {
        if (state is! ConversionBuilt) {
          return null;
        }

        final params = state.conversion.params;

        if (params != null) {
          return ConversionParamsViewModel(
            selected: params.active,
            selectedIndex: params.selectedIndex,
            paramSetsNames: params.paramSetValues
                .map((paramSetValue) => paramSetValue.paramSet.name)
                .toList(),
            removalIconVisible: params.selectedParamSetCanBeRemoved,
            unitGroup: state.conversion.unitGroup,
          );
        }

        return null;
      },
      builder: (_, paramsViewModel) {
        if (paramsViewModel == null) {
          return const SizedBox.shrink();
        }

        bool paramsAreVisible = paramsViewModel.selected != null;

        double paramSetMaxHeight = paramsAreVisible
            ? paramsViewModel.selected!.paramValues.length *
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
              paramsViewModel.unitGroup.name,
              paramsViewModel.selected?.paramSet.name,
            );

            bool jobInfoBoxVisible =
                paramsAreVisible && job != null && job.completedAt != null;

            return ConvertouchSlidingPanel(
              defaultPanelState:
                  paramsAreVisible ? PanelState.OPEN : PanelState.CLOSED,
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
                    child: paramsViewModel.paramSetsNames.isNotEmpty
                        ? _paramsView(
                            context,
                            paramsViewModel: paramsViewModel,
                            tabColors: tabColors,
                            paramsAreVisible: paramsAreVisible,
                          )
                        : _initialParamsView(
                            context,
                            colors: tabColors,
                            unitGroupId: paramsViewModel.unitGroup.id,
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
    required ConversionParamsViewModel paramsViewModel,
    required bool paramsAreVisible,
    required WidgetColorScheme tabColors,
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
        controller.index = paramsViewModel.selectedIndex;
      },
      onTabChanged: (index) {
        conversionController.showParamSet(
          context,
          index: index ?? 0,
        );
      },
      dynamicTabs: paramsViewModel.paramSetsNames
          .mapIndexed(
            (index, paramSetName) => TabData(
              index: index,
              title: _tabTitle(
                name: paramSetName,
                isSelected: index == paramsViewModel.selectedIndex,
                removable: paramsViewModel.removalIconVisible,
                colors: tabColors,
                onTabRemove: () {
                  conversionController.removeSelectedParamSet(
                    context,
                  );
                },
              ),
              content: paramsAreVisible
                  ? _tabContent(paramsViewModel)
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

  Widget _tabContent(ConversionParamsViewModel paramsViewModel) {
    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: ListView.builder(
        itemCount: paramsViewModel.selected!.paramValues.length,
        itemBuilder: (context, index) {
          var paramValue = paramsViewModel.selected!.paramValues[index];

          return Padding(
            padding: const EdgeInsets.only(
              bottom: _paramsSpacing,
            ),
            child: _param(
              context,
              paramValue: paramValue,
              colors: colors.paramItem,
              dialogColors: dialogColors,
              calculationSwitchersVisible: true,
              unitGroupName: paramsViewModel.unitGroup.name,
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

  Widget _param(
    BuildContext context, {
    required ConversionParamValueModel paramValue,
    required ConversionItemColorScheme colors,
    required WidgetColorScheme dialogColors,
    required bool calculationSwitchersVisible,
    required String unitGroupName,
  }) {
    return ConvertouchConversionItem(
      model: paramValue,
      draggable: false,
      removable: false,
      colors: colors,
      dialogColors: dialogColors,
      onUnitItemTap: () {
        unitsController.showUnitsForChangeInParam(
          context,
          paramValue: paramValue,
        );
      },
      onValueChanged: (value) {
        conversionController.changeParamValue(
          context,
          paramValue: paramValue,
          newValue: value,
          onChanged: (newConversion, {info}) {
            refreshButtonController.changeState(
              context,
              visible: newConversion.refreshable,
              disabled: !newConversion.readyToRefresh,
            );

            if (newConversion.refreshable && newConversion.readyToRefresh) {
              refreshingJobController.startRefreshingJob(
                context,
                unitGroupName: unitGroupName,
                params: newConversion.params?.active,
                srcUnit: newConversion.srcUnitValue?.unit,
                jobExecutionMode: JobExecutionMode.startNewJob,
              );
            } else {
              refreshingJobController.stopRefreshingJob(
                context,
                unitGroupName: unitGroupName,
                paramSetName: newConversion.params?.active?.paramSet.name,
              );
            }
          },
        );
      },
      prefixWidgets: [
        calculationSwitchersVisible && paramValue.param.calculable
            ? GestureDetector(
                onTap: () {
                  conversionController.toggleParamCalculable(
                    context,
                    paramId: paramValue.param.id,
                    paramSetId: paramValue.param.paramSetId,
                  );
                },
                child: Container(
                  width: _calculationSuffixIconWidth,
                  padding: const EdgeInsets.only(left: 2),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  child: Icon(
                    paramValue.calculated
                        ? Icons.calculate
                        : Icons.calculate_outlined,
                    color: paramValue.calculated
                        ? colors.suffixWidget.selected
                        : colors.suffixWidget.regular,
                  ),
                ),
              )
            : null,
      ],
    );
  }
}
