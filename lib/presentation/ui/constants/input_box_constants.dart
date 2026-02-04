import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:flutter/material.dart';

abstract interface class InputBoxConstants {
  static const double defaultHeight = 55;
  static const double defaultBorderRadiusNum = 15;
  static const Radius defaultRadius = Radius.circular(defaultBorderRadiusNum);
  static const BorderRadius defaultBorderRadius =
      BorderRadius.all(defaultRadius);
  static const double defaultBorderWidth = 1;
  static const double defaultFontSize = 17;
  static const double defaultContentPaddingLeft = 17;
  static const double defaultContentPaddingRight = 17;
  static const double defaultIconPaddingLeft = 10;
  static const double defaultIconPaddingRight = 10;
}

const Map<ItemsViewMode, IconData> itemViewModeIconMap = {
  ItemsViewMode.list: Icons.reorder_outlined,
  ItemsViewMode.grid: Icons.grid_view_rounded,
};

const Map<ConvertouchValueType, TextInputType> inputValueTypeToKeyboardTypeMap =
    {
  ConvertouchValueType.text: TextInputType.text,
  ConvertouchValueType.integer: TextInputType.numberWithOptions(
    signed: true,
    decimal: false,
  ),
  ConvertouchValueType.integerNonNegative: TextInputType.numberWithOptions(
    signed: false,
    decimal: false,
  ),
  ConvertouchValueType.decimal: TextInputType.numberWithOptions(
    signed: true,
    decimal: true,
  ),
  ConvertouchValueType.decimalNonNegative: TextInputType.numberWithOptions(
    signed: false,
    decimal: true,
  ),
  ConvertouchValueType.hexadecimal: TextInputType.text,
};

final Map<ConvertouchValueType, RegExp> inputValueTypeToRegExpMap = {
  ConvertouchValueType.text: RegExp(r'(^[\S ]+$)'),
  ConvertouchValueType.integer: RegExp(r'(^[.-]?$)|(^-?\d+$)'),
  ConvertouchValueType.integerNonNegative: RegExp(r'(^\d+$)'),
  ConvertouchValueType.decimal: RegExp(r'(^[.-]?$)|(^-?\d+\.?\d*$)'),
  ConvertouchValueType.decimalNonNegative: RegExp(r'(^\d+\.?\d*$)'),
  ConvertouchValueType.hexadecimal: RegExp(r'^0[xX][\da-fA-F]+$'),
};
