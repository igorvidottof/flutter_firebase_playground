import 'package:flutter/material.dart';
import 'package:flutter_firebase_playground/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _product = Product();
  var _isLoading = false;

  void _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return;
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Products>(context, listen: false).addProduct(_product);
    } catch (error) {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Something went wrong'),
              content: Text('Failed to save the product'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Ok'),
                ),
              ],
            );
          });
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add/Edit Product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
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
                    Text('Saving product...'),
                  ],
                ),
              ),
            )
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          initialValue: '',
                          decoration: InputDecoration(labelText: 'Title'),
                          autofocus: true,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_priceFocusNode),
                          validator: (value) {
                            if (value.isEmpty) return 'Please enter the title';
                            return null;
                          },
                          onSaved: (title) => _product.title = title,
                        ),
                        TextFormField(
                          initialValue: '',
                          decoration: InputDecoration(labelText: 'Price'),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _priceFocusNode,
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode),
                          validator: (value) {
                            if (value.isEmpty) return 'Please, enter a price';
                            if (double.tryParse(value) == null)
                              return 'Please, enter a valid number';
                            if (double.parse(value) <= 0)
                              return 'Please, enter a number greater than zero';
                            return null;
                          },
                          onSaved: (price) =>
                              _product.price = double.parse(price),
                        ),
                        TextFormField(
                          initialValue: '',
                          decoration: InputDecoration(labelText: 'Description'),
                          maxLines: 3,
                          textCapitalization: TextCapitalization.sentences,
                          focusNode: _descriptionFocusNode,
                          keyboardType: TextInputType.multiline,
                          validator: (value) {
                            if (value.isEmpty)
                              return 'Please enter a description';
                            if (value.length < 10)
                              return 'Description should be at least 10 characters long';
                            return null;
                          },
                          onSaved: (description) =>
                              _product.description = description,
                        ),
                        TextFormField(
                          initialValue: '',
                          decoration: InputDecoration(labelText: 'Image Url'),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          focusNode: _imageUrlFocusNode,
                          onFieldSubmitted: (_) => _saveForm(),
                          validator: (value) {
                            if (value.isEmpty) return 'Enter an image url';
                            if (!value.startsWith('http') &&
                                !value.startsWith('https'))
                              return 'Enter a valid url';
                            return null;
                          },
                          onSaved: (imageUrl) => _product.imageUrl = imageUrl,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
