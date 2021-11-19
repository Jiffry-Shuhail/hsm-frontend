import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyHome> {

  @override
  void initState() {
    super.initState();
    checkIfLogin();

  }

  bool isLoading=false;
  String status="Welcome to h Senid Mobile";
  String username="";

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: EdgeInsets.only(left: 35, top: 100),
              child: Text(
                'Hi $username',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5),
                child: isLoading ? Center(
                  child: CircularProgressIndicator(),) : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          Text(
                            status,
                            style: TextStyle(color: Colors.black, fontSize: 33),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            style: TextStyle(),
                            controller: statusController,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Status",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'My Status',
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        isLoading=true;
                                      });
                                      signIn(statusController.text);
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward,
                                    )),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () async{
                                  SharedPreferences sharedPreference=await SharedPreferences.getInstance();
                                  sharedPreference.clear();
                                  Navigator.pushNamed(context, 'login');
                                },
                                child: Text(
                                  'Sign out',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18),
                                ),
                                style: ButtonStyle(),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextEditingController statusController = new TextEditingController();

  signIn(String status) async{
    var jsonData = null;
    SharedPreferences sharedPreference=await SharedPreferences.getInstance();
    var param=sharedPreference.getString("id").toString()+"/"+status;
    print(sharedPreference.getString("token").toString());
    var response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/test/status/$param'),
        headers: {
          'Authorization':  'JiffryShuhail '+sharedPreference.getString("token").toString()
        });
    print(response.body);
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      setState(() {
        this.status = status;
      });
      sharedPreference.setString("status", status);
      statusController.clear();
    } else {
      final messengerState = ScaffoldMessenger.of(context);
      jsonData = json.decode(response.body);
      messengerState.showSnackBar(
        SnackBar(
          content: new Text(jsonData["error"]),
          action: SnackBarAction(
              label: 'UNDO', onPressed: messengerState.hideCurrentSnackBar),
        ),
      );
    }
  }

  checkIfLogin() async{
    SharedPreferences sharedPreference=await SharedPreferences.getInstance();
    if(sharedPreference.getString("status")!=null){
      setState(() {
        this.status = sharedPreference.getString("status").toString();
      });
    }
    if(sharedPreference.getString("username")!=null){
      setState(() {
        this.username = sharedPreference.getString("username").toString();
      });
    }
  }

}
