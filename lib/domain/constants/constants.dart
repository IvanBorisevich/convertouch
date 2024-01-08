import 'package:collection/collection.dart';

const String appName = "Convertouch";
const String iconAssetsPathPrefix = "assets/icons";
const String unitGroupDefaultIconName = "unit-group.png";
const String quicksandFontFamily = "Quicksand";

const String unitsConversionPage = "unitsConversionPage";
const String unitGroupsPageRegular = "unitGroupsPageRegular";
const String unitGroupsPageForConversion = "unitGroupsPageForConversion";
const String unitGroupsPageForUnitCreation = "unitGroupsPageForUnitCreation";
const String unitsPageRegular = "unitsPageRegular";
const String unitsPageForConversion = "unitsPageForConversion";
const String unitsPageForUnitCreation = "unitsPageForUnitCreation";
const String unitGroupCreationPage = "unitGroupCreationPage";
const String unitCreationPage = "unitCreationPage";
const String refreshingJobsPage = "refreshingJobsPage";
const String refreshingJobDetailsPage = "refreshingJobDetailsPage";

const String sourceUnitIdKey = 'sourceUnitId';
const String sourceValueKey = 'sourceValue';
const String targetUnitIdsKey = 'targetUnitIds';
const String conversionUnitGroupIdKey = 'conversionUnitGroupId';

enum ItemType {
  unit,
  unitGroup,
  unitValue,
  refreshingJob,
  cron,
}

enum BottomNavbarItem {
  home,
  unitsMenu,
  refreshableData,
  more,
}

enum ItemsViewMode {
  list,
  grid,
}

enum ConvertouchUITheme {
  light,
  dark,
}

enum ConversionType {
  static(0),
  dynamic(1),
  formula(2);

  final int value;

  const ConversionType(this.value);

  static ConversionType valueOf(int? value) {
    if (value == null) {
      return ConversionType.static;
    }
    return values.firstWhere((element) => value == element.value);
  }
}

enum RefreshableDataPart {
  value(0),
  coefficient(1);

  final int val;

  const RefreshableDataPart(this.val);

  static RefreshableDataPart valueOf(int value) {
    return values.firstWhere((element) => value == element.val);
  }

  @override
  String toString() {
    return name;
  }
}

enum JobAutoRefresh {
  off(0),
  on(1);

  final int value;

  const JobAutoRefresh(this.value);

  static JobAutoRefresh valueOf(int value) {
    return values.firstWhere((element) => value == element.value);
  }
}

enum Cron {
  everyHour(name: "Every hour", expression: "0 0 0/1 1/1 * ? *"),
  everyDay(name: "Every day", expression: "0 0 12 1/1 * ? *");

  final String name;
  final String expression;

  const Cron({
    required this.name,
    required this.expression,
  });

  static Cron? valueOf(String? name) {
    return values.firstWhereOrNull((element) => name == element.name);
  }
}
