import 'package:flutter/material.dart';
import 'package:graphql_practice/models/product_model.dart';

class EditProductDialog extends StatefulWidget {
  final Product product;
  const EditProductDialog({super.key, required this.product});

  @override
  // ignore: library_private_types_in_public_api
  _EditProductDialogState createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  final _formKey = GlobalKey<FormState>();

  String title = '';
  double price = 0;
  String description = '';
  double categoryId = 1;
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Product'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: widget.product.title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  title = value ?? '';
                },
              ),
              TextFormField(
                initialValue: widget.product.price.toString(),
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value != null) {
                    price = double.parse(value);
                  }
                },
              ),
              TextFormField(
                initialValue: widget.product.description,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  description = value ?? '';
                },
              ),
              TextFormField(
                initialValue: widget.product.category.toString(),
                decoration: const InputDecoration(labelText: 'Category ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category ID';
                  }
                  return null;
                },
                onSaved: (value) {
                  categoryId = double.parse(value ?? '1');
                },
              ),
              TextFormField(
                initialValue: widget.product.images?[0],
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
                onSaved: (value) {
                  imageUrl = value ?? '';
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              // Save product logic here
              Navigator.of(context).pop({
                'title': title,
                'price': price,
                'description': description,
                'categoryId': categoryId,
                'images': [imageUrl],
              });
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
