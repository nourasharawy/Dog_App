import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'noteApp/note-screen.dart';


main() {
  runApp(
      MyApp()
     /* MultiProvider(
          providers: [
            ChangeNotifierProvider<CourseProvider>(
              create: (ctx) => CourseProvider(),
            ),
          ],
          child: MyApp())*/
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:DogList(),
    );
  }
}
