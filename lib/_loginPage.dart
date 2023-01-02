import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dicks/AppConstants.dart';
import 'package:dicks/Include/_loding.dart';
import 'package:dicks/Model/LoginModel.dart';
import 'package:dicks/_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool loading = false;
  late LoginModel loginModel ;


  final TextEditingController _edtUsername = TextEditingController(text: '');
  final TextEditingController _edtPassword = TextEditingController(text: '');



  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
          body:loading?
          const LodingPage()
          :SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Card(
                  elevation: 5,
                  child: Container(
                    height: height/4,
                    width: width,
                    margin: EdgeInsets.all(height/50),
                    child: SizedBox(
                        height: height/10,
                        width: width,
                        child: Image.asset("assets/logo.png")
                    ),

                  ),
                ),
                SizedBox(height: height/10,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: height/30),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.all(Radius.circular(height/10)),
                    child: TextField(
                      controller: _edtUsername,
                      //obscureText: _obscureText,
                      onChanged: (String value) {},
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "UserName",
                          prefixIcon: Material(
                            elevation: 0,
                            borderRadius: BorderRadius.all(Radius.circular(height/15)),
                            child: const Icon(
                              Icons.account_circle,
                              color: Colors.blue,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/50)),
                    ),
                  ),
                ),
                SizedBox(height: height/30,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: height/30),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.all(Radius.circular(height/10)),
                    child: TextField(
                      controller: _edtPassword,
                      //obscureText: _obscureText,
                      onChanged: (String value) {},
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: Material(
                            elevation: 0,
                            borderRadius: BorderRadius.all(Radius.circular(height/15)),
                            child: const Icon(
                              Icons.lock,
                              color: Colors.blue,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/50)),
                    ),
                  ),
                ),
                SizedBox(height: height/30,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: height/30),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(height/40)),
                        color: const Color(0xff3188c1)),
                    child: TextButton(
                      child: Text(
                        "Login", style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: height/50),
                      ),
                      onPressed: () {


                        if (_edtUsername.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Enter The UserName");

                        } else if (_edtPassword.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Enter The Password");
                        } else {
                          //print('click');
                          postRequest1();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
    )
    );
  }

  Future<http.Response> postRequest1() async {
    log(AppConstants.LIVE_URL + 'login');
    var headers = {"Content-Type": "application/json"};
    var body = {
      "UserName": _edtUsername.text,
      "Password": _edtPassword.text
    };
    log(jsonEncode(body));
    setState(() {
      loading = true;
    });
    try {
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'login'),
          body: jsonEncode(body),
          headers: headers);
      log(AppConstants.LIVE_URL + 'login');
      setState(() {
        loading = false;
      });

      if (response.statusCode == 200) {
        var login = jsonDecode(response.body)['status'] = 0;

        if (login == false) {
          Fluttertoast.showToast(
              msg: "Login failed",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Login Success",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          log(response.body);

          loginModel = LoginModel.fromJson(jsonDecode(response.body));

          Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

           final SharedPreferences prefs = await _prefs;
           prefs.setString("UserID", loginModel.result![0].empId.toString());
           prefs.setString("FirstName", loginModel.result![0].firstName.toString());
           prefs.setString("DeptCode", loginModel.result![0].dept.toString());
           prefs.setString("DeptName", loginModel.result![0].name.toString());

          prefs.setString("LoggedIn", "true");

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Dashboard()),
          );
        }
        // showDialogbox(context, response.body);

      } else {
        showDialogboxWarning(context, "Failed to Login API");
      }
      return response;
    } on SocketException {
      setState(() {
        loading = false;
        showDialog(
            context: context,
            builder: (_) => const AlertDialog(
                backgroundColor: Colors.black,
                title: Text(
                  "No Response!..",
                  style: TextStyle(color: Colors.purple),
                ),
                content: Text(
                  "Slow Server Response or Internet connection",
                  style: TextStyle(color: Colors.white),
                )));
      });
      throw Exception('Internet is down');
    }
  }
}
Future showDialogboxWarning(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(message),
        actions: [
          ElevatedButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
