import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'custom_page_route.dart';
import 'dart:ui';
import 'result.dart';
import 'dart:async';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Trio<String, String, int>> widgets = [];

  _HistoryPageState() {
    _read();
  }

  void _delete(int id) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    helper.delete(id);
    for (var i in widgets)
      if (i.c == id) {
        widgets.remove(i);
        break;
      }
    setState(() {});
  }

  void _read({int id = -1}) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    var mapka = await helper.queryAllRows();
    if (id < 0) {
      widgets = [];
      setState(() {
        for (var row in mapka) {
          widgets.add(Trio(
              row[DatabaseHelper.columnName],
              row[DatabaseHelper.columnDate]
                  .substring(0, row[DatabaseHelper.columnDate].indexOf(' ')),
              row[DatabaseHelper.columnId]));
        }
      });
    } else {
      Navigator.of(context).push(CustomPageRoute(child: ResultPage(mapka[id])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Wpisy"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          SizedBox(height: 10),
          Column(
              children: widgets
                  .asMap()
                  .entries
                  .map((entry) => Column(children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              elevation: 0,
                            ),
                            onPressed: () {
                              _read(id: entry.key);
                            },
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    constraints: const BoxConstraints(
                                      minWidth: 100.0,
                                    ),
                                    child: Text(
                                      entry.value.a,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                          color: Theme.of(context)
                                                      .colorScheme
                                                      .brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                                  Text(
                                    entry.value.b,
                                    style: TextStyle(
                                        fontFeatures: [
                                          FontFeature.subscripts()
                                        ],
                                        fontSize: 20,
                                        color: Theme.of(context)
                                                    .colorScheme
                                                    .brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  ElevatedButton(
                                      child: Icon(Icons.delete),
                                      onPressed: () {
                                        _showMyDialog(entry.value.c);
                                      })
                                ])),
                        const SizedBox(height: 10),
                        Divider(
                            color: Color.fromRGBO(100, 100, 100, 1.0),
                            height: 1),
                      ]))
                  .toList())
        ])));
  }

  Future<void> _showMyDialog(int c) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Potwierdzenie'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Na pewno chcesz usunąć wpis?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Tak, usuń!'),
              onPressed: () {
                _delete(c);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Nie, zostaw!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
