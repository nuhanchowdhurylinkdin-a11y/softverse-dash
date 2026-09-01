import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/dashboard_controller.dart';
import '../../widgets/inventory_product_card.dart';

class InventorySearchScreen extends StatefulWidget {
  const InventorySearchScreen({super.key});

  @override
  State<InventorySearchScreen> createState() => _InventorySearchScreenState();
}

class _InventorySearchScreenState extends State<InventorySearchScreen> {
  final _query = TextEditingController();
  final _controller = Get.find<DashboardController>();
  Timer? _debounce;

  void _search(String value) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 350),
      () => _controller.refreshInventory(search: value),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.refreshInventory();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search inventory')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _query,
              autofocus: true,
              onChanged: _search,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                labelText: 'Name, SKU, or barcode',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (_controller.isInventoryLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (_controller.inventoryError.value != null) {
                  return Center(child: Text(_controller.inventoryError.value!));
                }
                final products = _controller.inventoryProducts;
                if (products.isEmpty) {
                  return const Center(child: Text('No items found'));
                }
                return ListView.separated(
                  itemCount: products.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (_, index) => InventoryProductCard(
                    product: products[index],
                    onTap: () =>
                        _controller.openInventoryProduct(products[index]),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
