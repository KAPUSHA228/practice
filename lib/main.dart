import 'package:flutter/material.dart';
import 'stack_screen.dart';
import 'queue_screen.dart';
import 'list_screen.dart';
import 'bst_screen.dart';
import 'avl_screen.dart';
import 'sorting_screen.dart'; 
import 'prefix_screen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Structures App',
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    StackScreen(),
    QueueScreen(),
    ListScreen(),
    BstScreen(),
    AvlScreen(),
    SortingScreen(),
    PrefixScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Data Structures')),
      body: _screens[_selectedIndex],
      drawer: Drawer(
            child: ListView(children: <Widget>[
          ListTile(
            leading: Icon(Icons.layers),
            title: Text('Stack'),
            onTap: () => _onItemTapped(0),
          ),
          ListTile(
            leading: Icon(Icons.queue),
            title: Text('Queue'),
            onTap: () => _onItemTapped(1),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('List'),
            onTap: () => _onItemTapped(2),
          ),
          ListTile(
            leading: Icon(Icons.account_tree),
            title: Text('BST'),
            onTap: () => _onItemTapped(3),
          ),
          ListTile(
            leading: Icon(Icons.lan_outlined),
            title: Text('AVL'),
            onTap: () => _onItemTapped(4),
          ),
          ListTile(
            leading: Icon(Icons.queue),
            title: Text('Sorting'),
            onTap: () => _onItemTapped(5),
          ),
          ListTile(
            leading: Icon(Icons.queue),
            title: Text('Prefix'),
            onTap: () => _onItemTapped(6),
          ),
        ])));
  }
}
