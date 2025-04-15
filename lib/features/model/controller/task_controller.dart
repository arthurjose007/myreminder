import 'package:get/get.dart';
import 'package:myreminder/utils/widgets/db/db_helper.dart';
import 'package:myreminder/features/model/addtask.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    getTasks();

    super.onReady();
  }

  var taskList = <AddTask>[].obs;
  Future<int> addTask({AddTask? addTask}) async {
    print("insert function called");
    return await DBHelper.insert(addTask);
  }

//get all the data from table
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => AddTask.fromJson(data)).toList());
    print("update value called");
    update();
  }

  void delete(AddTask task) async {
    var result = DBHelper.delete(task);
    print(result);
  }
}
