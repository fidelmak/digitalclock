import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';

import 'api/api.dart';
import 'todoapp.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Map<String, dynamic>> _todo = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshTodo();
  }

  Future<void> _refreshTodo() async {
    final data = await SQLHELPER.getItems();
    setState(() {
      _todo = data;
      _isLoading = false;
    });
  }

  Future<void> _deleteTodo(int id) async {
    try {
      await SQLHELPER.deleteItem(id);
      _refreshTodo(); // Refresh the list after deletion
    } catch (err) {
      debugPrint("Error deleting todo: $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _todo.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(20.0),
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListTile(
                      title: Text(
                        _todo[index]['title'].toString(),
                        style: TextStyle(color: Colors.black, fontSize: 40),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.black,
                          size: 40,
                        ),
                        onPressed: () {
                          _deleteTodo(_todo[index]['id']);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
