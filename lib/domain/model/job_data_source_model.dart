import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';

class JobDataSourceModel extends IdNameItemModel {
  final String url;
  final String responseTransformerClassName;
  final int jobId;

  const JobDataSourceModel({
    super.id,
    required super.name,
    required this.url,
    required this.responseTransformerClassName,
    required this.jobId,
    super.itemType = ItemType.jobDataSource,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    url,
    responseTransformerClassName,
    jobId,
    itemType,
  ];

  @override
  String toString() {
    return 'JobDataSourceModel{'
        'url: $url, '
        'responseTransformerClassName: $responseTransformerClassName';
  }
}
