// ignore_for_file: must_be_immutable, deprecated_member_use, unnecessary_null_comparison, prefer_typing_uninitialized_variables
import 'dart:convert';
import 'dart:developer';
import 'package:dicks/AppConstants.dart';
import 'package:dicks/Include/_appbar.dart';
import 'package:dicks/Include/_loding.dart';
import 'package:dicks/Model/GetMaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class ShedularReport extends StatefulWidget {
  ShedularReport({Key? key, required this. screenName}) : super(key: key);
  var screenName='';
  @override
  State<ShedularReport> createState() => _ShedularReportState();
}
class _ShedularReportState extends State<ShedularReport> {
  bool loading = false;
  var sessionUseId  =   '';
  var sessionName = '';
  var sessionDeptCode = '';
  var sessionDeptName = '';
  DateTime dateTime = DateTime.now();
  TimeOfDay picked = TimeOfDay.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  late GetMaster rawGetMaster;
  List<ScreenData> secScreenData=[];
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      getStringValuesSF();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
          body:
          loading?
          const LodingPage()
              :SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Container(
                      height: height/10,
                      width: width,
                      margin: EdgeInsets.all(height/200),
                      child: MyAppBar(screenName:widget.screenName),
                    ),
                    SizedBox(height: height/100,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: height/70),
                      child: Material(
                        elevation: 2.0,
                        child: SizedBox(
                          height: height/1.1,
                          child: ListView.builder(
                            itemCount: secScreenData.length,
                            itemBuilder: (BuildContext context1, int index) {
                              return Card(
                                child: SwipeActionCell(
                                  key: ObjectKey(index),
                                  trailingActions: <SwipeAction>[
                                    SwipeAction(
                                        icon: const Icon(Icons.delete,color: Colors.deepOrange,),
                                        onTap: (CompletionHandler handler) async {
                                          setState(() {
                                            //secSecreendata.removeAt(index);
                                          });
                                        },
                                        color: Colors.black12),
                                  ],
                                  child: ListTile(
                                    title: Column(
                                      children: [
                                        SizedBox(
                                          width: width,
                                          child: Text(
                                            secScreenData[index].cardName.toString(),
                                            style: const TextStyle(color: Colors.purpleAccent,fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        const SizedBox(height: 5,),
                                        SizedBox(
                                          width: width,
                                          child: Text(
                                              secScreenData[index].contactPerson.toString(),
                                              style: const TextStyle(color: Colors.black45,fontWeight: FontWeight.w500)
                                          ),
                                        ),
                                        const SizedBox(height: 5,),
                                        SizedBox(
                                          width: width,
                                          child: Text(
                                              secScreenData[index].remainderDate.toString(),
                                              style: const TextStyle(color: Colors.teal,fontWeight: FontWeight.w500)
                                          ),
                                        ),
                                        const SizedBox(height: 5,),
                                        SizedBox(
                                          width: width,
                                          child: Text(
                                              secScreenData[index].mobileNo.toString(),
                                              style: const TextStyle(color: Colors.red,fontWeight: FontWeight.w700)
                                          ),
                                        ),
                                        const SizedBox(height: 5,),
                                        SizedBox(
                                          width: width,
                                          child: Text(
                                              secScreenData[index].schedulerTime.toString(),
                                              style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w700)
                                          ),
                                        ),
                                        const SizedBox(height: 5,),
                                        SizedBox(
                                          width: width,
                                          child: Text(
                                              secScreenData[index].landMark.toString(),
                                              style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w700)
                                          ),
                                        ),
                                      ],
                                    ),
                                    dense: true,
                                    leading: CircleAvatar(
                                      backgroundColor:Colors.blueAccent,
                                      child: Text(secScreenData[index].docNo.toString(),
                                        style: TextStyle(color: Colors.white,fontSize: height/80),),
                                    ),
                                    trailing: CircleAvatar(
                                      backgroundColor:Colors.green.shade900,
                                      child: const Icon(Icons.remove_red_eye),

                                    ),
                                    onTap: (){
                                      var enterMobileNo;

                                    },
                                  ),

                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
            ),
          ),
          persistentFooterButtons: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  width: 10,
                ),
                FloatingActionButton.extended(
                  backgroundColor: Colors.green.shade700,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                  onPressed: () {
                    setState(() {

                    });
                  },
                ),
              ],
            ),
          ],
        )
    );
  }
  Future<void> getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sessionUseId  =   prefs.getString('UserID').toString();
      sessionName = prefs.getString('FirstName').toString();
      sessionDeptCode = prefs.getString('DeptCode').toString();
      sessionDeptName = prefs.getString('DeptName').toString();
      getLeadNumber();
    });
  }

  Future getLeadNumber() async {
    setState(() {
      loading = true;
      log("Save Method.....");
    });
    var body = {
      "FromId":1,
      "DocDate":"1",
      "UserId":"LeadCardName",
      "Status":"Y",
      "CardCode":"ContactPerson",
      "MobileNo":"CreateBy",
      "FieldName":"",
      "LeadNo":""
    };
    var header = {"Content-Type": "application/json"};
    var responce = await http.post(
        Uri.parse('${AppConstants.LIVE_URL}getmaster'),
        body: json.encode(body),
        headers: header);
    log(responce.body);
    if (responce.statusCode == 200) {
      final decode = jsonDecode(responce.body);

      log(decode['status'].toString());
      setState(()  {
        if(decode['status']==0){
          Fluttertoast.showToast(msg: "No Lead Data Create Lead");
        }else{

          setState(() {
            rawGetMaster = GetMaster.fromJson(jsonDecode(responce.body));

            for(int i = 0 ; i < rawGetMaster.result!.length;i++ ){
              secScreenData.add(
                  ScreenData(
                      rawGetMaster.result![i].systemDate,
                      rawGetMaster.result![i].docNo, rawGetMaster.result![i].cardName,
                      rawGetMaster.result![i].mobileNo, rawGetMaster.result![i].contactPerson,
                      rawGetMaster.result![i].contactPersonPosition,
                      rawGetMaster.result![i].email, rawGetMaster.result![i].streetName,
                      rawGetMaster.result![i].landMark, rawGetMaster.result![i].district,
                      rawGetMaster.result![i].state, rawGetMaster.result![i].officeNo,
                      rawGetMaster.result![i].docDate, rawGetMaster.result![i].createBy,
                      rawGetMaster.result![i].schedularStatus, rawGetMaster.result![i].mettingStatus,
                      rawGetMaster.result![i].reqrimentStatus, rawGetMaster.result![i].queationStatus,
                      rawGetMaster.result![i].remainderDate, rawGetMaster.result![i].schedulerTime,
                      rawGetMaster.result![i].demo));

            }
          });
        }

        loading = false;

      });

    } else {
      log("Somthing Worng Kindly Check Network...");
    }
  }
}
class ScreenData {
  String? systemDate;
  int? docNo;
  String? cardName;
  String? mobileNo;
  String? contactPerson;
  String? contactPersonPosition;
  String? email;
  String? streetName;
  String? landMark;
  String? district;
  String? state;
  String? officeNo;
  String? docDate;
  String? createBy;
  String? schedularStatus;
  String? mettingStatus;
  String? reqrimentStatus;
  String? queationStatus;
  String? remainderDate;
  String? schedulerTime;
  String? demo;

  ScreenData(
      this.systemDate,
        this.docNo,
        this.cardName,
        this.mobileNo,
        this.contactPerson,
        this.contactPersonPosition,
        this.email,
        this.streetName,
        this.landMark,
        this.district,
        this.state,
        this.officeNo,
        this.docDate,
        this.createBy,
        this.schedularStatus,
        this.mettingStatus,
        this.reqrimentStatus,
        this.queationStatus,
        this.remainderDate,
        this.schedulerTime,
        this.demo);


}





