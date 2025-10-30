import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<WishlistCartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: ListView.builder(
        itemCount: cartProvider.cart.length,
        itemBuilder: (context, index) {
          final item = cartProvider.cart[index];

          return Card(
            child: ListTile(
              leading: Image.network(item['thumbnail'], width: 50),
              title: Text(item['title']),
              subtitle: Text("₹ ${item['price']}"),

              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  cartProvider.removeFromCart(item);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
