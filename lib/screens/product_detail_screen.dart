import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shopx_app/providers/wishlist_cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Map product = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  fetchProduct() async {
    final res = await http.get(
        Uri.parse("https://dummyjson.com/products/${widget.productId}"));
    product = jsonDecode(res.body);
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<WishlistCartProvider>(context);

    if (loading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: Text(product['title'])),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Image.network(product['thumbnail'], height: 200),
            const SizedBox(height: 10),
            Text(product['description']),
            Text("₹ ${product['price']}",
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    cartProvider.addToCart(product);
                  },
                  child: const Text("Add to Cart"),
                ),
                ElevatedButton(
                  onPressed: () {
                    cartProvider.addToWishlist(product);
                  },
                  child: const Text("Add to Wishlist"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
