import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:final_proj_frontend/pagetwo.dart';
import 'package:final_proj_frontend/myGroupPage.dart';
import 'package:final_proj_frontend/AboutPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,

      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MainState();
}

final TextEditingController _categoryNameController = TextEditingController();

class _MainState extends State<MyHomePage> {
  List<Map<String, dynamic>> _data = [];
  bool _isLoading = false;
  var url = "http://localhost:3000/api/category";

  // var url = "https://flutter-backend-v1kf.onrender.com/api/books";

  @override
  void initState() {
    super.initState();
    _getData();
  }

  // GET category
  Future<void> _getData() async {
    setState(() {
      _isLoading = true;
    });

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
        print('Failed to load categories: ${response.statusCode}');
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

  // ADD Category
  Future<void> _saveCategory(String categoryName) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'category_name': categoryName}),
      );

      if (response.statusCode == 200) {
        // need the await to fetch data and restart list

        await _getData();
      } else {
        print("Failed to save category: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred while saving: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // DELETE Category
  Future<void> _deleteCategory(int id) async {
    final response = await http.delete(
      Uri.parse(url),

      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },

      body: jsonEncode({'category_id': id}),
    );

    if (response.statusCode == 200) {
      // Remove the deleted item from the list and update the UI

      setState(() {
        _data.removeWhere((element) => element['category_id'] == id);
      });
      // await _getData();
    } else {
      // Handle server error

      print('Failed to delete category: ${response.statusCode}');
    }
  }

  // EDIT Category
  Future<void> _editCategory(int id) async {
    final response = await http.delete(
      Uri.parse(url),

      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },

      body: jsonEncode({'category_id': id}),
    );

    if (response.statusCode == 200) {
      // Remove the deleted item from the list and update the UI

      setState(() {
        _data.removeWhere((element) => element['category_id'] == id);
      });
      // await _getData();
    } else {
      // Handle server error

      print('Failed to delete category: ${response.statusCode}');
    }
  }

  // DELETE ALERT DIALOG
  Future<void> _showDeleteConfirmationDialog(int id) async {
    return showDialog<void>(
      context: context,

      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm Deletion',
            style: TextStyle(
              fontFamily: 'GochiHand',
              // fontWeight: FontWeight.bold,
            ),
          ),

          content: const Text('Are you sure you want to delete this category?'),

          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),

              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[200],
                iconColor: Colors.red[200],

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ), // Adjust the radius for desired roundness
                ),
              ),
              child: Text('Delete'),

              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog

                await _deleteCategory(id); // Perform the delete action
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
          title: Text(
            'Add New Category',
            style: TextStyle(
              fontFamily: 'GochiHand',
              // fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _categoryNameController,
                  decoration: InputDecoration(
                    labelText: 'Category Name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ), // Adjust the radius for desired roundness
                ),
              ),

              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.green[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ), // Adjust the radius for desired roundness
                ),
              ),
              onPressed: () async {
                String categoryName = _categoryNameController.text;

                if (categoryName == '') {
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
                  _categoryNameController.clear();
                  Navigator.of(context).pop();
                  _saveCategory(categoryName);
                }
              },
              child: Text('Add', style: TextStyle(fontWeight: FontWeight.w500)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 254, 186),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.yellow[300],
        foregroundColor: Colors.grey[900],
        elevation: 5.0,
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Text(
                'My Presyo App => Categories',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MyGroceryFont',
                  fontSize: 30,
                ),
              ),
            ),

            Icon(Icons.shopping_cart_outlined),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _data.isEmpty
          ? Center(
              child: Text(
                "No cateogories found.",
                style: TextStyle(
                  fontFamily: 'MyGroceryFont',
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.only(bottom: 80),
              itemCount: _data.length,
              itemBuilder: (context, index) {
                final category = _data[index];
                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 6,
                      ),
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Pagetwo();
                            },
                          ),
                        );

                        print('$category');
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setInt(
                          'category_id',
                          category['category_id'],
                        );
                      },
                      title: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.label_important_rounded,
                              size: 14,
                            ),
                          ),
                          Text(
                            category['category_name'],
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'GochiHand',
                              // fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Tooltip(
                            message: "Edit",
                            child: IconButton(
                              icon: Icon(
                                Icons.edit_square,
                                color: Colors.green[300],
                              ),
                              onPressed: () {
                                print('Edit $category');
                              },
                            ),
                          ),

                          Tooltip(
                            message: "Delete",
                            child: IconButton(
                              icon: Icon(
                                Icons.disabled_by_default_outlined,
                                color: Colors.red[300],
                              ),
                              onPressed: () async {
                                await _showDeleteConfirmationDialog(
                                  category['category_id'],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey[700], // thin line like notepad lines
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
      drawer: myDrawer(context),
    );
  }
}

Widget myDrawer(BuildContext context) {
  return Drawer(
    child: Column(
      children: [
        DrawerHeader(
          child:
              // Icon(Icons.edit_note, size: 100)
              Text('📝', style: TextStyle(fontSize: 100)),
        ),

        ListTile(
          leading: Icon(Icons.group),

          title: Text("Members"),

          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return MyGroupPage();
                },
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.info_outline),

          title: Text("About the App"),

          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AboutPage();
                },
              ),
            );
          },
        ),
      ],
    ),
  );
}
