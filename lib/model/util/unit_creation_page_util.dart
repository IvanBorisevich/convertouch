const int unitAbbreviationMaxLength = 4;

String getInitialUnitAbbreviationFromName(String unitName) {
  return unitName.length > unitAbbreviationMaxLength
      ? unitName.substring(0, unitAbbreviationMaxLength)
      : unitName;
}