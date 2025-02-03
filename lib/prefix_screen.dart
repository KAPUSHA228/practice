import 'package:flutter/material.dart';

class MyStack<T> {
  final List<T> _items = [];

  void push(T item) => _items.add(item);

  T pop() {
    if (_items.isEmpty) {
      throw Exception('Stack is empty');
    }
    return _items.removeLast();
  }

  T peek() {
    if (_items.isEmpty) {
      throw Exception('Stack is empty');
    }
    return _items.last;
  }

  bool get isEmpty => _items.isEmpty;
  int get size => _items.length;
}
class PrefixScreen extends StatefulWidget {
  @override
  PrefixScreenState createState() => PrefixScreenState();
}

class PrefixScreenState extends State<PrefixScreen> {
  final _expressionController = TextEditingController();
  String _postfixExpression = '';

  void convert() {
    String expression = _expressionController.text;
    try {
      _postfixExpression = infixToPostfix(expression);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid expression: $e")),
      );
      return;
    }
    setState(() {});
  }

  String infixToPostfix(String expression) {
    expression = expression.replaceAll(' ', '');
    List<String> outputQueue = [];
    MyStack<String> operatorStack =
        MyStack<String>(); // Используем StackLogic

    for (int i = 0; i < expression.length; i++) {
      String token = expression[i];
      if (isNumber(token)) {
        outputQueue.add(token);
      } else if (token == '(') {
        operatorStack.push(token);
      } else if (token == ')') {
        while (!operatorStack.isEmpty && operatorStack.peek() != '(') {
          outputQueue.add(operatorStack.pop());
        }
        if (!operatorStack.isEmpty) {
          operatorStack.pop(); // Remove open parentheses
        }
      } else if (isOperator(token)) {
        while (!operatorStack.isEmpty &&
            hasHigherPrecedence(operatorStack.peek(), token)) {
          outputQueue.add(operatorStack.pop());
        }
        operatorStack.push(token);
      } else {
        throw Exception("Invalid character: $token");
      }
    }

    while (!operatorStack.isEmpty) {
      if (operatorStack.peek() == '(') {
        throw Exception("Invalid expression");
      }
      outputQueue.add(operatorStack.pop());
    }

    return outputQueue.join(' ');
  }

  bool isNumber(String value) {
    try {
      double.parse(value);
    } catch (e) {
      return false;
    }
    return true;
  }

  bool isOperator(String value) {
    return value == '+' || value == '-' || value == '*' || value == '/';
  }

  bool hasHigherPrecedence(String op1, String op2) {
    if (op1 == '(') return false;
    if ((op1 == '*' || op1 == '/') && (op2 == '+' || op2 == '-')) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Postfix Notation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _expressionController,
              decoration: InputDecoration(
                  labelText: 'Enter an arithmetic expression (e.g., (1+2)*3)'),
            ),
            ElevatedButton(
                onPressed: convert, child: Text('Convert to Postfix')),
            SizedBox(height: 20),
            Text('Postfix Expression: $_postfixExpression',
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
