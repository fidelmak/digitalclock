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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('My Todos'),
      ),
      backgroundColor: Colors.black,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _todo.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_todo[index]['title'].toString()),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _deleteTodo(_todo[index]['id']);
                    },
                  ),
                );
              },
            ),
    );
  }
}
