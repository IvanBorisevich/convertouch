import 'package:convertouch/model/constant.dart';
import 'package:convertouch/view/items_view/conversion_items_view.dart';
import 'package:convertouch/view/scaffold/scaffold.dart';
import 'package:flutter/material.dart';

class ConvertouchUnitsConversionPage extends StatefulWidget {
  const ConvertouchUnitsConversionPage({super.key});

  @override
  State<ConvertouchUnitsConversionPage> createState() =>
      _ConvertouchUnitsConversionPageState();
}

class _ConvertouchUnitsConversionPageState
    extends State<ConvertouchUnitsConversionPage> {
  @override
  Widget build(BuildContext context) {
    return ConvertouchScaffold(
      body: const ConvertouchConversionItemsView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(unitsPageId);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
