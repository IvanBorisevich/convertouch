import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/list_value_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../../domain/model/mock/mock_unit.dart';
import '../../../domain/repositories/mock/mock_network_repository.dart';

void main() {
  late ListValueRepositoryImpl listValueRepository;

  setUp(() {
    listValueRepository = const ListValueRepositoryImpl(
      networkRepository: MockNetworkRepository(),
    );
  });

  group('Enum items batch fetch', () {
    test('Should be fetched', () async {
      List<ListValueModel> listValues = ObjectUtils.tryGet(
        await listValueRepository.fetch(
          listType: ConvertouchListType.person,
          pageNum: 0,
          pageSize: 10,
        ),
      );

      expect(listValues, const [
        ListValueModel.raw("Man"),
        ListValueModel.raw("Woman"),
      ]);
    });
  });

  group('Num items batch fetch', () {
    test('All items batch should be fetched without coefficient', () async {
      List<ListValueModel> listValues = ObjectUtils.tryGet(
        await listValueRepository.fetch(
          listType: ConvertouchListType.barbellBarWeight,
          pageNum: 0,
          pageSize: 10,
        ),
      );

      expect(listValues, const [
        ListValueModel.raw("10"),
        ListValueModel.raw("20"),
      ]);
    });

    test('All items batch should be fetched with coefficient', () async {
      List<ListValueModel> listValues = ObjectUtils.tryGet(
        await listValueRepository.fetch(
          listType: ConvertouchListType.barbellBarWeight,
          pageNum: 0,
          pageSize: 10,
          unit: pound,
        ),
      );

      expect(listValues, const [
        ListValueModel.raw("22"),
        ListValueModel.raw("44"),
      ]);
    });

    test('First 5 items should be fetched without coefficient', () async {
      List<ListValueModel> listValues = ObjectUtils.tryGet(
        await listValueRepository.fetch(
          listType: ConvertouchListType.clothesSizeDe,
          pageNum: 0,
          pageSize: 5,
        ),
      );

      expect(listValues, const [
        ListValueModel.raw("32"),
        ListValueModel.raw("34"),
        ListValueModel.raw("36"),
        ListValueModel.raw("38"),
        ListValueModel.raw("40"),
      ]);
    });

    test('Next 5 items should be fetched without coefficient', () async {
      List<ListValueModel> listValues = ObjectUtils.tryGet(
        await listValueRepository.fetch(
          listType: ConvertouchListType.clothesSizeDe,
          pageNum: 1,
          pageSize: 5,
        ),
      );

      expect(listValues, const [
        ListValueModel.raw("42"),
        ListValueModel.raw("44"),
        ListValueModel.raw("46"),
        ListValueModel.raw("48"),
        ListValueModel.raw("50"),
      ]);
    });

    test('The rest of items should be fetched without coefficient', () async {
      List<ListValueModel> listValues = ObjectUtils.tryGet(
        await listValueRepository.fetch(
          listType: ConvertouchListType.clothesSizeDe,
          pageNum: 2,
          pageSize: 5,
        ),
      );

      expect(listValues, const [
        ListValueModel.raw("52"),
        ListValueModel.raw("54"),
        ListValueModel.raw("56"),
      ]);
    });
  });
}
