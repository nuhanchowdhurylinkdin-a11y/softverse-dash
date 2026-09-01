class InventoryProductModel {
  final String id;
  final String? categoryId;
  final String name;
  final String sku;
  final String barcode;
  final double price;
  final String imageUrl;
  final int stockCount;
  final int lowStock;
  final bool trackStock;
  final String stockStatus;
  final bool trackExpiration;
  final DateTime? expirationDate;
  final String expirationStatus;
  final String category;

  const InventoryProductModel({
    required this.id,
    this.categoryId,
    required this.name,
    required this.sku,
    required this.barcode,
    required this.price,
    required this.imageUrl,
    required this.stockCount,
    required this.lowStock,
    required this.trackStock,
    required this.stockStatus,
    required this.trackExpiration,
    this.expirationDate,
    required this.expirationStatus,
    required this.category,
  });

  factory InventoryProductModel.fromApi(Map<String, dynamic> json) {
    final rawDate = json['expirationDate']?.toString();
    return InventoryProductModel(
      id: json['id']?.toString() ?? '',
      categoryId: json['categoryId']?.toString(),
      name: json['name']?.toString() ?? 'Unnamed item',
      sku: json['sku']?.toString() ?? '',
      barcode: json['barcode']?.toString() ?? '',
      price: double.tryParse('${json['price'] ?? 0}') ?? 0,
      imageUrl: json['imageUrl']?.toString() ?? '',
      stockCount: _toInt(json['inStock']),
      lowStock: _toInt(json['lowStock']),
      trackStock: json['trackStock'] == true,
      stockStatus: json['stockStatus']?.toString() ?? 'untracked',
      trackExpiration: json['trackExpiration'] == true,
      expirationDate: rawDate == null ? null : DateTime.tryParse(rawDate),
      expirationStatus: json['expirationStatus']?.toString() ?? 'untracked',
      category: json['categoryName']?.toString() ?? 'Uncategorized',
    );
  }

  static int _toInt(dynamic value) =>
      (double.tryParse('${value ?? 0}') ?? 0).round();
}
