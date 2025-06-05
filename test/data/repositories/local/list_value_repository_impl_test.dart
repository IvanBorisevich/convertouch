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

  group('Enum items batch fetch', () {
    test('Should be fetched', () async {
      List<ListValueModel> listValues = ObjectUtils.tryGet(
        await listValueRepository.search(
          listType: ConvertouchListType.person,
          pageNum: 0,
          pageSize: 10,
        ),
      );

      expect(listValues, const [
        ListValueModel.value("Man"),
        ListValueModel.value("Woman"),
      ]);
    });
  });

  group('Num items batch fetch', () {
    test('All items batch should be fetched without coefficient', () async {
      List<ListValueModel> listValues = ObjectUtils.tryGet(
        await listValueRepository.search(
          listType: ConvertouchListType.barbellBarWeight,
          pageNum: 0,
          pageSize: 10,
        ),
      );

      expect(listValues, const [
        ListValueModel.value("10"),
        ListValueModel.value("20"),
      ]);
    });

    test('All items batch should be fetched with coefficient', () async {
      List<ListValueModel> listValues = ObjectUtils.tryGet(
        await listValueRepository.search(
          listType: ConvertouchListType.barbellBarWeight,
          pageNum: 0,
          pageSize: 10,
          unit: pound,
        ),
      );

      expect(listValues, const [
        ListValueModel.value("22"),
        ListValueModel.value("44"),
      ]);
    });

    test('First 5 items should be fetched without coefficient', () async {
      List<ListValueModel> listValues = ObjectUtils.tryGet(
        await listValueRepository.search(
          listType: ConvertouchListType.clothesSizeDe,
          pageNum: 0,
          pageSize: 5,
        ),
      );

      expect(listValues, const [
        ListValueModel.value("32"),
        ListValueModel.value("34"),
        ListValueModel.value("36"),
        ListValueModel.value("38"),
        ListValueModel.value("40"),
      ]);
    });

    test('Next 5 items should be fetched without coefficient', () async {
      List<ListValueModel> listValues = ObjectUtils.tryGet(
        await listValueRepository.search(
          listType: ConvertouchListType.clothesSizeDe,
          pageNum: 1,
          pageSize: 5,
        ),
      );

      expect(listValues, const [
        ListValueModel.value("42"),
        ListValueModel.value("44"),
        ListValueModel.value("46"),
        ListValueModel.value("48"),
        ListValueModel.value("50"),
      ]);
    });

    test('The rest of items should be fetched without coefficient', () async {
      List<ListValueModel> listValues = ObjectUtils.tryGet(
        await listValueRepository.search(
          listType: ConvertouchListType.clothesSizeDe,
          pageNum: 2,
          pageSize: 5,
        ),
      );

      expect(listValues, const [
        ListValueModel.value("52"),
        ListValueModel.value("54"),
        ListValueModel.value("56"),
      ]);
    });
  });
}
