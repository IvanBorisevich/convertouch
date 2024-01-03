import 'package:convertouch/domain/model/input/refreshing_jobs_events.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_progress_bloc.dart';
import 'package:convertouch/presentation/ui/items_view/refreshing_jobs_view.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchRefreshingJobsPage extends StatelessWidget {
  const ConvertouchRefreshingJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      return refreshingJobsBlocBuilder((jobsState) {
        return refreshingJobsProgressBlocBuilder((jobsProgressState) {
          return ConvertouchPage(
            appState: appState,
            title: "Refresh Data",
            body: ConvertouchRefreshingJobsView(
              jobsState.items,
              progressValues: jobsProgressState.progressValues,
              onItemClick: (item) {},
              onItemRefreshButtonClick: (item) {
                BlocProvider.of<RefreshingJobsProgressBloc>(context).add(
                  RefreshData(
                    job: item,
                    progressValues: jobsProgressState.progressValues,
                  ),
                );
              },
              theme: appState.theme,
            ),
          );
        });
      });
    });
  }
}
