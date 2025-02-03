import 'package:flutter/material.dart';
import 'dart:math';

class SortingScreen extends StatefulWidget {
  @override
  SortingScreenState createState() => SortingScreenState();
}

class SortingScreenState extends State<SortingScreen> {
  List<int> originalList = [];
  List<int> listInProgress = [];
  String selectedAlgorithm = 'Bubble Sort';
  final textController = TextEditingController();
  bool useRandom = false;
  int minRandom = 0;
  int maxRandom = 100;
  double randomCount = 10;
  final random = Random();
  DateTime? startTime;
  DateTime? endTime;
  String get elapsedTime {
    if (startTime == null || endTime == null) {
      return "0 ms";
    }
    return (endTime!.difference(startTime!).inMicroseconds / 1000)
            .toStringAsFixed(2) +
        " ms";
  }
  void startTimer() {
    startTime = DateTime.now();
  }

  void stopTimer() {
    endTime = DateTime.now();
  }
  void generateRandomList() {
    List<int> list = [];
    for (int i = 0; i < randomCount; i++) {
      list.add(minRandom + random.nextInt(maxRandom - minRandom));
    }
    setState(() {
      originalList = list;
      listInProgress = List.from(originalList);
    });
  }

  void generateList() {
    if (useRandom) {
      generateRandomList();
      return;
    }
    String input = textController.text;
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
      originalList = list;
      listInProgress = List.from(originalList);
    });
  }

  void _sort() async {
    startTimer();
    setState(() {
      listInProgress = List.from(originalList);
    });
    switch (selectedAlgorithm) {

      case 'Bubble Sort':
        await bubbleSort();
        break;
      case 'Insertion Sort':
        await insertionSort();
        break;
      case 'Merge Sort':
        await mergeSortWrapper();
        break;
      case 'Quick Sort':
        await quickSortWrapper();
        break;
      default:
        break;
    } stopTimer();
    setState(() {});
  }

  Future<void> bubbleSort() async {
    List<int> list = List.from(listInProgress);
    int n = list.length;
    for (int i = 0; i < n - 1; i++) {
      for (int j = 0; j < n - i - 1; j++) {
        if (list[j] > list[j + 1]) {
          int temp = list[j];
          list[j] = list[j + 1];
          list[j + 1] = temp;

          setState(() {
            listInProgress = List.from(list);
          });
          await Future.delayed(Duration(milliseconds: 20));
        }
      }
    }
      }

  Future<void> insertionSort() async {
    List<int> list = List.from(listInProgress);
    for (int i = 1; i < list.length; i++) {
      int key = list[i];
      int j = i - 1;
      while (j >= 0 && list[j] > key) {
        list[j + 1] = list[j];
        j = j - 1;
        setState(() {
          listInProgress = List.from(list);
        });
        await Future.delayed(Duration(milliseconds: 20));
      }
      list[j + 1] = key;
      setState(() {
        listInProgress = List.from(list);
      });
      await Future.delayed(Duration(milliseconds: 20));
    }
    
  }

  Future<void> mergeSortWrapper() async {
    List<int> list = List.from(listInProgress);
    await mergeSort(list, 0, list.length - 1);
  }

  Future<void> mergeSort(List<int> list, int left, int right) async {
    if (left < right) {
      int middle = left + (right - left) ~/ 2;
      await mergeSort(list, left, middle);
      await mergeSort(list, middle + 1, right);
      await merge(list, left, middle, right);
    }
    
  }

  Future<void> merge(List<int> list, int left, int middle, int right) async {
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
        listInProgress = List.from(list);
      });
      await Future.delayed(Duration(milliseconds: 20));
    }
    while (i < n1) {
      list[k] = L[i];
      i++;
      k++;
      setState(() {
        listInProgress = List.from(list);
      });
      await Future.delayed(Duration(milliseconds: 20));
    }
    while (j < n2) {
      list[k] = R[j];
      j++;
      k++;
      setState(() {
        listInProgress = List.from(list);
      });
      await Future.delayed(Duration(milliseconds: 20));
    }
  }

  Future<void> quickSortWrapper() async {
    List<int> list = List.from(listInProgress);
    await quickSort(list, 0, list.length - 1);
    
  }

  Future<void> quickSort(List<int> list, int low, int high) async {
    if (low < high) {
      int pi = await partition(list, low, high);
      await quickSort(list, low, pi - 1);
      await quickSort(list, pi + 1, high);
    }
  }

  Future<int> partition(List<int> list, int low, int high) async {
    int pivot = list[high];
    int i = (low - 1);

    for (int j = low; j < high; j++) {
      if (list[j] < pivot) {
        i++;
        int temp = list[i];
        list[i] = list[j];
        list[j] = temp;
        setState(() {
          listInProgress = List.from(list);
        });
        await Future.delayed(Duration(milliseconds: 20));
      }
    }
    int temp = list[i + 1];
    list[i + 1] = list[high];
    list[high] = temp;
    setState(() {
      listInProgress = List.from(list);
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
                    value: useRandom,
                    onChanged: (value) {
                      setState(() {
                        useRandom = value;
                      });
                    })
              ],
            ),
            if (useRandom) ...[
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
                          minRandom = val;
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
                          maxRandom = val;
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
                    value: randomCount,
                    min: 1,
                    max: 100,
                    onChanged: (value) {
                      setState(() {
                        randomCount = value;
                      });
                    },
                  ))
                ],
              ),
            ] else
              TextField(
                controller: textController,
                decoration: InputDecoration(
                    labelText: 'Enter numbers (probels separated)'),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: generateList, child: Text('Generate List')),
              ],
            ),
            DropdownButton<String>(
              value: selectedAlgorithm,
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
                    selectedAlgorithm = value;
                  });
                }
              },
            ),
            ElevatedButton(onPressed: _sort, child: Text('Sort')),
            SizedBox(height: 20),
            Text('Elapsed Time: $elapsedTime', style: TextStyle(fontSize: 18)),
            Text('Original List: ${originalList.join(', ')}',style: TextStyle(fontSize: 18)),
            Text('List in progress: ${listInProgress.join(', ')}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
