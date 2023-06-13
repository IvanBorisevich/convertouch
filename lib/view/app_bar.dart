import 'package:flutter/material.dart';

class ConvertouchAppBar extends StatelessWidget {
  const ConvertouchAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: const BoxDecoration(
        color: Color(0xFFDEE9FF),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            alignment: Alignment.center,
            child: const IconButton(
              icon: Icon(
                Icons.menu,
                color: Color(0xFF426F99),
              ),
              onPressed: null, // null disables the button
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                'Unit Groups',
                style: TextStyle(
                    color: Color(0xFF426F99),
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Container(
            width: 55,
            alignment: Alignment.center,
            child: const Visibility(
              visible: false,
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Color(0xFF426F99),
                ),
                onPressed: null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}