import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/product_grid_item.dart';
import '../widgets/app_drawer.dart';

class ProductsScreen extends StatefulWidget {
  static const routeName = '/products';

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  var _isInit = true;
  var _isLoading = false;

  void _showErrorMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Something went wrong'),
            content: Text('Failed to get data from the server'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Ok'),
              ),
            ],
          );
        });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts()
          .catchError((error) => _showErrorMessage())
          .then((_) => setState(() {
                _isLoading = false;
              }));
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).getProducts();
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Firebase Playground'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? SafeArea(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(height: 15),
                    Text('Loading products...'),
                  ],
                ),
              ),
            )
          : SafeArea(
              child: GridView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, i) {
                    return ProductGridItem(products[i]);
                  }),
            ),
    );
  }
}
