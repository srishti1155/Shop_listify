import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop_listify/data/categories.dart';
import 'package:shop_listify/models/grocery_item.dart';
import 'package:shop_listify/widgets/new_item.dart';
import 'package:shop_listify/widgets/edit_item.dart';

class GroceryList extends  StatefulWidget {
  const GroceryList({super.key});

 @override
  State<GroceryList> createState() => _GroceryListState();
 }

 class _GroceryListState extends State<GroceryList> {
   List<GroceryItem> _groceryItems = [];
   var _isLoading = true;
   String? _error ;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        'shop-listify-default-rtdb.firebaseio.com', 'shopping-list.json');

    try{
    final response = await http.get(url);
    if(response.statusCode >= 400) {
      throw ('Failed to fetch data. Please try again later.');
         }

    if(response.body == 'null') {
      setState(() {
        _isLoading =false;
      });
      return;
    }

   final Map<String,dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];

   for(final item in listData.entries) {
     final category = categories.entries.
     firstWhere((catItem) =>
     catItem.value.title == item.value['category']).value;
          loadedItems.add(GroceryItem(
              id: item.key,
              name: item.value['name'],
              quantity: item.value['quantity'],
              category: category,
          )
          );
   }

   setState(() {
     _groceryItems = loadedItems ;
     _isLoading = false;
   });
  } catch(error){
      setState(() {
        _error =error.toString();
        _isLoading = false;
      });
    }
    }

   void _editItem(GroceryItem item) async {
     final editedItem = await Navigator.of(context).push<GroceryItem>(
       MaterialPageRoute(builder: (ctx) => EditItem(item: item)),
     );

     if (editedItem == null) {
       return;
     }

     final url = Uri.https(
       'shop-listify-default-rtdb.firebaseio.com',
       'shopping-list/${item.id}.json',
     );

     final response = await http.patch(
       url,
       body: json.encode({
         'name': editedItem.name,
         'quantity': editedItem.quantity,
         'category': editedItem.category.title,
       }),
     );

     if (response.statusCode >= 400) {
       // Handle error
       return;
     }

     setState(() {
       final index = _groceryItems.indexWhere((element) => element.id == item.id);
       _groceryItems[index] = editedItem;
     });
   }



   void _addItem() async {
      final newItem = await Navigator.of(context).push<GroceryItem>(
       MaterialPageRoute(builder: (ctx) => const NewItem(),
       ),
     );

       if(newItem == null){
         return;
       }

       setState(() {
         _groceryItems.add(newItem);
       });
  }

    void _removeItem (GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
      setState(() {
        _groceryItems.remove(item) ;
      });
      final url = Uri.https(
          'shop-listify-default-rtdb.firebaseio.com',
          'shopping-list/${item.id}.json');
      final response = await http.delete(url);

         if(response.statusCode >= 400) {
           setState(() {
             _groceryItems.insert(index, item);
           });
         }
    }


   @override
   Widget build(BuildContext context) {
     Widget content = const Center(
       child:  Text('No items in the list') );

     if(_isLoading) {
       content = const Center(child: CircularProgressIndicator());
     } else if(_error!= null) {
       content = Center (child: Text(_error!) );
     } else if(_groceryItems.isNotEmpty) {
       content = ListView.builder(
           itemCount: _groceryItems.length,
           itemBuilder: (ctx, index) =>
               Dismissible(
                 onDismissed: (direction) {
                   _removeItem(_groceryItems[index]);
                 },

                 key: ValueKey(_groceryItems[index].id),
                   child: Card(
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(10),
                     ),
                     margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                 child: ListTile(
                   contentPadding: const EdgeInsets.all(8),
                   title: Text(_groceryItems[index].name,
                     style: const TextStyle(fontWeight: FontWeight.bold),
                   ),
                   leading: Text(
                     _groceryItems[index].category.emoji,
                     style: const TextStyle(fontSize: 24),
                   ),
                   trailing: Row(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                   Text(
                   _groceryItems[index].quantity.toString(),
                   style: const TextStyle(fontWeight: FontWeight.bold),
                 ),
                     IconButton(
                       icon: const Icon(Icons.edit_note),
                       onPressed: () => _editItem(_groceryItems[index]),

                   ),
                 ],
               )
               )
        )
               )
       );
     }

     return Scaffold(
       appBar: AppBar(
         title: const Text('Your Groceries'),
         actions: [
           IconButton(
               onPressed: _addItem,
               icon: const Icon(Icons.add))
         ],
       ),
       body: content,


     );
   }
 }
