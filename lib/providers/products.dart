import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product {
  String id;
  String title;
  String description;
  String imageUrl;
  double price;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavorite = false,
  });
}

class Products with ChangeNotifier {
  List<Product> _products = [];

  List<Product> getProducts() {
    return [..._products];
  }

  Future<void> fetchAndSetProducts() async {
    const url = '';
    try {
      final response = await http.get(url);
      final List<Product> loadedProducts = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((productId, product) {
        loadedProducts.add(
          Product(
            id: productId,
            title: product['title'],
            description: product['description'],
            imageUrl: product['imageUrl'],
            price: product['price'],
            isFavorite: product['isFavorite'],
          )
        );
      });
      _products = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
