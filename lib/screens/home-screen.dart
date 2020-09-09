import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:what_am_i_doing_to/bloc/tasksList.dart';
import 'dart:io';

import 'package:what_am_i_doing_to/models/TaskModel.dart';
import 'package:what_am_i_doing_to/screens/target-details-screen.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/";
  HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _taskList = Provider.of<TasksBloc>(context, listen: true);
    print("homescreen");
    print(_taskList.tasks);

    _taskList.updateList();
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: CustomScrollView(
              slivers: [
                buildAppBar(context, () {
                  showAddingAlert(context);
                }),
                StreamBuilder(
                  stream: _taskList.onListUpd,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<TaskModel>> snapshot) {
                    Widget child;
                    if (snapshot.hasData) {
                      if (snapshot.data.length > 0) {
                        child = SliverFixedExtentList(
                          itemExtent: 80.0,
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              final item = snapshot.data[index];
                              return SizedBox(
                                  height: 75,
                                  child: StreamBuilder<Object>(
                                      stream: _taskList.onListUpd,
                                      builder: (context, snapshot) {
                                        return TaskCell(item: item);
                                      }));
                            },
                            childCount: snapshot.data.length,
                          ),
                        );
                      } else {
                        child = SliverFixedExtentList(
                            itemExtent: MediaQuery.of(context).size.height,
                            delegate: SliverChildListDelegate(
                              [
                                Center(
                                  child: Text(
                                    "No tagets found 😕",
                                    style: !Platform.isIOS
                                        ? Theme.of(context)
                                            .textTheme
                                            .headline4
                                            .apply(
                                                color: Theme.of(context)
                                                    .primaryColorDark)
                                        : null,
                                  ),
                                ),
                              ],
                            ));
                      }
                    } else if (snapshot.hasError) {
                      child = SliverFixedExtentList(
                          itemExtent: MediaQuery.of(context).size.height,
                          delegate: SliverChildListDelegate([
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 60,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Text('Error: ${snapshot.error}'),
                                  )
                                ])
                          ]));
                    } else {
                      child = SliverFixedExtentList(
                        itemExtent: MediaQuery.of(context).size.height,
                        delegate: SliverChildListDelegate(
                          [
                            Center(
                              child: Text(
                                "No tagets found 😕",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .apply(
                                        color:
                                            Theme.of(context).primaryColorDark),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return child;
                  },
                ),
              ],
            ),
          )
        : Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
            body: CustomScrollView(
              slivers: [
                buildAppBar(context, () {
                  _taskList.loadFromDB();
                }),
                StreamBuilder(
                  stream: _taskList.onListUpd,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<TaskModel>> snapshot) {
                    Widget child;
                    if (snapshot.hasData) {
                      if (snapshot.data.length > 0) {
                        child = SliverFixedExtentList(
                          itemExtent: 80.0,
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              final item = snapshot.data[index];
                              return SizedBox(
                                  height: 75,
                                  child: StreamBuilder<Object>(
                                      stream: _taskList.onListUpd,
                                      builder: (context, snapshot) {
                                        return TaskCell(item: item);
                                      }));
                            },
                            childCount: snapshot.data.length,
                          ),
                        );
                      } else {
                        child = SliverFixedExtentList(
                            itemExtent: MediaQuery.of(context).size.height,
                            delegate: SliverChildListDelegate(
                              [
                                Center(
                                  child: Text(
                                    "No tagets found 😕",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .apply(
                                            color: Theme.of(context)
                                                .primaryColorDark),
                                  ),
                                ),
                              ],
                            ));
                      }
                    } else if (snapshot.hasError) {
                      child = SliverFixedExtentList(
                          itemExtent: MediaQuery.of(context).size.height,
                          delegate: SliverChildListDelegate([
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 60,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Text('Error: ${snapshot.error}'),
                                  )
                                ])
                          ]));
                    } else {
                      child = SliverFixedExtentList(
                        itemExtent: MediaQuery.of(context).size.height,
                        delegate: SliverChildListDelegate(
                          [
                            Center(
                              child: Text(
                                "No tagets found 😕",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .apply(
                                        color:
                                            Theme.of(context).primaryColorDark),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return child;
                  },
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  showAddingAlert(context);
                },
                label: Text("✍️ Add new")),
          );
  }

  showAddingAlert(BuildContext context) {
    final _taskList = Provider.of<TasksBloc>(context, listen: false);

    ValueNotifier<String> newName = ValueNotifier("");
    if (Platform.isIOS) {
      print("cupertino");

      showCupertinoDialog<String>(
        context: context,

        builder: (context) {
          return CupertinoAlertDialog(
            insetAnimationCurve: Curves.easeInOut,

            title: Text(
              'Adding new target',
              style: TextStyle(fontFamily: "SF"),
            ),
            content: Column(
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                CupertinoTextField(
                  style: TextStyle(fontSize: 15),
                  onChanged: (value) {
                    newName.value = value;
                  },
                  placeholder: "Enter taget's name",
                )
              ],
            ),
            actions: <Widget>[
              new CupertinoDialogAction(
                  child: const Text('cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
          ValueListenableBuilder(
          valueListenable: newName,
          builder: (BuildContext context, value, Widget child)=>new CupertinoDialogAction(
              child: const Text('add'),
              onPressed: newName.value.length > 0
                  ? () {
                _taskList.addTask(new TaskModel(
                    id: _taskList.tasks != null
                        ? _taskList.tasks.length + 1
                        : 0,
                    title: newName.value));
                Navigator.pop(context);
              }
                  : null))

            ],
          );
        },
      );
    } else {
      print("material");
      showDialog<String>(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(16.0),
              content: new Row(
                children: <Widget>[
                  new Expanded(
                    child: Column(
                        mainAxisSize:MainAxisSize.min,
                      children: [
                        Text('Adding new target',style:Theme.of(context).textTheme.headline4.apply(fontSizeDelta: -5, color: Theme.of(context).primaryColorDark)),
                        new TextField(

                          autofocus: true,
                          onChanged: (val) => newName.value = val,
                          decoration: new InputDecoration(

                            //labelStyle:
                              hintStyle: TextStyle(
                                  color: Theme.of(context).hintColor),


                              hintText: 'Enter target\'s name'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              actions: <Widget>[
                new FlatButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                ValueListenableBuilder(
                    valueListenable: newName,
                    builder: (BuildContext context, value, Widget child) {
                      return new FlatButton(
                          child: const Text('Add'),
                          onPressed: newName.value.length > 0
                              ? () {
                                  _taskList.addTask(new TaskModel(
                                      id: _taskList.tasks.length + 1,
                                      title: newName.value));

                                  Navigator.pop(context);
                                }
                              : null);
                    })
              ],
            );
          });
    }
  }

  buildAppBar(context, onTap) => Platform.isIOS
      ? CupertinoSliverNavigationBar(
          largeTitle: Text(
            'Targets🎯',
            textAlign: TextAlign.left,
          ),
          // automaticallyImplyTitle: false,
          // automaticallyImplyLeading: true,

          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  showAddingAlert(context);
                },
                child: Icon(
                  SFSymbols.square_pencil,
                  color: Platform.isIOS
                      ? CupertinoTheme.of(context).primaryColor
                      : Theme.of(context).primaryColorDark,
                  size: 22,
                ),
              ),

              // CupertinoButton(
              //   onPressed: onTap,
              //   child: Icon(SFSymbols.ellipsis),
              // ),
            ],
          ),
        )
      : SliverAppBar(
          centerTitle: true,
          expandedHeight: 150.0,
          backgroundColor: Theme.of(context).backgroundColor,
          floating: true,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              'Targets🎯',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.headline1.apply(color: Theme.of(context).primaryColorDark),
            ),
          ),
          actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.create,
                  size: 20,
                ),
                onPressed: () =>
                  showAddingAlert(context)
                ,
              ),

            ]);
}

class TaskCell extends StatelessWidget {
  const TaskCell({
    Key key,
    @required this.item,
  }) : super(key: key);

  final TaskModel item;

  @override
  Widget build(BuildContext context) {
    final _taskList = Provider.of<TasksBloc>(context, listen: false);

    return Dismissible(
      key: Key(item.id.toString()),
      onDismissed: (_) {
        _taskList.removeAt(item);
      },
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        child: Row(
          children: [
            Spacer(),
            Icon(CupertinoIcons.delete),
            SizedBox(
              width: 15,
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .pushNamed(TargetDetailsScreen.routeName, arguments: item),
        child: Container(
          color: Platform.isIOS
              ? CupertinoTheme.of(context).scaffoldBackgroundColor
              : Theme.of(context).primaryColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 75,
                margin: EdgeInsets.only(bottom: 5),
                alignment: Alignment.center,

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    StreamBuilder<Object>(
                        stream: _taskList.onListUpd,
                        builder: (context, snapshot) {
                          return SizedBox(
                            width: 25,
                            child: item.isCompleted
                                ? Icon(SFSymbols.checkmark_alt,color: Platform.isIOS ?CupertinoTheme.of(context).primaryColor: Theme.of(context).primaryColorDark,)
                                : null,
                          );
                        }),
                    Spacer(),
                    Text(
                      item.title,
                      style: TextStyle(
                          fontFamily: "SF-Rounded",
                          fontWeight: FontWeight.w500,
                          color: Platform.isIOS ?CupertinoTheme.of(context).primaryColor: Theme.of(context).primaryColorDark,
                          fontSize: 20),
                    ),
                    Spacer(),
                    Text(
                      "${item.completed}/${item.steps.length}",
                      style: TextStyle(
                          fontFamily: "SF-Rounded",
                          fontWeight: FontWeight.w400,
                          color: Platform.isIOS ?CupertinoTheme.of(context).primaryColor: Theme.of(context).primaryColorDark,
                          fontSize: 20),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Icon(CupertinoIcons.forward),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                color:Colors.black
              ),
            ],
          ),
        ),
      ),
    );
  }
}
