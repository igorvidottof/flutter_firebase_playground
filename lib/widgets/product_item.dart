import 'package:flutter/material.dart';
import 'package:flutter_firebase_playground/providers/products.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(product.imageUrl, fit: BoxFit.cover,),
      footer: GridTileBar(
        backgroundColor: Colors.black54,
        title: Text(product.title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(icon: Icon(Icons.favorite_border), onPressed: () {}),
            IconButton(icon: Icon(Icons.add_shopping_cart), onPressed: () {}),
          ],
        ),
      ),
      
    );
  }
}
