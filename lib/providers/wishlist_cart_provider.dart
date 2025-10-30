import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WishlistCartProvider with ChangeNotifier {
  List cart = [];
  List wishlist = [];

  WishlistCartProvider() {
    loadData();
  }

  // Add to cart
  void addToCart(dynamic product) {
    cart.add(product);
    saveData();
    notifyListeners();
  }

  // Remove from cart (by object)
  void removeFromCart(dynamic product) {
    cart.remove(product);
    saveData();
    notifyListeners();
  }

  // Optionally remove by id (safer if objects differ)
  void removeFromCartById(dynamic id) {
    cart.removeWhere((p) => p['id'] == id);
    saveData();
    notifyListeners();
  }

  // Add to wishlist
  void addToWishlist(dynamic product) {
    wishlist.add(product);
    saveData();
    notifyListeners();
  }

  // Remove from wishlist (by object)
  void removeFromWishlist(dynamic product) {
    wishlist.remove(product);
    saveData();
    notifyListeners();
  }

  // Optionally remove wishlist by id
  void removeFromWishlistById(dynamic id) {
    wishlist.removeWhere((p) => p['id'] == id);
    saveData();
    notifyListeners();
  }

  // Persist data
  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("cart", jsonEncode(cart));
    await prefs.setString("wishlist", jsonEncode(wishlist));
  }

  // Load persisted data
  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cart = jsonDecode(prefs.getString("cart") ?? '[]');
    wishlist = jsonDecode(prefs.getString("wishlist") ?? '[]');
    notifyListeners();
  }
}
