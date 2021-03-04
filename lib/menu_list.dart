import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<Menu> {
  List<String> todoItems = [];

  void addTodoItem() {
    setState(() {
      int index = todoItems.length;
      todoItems.add('Item ' + index.toString());
    });
  }

  Widget buildTodoList() {
    return new ListView.builder(
      // ignore: missing_return
      itemBuilder: (context, index) {
        if (index < todoItems.length) {
          return buildTodoItem(todoItems[index]);
        }
      },
    );
  }

  Widget buildTodoItem(String todoText) {
    return new ListTile(title: new Text(todoText));
  }

  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? Text('drawings')
            : TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: 'Search Here',
                    hintStyle: TextStyle(color: Colors.white)),
              ),
        centerTitle: true,
        actions: <Widget>[
          isSearching
              ? IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      this.isSearching = false;
                    });
                  })
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      this.isSearching = true;
                    });
                  })
        ],
      ),
      body: buildTodoList(),
      floatingActionButton: new FloatingActionButton(
          onPressed: addTodoItem,
          tooltip: 'Add task',
          child: new Icon(Icons.add)),
    );
  }
}
