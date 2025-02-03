import 'package:flutter/material.dart';

class Node {
  int data;
  Node? left;
  Node? right;

  Node(this.data);
}
class TreeItem {
  final String value;
  final double offset;

  TreeItem(this.value, this.offset);
}
class BST {
  Node? root;

  void insert(int data) {
    root = insertRec(root, data);
  }

  Node? insertRec(Node? node, int data) {
    if (node == null) {
      return Node(data);
    }
    if (data < node.data) {
      node.left = insertRec(node.left, data);
    } else if (data > node.data) {
      node.right = insertRec(node.right, data);
    }
    return node;
  }
  void delete(int data) {
    root = deleteRec(root, data);
  }

  Node? deleteRec(Node? node, int data) {
    if (node == null) return node;

    if (data < node.data) {
      node.left = deleteRec(node.left, data);
    } else if (data > node.data) {
      node.right = deleteRec(node.right, data);
    } else {
      // Case 1: Leaf node or node with one child
      if (node.left == null) {
        return node.right;
      } else if (node.right == null) {
        return node.left;
      }
      // Case 2: Node with two children
      node.data = minValue(node.right!);
      node.right = deleteRec(node.right, node.data);
    }
    return node;
  }

  int minValue(Node node) {
    int minv = node.data;
    while (node.left != null) {
      minv = node.left!.data;
      node = node.left!;
    }
    return minv;
  }
  bool search(int data) {
    return searchRec(root, data);
  }

  bool searchRec(Node? node, int data) {
    if (node == null) return false;
    if (data == node.data) return true;
    if (data < node.data) return searchRec(node.left, data);
    return searchRec(node.right, data);
  }

  List<String> inorderTraversal() {
    List<String> list = [];
    inorderTraversalRec(root, list, 0);
    return list;
  }

  void inorderTraversalRec(Node? node, List<String> list, int level) {
    if (node != null) {
      inorderTraversalRec(node.left, list, level + 1);
      String indent = "  " * level;
      list.add("$indent${node.data}");
      inorderTraversalRec(node.right, list, level + 1);
    }
  }
   List<List<TreeItem>> buildTreeData() {
    List<List<TreeItem>> treeData = [];
    buildTreeDataRec(root, treeData, 0, 0);
    return treeData;
  }

  void buildTreeDataRec(
      Node? node, List<List<TreeItem>> treeData, int level, double x) {
    if (node == null) {
      return;
    }

    if (treeData.length <= level) {
      treeData.add([]);
    }
    const double delta = 30.0; // Constant смещения
    buildTreeDataRec(node.left, treeData, level + 1, x - delta);
    treeData[level].add(TreeItem("${node.data}", x));
    buildTreeDataRec(node.right, treeData, level + 1, x + delta);
  }
}

class BstScreen extends StatefulWidget {
  @override
  BstScreenState createState() => BstScreenState();
}

class BstScreenState extends State<BstScreen> {
  BST bst = BST();
  final textController = TextEditingController();
  final searchController = TextEditingController();
final deleteController = TextEditingController();

  void delete() {
    int? data = int.tryParse(deleteController.text);
    if (data == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Invalid input"),
      ));
      return;
    }
    setState(() {
      bst.delete(data);
      deleteController.clear();
    });
  }
  void insert() {
    int? data = int.tryParse(textController.text);
    if (data == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Invalid input"),
      ));
      return;
    }
    setState(() {
      bst.insert(data);
      textController.clear();
    });
  }

  void search() {
    int? data = int.tryParse(searchController.text);
    if (data == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Invalid input"),
      ));
      return;
    }
    bool found = bst.search(data);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(found ? "Found" : "Not found"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Binary Search Tree')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:     Column(
          children: [
            TextField(
              controller: textController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter element to insert'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: insert, child: Text('Insert')),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: searchController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter element to search'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: search, child: Text('Search')),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: deleteController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter element to delete'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: delete, child: Text('Delete')),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: bst
                    .buildTreeData()
                    .map((level) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: level
                            .map((item) => Transform.translate(
                                  offset: Offset(item.offset, 0),
                                  child: Container(
                                    margin: EdgeInsets.all(4),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(item.value,
                                        style: TextStyle(fontSize: 18)),
                                  ),
                                ))
                            .toList()))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
