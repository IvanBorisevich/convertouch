import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:equatable/equatable.dart';

class OutputItemsFetchModel<T extends IdNameSearchableItemModel,
    P extends ItemsFetchParams> extends Equatable {
  final List<T> items;
  final String? searchString;
  final FetchingStatus status;
  final bool hasReachedMax;
  final int pageNum;
  final P? params;

  const OutputItemsFetchModel.empty()
      : this(
          items: const [],
          status: FetchingStatus.success,
          hasReachedMax: false,
          pageNum: 0,
        );

  const OutputItemsFetchModel({
    required this.items,
    this.searchString,
    this.status = FetchingStatus.success,
    this.hasReachedMax = false,
    this.pageNum = 0,
    this.params,
  });

  OutputItemsFetchModel<T, P> copyWith({
    List<T>? items,
    String? searchString,
    FetchingStatus? status,
    bool? hasReachedMax,
    int? pageNum,
    P? params,
    bool? fetchedRemotely,
  }) {
    return OutputItemsFetchModel(
      items: items ?? this.items,
      searchString: searchString ?? this.searchString,
      status: status ?? this.status,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      pageNum: pageNum ?? this.pageNum,
      params: params ?? this.params,
    );
  }

  @override
  List<Object?> get props => [
        items,
        searchString,
        status,
        hasReachedMax,
        pageNum,
        params,
      ];

  Map<String, dynamic> toJson({
    bool removeNulls = true,
    bool saveParams = true,
  }) {
    var result = {
      'items': params?.fetchRemotely == true
          ? items.map((e) => e.toJson()).toList()
          : [],
      'searchString': searchString,
      'hasReachedMax': hasReachedMax,
      'pageNum': pageNum,
      'params': saveParams ? params?.toJson() : null,
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
      params: fromParamsJson.call(json['params']),
    );
  }

  @override
  String toString() {
    return 'OutputItemsFetchModel{'
        'numOfItems: ${items.length}, '
        'searchString: $searchString, '
        'status: $status, '
        'hasReachedMax: $hasReachedMax, '
        'pageNum: $pageNum, '
        'params: $params}';
  }
}
