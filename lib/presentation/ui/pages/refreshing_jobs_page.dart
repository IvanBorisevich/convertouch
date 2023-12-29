import 'package:convertouch/domain/model/input/refreshing_jobs_events.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_bloc.dart';
import 'package:convertouch/presentation/ui/items_view/refreshing_jobs_view.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchRefreshingJobsPage extends StatelessWidget {
  const ConvertouchRefreshingJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      return refreshingJobsBlocBuilder((pageState) {
        return ConvertouchPage(
          appState: appState,
          title: "Refresh Data",
          body: ConvertouchRefreshingJobsView(
            pageState.items,
            activeJobIds: pageState.activeJobIds,
            onItemClick: (item) {},
            onItemRefreshButtonClick: (item) {
              BlocProvider.of<RefreshingJobsBloc>(context).add(
                StartRefreshingData(
                  jobId: item.id!,
                  activeJobIds: pageState.activeJobIds,
                ),
              );
            },
            onItemToggleButtonClick: (item) {
              BlocProvider.of<RefreshingJobsBloc>(context).add(
                ToggleRefreshingJob(
                  jobId: item.id!,
                  activeJobIds: pageState.activeJobIds,
                ),
              );
            },
            theme: appState.theme,
          ),
        );
      });
    });
  }
}
