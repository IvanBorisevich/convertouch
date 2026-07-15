import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:equatable/equatable.dart';

enum FetchingStatus {
  success,
  loading,
  failure,
}

const int _nonSearchableListItemsMinLimit = 5;

class OutputItemsFetchModel<T extends IdNameSearchableItemModel,
    P extends ItemsFetchParams> extends Equatable {
  final List<T> items;
  final T? selectedItem;
  final String? searchString;
  final FetchingStatus status;
  final ConvertouchException? error;
  final bool hasReachedMax;
  final int pageNum;
  final P? fetchParams;

  const OutputItemsFetchModel({
    required this.items,
    this.selectedItem,
    this.searchString,
    this.status = FetchingStatus.success,
    this.error,
    this.hasReachedMax = false,
    this.pageNum = 0,
    this.fetchParams,
  });

  const OutputItemsFetchModel.loading({
    this.fetchParams,
    this.searchString,
    this.selectedItem,
  })  : items = const [],
        status = FetchingStatus.loading,
        hasReachedMax = false,
        pageNum = 0,
        error = null;

  const OutputItemsFetchModel.failure({
    required this.items,
    this.selectedItem,
    this.searchString,
    this.error,
    this.hasReachedMax = false,
    this.pageNum = 0,
    this.fetchParams,
  }) : status = FetchingStatus.failure;

  const OutputItemsFetchModel.success({
    required this.items,
    this.selectedItem,
    this.searchString,
    this.hasReachedMax = false,
    this.pageNum = 0,
    this.fetchParams,
  })  : status = FetchingStatus.success,
        error = null;

  const OutputItemsFetchModel.successEmpty({
    this.items = const [],
    this.selectedItem,
    this.searchString,
    this.pageNum = 0,
    this.fetchParams,
  })  : status = FetchingStatus.success,
        error = null,
        hasReachedMax = true;

  OutputItemsFetchModel<T, P> copyWith({
    List<T>? items,
    Patchable<T>? selectedItem,
    String? searchString,
    FetchingStatus? status,
    ConvertouchException? error,
    bool? hasReachedMax,
    int? pageNum,
    P? params,
    bool? fetchedRemotely,
    ValueModel? foundSelectedValue,
  }) {
    return OutputItemsFetchModel(
      items: items ?? this.items,
      selectedItem: ObjectUtils.patch(this.selectedItem, selectedItem),
      searchString: searchString ?? this.searchString,
      status: status ?? this.status,
      error: error ?? this.error,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      pageNum: pageNum ?? this.pageNum,
      fetchParams: params ?? this.fetchParams,
    );
  }

  bool get isLoading => status == FetchingStatus.loading;

  bool get isFailed => status == FetchingStatus.failure;

  bool get isSuccess => status == FetchingStatus.success;

  bool get isEmpty => items.isEmpty;

  bool get isFinalEmpty => isEmpty && hasReachedMax;

  bool get searchable => items.length > _nonSearchableListItemsMinLimit;

  @override
  List<Object?> get props => [
        items,
        selectedItem,
        searchString,
        status,
        error,
        hasReachedMax,
        pageNum,
        fetchParams,
      ];

  Map<String, dynamic> toJson({bool removeNulls = true}) {
    var result = {
      'items': items.map((e) => e.toJson()).toList(),
      'searchString': searchString,
      'hasReachedMax': hasReachedMax,
      'pageNum': pageNum,
    };

    if (removeNulls) {
      result.removeWhere((key, value) => value == null);
    }

    return result;
  }

  static OutputItemsFetchModel<T, P>?
      fromJson<T extends IdNameSearchableItemModel, P extends ItemsFetchParams>(
    Map<String, dynamic>? json, {
    required T Function(Map<String, dynamic>) fromItemJson,
  }) {
    if (json == null) {
      return null;
    }

    return OutputItemsFetchModel(
      items: json['items'] != null
          ? (json['items'] as List).map((e) => fromItemJson.call(e)).toList()
          : [],
      searchString: json['searchString'],
      hasReachedMax: json['hasReachedMax'],
      pageNum: json['pageNum'],
    );
  }

  @override
  String toString() {
    return 'FetchResult{'
        'size: ${items.length}, '
        'selected: ${selectedItem != null ? selectedItem!.name : "-"}, '
        '${searchString != null ? "$searchString, " : ""}'
        'status: $status, '
        '${error != null ? "${error!.message}, " : ""}'
        'more items: ${!hasReachedMax}, '
        'pageNum: $pageNum, '
        'fetchParams: $fetchParams}';
  }
}
