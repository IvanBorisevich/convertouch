import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';

class DataSourceModel extends IdNameItemModel {
  final String url;
  final String responseTransformerClassName;
  final RefreshableDataPart refreshablePart;

  const DataSourceModel({
    required super.name,
    required this.url,
    required this.responseTransformerClassName,
    required this.refreshablePart,
    super.itemType = ItemType.dataSource,
    super.oob = true,
  });

  @override
  List<Object?> get props => [
        name,
        url,
        responseTransformerClassName,
        refreshablePart,
        itemType,
      ];

  static DataSourceModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return DataSourceModel(
      name: json["name"],
      url: json["url"],
      responseTransformerClassName: json["responseTransformerClassName"],
      refreshablePart: RefreshableDataPart.valueOf(json["refreshablePart"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "url": url,
      "responseTransformerClassName": responseTransformerClassName,
      "refreshablePart": refreshablePart.name,
    };
  }

  @override
  String toString() {
    return 'DataSourceModel{'
        'name: $name, '
        'url: $url, '
        'responseTransformerClassName: $responseTransformerClassName, '
        'refreshablePart: $refreshablePart';
  }
}
