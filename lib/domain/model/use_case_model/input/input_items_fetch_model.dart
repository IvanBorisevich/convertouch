class InputItemsFetchModel {
  final String? searchString;
  final int parentItemId;
  final int pageSize;
  final int pageNum;

  const InputItemsFetchModel({
    this.searchString,
    this.parentItemId = -1,
    required this.pageSize,
    required this.pageNum,
  });
}
