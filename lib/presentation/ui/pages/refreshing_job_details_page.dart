import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/input/refreshing_job_details_event.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/refreshing_job_details_bloc.dart';
import 'package:convertouch/presentation/ui/items_view/item/refreshing_job_item.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ConvertouchRefreshingJobDetailsPage extends StatelessWidget {
  const ConvertouchRefreshingJobDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      return refreshingJobDetailsBlocBuilder((pageState) {
        ConvertouchScaffoldColor scaffoldColor =
            scaffoldColors[appState.theme]!;
        RefreshingJobItemColor color =
            refreshingJobItemsColors[appState.theme]!;

        Widget lastRefreshedInfoBox = jobInfoLabel(
          visible: pageState.job.lastRefreshTime != null,
          text: 'Last refreshed at ${pageState.job.lastRefreshTime}',
          padding: const EdgeInsets.all(0),
          alignment: Alignment.center,
          textColor: color.jobItem.regular.content,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        );

        return ConvertouchPage(
          appState: appState,
          title: pageState.job.name,
          customLeadingIcon: null,
          appBarRightWidgets: null,
          secondaryAppBarColor: scaffoldColor.regular.backgroundColor,
          secondaryAppBarPadding: const EdgeInsets.all(5),
          secondaryAppBar: pageState.job.lastRefreshTime != null
              ? Container(
                  decoration: BoxDecoration(
                    color: color.jobItem.regular.background,
                    border: Border.all(
                      color: color.jobItem.regular.border,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: pageState.progressValue == null
                      ? lastRefreshedInfoBox
                      : StreamBuilder<double>(
                          stream: pageState.progressValue,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 20,
                              );
                            } else if (snapshot.data == null) {
                              return lastRefreshedInfoBox;
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return lastRefreshedInfoBox;
                            } else {
                              return LinearPercentIndicator(
                                width: MediaQuery.of(context).size.width,
                                animation: true,
                                animateFromLastPercent: true,
                                lineHeight: 20,
                                percent: snapshot.data!,
                                center: Text("${snapshot.data}%"),
                                barRadius: const Radius.circular(10),
                                progressColor: color.jobItem.regular.content,
                              );
                            }
                          },
                        ),
                )
              : null,
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildRadioList<JobAutoRefresh>(
                  listHeaderText: "Auto-Refresh Data",
                  entries: JobAutoRefresh.values
                      .map((e) => MapEntry(e, e.name))
                      .toList(),
                  selectedValue: pageState.job.autoRefresh,
                  listHeaderContentColor: color.jobItem.regular.content,
                  listHeaderBackgroundColor: color.jobItem.regular.background,
                  listItemContentColor: color.jobItem.regular.content,
                  onItemChanged: (JobAutoRefresh? newValue) {
                    if (newValue != null) {
                      BlocProvider.of<RefreshingJobDetailsBloc>(context).add(
                        ToggleAutoRefreshMode(
                          mode: newValue,
                          job: pageState.job,
                          progressValue: pageState.progressValue,
                        ),
                      );
                    }
                  },
                ),
                _buildRadioList<Cron>(
                  listHeaderText: "Data Auto-Refreshing Frequency",
                  enabled: pageState.job.autoRefresh == JobAutoRefresh.on,
                  entries: Cron.values.map((e) => MapEntry(e, e.name)).toList(),
                  selectedValue: pageState.job.cron,
                  listHeaderContentColor: color.jobItem.regular.content,
                  listHeaderBackgroundColor: color.jobItem.regular.background,
                  listItemContentColor: color.jobItem.regular.content,
                  onItemChanged: (Cron? newCron) {
                    if (newCron != null) {
                      BlocProvider.of<RefreshingJobDetailsBloc>(context).add(
                        SelectAutoRefreshCron(
                          newCron: newCron,
                          job: pageState.job,
                          progressValue: pageState.progressValue,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: null,
        );
      });
    });
  }

  Widget _buildRadioList<T>({
    required List<MapEntry<T, String>> entries,
    T? selectedValue,
    required String listHeaderText,
    required Color listHeaderContentColor,
    required Color listHeaderBackgroundColor,
    required Color listItemContentColor,
    required void Function(T?)? onItemChanged,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 10,
              top: 7,
              right: 10,
              bottom: 7,
            ),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: listHeaderBackgroundColor,
            ),
            child: Text(
              listHeaderText,
              style: TextStyle(
                color: listHeaderContentColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          for (MapEntry<T, String> itemEntry in entries)
            RadioListTile(
              title: Text(
                itemEntry.value,
                style: TextStyle(
                  color: listItemContentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              value: itemEntry.key,
              groupValue: selectedValue,
              onChanged: enabled ? onItemChanged : null,
              contentPadding: const EdgeInsets.only(left: 7),
              fillColor: MaterialStateColor.resolveWith(
                (states) {
                  if (!enabled) {
                    return listItemContentColor.withOpacity(0.5);
                  }
                  return listItemContentColor;
                },
              ),
            ),
        ],
      ),
    );
  }
}
