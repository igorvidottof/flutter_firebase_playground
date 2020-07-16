import 'package:flutter/material.dart';
import 'package:flutter_firebase_playground/providers/products.dart';
import 'package:flutter_firebase_playground/widgets/app_drawer.dart';
import 'package:flutter_firebase_playground/widgets/product_list_item.dart';
import 'package:provider/provider.dart';

class ManageProductsScreen extends StatelessWidget {
  static const routeName = '/manage-products';

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).getProducts();
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: () {}),
        ],
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: products.length,
          itemBuilder: (context, i) {
            return Column(
              children: <Widget>[
                ProductListItem(products[i]),
                Divider(),
              ],
            );
          }),
    );
  }
}
