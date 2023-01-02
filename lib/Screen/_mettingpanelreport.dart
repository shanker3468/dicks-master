// ignore_for_file: must_be_immutable, deprecated_member_use, unnecessary_null_comparison, prefer_typing_uninitialized_variables
import 'dart:convert';
import 'dart:developer';
import 'package:dicks/AppConstants.dart';
import 'package:dicks/Include/_appbar.dart';
import 'package:dicks/Include/_loding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Model/GetMettingMaster.dart';



class MetteingPanelReport extends StatefulWidget {
  MetteingPanelReport({Key? key, required this. screenName}) : super(key: key);

  var screenName='';

  @override
  State<MetteingPanelReport> createState() => _MetteingPanelReportState();
}

class _MetteingPanelReportState extends State<MetteingPanelReport> {
  bool loading = false;
  var sessionUseId  =   '';
  var sessionName = '';
  var sessionDeptCode = '';
  var sessionDeptName = '';


  DateTime dateTime = DateTime.now();
  TimeOfDay picked = TimeOfDay.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  late GetMettingMaster rawGetMettingMaster;
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
                                            secScreenData[index].nextMettingDate.toString(),
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
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                secScreenData[index].startTime.toString(),
                                                style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w700)
                                            ),
                                            Text(
                                                secScreenData[index].endTime.toString(),
                                                style: const TextStyle(color: Colors.green,fontWeight: FontWeight.w700)
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 5,),
                                      SizedBox(
                                        width: width,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Text('Demo Status :',
                                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700)
                                                ),
                                                Text(
                                                    secScreenData[index].demoStatus.toString(),
                                                    style: const TextStyle(color: Colors.pinkAccent,fontWeight: FontWeight.w700)
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text('Metting Status :',
                                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700)
                                                ),
                                                Text(
                                                    secScreenData[index].mettingStatus.toString(),
                                                    style: const TextStyle(color: Colors.pinkAccent,fontWeight: FontWeight.w700)
                                                ),
                                              ],
                                            ),
                                          ],
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
                                    backgroundColor:Colors.white,
                                    child: Text(
                                        secScreenData[index].joinedPerson.toString(),
                                        style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w700)
                                    ),

                                  ),
                                  onTap: (){


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
                Visibility(
                  child: FloatingActionButton.extended(
                    backgroundColor: Colors.green.shade700,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                    onPressed: () {
                      setState(() {

                      });
                    },
                  ),
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
      "FromId":2,
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
            rawGetMettingMaster = GetMettingMaster.fromJson(jsonDecode(responce.body));
            for(int i=0;i<rawGetMettingMaster.result!.length;i++){
              secScreenData.add(
                  ScreenData(
                      rawGetMettingMaster.result![i].systemDate,
                      rawGetMettingMaster.result![i].docNo,
                      rawGetMettingMaster.result![i].cardName,
                      rawGetMettingMaster.result![i].mobileNo,
                      rawGetMettingMaster.result![i].contactPerson,
                      rawGetMettingMaster.result![i].startTime, rawGetMettingMaster.result![i].endTime,
                      rawGetMettingMaster.result![i].joinedPerson, rawGetMettingMaster.result![i].demoStatus,
                      rawGetMettingMaster.result![i].mettingStatus, rawGetMettingMaster.result![i].nextMettingDate));
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
  String? startTime;
  String? endTime;
  String? joinedPerson;
  String? demoStatus;
  String? mettingStatus;
  String? nextMettingDate;

  ScreenData(
      this.systemDate,
        this.docNo,
        this.cardName,
        this.mobileNo,
        this.contactPerson,
        this.startTime,
        this.endTime,
        this.joinedPerson,
        this.demoStatus,
        this.mettingStatus,
        this.nextMettingDate);


}

