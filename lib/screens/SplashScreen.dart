import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:what_am_i_doing_to/bloc/tasksList.dart';


import 'home-screen.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = "/splash";
  @override
  Widget build(BuildContext context) {
    // final _taskList = Provider.of<TasksBloc>(context, listen: true);
    // _taskList.loadFromDB().then((_) {print(_taskList.tasks);print("splash"); Navigator.pushReplacementNamed(context,"/");});
    Future.delayed(const Duration(milliseconds: 1500), () {
    Navigator.pushReplacementNamed(context,"/");
    });
    return Scaffold(
      body: Center(
          child: Theme
              .of(context)
              .platform == TargetPlatform.iOS ?
          CupertinoActivityIndicator() : CircularProgressIndicator()
      ),
    );
  }
}
