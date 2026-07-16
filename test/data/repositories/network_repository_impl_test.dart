import 'dart:convert';

import 'package:convertouch/data/const/constants.dart';
import 'package:convertouch/data/dao/dynamic_value_dao.dart';
import 'package:convertouch/data/dao/net/network_helper/network_helper.dart';
import 'package:convertouch/data/dao/network_dao.dart';
import 'package:convertouch/data/dao/unit_dao.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/repositories/network_repository_impl.dart';
import 'package:convertouch/data/translators/dynamic_coefficients_translator.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../domain/model/mock/mock_param.dart';
import '../../domain/model/mock/mock_unit.dart';
import '../../domain/repositories/mock/mock_unit_group_repository.dart';
import 'network_repository_impl_test.mocks.dart';

final _locator = GetIt.I;

@GenerateMocks(
  [],
  customMocks: [
    MockSpec<NetworkHelper>(as: #MockNetworkHelper),
    MockSpec<NetworkDao>(as: #MockNetworkDao),
    MockSpec<UnitDao>(as: #MockUnitDao),
    MockSpec<DynamicValueDao>(as: #MockDynamicValueDao),
  ],
)
Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Database database;
  late NetworkRepositoryImpl networkRepository;
  late ConversionParamSetValueModel exchangeRateParams;

  late MockNetworkDao mockNetworkDao;
  late MockUnitDao mockUnitDao;
  late MockDynamicValueDao mockDynamicValueDao;
  late MockUnitGroupRepository mockUnitGroupRepository;

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    database = await openDatabase(inMemoryDatabasePath, version: 1);

    _locator.registerLazySingleton<DynamicCoefficientsTranslator>(
      () => DynamicCoefficientsTranslator(),
    );
  });

  setUp(() {
    mockNetworkDao = MockNetworkDao();
    mockUnitDao = MockUnitDao();
    mockDynamicValueDao = MockDynamicValueDao();
    mockUnitGroupRepository = const MockUnitGroupRepository();

    networkRepository = NetworkRepositoryImpl(
      networkDao: mockNetworkDao,
      unitDao: mockUnitDao,
      dynamicValueDao: mockDynamicValueDao,
      database: database,
      unitGroupRepository: mockUnitGroupRepository,
    );

    exchangeRateParams = ConversionParamSetValueModel(
      paramSet: exchangeRateParamSet,
      paramValues: [
        ConversionParamValueModel.tuple(
            exchangeRateSourceBankParam, "FloatRates", null),
      ],
    );
  });

  group("Should check connectivity", () {
    test("Should detect the lack of connectivity", () async {
      when(
        mockNetworkDao.fetch(
          any,
          queryParams: anyNamed("queryParams"),
          headers: anyNamed('headers'),
        ),
      ).thenThrow(
        ConvertouchException(
          message: "No internet connection",
          severity: ExceptionSeverity.warning,
        ),
      );

      final result = await networkRepository.fetchCoefficients(
        conversionGroupName: GroupNames.currency,
        params: exchangeRateParams,
      );

      expect(result.isLeft, true);
      expect(result.left.message, "No internet connection");
    });
  });

  group("Should fetch list values", () {
    test("Should fetch 'Source / Bank' param list values", () async {
      when(
        mockNetworkDao.fetch(
          exchangeRateSourcesPath,
          queryParams: anyNamed('queryParams'),
        ),
      ).thenAnswer(
        (_) async => jsonEncode([
          {
            "raw": "British Bank",
            "alt": "British Bank",
          },
          {
            "raw": "ExchangeAPI.com",
            "alt": "ExchangeAPI.com",
          },
        ]),
      );

      var fetchedSources = await networkRepository.fetchListValues(
        listType: ConvertouchListType.exchangeRateSource,
        conversionGroupName: GroupNames.currency,
        params: exchangeRateParams,
        pageSize: 100,
        pageNum: 1,
      );

      expect(fetchedSources.isRight, true);
      expect(fetchedSources.right, const [
        ValueModel.rawStr('British Bank', iconUri: IconKeys.dataSource),
        ValueModel.rawStr('ExchangeAPI.com', iconUri: IconKeys.dataSource),
      ]);
    });
  });

  group("Should fetch dynamic coefficients", () {
    test('Should fetch exchange rate', () async {
      Map<String, dynamic> ratesResponseMap = {
        "USD": 1,
        "EUR": 1.123,
      };

      Map<int, double?> expectedCoefficients = {
        23: 1,
        24: 1.123,
      };

      when(
        mockNetworkDao.fetch(
          exchangeRatePath,
          queryParams: anyNamed('queryParams'),
        ),
      ).thenAnswer((_) async => jsonEncode(ratesResponseMap));

      when(
        mockUnitDao.updateUnitsCoefficients(database, any, any),
      ).thenAnswer((invocation) async {
        final unitIdToCoefficient = invocation.positionalArguments[2];

        return [usd, eur]
            .map(
              (unit) => UnitEntity(
                id: unit.id,
                name: unit.name,
                code: unit.code,
                coefficient: unitIdToCoefficient[unit.code],
                unitGroupId: unit.unitGroupId,
              ),
            )
            .toList();
      });

      var result = await networkRepository.fetchCoefficients(
        conversionGroupName: GroupNames.currency,
        params: exchangeRateParams,
      );

      expect(
        result.right,
        DynamicCoefficientsModel(expectedCoefficients),
      );

      verify(
        mockNetworkDao.fetch(
          exchangeRatePath,
          queryParams: {'source': 'FloatRates'},
        ),
      ).called(1);
    });
  });
}
