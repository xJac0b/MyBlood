import 'package:flutter/material.dart';
import 'package:ft1/pages/custom_page_route.dart';
import 'package:ft1/pages/home.dart';
import 'package:ft1/pages/add.dart';
import 'package:ft1/pages/history.dart';
import '../theme_model.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, ThemeModel themeNotifier, child) {
        return Scaffold(
            appBar: AppBar(
              title: const Text("MyBlood"),
              centerTitle: true,
              actions: [
                IconButton(
                    icon: Icon(themeNotifier.isDark
                        ? Icons.nightlight_round
                        : Icons.wb_sunny),
                    onPressed: () {
                      themeNotifier.isDark
                          ? themeNotifier.isDark = false
                          : themeNotifier.isDark = true;
                    })
              ],
            ),
            body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(children: [
                    ElevatedButton(
                        onPressed: () => Navigator.of(context)
                            .push(CustomPageRoute(child: AddPage(dataa: {}))),
                        child: Text('Dodaj wpis'),
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromRGBO(190, 0, 0, 1),
                          minimumSize: const Size(300, 100),
                        )),
                    SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () => Navigator.of(context)
                            .push(CustomPageRoute(child: HistoryPage())),
                        child: Text("Historia wpisów"),
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromRGBO(190, 0, 0, 1),
                          minimumSize: const Size(300, 100),
                        )),
                    SizedBox(height: 20),
                  ])
                ]));
      },
    );
  }
}
