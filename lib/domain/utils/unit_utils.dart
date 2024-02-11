class UnitUtils {
  const UnitUtils._();

  static String calcInitialUnitCode(
    String unitName, {
    int unitCodeMaxLength = 4,
  }) {
    return unitName.length > unitCodeMaxLength
        ? unitName.substring(0, unitCodeMaxLength)
        : unitName;
  }
}
