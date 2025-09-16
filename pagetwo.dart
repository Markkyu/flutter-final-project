import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Pagetwo extends StatefulWidget {
  const Pagetwo({Key? key}) : super(key: key);

  @override
  State<Pagetwo> createState() => _PagetwoState();
}

class _PagetwoState extends State<Pagetwo> {
  int? category_id; // make it nullable so we know when it's loaded
  List<Map<String, dynamic>> _data = [];
  bool _isLoading = false;

  final TextEditingController _productNameController =
      new TextEditingController();

  final TextEditingController _productPriceController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategoryIdAndData();
  }

  Future<void> _loadCategoryIdAndData() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt("category_id");

    // shared preference cant get the id immediately
    if (id != null) {
      setState(() {
        category_id = id;
      });

      await _getProducts(); // wait for the category id
    }
  }

  // GET PRODUCT
  Future<void> _getProducts() async {
    if (category_id == null) return;

    setState(() {
      _isLoading = true;
    });

    final String url =
        "http://localhost:3000/api/category/$category_id/products";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _data = List<Map<String, dynamic>>.from(data);
        });
      } else {
        print('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false;
        print(_data);
      });
    }
  }

  // ADD PRODUCT
  // Future<void> _addProduct(
  //   productName,
  //   productPrice,
  //   categoryId,
  // ) async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   final url = 'http://localhost:3000/api/category/$categoryId/products';

  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(<String, String>{
  //         'product_name': productName,
  //         'product_price', productPrice,
  //         'category_id', categoryId,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       // need the await to fetch data and restart list

  //       await _getProducts();
  //     } else {
  //       print("Failed to save category: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("Error occurred while saving: $e");
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  // DELETE PRODUCT
  Future<void> _deleteProduct(int id) async {
    // setState(() {
    //   _isLoading = true;
    // });

    final url = "http://localhost:3000/api/products";

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },

        body: jsonEncode({'product_id': id}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _data.removeWhere((element) => element['product_id'] == id);
        });
      } else {
        print('Failed to delete products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
    // finally {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }

  Future<void> _showDeleteConfirmationDialog(int id) async {
    return showDialog<void>(
      context: context,

      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Item Deletion'),

          content: const Text('Are you sure you want to delete this product?'),

          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),

              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),

            TextButton(
              child: const Text('Delete'),

              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                // print('Product deleted: $id');

                await _deleteProduct(id); // Perform the delete action
              },
            ),
          ],
        );
      },
    );
  }

  void _showFormPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Product Category'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _productNameController,
                  decoration: InputDecoration(
                    labelText: 'Category Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String productName = _productNameController.text;
                String productPrice = _productPriceController.text;

                if (productName == '' || productPrice == '') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Input form cannot be empty',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: Colors.yellow[300],
                    ),
                  );
                } else {
                  // clear text fields
                  _productNameController.clear();
                  Navigator.of(context).pop();
                  _saveProduct(productName);
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return // pagetwo.dart
    Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        255,
        254,
        186,
      ), // same as categories page
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.yellow[300], // same yellow app bar
        foregroundColor: Colors.grey[900],
        elevation: 5.0,
        title: Row(
          children: const [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Text(
                'My Presyo App => Products',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MyGroceryFont',
                  fontSize: 30,
                ),
              ),
            ),
            Icon(Icons.list_alt),
          ],
        ),
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _data.isEmpty
          ? const Center(
              child: Text(
                "No products found.",
                style: TextStyle(
                  fontFamily: 'MyGroceryFont',
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: _data.length,
              itemBuilder: (context, index) {
                final product = _data[index];
                final prodId = product['product_id'];
                final prodName = product['product_name'];
                final prodPrice = product['product_price'];

                return Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 6,
                      ),
                      onTap: () async {
                        // print('Tapped $prodName');
                        _showProduct(context, prodName);
                      },
                      title: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.circle, size: 12),
                          ),
                          Expanded(
                            child: Text(
                              prodName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontFamily:
                                    'GochiHand', // same handwritten font
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(
                          left: 22,
                        ), // align with name
                        child: Text(
                          "₱ $prodPrice",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Tooltip(
                            message: "Edit",
                            child: IconButton(
                              icon: Icon(
                                Icons.edit_square, // match main.dart
                                color: Colors.green[300],
                              ),
                              onPressed: () {
                                print('Edit $prodName');
                              },
                            ),
                          ),
                          Tooltip(
                            message: "Delete",
                            child: IconButton(
                              icon: Icon(
                                Icons
                                    .disabled_by_default_outlined, // match main.dart
                                color: Colors.red[300],
                              ),
                              onPressed: () async {
                                await _showDeleteConfirmationDialog(prodId);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey[700], // same notepad line
                      indent: 10,
                      endIndent: 10,
                    ),
                  ],
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[800],
        onPressed: () {
          _showFormPopup(context);
        },
        child: Icon(Icons.add, color: Colors.green[50], size: 30),
      ),
    );

    // return Scaffold(
    //   backgroundColor: Color.fromARGB(255, 224, 224, 224),
    //   appBar: AppBar(
    //     centerTitle: true,
    //     backgroundColor: Colors.blue[500],
    //     foregroundColor: Colors.white,
    //     title: const Text('My ₱resyo App > Products'),
    //   ),

    //   body: _isLoading
    //       ? Center(child: CircularProgressIndicator())
    //       : _data.isEmpty
    //       ? Center(child: Text("No product categories found."))
    //       : ListView.builder(
    //           padding: EdgeInsets.only(bottom: 80),
    //           itemCount: _data.length,
    //           itemBuilder: (context, index) {
    //             final product = _data[index];
    //             final prodId = product['product_id'];
    //             final prodName = product['product_name'];
    //             final prodPrice = product['product_price'];
    //             return Card(
    //               elevation: 4,
    //               margin: EdgeInsets.all(12),
    //               child: Padding(
    //                 padding: EdgeInsets.all(10.0),
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     ListTile(
    //                       onTap: () async {},
    //                       title: Text(
    //                         prodName,
    //                         style: TextStyle(
    //                           fontSize: 24,
    //                           fontWeight: FontWeight.bold,
    //                         ),
    //                       ),
    //                       subtitle: Text(
    //                         "₱ $prodPrice",
    //                         style: TextStyle(
    //                           fontSize: 20,
    //                           fontWeight: FontWeight.w600,
    //                         ),
    //                       ),
    //                       trailing: Row(
    //                         mainAxisSize: MainAxisSize.min,
    //                         children: [
    //                           IconButton(
    //                             icon: Icon(
    //                               Icons.edit,
    //                               color: Colors.green[400],
    //                             ),
    //                             onPressed: () {
    //                               print('Edit $prodName');
    //                             },
    //                           ),
    //                           IconButton(
    //                             icon: Icon(
    //                               Icons.delete,
    //                               color: Colors.red[400],
    //                             ),
    //                             onPressed: () async {
    //                               _showDeleteConfirmationDialog(prodId);
    //                             },
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             );
    //           },
    //         ),

    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () {
    //       _saveProduct("test");
    //     },
    //     child: Icon(Icons.add),
    //   ),
    // );
  }
}

void _saveProduct(productName) {
  print(productName);
}

Widget _showProduct(BuildContext context, productName) {
  // showDialog<void>(
  //   context: context,

  //   builder: (BuildContext context) {
  return AlertDialog(
    title: const Text('Confirm Deletion'),

    content: const Text('Are you sure you want to delete this category?'),

    actions: <Widget>[
      TextButton(
        child: const Text('Cancel'),

        onPressed: () {
          Navigator.of(context).pop(); // Close the dialog
        },
      ),

      TextButton(
        child: const Text('Delete'),

        onPressed: () async {
          Navigator.of(context).pop(); // Close the dialog
        },
      ),
    ],
  );
  //   },
  // );

  // return AlertDialog(
  //   title: Text('Add New Product Category'),
  //   content: SingleChildScrollView(
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: <Widget>[
  //         TextField(
  //           // controller: _categoryNameController,
  //           decoration: InputDecoration(
  //             labelText: 'Category Name',
  //             border: OutlineInputBorder(),
  //           ),
  //         ),
  //       ],
  //     ),
  //   ),
  //   actions: <Widget>[
  //     TextButton(
  //       onPressed: () {
  //         Navigator.of(context).pop();
  //       },
  //       child: Text('Cancel'),
  //     ),
  //   ],
  // );
}
