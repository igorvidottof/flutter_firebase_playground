import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/error_dialog.dart';

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
  Product _product;
  var _isLoading = false;
  var _isInit = true;


  @override
  void didChangeDependencies() {
    if (_isInit) {
      final _originalProduct = ModalRoute.of(context).settings.arguments as Product;
      _product = _originalProduct == null ? Product() : _originalProduct.generateClone();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _showErrorMessage() async {
    await showDialog(
        context: context,
        builder: (context) {
          return ErrorDialog('Failed to save the product');
        });
  }

  void _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return;
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_product.id != null) {
      try {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_product);
      } catch (error) {
        await _showErrorMessage();
      }
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_product);
      } catch (error) {
        await _showErrorMessage();
      }
    }
    setState(() {
      // free from memory
      _product = null;
      _isLoading = false;
    });
    Navigator.of(context).pop();
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
                          initialValue:
                              _product?.title == null ? '' : _product.title,
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
                          initialValue: _product?.price == null
                              ? ''
                              : _product.price.toStringAsFixed(2),
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
                          initialValue: _product?.description == null
                              ? ''
                              : _product.description,
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
                          initialValue: _product?.imageUrl == null
                              ? ''
                              : _product.imageUrl,
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
