import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/list_value_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../../domain/model/mock/mock_list_values_batch.dart';
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

      expect(listValues, personParamListValues.items);
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

      expect(listValues, barWeightParamKgListValues.items);
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

      expect(listValues, barWeightParamPoundListValues.items);
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
        ListValueModel.str("32"),
        ListValueModel.str("34"),
        ListValueModel.str("36"),
        ListValueModel.str("38"),
        ListValueModel.str("40"),
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
        ListValueModel.str("42"),
        ListValueModel.str("44"),
        ListValueModel.str("46"),
        ListValueModel.str("48"),
        ListValueModel.str("50"),
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
        ListValueModel.str("52"),
        ListValueModel.str("54"),
        ListValueModel.str("56"),
      ]);
    });
  });
}
