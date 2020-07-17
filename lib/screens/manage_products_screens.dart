import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/product_list_item.dart';
import './edit_product_screen.dart';

class ManageProductsScreen extends StatelessWidget {
  static const routeName = '/manage-products';

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).getProducts();
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
          ),
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
