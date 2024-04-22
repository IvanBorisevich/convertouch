import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';

class JobDataSourceModel extends IdNameItemModel {
  final String url;
  final String responseTransformerClassName;

  const JobDataSourceModel({
    required super.name,
    required this.url,
    required this.responseTransformerClassName,
    super.itemType = ItemType.jobDataSource,
    super.oob = true,
  });

  @override
  List<Object?> get props => [
        name,
        url,
        responseTransformerClassName,
        itemType,
      ];

  static JobDataSourceModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return JobDataSourceModel(
      name: json["name"],
      url: json["url"],
      responseTransformerClassName: json["responseTransformerClassName"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "url": url,
      "responseTransformerClassName": responseTransformerClassName,
    };
  }

  @override
  String toString() {
    return 'JobDataSourceModel{'
        'name: $name, '
        'url: $url, '
        'responseTransformerClassName: $responseTransformerClassName';
  }
}
