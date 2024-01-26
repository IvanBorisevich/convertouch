import 'package:convertouch/presentation/bloc/abstract_state.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:flutter/material.dart';

class ConvertouchErrorPage extends StatelessWidget {
  final String pageTitle;
  final ConvertouchErrorState errorState;

  const ConvertouchErrorPage({
    this.pageTitle = "Error",
    required this.errorState,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      return ConvertouchPage(
        appState: appState,
        title: pageTitle,
        body: Center(
          child: Text(
            errorState.exception.message,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    });
  }
}