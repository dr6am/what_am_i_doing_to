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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          buildAppBar(context,(){_taskList.loadFromDB();}),
          StreamBuilder(
            stream: _taskList.onListUpd,
            builder: (BuildContext context, AsyncSnapshot<List<TaskModel>> snapshot) {
              Widget child;
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  child = SliverFixedExtentList(
                    itemExtent: 75.0,
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        final item = snapshot.data[index];
                        return SizedBox(height: 75, child: StreamBuilder<Object>(
                          stream: _taskList.onListUpd,
                          builder: (context, snapshot) {
                            return TaskCell(
                                item: item);
                          }
                        ));
                      },
                      childCount: snapshot.data.length,
                    ),
                  );
                }
                else{
                  child = SliverFixedExtentList(
                      itemExtent: MediaQuery.of(context).size.height,
                      delegate: SliverChildListDelegate(
                        [
                          Center(
                            child: Text(
                              "No tagets found 😕",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline4
                                  .apply(color: Theme
                                  .of(context)
                                  .primaryColorDark),
                            ),
                          ),
                        ],
                      )
                  );
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
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline4
                              .apply(color: Theme
                              .of(context)
                              .primaryColorDark),
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
            showAddingBottomSheet(context);
          },
          label: Text("✍️ Add new")),
    );
  }

  showAddingBottomSheet(BuildContext context) {
    final _taskList = Provider.of<TasksBloc>(context, listen: false);
    String newName = "";
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      print("cupertino");

      showDialog<String>(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            insetAnimationCurve: Curves.easeInOut,

            title: Text('Adding new target',style: TextStyle(fontFamily: "SF"),),
            actions: <Widget>[
              new CupertinoDialogAction(
                  child: const Text('cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new CupertinoDialogAction(
                  child: const Text('add'),
                  onPressed: () {
                    _taskList.addTask(new TaskModel(
                        id: _taskList.tasks != null ? _taskList.tasks.length + 1 : 0, title: newName));
                    Navigator.pop(context);
                  })
            ],
            content: Column(
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                CupertinoTextField(
                  onChanged: (value) {
                    newName = value;
                  },
                  placeholder: "Enter taget's name",
                )
              ],
            ),
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
                    child: new TextField(
                      autofocus: true,
                      onChanged: (val)=>newName=val,
                      decoration: new InputDecoration(
                          labelText: 'Adding new target',
                          hintText: 'Enter target\'s name'),
                    ),
                  )
                ],
              ),
              actions: <Widget>[
                new FlatButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                new FlatButton(
                    child: const Text('OPEN'),
                    onPressed: () {
                      _taskList.addTask(new TaskModel(
                          id: _taskList.tasks.length + 1, title: newName));

                      Navigator.pop(context);
                    })
              ],
            );
          });
    }
  }

  buildAppBar(context,onTap) => Platform.isIOS
      ? CupertinoSliverNavigationBar(
          largeTitle: Text(
            'Targets🎯',
            textAlign: TextAlign.left,
          ),
          // automaticallyImplyTitle: false,
          // automaticallyImplyLeading: true,

          trailing:
              CupertinoButton(
                onPressed: onTap,
                child: Icon(Icons.refresh),
              ),

        )
      : SliverAppBar(
          expandedHeight: 150.0,
          floating: true,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              'Targets',
              textAlign: TextAlign.left,
            ),
          ),
          actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.create,
                  size: 20,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.more_horiz,
                  size: 20,
                ),
                onPressed: () {},
              ),
            ]);
}

class TaskCell extends StatelessWidget {
  const TaskCell({
    Key key,
    @required this.item,
  }) : super(key: key);

  final TaskModel  item;

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
          margin: EdgeInsets.only(bottom: 5)),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(TargetDetailsScreen.routeName,arguments: item),
        child: Container(
          height: 75,
          margin: EdgeInsets.only(bottom: 5),
          alignment: Alignment.center,
          color: Colors.white,
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
                    child: item.isCompleted ? Icon(Icons.check) : null,
                  );
                }
              ),
              Spacer(),
              Text(item.title),
              Spacer(),
              SizedBox(
                width: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
