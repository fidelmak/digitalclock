import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'api/api.dart';

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List<Map<String, dynamic>> _todo = [];
  bool _isLoading = true;

  void _refreshTodo() async {
    final data = await SQLHELPER.getItems();
    setState(() {
      _todo = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshTodo();
    print("no of ${_todo.length}");
  }

  final TextEditingController _title = TextEditingController();
  void _showForm(int? id) async {
    if (id != null) {
      final existingTodo = _todo.firstWhere((element) => element['id' == id]);
      _title.text = existingTodo['title'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              style: TextStyle(
                color: Colors.white,
              ),
              controller: _title,
              decoration: InputDecoration(
                hintText: 'Enter a new todo...',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final taskName = _title.text;
                addTodos();
              },
              child: Text('Add Todo'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Todo List:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: _todo.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _todo[index]['title'].toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        deleteTodo(index);
                        print("deleted");
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addTodos() async {
    try {
      await SQLHELPER.createItem(_title.text);
    } catch (e) {
      print('Error adding todo: $e');
    }

    setState(() {
      _title.clear();
    });
  }

  Future<void> deleteTodo(int id) async {
    try {
      final x = await SQLHELPER.deleteItem(id);
    } catch (e) {
      print('Error adding todo: $e');
    }

    setState(() {
      _todo.removeWhere((item) => item['id'] == id);
    });
  }
}
