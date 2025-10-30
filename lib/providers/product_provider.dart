import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  List products = [];
  int skip = 0;
  int limit = 10;
  int total = 100; // default; will update from API
  bool isLoading = false;

  Future<void> fetchProducts() async {
    if (isLoading) return;
    if (skip >= total) return; // no more items

    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("https://dummyjson.com/products?limit=$limit&skip=$skip"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List newItems = List.from(data['products'] ?? []);
        total = data['total'] ?? total;
        if (newItems.isNotEmpty) {
          products.addAll(newItems);
          skip += newItems.length;
        }
      } else {
        // optional: handle non-200
        debugPrint('Products fetch failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Products fetch error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
