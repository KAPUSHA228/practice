import 'package:flutter/material.dart';

class StackScreen extends StatefulWidget {
  @override
  StackScreenState createState() => StackScreenState();
}

class StackScreenState extends State<StackScreen> {
  List<String> stack = [];
  final textController = TextEditingController();

  void push() {
    if (textController.text.isNotEmpty) {
      setState(() {
        stack.add(textController.text);
        textController.clear();
      });
    }
  }

  void pop() {
    if (stack.isNotEmpty) {
      setState(() {
        stack.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stack Visualizer')),
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
                ElevatedButton(onPressed: push, child: Text('Push')),
                ElevatedButton(onPressed: pop, child: Text('Pop')),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
                child: ListView.builder(
                    reverse: true,
                    itemCount: stack.length,
                    itemBuilder: (context, index) {
                      return Card(
                          child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(stack[index],
                                  style: TextStyle(fontSize: 18))));
                    })),
          ],
        ),
      ),
    );
  }
}
