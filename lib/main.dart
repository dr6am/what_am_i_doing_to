import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_am_i_doing_to/bloc/tasksList.dart';
import 'package:what_am_i_doing_to/models/TaskModel.dart';
import 'package:what_am_i_doing_to/screens/SplashScreen.dart';

import 'package:what_am_i_doing_to/screens/home-screen.dart';
import 'package:what_am_i_doing_to/screens/target-details-screen.dart';

import 'db/db_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DB.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final mock = [
    TaskModel(
      id: 1,
      title: "123",
    ),
    TaskModel(
      id: 2,
      title: "123",
    ),
    TaskModel(
      id: 3,
      title: "123",
    ),
  ];
  // void _toggle(TodoItem item) async {
  //
  //   item.complete = !item.complete;
  //   dynamic result = await DB.update(TodoItem.table, item);
  //   print(result);
  //   refresh();
  // }
  //
  // void _delete(TodoItem item) async {
  //
  //   DB.delete(TodoItem.table, item);
  //   refresh();
  // }
  //
  // void _save() async {
  //
  //
  //   await DB.insert(TodoItem.table, item);
  //   setState(() => _task = '' );
  //   refresh();
  // }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TasksBloc>(create: (_) => TasksBloc([])),
      ],
      child: MaterialApp(
        title: 'Material App',
        theme: ThemeData(
            fontFamily: "SF",
            accentColor: Colors.grey[800],
            primaryColorDark: Colors.black,
            primaryColor: Colors.grey[200],
            textTheme: TextTheme(
              headline1: TextStyle(
                color: Color(0x31313100),
                fontFamily: "SF-Rounded",
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
              headline4: TextStyle(
                color: Color(0x31313100),
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            )),
        initialRoute: HomeScreen.routeName,
        routes: {
          SplashScreen.routeName: (context)=> SplashScreen(),
          HomeScreen.routeName: (context) => HomeScreen(),
          TargetDetailsScreen.routeName: (context) => TargetDetailsScreen(),
        },
      ),
    );
  }
}
