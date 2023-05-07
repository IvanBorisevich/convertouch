import 'package:flutter/material.dart';

class ConvertouchSearchBarTextField extends StatefulWidget {
  const ConvertouchSearchBarTextField({super.key});

  @override
  State createState() => _ConvertouchSearchBarTextFieldState();
}

class _ConvertouchSearchBarTextFieldState
    extends State<ConvertouchSearchBarTextField> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 2, 3),
          child: TextFormField(
            autofocus: false,
            obscureText: false,
            decoration: InputDecoration(
              hintText: 'Search unit groups...',
              hintStyle: const TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xFF426F99),
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  )),
              filled: true,
              fillColor: const Color(0xFFF6F9FF),
              contentPadding: const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
            ),
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xFF426F99),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.start,
            minLines: 1,
          ),
        ),
      ),
    );
  }
}
