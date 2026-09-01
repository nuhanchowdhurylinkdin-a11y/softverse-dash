class ItemSalesReportRow {
  final String id;
  final String name;
  final String imageUrl;
  final double quantitySold;
  final double netSales;

  const ItemSalesReportRow({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.quantitySold,
    required this.netSales,
  });
}

class CategorySalesReportRow {
  final String? id;
  final String name;
  final double itemsSold;
  final double netSales;

  const CategorySalesReportRow({
    this.id,
    required this.name,
    required this.itemsSold,
    required this.netSales,
  });
}

class EmployeeSalesReportRow {
  final String id;
  final String name;
  final String avatarUrl;
  final int receipts;
  final double netSales;

  const EmployeeSalesReportRow({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.receipts,
    required this.netSales,
  });
}
