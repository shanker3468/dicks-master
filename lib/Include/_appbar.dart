// ignore_for_file: must_be_immutable

import 'package:dicks/_loginPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppBar extends StatefulWidget {
   MyAppBar( {Key? key,required this.screenName}) : super(key: key);
   var screenName='';

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height/12,
        width: width,
        decoration: const BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: Row(
          children: [
            IconButton(
                onPressed: (){
              Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back,color: Colors.white,),
            ),
            Container(
              width: width/1.5,
              alignment: Alignment.center,
              child: Text(widget.screenName,style: TextStyle(color: Colors.white,fontSize: height/40,fontWeight: FontWeight.w700),),
            ),
            IconButton(
              onPressed: () async {
                //Navigator.pop(context);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('DocEntry', "");
                prefs.setString('Name', "");
                prefs.setString('MobileNo', "");
                prefs.setString('EmailID', "");
                prefs.setString('UserRole', "");
                prefs.setString('Password', "");
                prefs.setString('MobileNo', "");
                prefs.setString("LogSattus", "LoginOut");

                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (BuildContext context)=>
                        const LoginPage(),
                  ),
                  );

                });

              },
              icon: const Icon(Icons.exit_to_app,color: Colors.white,),
            ),
          ],
        ),
      ),
    );
  }
}

