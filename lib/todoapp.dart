import 'package:appwrite/appwrite.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'package:digitalclock/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'api/api.dart';
import 'screen.dart';

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

  int _currentPage = 0;
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomBar(
          selectedIndex: _currentPage,
          onTap: (int index) {
            _pageController.jumpToPage(index);
            setState(() => _currentPage = index);
          },
          items: <BottomBarItem>[
            BottomBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              activeColor: Colors.blue,
            ),
            BottomBarItem(
              icon: Icon(Icons.favorite),
              title: Text('Favorites'),
              activeColor: Colors.red,
            ),
            BottomBarItem(
              icon: Icon(Icons.person),
              title: Text('Account'),
              activeColor: Colors.greenAccent.shade700,
            ),
            BottomBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings'),
              activeColor: Colors.orange,
            ),
          ]),
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PageView(
          controller: _pageController,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Column(
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
                      _showPopup(context);
                    },
                    child: Text('Add Todo'),
                  ),
                ],
              ),
            ),
            HomePage(),
            SizedBox(height: 8.0),
          ],
          onPageChanged: (index) {
            // Use a better state management solution
            // setState is used for simplicity
            setState(() => _currentPage = index);
          },
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

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('CREATED SUCESSFULLY'),
          content: Text('start your list '),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
