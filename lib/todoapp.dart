import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List<String> todos = [];
  late final Databases database;

  TextEditingController todoController = TextEditingController();

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
              controller: todoController,
              decoration: InputDecoration(
                hintText: 'Enter a new todo...',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final taskName = todoController.text;
                addTodos(taskName);
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
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      todos[index],
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteTodo(index);
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

  Future<void> addTodos(String taskName) async {
    if (taskName.isNotEmpty) {
      // Create a new document in the Appwrite collection
      try {
        await database.createDocument(
          collectionId:
              '6578d806e281a763881f', // Replace with your Appwrite collection ID
          data: {'taskName': "todoTask"}, databaseId: '6578d7e968df3b6957ee',
          documentId: '6578d806e281a763881f',
        );
      } catch (e) {
        print('Error adding todo: $e');
        // Handle error, e.g., show a snackbar or display an error message
      }

      // After successfully adding the todo to the database, update the local state if needed
      setState(() {
        todos.add(taskName);
        todoController.clear();
      });
    }
  }

  Future<void> addTodo(String taskName) async {
    String newTodo = todoController.text.trim();

    if (newTodo.isNotEmpty) {
      setState(() {
        todos.add(newTodo);
        todoController.clear();
      });
    }
  }

  void deleteTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
  }
}
