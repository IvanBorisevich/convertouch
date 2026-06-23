import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:equatable/equatable.dart';

class OutputItemsFetchModel<T extends IdNameSearchableItemModel,
    P extends ItemsFetchParams> extends Equatable {
  final List<T> items;
  final String? searchString;
  final FetchingStatus status;
  final ConvertouchException? error;
  final bool hasReachedMax;
  final int pageNum;
  final P? fetchParams;
  final bool containsSelectedValue;

  const OutputItemsFetchModel({
    required this.items,
    this.searchString,
    this.status = FetchingStatus.success,
    this.error,
    this.hasReachedMax = false,
    this.pageNum = 0,
    this.fetchParams,
    this.containsSelectedValue = true,
  });

  const OutputItemsFetchModel.loading()
      : this(
          items: const [],
          status: FetchingStatus.loading,
          hasReachedMax: false,
          pageNum: 0,
        );

  const OutputItemsFetchModel.failure({
    required this.items,
    this.searchString,
    this.error,
    this.hasReachedMax = false,
    this.pageNum = 0,
    this.fetchParams,
    this.containsSelectedValue = true,
  }) : status = FetchingStatus.failure;

  const OutputItemsFetchModel.success({
    required this.items,
    this.searchString,
    this.hasReachedMax = false,
    this.pageNum = 0,
    this.fetchParams,
    this.containsSelectedValue = true,
  })  : status = FetchingStatus.success,
        error = null;

  const OutputItemsFetchModel.successEmpty({
    this.items = const [],
    this.searchString,
    this.pageNum = 0,
    this.fetchParams,
  })  : status = FetchingStatus.success,
        error = null,
        hasReachedMax = true,
        containsSelectedValue = true;

  OutputItemsFetchModel<T, P> copyWith({
    List<T>? items,
    String? searchString,
    FetchingStatus? status,
    ConvertouchException? error,
    bool? hasReachedMax,
    int? pageNum,
    P? params,
    bool? fetchedRemotely,
    bool? containsSelectedValue,
  }) {
    return OutputItemsFetchModel(
      items: items ?? this.items,
      searchString: searchString ?? this.searchString,
      status: status ?? this.status,
      error: error ?? this.error,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      pageNum: pageNum ?? this.pageNum,
      fetchParams: params ?? this.fetchParams,
      containsSelectedValue:
          containsSelectedValue ?? this.containsSelectedValue,
    );
  }

  @override
  List<Object?> get props => [
        items,
        searchString,
        status,
        error,
        hasReachedMax,
        pageNum,
        fetchParams,
        containsSelectedValue,
      ];

  Map<String, dynamic> toJson({
    bool removeNulls = true,
    bool saveParams = true,
  }) {
    var result = {
      'items': items.map((e) => e.toJson()).toList(),
      'searchString': searchString,
      'hasReachedMax': hasReachedMax,
      'pageNum': pageNum,
      'params': saveParams ? fetchParams?.toJson() : null,
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
    required P? Function(Map<String, dynamic>?) fromParamsJson,
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
      fetchParams: fromParamsJson.call(json['params']),
    );
  }

  @override
  String toString() {
    return 'FetchResult{'
        'numOfItems: ${items.length}, '
        'searchString: $searchString, '
        'status: $status, '
        'error: $error, '
        'hasReachedMax: $hasReachedMax, '
        'pageNum: $pageNum, '
        'fetchParams: $fetchParams}';
  }
}
