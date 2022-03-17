import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class SizeConfig {
  static getHeight(context) {
    return MediaQuery.of(context).size.height;
  }

  static getWidth(context) {
    return MediaQuery.of(context).size.width;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = false;
  late List data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  int deletedItem = 0;
  bool showUndo = false;

  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF403F3C),
            ),
          )
        : Scaffold(
            floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //The button which will allow us to undo a deletion.
                  showUndo
                      ? FloatingActionButton(
                          onPressed: () {
                            setState(() {
                              data.insert(deletedItem - 1, deletedItem);
                              showUndo = false;
                              deletedItem = 0;
                            });
                          },
                          backgroundColor: Colors.orange[400],
                          child: const Icon(Icons.undo),
                        )
                      : const SizedBox(width: 0, height: 0),
                  SizedBox(
                    width: width * 0.63,
                  ),
                  //The button which will be used to add a new item to the list.
                  FloatingActionButton(
                    backgroundColor: Colors.pink,
                    child: const Icon(Icons.add),
                    onPressed: () {
                      data.insert(data.length, data[data.length - 1] + 1);
                      setState(() {
                        showUndo = false;
                        deletedItem = 0;
                      });
                    },
                  )
                ]),
            body: SafeArea(
                child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: width * 0.08, vertical: 0.0),
              child: Container(
                width: width * 0.9,
                height: height * 0.078 * data.length,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(height / 50)),
                ),
                //The list of items.
                child: ListView.separated(
                  itemCount: data.length,
                  itemBuilder: (context, i) {
                    final item = data[i];
                    return Dismissible(
                      key: Key(data[i].toString()),
                      background: Container(
                          color: Colors.red, child: const Icon(Icons.delete)),
                      direction: DismissDirection.endToStart,
                      child: ListTile(
                        tileColor: Colors.white,
                        title: Text(item.toString()),
                      ),
                      //Make it asynchronous if the function that calls the backend database needs it.
                      onDismissed: (direction) {
                        setState(() {
                          isLoading = true;
                        });
                        if (deletedItem != 0) {
                          delete();
                        } else {}
                        setState(() {
                          deletedItem = data.removeAt(i);
                          showUndo = true;
                          isLoading = false;
                        });
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      thickness: 1,
                      indent: width * 0.03,
                      endIndent: width * 0.03,
                    );
                  },
                ),
              ),
            )),
          );
  }
}

//The function which will delete the item perma from the database
void delete() {}
