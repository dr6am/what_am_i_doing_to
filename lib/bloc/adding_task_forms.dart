import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class AddingTaskForms {
  final _taskName = BehaviorSubject<String>();
  Stream<String> get taskName$ => _taskName.stream.transform(validateTaskName);
  Sink<String> get inTaskName => _taskName.sink;
//TODO
  static bool isTaskName(String taskName) => taskName.length > 1;

  final validateTaskName =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (isTaskName(value)) {
      sink.add(value);
    } else {
      sink.addError("Name is too short");
    }
  });

  dispose(){
    _taskName.close();
  }
}
