import 'package:get/get.dart';
import 'package:myreminder/db/db_helper.dart';
import 'package:myreminder/model/addtask.dart';

class TaskController extends GetxController{
  @override
  void onReady(){
    super.onReady();
  }
  Future<int> addTask({AddTask? addTask })async{
    print("insert function called");
    return await DBHelper.insert(addTask);
  }
}