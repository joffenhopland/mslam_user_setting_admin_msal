import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mslam_user_setting_admin/services/auth_manager/auth_manager_interface.dart';
import 'package:mslam_user_setting_admin/services/auth_manager/auth_manager_web.dart';

Future<void> main() async {
  String? token = await AuthManager.instance?.getAccessToken();
  print('token: $token');


  if(token != null){
    runApp(const MyApp());
  } else {
    AuthManager.instance?.login().then((value) {
      runApp(const MyApp());
    }).onError((error, stackTrace)  {
      print(error.toString());
    });
  }
}

class MyApp extends StatefulWidget{
  const MyApp({Key? key}):super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  @override
  void initState(){
    super.initState();
    String? accessToken;
    AuthManager.instance?.getAccessToken().then((value) => accessToken = value);


    print('accessToken instance: ${AuthManager.instance}');
    print('accessToken: $accessToken');
  }
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: 'mWorkAdmin',
      theme: ThemeData(
          primarySwatch: Colors.blue
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('MSlamAdmin'),
        ),
        body: Center(
          child: ElevatedButton(
            child: Text('Log out'),
            onPressed: (){getManager().logout();}
            ),
          ),
        ),
      );
  }
}