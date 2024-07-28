import 'package:flutter/material.dart';
import 'package:shop_listify/models/grocery_item.dart';
import 'package:shop_listify/data/categories.dart';

class EditItem extends StatefulWidget {
  final GroceryItem item;

  const EditItem({required this.item, super.key});

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late int _quantity;
  late String _category;

  @override
  void initState() {
    super.initState();
    _name = widget.item.name;
    _quantity = widget.item.quantity;
    _category = widget.item.category.title;
  }

  void _saveForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final editedItem = GroceryItem(
        id: widget.item.id,
        name: _name,
        quantity: _quantity,
        category: categories.entries
            .firstWhere((catItem) => catItem.value.title == _category)
            .value,
      );
      Navigator.of(context).pop(editedItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please provide a value.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                initialValue: _quantity.toString(),
                decoration: const InputDecoration(labelText: 'Quantity'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please provide a value.';
                  }
                  if (int.tryParse(value!) == null) {
                    return 'Please enter a valid number.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _quantity = int.parse(value!);
                },
              ),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: categories.entries
                    .map((catItem) => DropdownMenuItem(
                  value: catItem.value.title,
                  child: Text(catItem.value.title),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                  });
                },
                onSaved: (value) {
                  _category = value!;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
