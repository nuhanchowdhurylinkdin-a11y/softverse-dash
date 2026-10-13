/// One tax and how much of it the selected period's sales collected.
class DashboardTaxModel {
  final String name;
  final double ratePercent;
  final bool includedInPrice;
  final double amountCollected;

  const DashboardTaxModel({
    required this.name,
    required this.ratePercent,
    required this.includedInPrice,
    required this.amountCollected,
  });

  factory DashboardTaxModel.fromApi(Map<String, dynamic> row) =>
      DashboardTaxModel(
        name: row['taxName']?.toString() ?? 'Tax',
        ratePercent: (row['taxRatePercent'] as num?)?.toDouble() ?? 0,
        includedInPrice: row['type'] == 'included_in_price',
        amountCollected: (row['amountTaxed'] as num?)?.toDouble() ?? 0,
      );
}
