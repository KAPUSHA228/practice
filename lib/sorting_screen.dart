import 'package:flutter/material.dart';
import 'dart:math';

class SortingScreen extends StatefulWidget {
  @override
  _SortingScreenState createState() => _SortingScreenState();
}

class _SortingScreenState extends State<SortingScreen> {
  List<int> _originalList = [];
  List<int> _listInProgress = [];
  String _selectedAlgorithm = 'Bubble Sort';
  final _textController = TextEditingController();
  bool _useRandom = false;
  int _minRandom = 0;
  int _maxRandom = 100;
  double _randomCount = 10;
  final random = Random();
  DateTime? _startTime;
  DateTime? _endTime;
  String get elapsedTime {
    if (_startTime == null || _endTime == null) {
      return "0 ms";
    }
    return (_endTime!.difference(_startTime!).inMicroseconds / 1000)
            .toStringAsFixed(2) +
        " ms";
  }
  void _startTimer() {
    _startTime = DateTime.now();
  }

  void _stopTimer() {
    _endTime = DateTime.now();
  }
  void _generateRandomList() {
    List<int> list = [];
    for (int i = 0; i < _randomCount; i++) {
      list.add(_minRandom + random.nextInt(_maxRandom - _minRandom));
    }
    setState(() {
      _originalList = list;
      _listInProgress = List.from(_originalList);
    });
  }

  void _generateList() {
    if (_useRandom) {
      _generateRandomList();
      return;
    }
    String input = _textController.text;
    List<int> list = [];
    if (input.isNotEmpty) {
      try {
        list = input.split(' ').map((e) => int.parse(e.trim())).toList();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Invalid input"),
        ));
        return;
      }
    }

    setState(() {
      _originalList = list;
      _listInProgress = List.from(_originalList);
    });
  }

  void _sort() async {
    _startTimer();
    setState(() {
      _listInProgress = List.from(_originalList);
    });
    switch (_selectedAlgorithm) {

      case 'Bubble Sort':
        await _bubbleSort();
        break;
      case 'Insertion Sort':
        await _insertionSort();
        break;
      case 'Merge Sort':
        await _mergeSortWrapper();
        break;
      case 'Quick Sort':
        await _quickSortWrapper();
        break;
      default:
        break;
    } _stopTimer();
  }

  Future<void> _bubbleSort() async {
    List<int> list = List.from(_listInProgress);
    int n = list.length;
    for (int i = 0; i < n - 1; i++) {
      for (int j = 0; j < n - i - 1; j++) {
        if (list[j] > list[j + 1]) {
          int temp = list[j];
          list[j] = list[j + 1];
          list[j + 1] = temp;

          setState(() {
            _listInProgress = List.from(list);
          });
          await Future.delayed(Duration(milliseconds: 20));
        }
      }
    }
      }

  Future<void> _insertionSort() async {
    List<int> list = List.from(_listInProgress);
    for (int i = 1; i < list.length; i++) {
      int key = list[i];
      int j = i - 1;
      while (j >= 0 && list[j] > key) {
        list[j + 1] = list[j];
        j = j - 1;
        setState(() {
          _listInProgress = List.from(list);
        });
        await Future.delayed(Duration(milliseconds: 20));
      }
      list[j + 1] = key;
      setState(() {
        _listInProgress = List.from(list);
      });
      await Future.delayed(Duration(milliseconds: 20));
    }
    
  }

  Future<void> _mergeSortWrapper() async {
    List<int> list = List.from(_listInProgress);
    await _mergeSort(list, 0, list.length - 1);
  }

  Future<void> _mergeSort(List<int> list, int left, int right) async {
    if (left < right) {
      int middle = left + (right - left) ~/ 2;
      await _mergeSort(list, left, middle);
      await _mergeSort(list, middle + 1, right);
      await _merge(list, left, middle, right);
    }
    
  }

  Future<void> _merge(List<int> list, int left, int middle, int right) async {
    int n1 = middle - left + 1;
    int n2 = right - middle;

    List<int> L = List.filled(n1, 0);
    List<int> R = List.filled(n2, 0);

    for (int i = 0; i < n1; i++) {
      L[i] = list[left + i];
    }
    for (int j = 0; j < n2; j++) {
      R[j] = list[middle + 1 + j];
    }
    int i = 0;
    int j = 0;
    int k = left;

    while (i < n1 && j < n2) {
      if (L[i] <= R[j]) {
        list[k] = L[i];
        i++;
      } else {
        list[k] = R[j];
        j++;
      }
      k++;
      setState(() {
        _listInProgress = List.from(list);
      });
      await Future.delayed(Duration(milliseconds: 20));
    }
    while (i < n1) {
      list[k] = L[i];
      i++;
      k++;
      setState(() {
        _listInProgress = List.from(list);
      });
      await Future.delayed(Duration(milliseconds: 20));
    }
    while (j < n2) {
      list[k] = R[j];
      j++;
      k++;
      setState(() {
        _listInProgress = List.from(list);
      });
      await Future.delayed(Duration(milliseconds: 20));
    }
  }

  Future<void> _quickSortWrapper() async {
    List<int> list = List.from(_listInProgress);
    await _quickSort(list, 0, list.length - 1);
    
  }

  Future<void> _quickSort(List<int> list, int low, int high) async {
    if (low < high) {
      int pi = await _partition(list, low, high);
      await _quickSort(list, low, pi - 1);
      await _quickSort(list, pi + 1, high);
    }
  }

  Future<int> _partition(List<int> list, int low, int high) async {
    int pivot = list[high];
    int i = (low - 1);

    for (int j = low; j < high; j++) {
      if (list[j] < pivot) {
        i++;
        int temp = list[i];
        list[i] = list[j];
        list[j] = temp;
        setState(() {
          _listInProgress = List.from(list);
        });
        await Future.delayed(Duration(milliseconds: 20));
      }
    }
    int temp = list[i + 1];
    list[i + 1] = list[high];
    list[high] = temp;
    setState(() {
      _listInProgress = List.from(list);
    });
    await Future.delayed(Duration(milliseconds: 20));
    return i + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sorting Algorithms')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Random Numbers', style: TextStyle(fontSize: 16)),
                Switch(
                    value: _useRandom,
                    onChanged: (value) {
                      setState(() {
                        _useRandom = value;
                      });
                    })
              ],
            ),
            if (_useRandom) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Min", style: TextStyle(fontSize: 16)),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        int? val = int.tryParse(value);
                        if (val != null) {
                          _minRandom = val;
                        }
                      },
                    ),
                  ),
                  Text("Max", style: TextStyle(fontSize: 16)),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        int? val = int.tryParse(value);
                        if (val != null) {
                          _maxRandom = val;
                        }
                      },
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Count: ", style: TextStyle(fontSize: 16)),
                  Expanded(
                      child: Slider(
                    value: _randomCount,
                    min: 1,
                    max: 100,
                    onChanged: (value) {
                      setState(() {
                        _randomCount = value;
                      });
                    },
                  ))
                ],
              ),
            ] else
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                    labelText: 'Enter numbers (probels separated)'),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: _generateList, child: Text('Generate List')),
              ],
            ),
            DropdownButton<String>(
              value: _selectedAlgorithm,
              items: <String>[
                'Bubble Sort',
                'Insertion Sort',
                'Merge Sort',
                'Quick Sort'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedAlgorithm = value;
                  });
                }
              },
            ),
            ElevatedButton(onPressed: _sort, child: Text('Sort')),
            SizedBox(height: 20),
            Text('Original List: ${_originalList.join(', ')}',
                style: TextStyle(fontSize: 18)),
            Text('List in progress: ${_listInProgress.join(', ')}',
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
