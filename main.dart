import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ft1/pages/home.dart';
import 'theme_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Map<int, Color> color = {
    50: Color.fromRGBO(190, 0, 0, .1),
    100: Color.fromRGBO(190, 0, 0, .2),
    200: Color.fromRGBO(190, 0, 0, .3),
    300: Color.fromRGBO(190, 0, 0, .4),
    400: Color.fromRGBO(190, 0, 0, .5),
    500: Color.fromRGBO(190, 0, 0, .6),
    600: Color.fromRGBO(190, 0, 0, .7),
    700: Color.fromRGBO(190, 0, 0, .8),
    800: Color.fromRGBO(190, 0, 0, .9),
    900: Color.fromRGBO(190, 0, 0, 1),
  };
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) {
        return MaterialApp(
          title: 'MyBlood',
          themeMode: themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData(
            primarySwatch: MaterialColor(0xFFBE0000, color),
            primaryColor: MaterialColor(0xFFBE0000, color),
            brightness: Brightness.dark,
          ),
          theme: ThemeData(
            primarySwatch: MaterialColor(0xFFBE0000, color),
            primaryColor: MaterialColor(0xFFBE0000, color),
            brightness: Brightness.light,
          ),
          debugShowCheckedModeBanner: false,
          home: Home(),
        );
      }),
    );
  }
}
