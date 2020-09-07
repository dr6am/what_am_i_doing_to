import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_am_i_doing_to/bloc/targetBloc.dart';
import 'package:what_am_i_doing_to/bloc/tasksList.dart';
import 'package:what_am_i_doing_to/models/TaskModel.dart';

class TargetDetailsScreen extends StatelessWidget {

  static String routeName = "/home";

  @override
  Widget build(BuildContext context) {

    final TaskModel args = ModalRoute.of(context).settings.arguments;
    print(args);
    final dataBloc = TargetBloc(args);
    // final int indexTask = _taskList.tasks.indexOf(args);
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
        middle: Text(
          dataBloc.target.title,
          style: Theme
              .of(context)
              .textTheme
              .headline1
              .apply(
            fontSizeDelta: -8,
              color: Theme
                  .of(context)
                  .primaryColorDark
                  .withAlpha(980)),
        ),
        previousPageTitle: "targets",
      )
          : AppBar(
        title: Text(dataBloc.target.title),
        centerTitle: true,
        leading: InkWell(
          onTap: () =>
          Navigator.canPop(context) ? Navigator.pop(context) : null,
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        // bottom: false,
        child: Column(
          children: [
            StreamBuilder<Object>(
                stream: dataBloc.onTargetUpd,
                builder: (context, snapshot) {
                   return ProgressWidget(
                    //TODO colors
                      completed: dataBloc.target.completed,
                      total: dataBloc.target.total);
                }),
            Divider(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: StreamBuilder<Object>(
                    stream: dataBloc.onTargetUpd,
                    builder: (context, snapshot) {
                      if (dataBloc.target.steps.length > 0){
                        return ListView.separated(
                          itemCount: dataBloc.target.steps.length,
                          itemBuilder: (context, index) {
                            return buildStepCell(dataBloc, index,context);
                          },
                          separatorBuilder: (_, __) => Divider(),
                        );
                      }else{
                      return  Center(
                          child: Text(
                            "No steps found 😕",
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline4
                                .apply(color: Theme
                                .of(context)
                                .primaryColorDark),
                          ),
                        );
                      }

                    })

              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showAddingBottomSheet(context, dataBloc);
          },
          label: Text("✍️ Add new")),
    );
  }

  showAddingBottomSheet(BuildContext context,TargetBloc _targetBloc) {
    final _taskList = Provider.of<TasksBloc>(context, listen: false);

    String newName = "";
    if (Theme
        .of(context)
        .platform == TargetPlatform.iOS) {
      showDialog<String>(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Adding new step'),
            actions: <Widget>[
              new CupertinoDialogAction(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new CupertinoDialogAction(
                  child: const Text('Add'),
                  onPressed: () {
                    _targetBloc.addTask(new TargetStep(
                        id: _targetBloc.target.steps.length + 1,
                        title: newName));
                    _taskList.updateTask(_targetBloc.target);
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
                      onChanged: (val) => newName = val,
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
                      _targetBloc.addTask(new TargetStep(
                          id: _targetBloc.target.steps.length + 1,
                          title: newName));
                      Navigator.pop(context);
                    })
              ],
            );
          });
    }
  }

  buildStepCell(TargetBloc targetBloc, int index,BuildContext context) {
    final data = targetBloc.target.steps[index];
    return  ListTile(
          title: Text(data.title, style: data.isCompleted ? TextStyle(
              decoration: TextDecoration.lineThrough) : null,),
          trailing: data.isCompleted ? Icon(Icons.check) : null,
          onTap: () {
            final _taskList = Provider.of<TasksBloc>(context, listen: false);

            targetBloc.toggleCompletedState(index);
            _taskList.updateTask( targetBloc.target);

          },

    );
  }


}

class ProgressWidget extends StatelessWidget {
  ProgressWidget({this.completed, this.total});

  final int completed;
  final int total;

  ProgressWidget.fromQuick({this.total,this.completed});



  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.all(24),
      height: 75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your progress:",
                style: Theme
                    .of(context)
                    .textTheme
                    .headline4
                    .apply(
                    color: Theme
                        .of(context)
                        .primaryColorDark,
                    fontSizeDelta: -5),
              ),
              Text(
                "$completed / $total",
                style: Theme
                    .of(context)
                    .textTheme
                    .headline4
                    .apply(
                    color: Theme
                        .of(context)
                        .primaryColorDark,
                    fontSizeDelta: -5),
              ),
            ],
          ),
          LinearProgressIndicator(
            backgroundColor: Theme
                .of(context)
                .primaryColor,
            valueColor: new AlwaysStoppedAnimation<Color>(
                Theme
                    .of(context)
                    .primaryColorDark),
            value: completed != 0 && total != 0 ? completed / total : 0,
          ),
        ],
      ),
    );
  }
}
