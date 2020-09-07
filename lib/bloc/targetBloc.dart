import 'package:rxdart/subjects.dart';
import '../models/TaskModel.dart';

class TargetBloc {
  TaskModel _target;

  TaskModel get target => _target;

  TargetBloc(this._target)
      : this.onTargetUpd = BehaviorSubject<TaskModel>.seeded(_target);

  final BehaviorSubject<TaskModel> onTargetUpd;

  Future addTask(TargetStep newTask) async {
    var temp = _target;
    temp.steps.toList();
    temp.steps.add(newTask);
    print(temp.steps);
    onTargetUpd.add(temp);
  }

  Future removeAt(int index) async {
    TaskModel res = _target;
    res.steps.removeAt(index);
    onTargetUpd.add(res);
  }

  Future markAsComplete(int index) async {
    TaskModel res = _target;
    res.steps[index].isCompleted = true;
    onTargetUpd.add(_target);
  }



  //
  Future unMarkAsComplete(int index) async {
    TaskModel res = _target;
    res.steps[index].isCompleted = false;
    onTargetUpd.add(_target);
  }
  Future toggleCompletedState(int index) async {
    TaskModel res = _target;
    res.steps[index].isCompleted = !res.steps[index].isCompleted;
    onTargetUpd.add(_target);
  }

}
