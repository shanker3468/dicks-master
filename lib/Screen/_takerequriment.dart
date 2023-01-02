// ignore_for_file: must_be_immutable, deprecated_member_use, unnecessary_null_comparison, prefer_typing_uninitialized_variables
import 'dart:convert';
import 'dart:developer';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dicks/AppConstants.dart';
import 'package:dicks/Include/_appbar.dart';
import 'package:dicks/Include/_loding.dart';
import 'package:dicks/Model/GetItemMaster.dart';
import 'package:dicks/Model/GetLeaddata.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;



class TakeMyRequriment extends StatefulWidget {
  TakeMyRequriment({Key? key, required this. screenName}) : super(key: key);

  var screenName='';

  @override
  State<TakeMyRequriment> createState() => _TakeMyRequrimentState();
}

class _TakeMyRequrimentState extends State<TakeMyRequriment> {
  bool loading = false;
  var sessionUseId  =   '';
  var sessionName = '';
  var sessionDeptCode = '';
  var sessionDeptName = '';
  var alterleadno='';
  var alterleadname = '';
  var alterItemcode = '';
  var alterItemName = '';
  var statusMessage='';
  late GetLeaddata rawGetLeaddata;
  List<String> secleadlist = [];
  final TextEditingController _mobileno = TextEditingController();
  final TextEditingController _contactperson = TextEditingController();
  DateTime dateTime = DateTime.now();
  TimeOfDay picked = TimeOfDay.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool demo =false;
  String demochar='N';
  List<StatusList> secStatusList= [];
  late GetItemMaster rawGetItemMaster;
  List<String> secitemmaster=[];
  List<ScreenData> secSecreendata = [];

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
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: height/30),
                        child: Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.all(Radius.circular(height/10)),
                          child: SizedBox(
                            height: height/15,
                            child: DropdownSearch<String>(
                              mode: Mode.DIALOG,
                              showSearchBox: true,
                              items: secleadlist,
                              hint: 'Select The Lead No',
                              label: 'Select The Lead No',
                              dropdownSearchDecoration: InputDecoration(
                                  enabled: false,
                                  enabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/60)
                              ),
                              onChanged: (val) {
                                log(val.toString());
                                for (int kk = 0; kk < rawGetLeaddata.result!.length; kk++) {
                                  setState(() {
                                    if (rawGetLeaddata.result![kk].docNo.toString()
                                        +"-"+ rawGetLeaddata.result![kk].cardName.toString() == val) {
                                      // log(rawGetStateMaster.data![kk].docEntry.toString());
                                      alterleadno = rawGetLeaddata.result![kk].docNo.toString();
                                      alterleadname = rawGetLeaddata.result![kk].cardName.toString();
                                      _mobileno.text = rawGetLeaddata.result![kk].mobileNo.toString();
                                      _contactperson.text = rawGetLeaddata.result![kk].contactPerson.toString();
                                    }
                                    log(alterleadname);
                                  });
                                }
                              },
                              selectedItem: alterleadname,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height/100,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: height/30),
                        child: Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.all(Radius.circular(height/10)),
                          child: TextField(
                            controller: _mobileno,
                            readOnly: true,
                            cursorColor: Colors.blue,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: "MobileNo",
                                hintText: "MobileNo",
                                prefixIcon: Material(
                                  elevation: 0,
                                  borderRadius: BorderRadius.all(Radius.circular(height/15)),
                                  child: const Icon(
                                    Icons.mobile_screen_share_sharp,
                                    color: Colors.blue,
                                  ),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/50)
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height/100,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: height/30),
                        child: Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.all(Radius.circular(height/10)),
                          child: TextField(
                            controller: _contactperson,
                            readOnly: true,
                            cursorColor: Colors.blue,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: "Contact Person",
                                hintText: "Contact Person",
                                prefixIcon: Material(
                                  elevation: 0,
                                  borderRadius: BorderRadius.all(Radius.circular(height/15)),
                                  child: const Icon(
                                    Icons.account_circle_outlined,
                                    color: Colors.blue,
                                  ),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/50)),
                          ),
                        ),
                      ),
                      SizedBox(height: height/100,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: height/30),
                        child: Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.all(Radius.circular(height/10)),
                          child: SizedBox(
                            height: height/15,
                            child: DropdownSearch<String>(
                              mode: Mode.DIALOG,
                              showSearchBox: true,
                              items: secitemmaster,
                              hint: 'Select ItemName',
                              label: 'Select ItemName',
                              dropdownSearchDecoration: InputDecoration(
                                  enabled: false,
                                  enabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/60)
                              ),
                              onChanged: (val) {
                                for (int kk = 0; kk < rawGetItemMaster.result!.length; kk++) {
                                  setState(() {
                                    if (rawGetItemMaster.result![kk].itemName.toString() == val) {
                                    alterItemcode = rawGetItemMaster.result![kk].itemCode.toString();
                                    alterItemName = rawGetItemMaster.result![kk].itemName.toString();
                                    }
                                  });
                                }
                                log(alterItemcode);

                                addmytable(alterItemcode,alterItemName);
                              },
                              selectedItem: alterItemName,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height/100,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: height/30),
                        child: Material(
                          elevation: 2.0,
                          child: SizedBox(
                            height: height/2,
                            child: ListView.builder(
                              itemCount: secSecreendata.length,
                              itemBuilder: (BuildContext context1, int index) {
                                return Card(
                                  child: SwipeActionCell(
                                    key: ObjectKey(index),
                                    trailingActions: <SwipeAction>[
                                      SwipeAction(
                                          icon: const Icon(Icons.delete,color: Colors.deepOrange,),
                                          onTap: (CompletionHandler handler) async {
                                              setState(() {
                                                secSecreendata.removeAt(index);
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
                                              secSecreendata[index].itemcode.toString(),
                                              style: const TextStyle(color: Colors.purpleAccent,fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          const SizedBox(height: 5,),
                                          SizedBox(
                                            width: width,
                                            child: Text(
                                                secSecreendata[index].itemName.toString(),
                                                style: const TextStyle(color: Colors.black45,fontWeight: FontWeight.w500)
                                            ),
                                          ),
                                        ],
                                      ),
                                      dense: true,
                                      leading: CircleAvatar(
                                        backgroundColor:Colors.blueAccent,
                                        child: Text((index+1).toString(),
                                          style: TextStyle(color: Colors.white,fontSize: height/80),),
                                      ),
                                      trailing: CircleAvatar(
                                        backgroundColor:Colors.green.shade900,
                                        child: Text(secSecreendata[index].qty.toString(),
                                          style: TextStyle(color: Colors.white,fontSize: height/80),),
                                      ),
                                      onTap: (){
                                        var enterMobileNo;
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext contex1) => AlertDialog(
                                            content: TextFormField(
                                              keyboardType: TextInputType.number,
                                              autofocus: true,
                                              onChanged: (vvv) {
                                                enterMobileNo = vvv;
                                                if (enterMobileNo.toString().length ==10) {
                                                  secSecreendata[index].qty = enterMobileNo;
                                                  Navigator.pop(contex1);
                                                }
                                              },
                                            ),
                                            title: const Text("Enter Qty"),
                                            actions: <Widget>[
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            secSecreendata[index].qty = double.parse(enterMobileNo.toString()) ;
                                                            Navigator.pop(contex1, 'Ok',);
                                                          });
                                                        },
                                                        child: const Text("Ok"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(contex1, 'Cancel'),
                                                        child: const Text('Cancel'),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
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
                    backgroundColor: Colors.redAccent,
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Cancel'),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Visibility(
                  child: FloatingActionButton.extended(
                    backgroundColor: Colors.green.shade700,
                    icon: const Icon(Icons.check),
                    label: const Text('Save'),
                    onPressed: () {
                      setState(() {
                        postsave().then((value) {
                          AwesomeDialog(
                              context: context,
                              dialogType: DialogType.SUCCES,
                              animType: AnimType.SCALE,
                              headerAnimationLoop: true,
                              title: 'This Lead No is-'+alterleadno.toString(),
                              desc: statusMessage.toString(),
                              btnOkOnPress: () {
                                // Navigator.pop(context);
                              },
                              btnOkIcon: Icons.cancel,
                              btnOkColor: Colors.greenAccent)
                              .show();

                        });
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
      secleadlist.clear();
      log("Save Method.....");
    });
    var body = {
      "FromId":3, "CardName":"CardName", "MobileNo":"MobileNo", "ContactPerson":"ContactPerson",
      "ContactPersonPosition":"ContactPersonPosition", "Email":"Email", "StreetName":"StreetName",
      "LandMark":"LandMark", "District":"District", "State":"State", "OfficeNo":"OfficeNo",
      "DocDate":"DocDate", "CreateBy":sessionUseId.toString(), "CompanyGroup":"", "TypeOfBusiness":"",
      "Currency":"", "Panno":"", "Gstin":"", "GstType":"", "BankName":"", "ACno":"", "Branch":"", "IFscCode":""
    };
    var header = {"Content-Type": "application/json"};
    var responce = await http.post(
        Uri.parse('${AppConstants.LIVE_URL}insetleadmaster'),
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
          rawGetLeaddata = GetLeaddata.fromJson(jsonDecode(responce.body));
          for (int i = 0 ; i <rawGetLeaddata.result!.length;i++ ){
            secleadlist.add(rawGetLeaddata.result![i].docNo.toString()
            +"-"+ rawGetLeaddata.result![i].cardName.toString() ) ;
          }
        }
        loading = false;
        getItemMaster();
      });
    } else {
      log("Somthing Worng Kindly Check Network...");
    }
  }

  Future getItemMaster() async {
    setState(() {
      loading = true;
      secitemmaster.clear();
      log("getItemMaster.....");
    });
    var body = {
      "Fromid":2,
      "LeadNo":"1",
      "LeadCardName":"LeadCardName",
      "MobileNo":"MobileNo",
      "ContactPerson":"ContactPerson",
      "StartTime":"StartTime",
      "EndTime":"EndTime",
      "JoinedPerson":"JoinedPerson",
      "DemoStatus":"DemoStatus",
      "MettingStatus":"MettingStatus",
      "SaleQute":"SaleQute",
      "BasicRequriment":"BasicRequriment",
      "Remarks":"Remarks",
      "DocDate":"DocDate",
      "CreateBy":"CreateBy",
      "NextMettingDate":"CreateBy"
    };
    log(json.encode(body));
    var header = {"Content-Type": "application/json"};
    var responce = await http.post(
        Uri.parse('${AppConstants.LIVE_URL}insetmettingrmaster'),
        body: json.encode(body),
        headers: header);
    log('${AppConstants.LIVE_URL}insetmettingrmaster');
    log(responce.body);
    if (responce.statusCode == 200) {
      setState(()  {
        rawGetItemMaster = GetItemMaster.fromJson(jsonDecode(responce.body));
        for(int i = 0 ; i< rawGetItemMaster.result!.length;i++){
          secitemmaster.add(rawGetItemMaster.result![i].itemName.toString());
        }
        loading = false;
       log(responce.body);

      });

    } else {
      log("Somthing Worng Kindly Check Network...");
    }
  }

  addmytable(String alterItemcode, String alterItemName) {
    int check=0;
    setState(() {
    for(int f=0;f<secSecreendata.length;f++){
      if(secSecreendata[f].itemcode==alterItemcode){
        check=100;
      }
    }
    if(check==100){
      Fluttertoast.showToast(msg: "This ItemCode Already Added...");
    }else{
      secSecreendata.add(ScreenData(alterItemcode, alterItemName, 1));
    }
    });
  }

  Future postsave() async {
    int docNo = 0;
    setState(() {
      loading = true;

      log("Save Method.....");
    });
    var body = {
      "FormId":1,
      "LeadNo":alterleadno,
      "LeadCardName":alterleadname,
      "MobileNo":_mobileno.text,
      "ContactPerson":_contactperson.text,
      "CreateBy":"CreateBy",
      "TotalQty":0.0,
      "DocNo":1,
      "ItemCode":"ItemCode",
      "ItemName":"ItemName",
      "Qty":0.2
    };
    log(json.encode(body));
    var header = {"Content-Type": "application/json"};
    var responce = await http.post(
        Uri.parse('${AppConstants.LIVE_URL}insetrreqmaster'),
        body: json.encode(body),
        headers: header);
    log('${AppConstants.LIVE_URL}insetrreqmaster');
    log(responce.body);
    if (responce.statusCode == 200) {
      final decode = jsonDecode(responce.body);
      log("Saved...");
      setState(()  {
        loading = false;
        docNo= decode['result'][0]['HeaderDocNo'];
        statusMessage = decode['result'][0]['SatusMsg'].toString();
        for(int i=0; i < secSecreendata.length; i ++){
          postlinesave(i,docNo);
        }

      });
    } else {
      log("Somthing Worng Kindly Check Network...");
    }
  }

  Future postlinesave(index, int docNo) async {
    setState(() {
      loading = true;
      log("Save Method.....");
    });
    var body = {
      "FormId":2,
      "LeadNo":alterleadno,
      "LeadCardName":alterleadname,
      "MobileNo":_mobileno.text,
      "ContactPerson":_contactperson.text,
      "CreateBy":"CreateBy",
      "TotalQty":0.0,
      "DocNo":docNo,
      "ItemCode":secSecreendata[index].itemcode,
      "ItemName":secSecreendata[index].itemName,
      "Qty":secSecreendata[index].qty
    };
    var header = {"Content-Type": "application/json"};
    var responce = await http.post(
        Uri.parse('${AppConstants.LIVE_URL}insetrreqmaster'),
        body: json.encode(body),
        headers: header);
    log('${AppConstants.LIVE_URL}insetrreqmaster');

    if (responce.statusCode == 200) {
      log("Saved...");
      setState(()  {
        loading = false;
        log(responce.body);
      });

    } else {
      log("Somthing Worng Kindly Check Network...");
    }
  }
}
class StatusList{
  String? discription;
  int? type;
  StatusList(this.discription,this.type);

}


class ScreenData {
  String? itemcode;
  String? itemName;
  double? qty;

  ScreenData(this.itemcode,this.itemName,this.qty);

}


