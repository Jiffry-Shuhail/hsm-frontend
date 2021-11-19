import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loginuicolors/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

void main() {
  runApp(SplashScreen());
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashScreen> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    checkIfLogin();

  }

  checkIfLogin() async{
    SharedPreferences sharedPreference=await SharedPreferences.getInstance();
    if(sharedPreference.getString("token")!=null){
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHome()));
    }else{
      startTime();
    }
  }

  startTime() async {
    var duration = Duration(seconds: 4);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MyLogin()));
  }

  @override
  Widget build(BuildContext context) {
    return initWidget(context);
  }

  Widget initWidget(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/login.png'), fit: BoxFit.cover),),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: new Image.asset('assets/log.png')
          ),
        ],
      ),
    );
  }
}
