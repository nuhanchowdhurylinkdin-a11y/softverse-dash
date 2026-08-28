class InventoryProductModel {
  final String name;
  final String sku;
  final double price;
  final String imageUrl;
  final int stockCount;
  final String category;

  const InventoryProductModel({
    required this.name,
    required this.sku,
    required this.price,
    required this.imageUrl,
    required this.stockCount,
    required this.category,
  });
}
