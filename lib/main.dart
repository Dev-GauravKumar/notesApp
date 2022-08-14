import 'package:flutter/material.dart';
import 'package:notes/Pages/notes_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColorLight: Color.fromRGBO(255, 191, 0,1),
        primaryColorDark: Colors.blueGrey,
        canvasColor: Colors.grey,
        floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.blueGrey),
        scaffoldBackgroundColor: Color.fromRGBO(54, 69, 79, 1),
      ),
      debugShowCheckedModeBanner: false,
      home: NotesPage(),
    );
  }
}
