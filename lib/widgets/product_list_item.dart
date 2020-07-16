import 'package:flutter/material.dart';
import 'package:flutter_firebase_playground/providers/products.dart';

class ProductListItem extends StatelessWidget {
  final Product product;

  ProductListItem(this.product);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      subtitle: Text(product.description),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(icon: Icon(Icons.edit), onPressed: () {}),
          IconButton(icon: Icon(Icons.delete), onPressed: () {}),
        ],
      ),
    );
  }
}
