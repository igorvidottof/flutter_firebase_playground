import 'package:flutter/material.dart';

import '../screens/products_screen.dart';
import '../screens/manage_products_screens.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: <Widget>[
        AppBar(
          title: Text('Pages'),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          onTap: () => Navigator.of(context).pushReplacementNamed(ProductsScreen.routeName),
          leading: Icon(Icons.shopping_basket),
          title: Text('Shop Products'),
        ),
        Divider(),
        ListTile(
          onTap: () => Navigator.of(context).pushReplacementNamed(ManageProductsScreen.routeName),
          leading: Icon(Icons.view_list),
          title: Text('Manage Products'),
        ),
        Divider(),
      ],),
    );
  }
}