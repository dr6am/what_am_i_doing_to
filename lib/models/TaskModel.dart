import 'dart:convert';

class TaskModel {

  int id;
  String title;
  List<TargetStep> steps = List<TargetStep>() ;

  int get total => this.steps.length;
  int get completed =>
      this.steps.where((element) => element.isCompleted).length;
  bool get isCompleted {
    print(this.steps.where((element) => element.isCompleted).length ==
        steps.length);
    if (steps != null && steps.length > 0)
      return this.steps.where((element) => element.isCompleted).length ==
          steps.length;
    else
      return false;
  }

  double get progress {
    List<double> completedArray;
    this.steps.forEach((e) {
      completedArray.add(e.isCompleted ? 1 : 0);
    });
    return completedArray.reduce((a, b) => a + b) / completedArray.length;
  }

  TaskModel({
    this.id,
    this.title,
    this.steps,
  }) {
    if (steps == null) steps = List<TargetStep>();
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    List<TargetStep> temp_steps = List<TargetStep>();
     jsonDecode(json["steps_json"])
        .forEach((e) => temp_steps.add(new TargetStep.fromJson(jsonDecode(e))));
    return TaskModel(
        id: json["id"],
        title: json["title"].toString(),
        steps: temp_steps
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id.toInt(),
        "title": title.toString(),
        "steps_json":jsonEncode(<String>[
          ...steps.map((e) => jsonEncode(e.toJson())).toList()
        ]).toString()
      };

}

class TargetStep {
  int id;
  String title;
  bool isCompleted;

  TargetStep({
    this.id,
    this.title,
    this.isCompleted = false,
  });

  factory TargetStep.fromJson(Map<String, dynamic> json) {
    print(json);
    return new TargetStep(
        id: json["id"], title: json["title"], isCompleted: json["isCompleted"]);
  }

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "title": this.title,
        "isCompleted": this.isCompleted,
      };
}
