import 'package:convertouch/domain/constants/constants.dart';

class InputItemsFetchModel {
  final String? searchString;
  final int parentItemId;
  final int pageSize;
  final int pageNum;
  final double? coefficient;
  final ConvertouchListType? listType;
  final ItemType? parentItemType;

  const InputItemsFetchModel({
    this.searchString,
    this.parentItemId = -1,
    required this.pageSize,
    required this.pageNum,
    this.coefficient,
    this.listType,
    this.parentItemType,
  });
}
