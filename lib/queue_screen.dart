import 'package:flutter/material.dart';

class QueueScreen extends StatefulWidget {
  @override
  _QueueScreenState createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  List<String> queue = [];
  final textController = TextEditingController();

  void toAdd() {
    if (textController.text.isNotEmpty) {
      setState(() {
        queue.add(textController.text);
        textController.clear();
      });
    }
  }

  void toDelete() {
    if (queue.isNotEmpty) {
      setState(() {
        queue.removeAt(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Queue Visualizer')),
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
                ElevatedButton(onPressed: toDelete, child: Text('Delete')),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
                child: ListView.builder(
                    itemCount: queue.length,
                    itemBuilder: (context, index) {
                      return Card(
                          child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(queue[index],
                                  style: TextStyle(fontSize: 18))));
                    })),
          ],
        ),
      ),
    );
  }
}
