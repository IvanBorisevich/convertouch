import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:flutter/material.dart';

class ConvertouchRadioDialog<T> extends StatelessWidget {
  final String title;
  final T selectedValue;
  final String Function(T)? valueMap;
  final List<T> possibleValues;
  final void Function(T?)? onChanged;
  final SettingItemColorScheme colors;

  const ConvertouchRadioDialog({
    required this.title,
    required this.selectedValue,
    this.valueMap,
    required this.possibleValues,
    this.onChanged,
    required this.colors,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          color: colors.foreground.regular,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      backgroundColor: colors.background.regular,
      content: ListView.builder(
        shrinkWrap: true,
        itemCount: possibleValues.length,
        itemBuilder: (context, index) {
          final itemValue = possibleValues[index];
          return RadioListTile<T>.adaptive(
            title: Text(
              valueMap?.call(itemValue) ?? itemValue.toString(),
              style: TextStyle(
                color: colors.foreground.regular,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
              ),
            ),
            visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
            fillColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return colors.foreground.selected;
              }
              if (states.contains(WidgetState.disabled)) {
                return colors.foreground.disabled;
              }
              return colors.foreground.regular;
            }),
            value: itemValue,
            groupValue: selectedValue,
            onChanged: onChanged,
          );
        },
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Cancel',
            style: TextStyle(
              color: colors.selectedValue.regular,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
