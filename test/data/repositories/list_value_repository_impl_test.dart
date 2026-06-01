import 'package:convertouch/data/repositories/list_value_repository_impl.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../domain/model/mock/mock_list_values_batch.dart';
import '../../domain/model/mock/mock_unit.dart';
import '../../domain/repositories/mock/mock_network_repository.dart';

void main() {
  late ListValueRepositoryImpl listValueRepository;

  setUp(() {
    listValueRepository = const ListValueRepositoryImpl(
      networkRepository: MockNetworkRepository(),
    );
  });

  group('Enum items batch fetch', () {
    test('Should be fetched', () async {
      List<ValueModel> listValues = ObjectUtils.tryGet(
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
      List<ValueModel> listValues = ObjectUtils.tryGet(
        await listValueRepository.fetch(
          listType: ConvertouchListType.barbellBarWeight,
          pageNum: 0,
          pageSize: 10,
        ),
      );

      expect(listValues, barWeightParamKgListValues.items);
    });

    test('All items batch should be fetched with coefficient', () async {
      List<ValueModel> listValues = ObjectUtils.tryGet(
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
      List<ValueModel> listValues = ObjectUtils.tryGet(
        await listValueRepository.fetch(
          listType: ConvertouchListType.clothesSizeDe,
          pageNum: 0,
          pageSize: 5,
        ),
      );

      expect(listValues, [
        ValueModel.str("32"),
        ValueModel.str("34"),
        ValueModel.str("36"),
        ValueModel.str("38"),
        ValueModel.str("40"),
      ]);
    });

    test('Next 5 items should be fetched without coefficient', () async {
      List<ValueModel> listValues = ObjectUtils.tryGet(
        await listValueRepository.fetch(
          listType: ConvertouchListType.clothesSizeDe,
          pageNum: 1,
          pageSize: 5,
        ),
      );

      expect(listValues, [
        ValueModel.str("42"),
        ValueModel.str("44"),
        ValueModel.str("46"),
        ValueModel.str("48"),
        ValueModel.str("50"),
      ]);
    });

    test('The rest of items should be fetched without coefficient', () async {
      List<ValueModel> listValues = ObjectUtils.tryGet(
        await listValueRepository.fetch(
          listType: ConvertouchListType.clothesSizeDe,
          pageNum: 2,
          pageSize: 5,
        ),
      );

      expect(listValues, [
        ValueModel.str("52"),
        ValueModel.str("54"),
        ValueModel.str("56"),
      ]);
    });
  });
}
