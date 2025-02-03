import 'package:flutter/material.dart';

class Node {
  int data;
  Node? left;
  Node? right;
  int height;

  Node(this.data) : height = 1;
}

class TreeItem {
  final String value;
  final double offset;

  TreeItem(this.value, this.offset);
}

class AVLTree {
  Node? root;

  int height(Node? node) {
    if (node == null) return 0;
    return node.height;
  }

  int getBalance(Node? node) {
    if (node == null) return 0;
    return height(node.left) - height(node.right);
  }

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
    } else {
      return node;
    }

    node.height = 1 + max(height(node.left), height(node.right));
    int balance = getBalance(node);

    // Left Left Case
    if (balance > 1 && data < (node.left?.data ?? -1)) {
      return rotateRight(node);
    }
    // Right Right Case
    if (balance < -1 && data > (node.right?.data ?? -1)) {
      return rotateLeft(node);
    }
    // Left Right Case
    if (balance > 1 && data > (node.left?.data ?? -1)) {
      if (node.left != null) {
        node.left = rotateLeft(node.left!);
      }
      return rotateRight(node);
    }

    // Right Left Case
    if (balance < -1 && data < (node.right?.data ?? -1)) {
      if (node.right != null) {
        node.right = rotateRight(node.right!);
      }
      return rotateLeft(node);
    }
    if (balance < -1 && node.right == null) {
      return rotateLeft(node);
    }
    if (balance > 1 && node.left == null) {
      return rotateRight(node);
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
      if (node.left == null) {
        return node.right;
      } else if (node.right == null) {
        return node.left;
      }

      node.data = minValue(node.right!);
      node.right = deleteRec(node.right, node.data);
    }
    node.height = 1 + max(height(node.left), height(node.right));
    int balance = getBalance(node);
    // Left Left Case
    if (balance > 1 && getBalance(node.left) >= 0) {
      return rotateRight(node);
    }
    // Left Right Case
    if (balance > 1 && getBalance(node.left) < 0) {
      if (node.left != null) {
        node.left = rotateLeft(node.left!);
      }
      return rotateRight(node);
    }
    // Right Right Case
    if (balance < -1 && getBalance(node.right) <= 0) {
      return rotateLeft(node);
    }
    // Right Left Case
    if (balance < -1 && getBalance(node.right) > 0) {
      if (node.right != null) {
        node.right = rotateRight(node.right!);
      }
      return rotateLeft(node);
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

  Node rotateRight(Node node) {
    Node x = node.left!;
    Node? t2 = x.right;

    x.right = node;
    node.left = t2;

    node.height = max(height(node.left), height(node.right)) + 1;
    x.height = max(height(x.left), height(x.right)) + 1;
    return x;
  }

  Node rotateLeft(Node node) {
    Node y = node.right!;
    Node? t2 = y.left;

    y.left = node;
    node.right = t2;

    node.height = max(height(node.left), height(node.right)) + 1;
    y.height = max(height(y.left), height(y.right)) + 1;
    return y;
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

  int max(int a, int b) {
    return a > b ? a : b;
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
    const double delta = 30.0;
    buildTreeDataRec(node.left, treeData, level + 1, x - delta);
    treeData[level].add(TreeItem("${node.data}", x));
    buildTreeDataRec(node.right, treeData, level + 1, x + delta);
  }
}

class AvlScreen extends StatefulWidget {
  @override
  AvlScreenState createState() => AvlScreenState();
}

class AvlScreenState extends State<AvlScreen> {
  AVLTree avl = AVLTree();
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
      avl.delete(data);
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
      avl.insert(data);
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
    bool found = avl.search(data);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(found ? "Found" : "Not found"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AVL Tree')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                children: avl
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
