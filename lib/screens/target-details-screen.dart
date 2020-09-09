import 'dart:io';

import 'package:cupertino_superellipse/cupertino_superellipse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
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
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(
                dataBloc.target.title,
                // style: Theme
                //     .of(context)
                //     .textTheme
                //     .headline1
                //     .apply(
                //     fontSizeDelta: -8,
                //     color: Theme
                //         .of(context)
                //         .primaryColorDark
                //         .withAlpha(980)),
                //
              ),
              previousPageTitle: "targets",

              trailing: GestureDetector(
                onTap: () {
                  showAddingBottomSheet(context, dataBloc);
                },
                child: Icon(
                  SFSymbols.square_pencil,
                  color:  Platform.isIOS
                    ? CupertinoTheme.of(context).primaryColor
                      : Theme.of(context).primaryColorDark,
                  size: 22,
                ),
              ),
            ),
            child: buildBody(context,dataBloc),
          )
        : Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              title: Text(dataBloc.target.title),
              centerTitle: true,
              leading: InkWell(
                onTap: () =>
                    Navigator.canPop(context) ? Navigator.pop(context) : null,
                child: Icon(Icons.arrow_back_ios),
              ),
            ),
            body: buildBody(context,dataBloc),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  showAddingBottomSheet(context, dataBloc);
                },
                label: Text("✍️ Add new")),
          );
  }
  Widget buildBody(context,dataBloc){
   return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          Positioned(
            top: 150,
            left: 0.0,
            right: 0.0,
            child:  Container(
                height: MediaQuery.of(context).size.height-150,
                width: MediaQuery.of(context).size.width - 48,
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                child: StreamBuilder<Object>(
                    stream: dataBloc.onTargetUpd,
                    builder: (context, snapshot) {
                      if (dataBloc.target.steps.length > 0) {
                        return  Material(
                          color: Colors.transparent,
                          child: ListView.builder(
                            padding: EdgeInsets.only(top:35),
                            itemCount: dataBloc.target.steps.length,
                            itemBuilder: (context, index) {
                              return buildStepCell(
                                  dataBloc, index, context);
                            },
                          ),

                        );
                      } else {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "No steps found 😕",
                                style: !Platform.isIOS
                                    ? Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .apply(
                                    color: Theme.of(context)
                                        .primaryColorDark)
                                    : null,
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              CupertinoButton.filled(
                                  child: Text("Add new step",style: TextStyle(color:Platform.isIOS ? CupertinoTheme.of(context).primaryContrastingColor  : Theme.of(context).primaryColorDark),),
                                  onPressed: () =>
                                      showAddingBottomSheet(
                                          context, dataBloc))
                            ],
                          ),
                        );
                      }
                    })),
          ),


          Positioned(
            top: 15.0,
            left: 15.0,
            right: 15.0,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
                color: Platform.isIOS
                    ? CupertinoTheme.of(context).barBackgroundColor
                    : Theme.of(context).primaryColor,
              ),
              height: 150,
              child: StreamBuilder<Object>(
                  stream: dataBloc.onTargetUpd,
                  builder: (context, snapshot) {
                    return ProgressWidget(
                        completed: dataBloc.target.completed,
                        total: dataBloc.target.total);
                  }),
            ),
          ),

        ],
      ),
    );
  }
  showAddingBottomSheet(BuildContext context, TargetBloc _targetBloc) {
    final _taskList = Provider.of<TasksBloc>(context, listen: false);

    ValueNotifier<String> newName = ValueNotifier("");
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      showCupertinoDialog<String>(
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
              ValueListenableBuilder(
                  valueListenable: newName,
                  builder: (BuildContext context, value, Widget child) {
                    return new CupertinoDialogAction(
                        child: const Text('Add'),
                        onPressed: newName.value.length > 0
                            ? () {
                                _targetBloc.addTask(new TargetStep(
                                    id: _targetBloc.target.steps.length + 1,
                                    title: newName.value));
                                _taskList.updateTask(_targetBloc.target);
                                Navigator.pop(context);
                              }
                            : null);
                  })
            ],
            content: Column(
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                CupertinoTextField(
                  style: TextStyle(fontSize: 15),
                  onChanged: (newValue) => newName.value = newValue,
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
                      onChanged: (val) => newName.value = val,
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
                    child: const Text('ADD'),
                    onPressed: () {
                      _targetBloc.addTask(new TargetStep(
                          id: _targetBloc.target.steps.length + 1,
                          title: newName.value));
                      Navigator.pop(context);
                    })
              ],
            );
          });
    }
  }

  buildStepCell(TargetBloc targetBloc, int index, BuildContext context) {
    final data = targetBloc.target.steps[index];

    return Container(

        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Platform.isIOS ?CupertinoTheme.of(context).primaryColor: Theme.of(context).primaryColorDark,
          borderRadius:   BorderRadius.circular(15),
          boxShadow: [

            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child:  ClipRRect(
          borderRadius: BorderRadius.circular(15),

          child:   Container(

            color: Platform.isIOS ?CupertinoTheme.of(context).primaryContrastingColor: Theme.of(context).primaryColor,
            child: Dismissible(
              key: Key(index.toString()),
              onDismissed: (_) {
                final _taskList = Provider.of<TasksBloc>(context, listen: false);

                targetBloc.removeAt(index);
                _taskList.updateTask(targetBloc.target);
              },
              direction: DismissDirection.endToStart,
              background: Container(
                height: 20,
                color: Theme.of(context).errorColor,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Spacer(),
                    Icon(SFSymbols.trash,color:  Platform.isIOS
                        ? CupertinoTheme.of(context).primaryColor
                      : Theme.of(context).primaryColorDark,),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              ),
              child: Container(
                margin: EdgeInsets.all(15),
                child: GestureDetector(
                  onTap: () {
                    final _taskList = Provider.of<TasksBloc>(context, listen: false);

                    targetBloc.toggleCompletedState(index);
                    _taskList.updateTask(targetBloc.target);
                  },
                  child:Row(
                      children: [ Container(
                      width: MediaQuery.of(context).size.width * .65,
                      child:
                          Text(
                            data.title.length > 25 ? data.title.substring(0,40) : data.title,
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: "SF-Rounded",
                                  fontWeight: FontWeight.w500,
                                  color:Platform.isIOS
                                  ? CupertinoTheme.of(context).primaryColor
                                  : Theme.of(context).primaryColorDark,
                                  decoration: data.isCompleted ?  TextDecoration.lineThrough
                                      : null),

                          ), ),
                          data.isCompleted ? Icon(Icons.check,color:   Platform.isIOS
                              ? CupertinoTheme.of(context).primaryColor
                              : Theme.of(context).primaryColorDark,) : Container(),
                        ],

                    ),
                ),
              ),

              ),
          ),

      ),
    );
  }
}

class ProgressWidget extends StatelessWidget {
  ProgressWidget({this.completed, this.total});

  final int completed;
  final int total;


  @override
  Widget build(BuildContext context) {
    return  Container(

        margin: EdgeInsets.all(30),
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Your progress:",
                  style: !Platform.isIOS
                      ? Theme.of(context)
                          .textTheme
                          .headline4
                          .apply(fontSizeDelta: -5,color: Theme.of(context).primaryColorDark)
                      : null,
                ),
                Text(
                  "$completed / $total",
                  style: !Platform.isIOS
                      ? Theme.of(context)
                          .textTheme
                          .headline4
                          .apply(fontSizeDelta: -5,color: Theme.of(context).primaryColorDark)
                      : null,
                ),
              ],
            ),

            LinearProgressIndicator(
              backgroundColor: Platform.isIOS
                  ? CupertinoTheme.of(context).primaryColor.withAlpha(800)
                  : Theme.of(context).primaryColor,
              valueColor: new AlwaysStoppedAnimation<Color>(Platform.isIOS
                  ? CupertinoTheme.of(context).primaryColor
                  : Theme.of(context).primaryColorDark),
              value: completed != 0 && total != 0 ? completed / total : 0,
            ),
          ],
        ),

    );
  }
}
