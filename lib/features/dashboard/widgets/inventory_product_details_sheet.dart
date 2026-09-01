import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/inventory_product_model.dart';

void showInventoryProductDetails(InventoryProductModel product) {
  Get.bottomSheet<void>(
    SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text('SKU: ${product.sku.isEmpty ? 'Not available' : product.sku}'),
            Text(
              'Barcode: ${product.barcode.isEmpty ? 'Not available' : product.barcode}',
            ),
            Text('Category: ${product.category}'),
            Text(
              'Stock: ${product.trackStock ? product.stockCount : 'Not tracked'}',
            ),
            if (product.expirationDate != null)
              Text(
                '${product.expirationStatus == 'expired' ? 'Expired' : 'Expires'}: '
                '${DateFormat('dd MMM yyyy').format(product.expirationDate!.toLocal())}',
              ),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}
