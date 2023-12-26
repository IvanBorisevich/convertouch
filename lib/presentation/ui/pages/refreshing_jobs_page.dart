import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/ui/items_view/refreshing_jobs_view.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:flutter/material.dart';

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
            onItemTap: (item) {
            },
            theme: appState.theme,
          ),
        );
      });
    });
  }
}