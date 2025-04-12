class AddTask {
  int? id;
  String? title;
  String? note;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;
  AddTask({
    this.id,
    this.title,
    this.note,
    this.isCompleted,
    this.date,
    this.color,
    this.startTime,
    this.endTime,
    this.remind,
    this.repeat,
  });
  AddTask.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    note = json['note'];
    isCompleted = json['isCompleted'];
    date = json['date'];
    color = json['color'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    remind = json['remind'];
    repeat = json['repeat'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['note'] = note;
    data['date'] = date;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['remind'] = remind;
    data['repeat'] = repeat;
    data['color'] = color;
    data['isCompleted'] = isCompleted;
    return data;
  }
}
