import 'package:convertouch/items_view/items_view.dart';
import 'package:flutter/material.dart';

class UnitGroupsPage extends StatefulWidget {
  const UnitGroupsPage({super.key});

  @override
  State<UnitGroupsPage> createState() => _UnitGroupsPageState();
}

class _UnitGroupsPageState extends State<UnitGroupsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFF6F9FF),
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                    child: ConvertouchItemsView(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
