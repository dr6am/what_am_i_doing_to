import 'package:rxdart/subjects.dart';
import 'package:what_am_i_doing_to/db/db_client.dart';
import '../models/TaskModel.dart';

class TasksBloc {
  List<TaskModel> _tasks;

  List<TaskModel> get tasks => _tasks;

  TasksBloc(this._tasks)
      : this.onListUpd = BehaviorSubject<List<TaskModel>>.seeded(_tasks);

  final BehaviorSubject<List<TaskModel>> onListUpd;

  Future addTask(TaskModel newTask) async {
    print("add");
    await DB.query().then((value) => newTask.id = value.length);
    await DB.insert(newTask);
    List<TaskModel> res = _tasks != null ? _tasks : List<TaskModel>();
    res.add(newTask);
    updateList();
    onListUpd.add(res);
  }

  Future updateTask(TaskModel newTask) async {
    print("update");
    print(newTask);
    await DB.update(newTask);
    List<TaskModel> res = _tasks;
    this.loadFromDB();
    onListUpd.add(res);
  }

  Future updateList() async {
    loadFromDB();
  }

  Future removeAt(item) async {
    print("remove");
    print(item);
    await DB.delete(item);
    _tasks = [];
    List<Map<String, dynamic>> _results = await DB.query();

    List<TaskModel> res = _results.map((item) {
      print(item);
      return TaskModel.fromJson(item);
    }).toList();

    onListUpd.add(res);
  }

  Future loadFromDB() async {
    print("loading");
    _tasks = [];
    List<Map<String, dynamic>> _results = await DB.query();

    List<TaskModel> res = _results.map((item) {
      print(item);
      return TaskModel.fromJson(item);
    }).toList();
    print(res);
    onListUpd.add(res);
  }
}
