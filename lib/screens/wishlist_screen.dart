import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopx_app/providers/wishlist_cart_provider.dart' show WishlistCartProvider;

class WishlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistCartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Wishlist")),
      body: ListView.builder(
        itemCount: wishlistProvider.wishlist.length,
        itemBuilder: (context, index) {
          final item = wishlistProvider.wishlist[index];

          return Card(
            child: ListTile(
              leading: Image.network(item['thumbnail'], width: 50),
              title: Text(item['title']),
              subtitle: Text("₹ ${item['price']}"),

              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  wishlistProvider.removeFromWishlist(item);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
