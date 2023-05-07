import 'package:flutter/material.dart';

class ConvertouchItemsViewModeButton extends StatefulWidget {
  const ConvertouchItemsViewModeButton({super.key});

  @override
  State createState() => _ConvertouchItemsViewModeButtonState();
}

class _ConvertouchItemsViewModeButtonState
    extends State<ConvertouchItemsViewModeButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      alignment: Alignment.center,
      child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(2, 0, 4, 3),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF6F9FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              // style: ,
              onPressed: () {},
              icon: const Icon(
                Icons.grid_view,
                color: Color(0xFF426F99),
              ),
            ),
          )),
    );
  }
}
