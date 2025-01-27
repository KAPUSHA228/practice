import 'package:flutter/material.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<String> list = [];
  final textController = TextEditingController();
  final indexController = TextEditingController();

  void toAdd() {
    if (textController.text.isNotEmpty) {
      setState(() {
        list.add(textController.text);
        textController.clear();
      });
    }
  }

  void toRemove() {
    int? index = int.tryParse(indexController.text);
    if (index != null && index >= 0 && index < list.length) {
      setState(() {
        list.removeAt(index);
        indexController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Invalid index"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('List Visualizer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(labelText: 'Enter element'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: toAdd, child: Text('Add')),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: indexController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter index to remove'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: toRemove, child: Text('Remove at index')),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('Index: $index, Value: ${list[index]}',
                                style: TextStyle(fontSize: 18))));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
