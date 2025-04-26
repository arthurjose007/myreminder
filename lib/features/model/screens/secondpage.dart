import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myreminder/features/model/screens/home_screen.dart';

class SecondScreen extends StatelessWidget {
  final String payload;
  SecondScreen(this.payload,{super.key ,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed:(){
          Get.to(()=>HomeScreen());
        }, icon: Icon(Icons.arrow_back_ios_rounded)),
        backgroundColor: Get.isDarkMode?Colors.grey[600]:Colors.white,
      title: Text(this.payload.toString().split("|")[0]),)
      ,
      body: Center(child: Container(height: 400,width: 300,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Get.isDarkMode?Colors.white:Colors.grey[400],),
    child: Center(child: Text(this.payload.toString().split("|")[1],style: TextStyle(color: Colors.black,fontSize: 28),)),),




















    ));
  }
}
