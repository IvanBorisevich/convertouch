import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../../domain/model/mock/mock_unit.dart';

void main() {
  late ListValueRepositoryImpl listValueRepository;

  setUp(() {
    listValueRepository = const ListValueRepositoryImpl();
  });

  group('Enum items fetch', () {
    test('Should be fetched', () async {
      List<ListValueModel> listValues = ObjectUtils.tryGet(
        await listValueRepository.search(listType: ConvertouchListType.person),
      );

      expect(listValues, const [
        ListValueModel.value("Man"),
        ListValueModel.value("Woman"),
      ]);
    });
  });

  group('Num items fetch', () {
    test('Items should be fetched without coefficient', () async {
      List<ListValueModel> listValues = ObjectUtils.tryGet(
        await listValueRepository.search(
          listType: ConvertouchListType.barbellBarWeight,
        ),
      );

      expect(listValues, const [
        ListValueModel.value("10"),
        ListValueModel.value("20"),
      ]);
    });

    test('Items should be fetched with coefficient', () async {
      List<ListValueModel> listValues = ObjectUtils.tryGet(
        await listValueRepository.search(
          listType: ConvertouchListType.barbellBarWeight,
          unit: pound,
        ),
      );

      expect(listValues, const [
        ListValueModel.value("22"),
        ListValueModel.value("44"),
      ]);
    });
  });
}
