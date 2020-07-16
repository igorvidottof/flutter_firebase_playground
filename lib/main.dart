import 'package:flutter/material.dart';
import 'package:flutter_firebase_playground/providers/products.dart';
import 'package:flutter_firebase_playground/screens/manage_products_screens.dart';
import 'package:provider/provider.dart';

import './screens/products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Firebase Playground',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ProductsScreen(),
        routes: {
          ManageProductsScreen.routeName: (context) => ManageProductsScreen(),
          ProductsScreen.routeName: (context) => ProductsScreen(),
        },
      ),
    );
  }
}
