import 'package:flutter/material.dart';

class ListInputDialogContent<T> extends StatelessWidget {
  final List<T> values;
  final T? selectedValue;

  const ListInputDialogContent({
    required this.values,
    this.selectedValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
