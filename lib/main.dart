import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();
List todolist = [];

void main() {
  runApp(const MyApp.TodoApp());
}

class MyApp extends StatelessWidget {
  const MyApp.TodoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: TodoListPage(),
    );
  }
}

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  _readAll() async {
    Map<String, String> allValues = await storage.readAll();
    debugPrint(allValues.toString());
    List fromStorageAllList = [];
    allValues.forEach((key, value) {
      fromStorageAllList.add(value);
    });
    setState(() {
      todolist.addAll(fromStorageAllList);
    });
  }

  @override
  void initState() {
    _readAll();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _textEditingController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('タスク一覧'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: todolist.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(todolist[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          todolist.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Flexible(
                    child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'タスクを入力'
                        )
                    )
                ),
                TextButton(onPressed: () {
                  debugPrint(_textEditingController.text);
                  setState(() {
                    todolist.add(_textEditingController.text);
                  });
                  int currentValue = todolist.length +1;
                  storage.write(key: currentValue.toString(), value: _textEditingController.text);
                }, child: Text('追加'))
              ],
            ),
          )
        ],
      ),
      // TextButton(onPressed: (){}, child: Text('追加'))
    );
  }
}
