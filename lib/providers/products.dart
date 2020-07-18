import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Product {
  String id;
  String title;
  String description;
  String imageUrl;
  double price;
  bool isFavorite;

  Product({
    this.id,
    this.title,
    this.description,
    this.imageUrl,
    this.price,
    this.isFavorite = false,
  });

  // copy an object without referencing it
  Product generateClone() {
    return Product(
      id: this.id,
      title: this.title,
      description: this.description,
      imageUrl: this.imageUrl,
      price: this.price,
      isFavorite: this.isFavorite,
    );
  }
}

class Products with ChangeNotifier {
  List<Product> _products = [];

  List<Product> getProducts() {
    return [..._products];
  }

  Product getProductById(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  Future<void> toggleFavoriteProduct(String id) async {
    final url = '';
    // optimistic updating
    var product = getProductById(id);
    final oldStatus = product.isFavorite;
    product.isFavorite = !product.isFavorite;
    notifyListeners();
    final response = await http.patch(
      url,
      body: json.encode({
        'isFavorite': product.isFavorite,
      }),
    );
    if (response.statusCode >= 400) {
      // revert the operation
      product.isFavorite = oldStatus;
      notifyListeners();
      throw HttpException(response.reasonPhrase);
    }
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
          ),
        );
      });
      _products = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    const url = '';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'isFavorite': product.isFavorite,
          'imageUrl': product.imageUrl,
        }),
      );
      _products.add(
        Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          price: product.price,
          description: product.description,
          isFavorite: product.isFavorite,
          imageUrl: product.imageUrl,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(Product updatedProduct) async {
    final url = '';
    final productIndex =
        _products.indexWhere((product) => product.id == updatedProduct.id);

    final response = await http.patch(
      url,
      body: json.encode({
        'title': updatedProduct.title,
        'price': updatedProduct.price,
        'description': updatedProduct.description,
        'imageUrl': updatedProduct.imageUrl,
      }),
    );
    if (response.statusCode >= 400) {
      throw HttpException(response.reasonPhrase);
    }
    // else isn't needed here because throw breaks the function
    _products[productIndex] = updatedProduct;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    // optimistic deleting
    final url = '';
    final productIndex = _products.indexWhere((product) => product.id == id);
    // points to a reference of the removed object
    var removedProduct = _products[productIndex];
    _products.removeAt(productIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _products.insert(productIndex, removedProduct);
      notifyListeners();
      throw HttpException(response.reasonPhrase);
    }
    // free from memory
    removedProduct = null;
  }
}
