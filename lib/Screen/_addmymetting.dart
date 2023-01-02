// ignore_for_file: must_be_immutable, deprecated_member_use, unnecessary_null_comparison
import 'dart:convert';
import 'dart:developer';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dicks/AppConstants.dart';
import 'package:dicks/Include/_appbar.dart';
import 'package:dicks/Include/_loding.dart';
import 'package:dicks/Model/GetLeaddata.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;



class AddMyMetting extends StatefulWidget {
  AddMyMetting({Key? key, required this. screenName}) : super(key: key);

  var screenName='';

  @override
  State<AddMyMetting> createState() => _AddMyMettingState();
}

class _AddMyMettingState extends State<AddMyMetting> {



  bool loading = false;
  var sessionUseId  =   '';
  var sessionName = '';
  var sessionDeptCode = '';
  var sessionDeptName = '';

  var alterleadno='';
  var alterleadname = '';

  late GetLeaddata rawGetLeaddata;

  List<String> secleadlist = [];

  final TextEditingController _mobileno = TextEditingController();
  final TextEditingController _contactperson = TextEditingController();
  final TextEditingController _nextmettingdate = TextEditingController();
  final TextEditingController _remarks = TextEditingController();
  final TextEditingController _startime = TextEditingController();
  final TextEditingController _endTime = TextEditingController();
  final TextEditingController _demostatus = TextEditingController();
  final TextEditingController _mettingstatus = TextEditingController();
  final TextEditingController _joinedperson = TextEditingController();
  final TextEditingController _basicrequriment = TextEditingController();
  DateTime dateTime = DateTime.now();
  TimeOfDay picked = TimeOfDay.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool demo =false;
  String demochar='N';

  List<StatusList> secStatusList= [];


  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      getStringValuesSF();
      secStatusList.addAll([
        StatusList("No Demo", 1),
        StatusList("Not Bad", 1),
        StatusList("Super", 1),
        StatusList("Good", 2),
        StatusList("Average", 2),
        StatusList("Not Bad", 2),
        StatusList("Inserted", 2),
        StatusList("Not Inserted", 2),
      ]);
    });
    super.initState();
  }


  _selectToDate(BuildContext context,fromid) async {
    var picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        if (fromid == 1) {
          setState(() {
            _nextmettingdate.text = DateFormat('dd-MM-yyyy').format(picked);
          });
        } else if (fromid == 2) {
          setState(() {
            _nextmettingdate.text = DateFormat('dd-MM-yyyy').format(picked);
          });
        }
      });
    }
  }

  _selectTime(BuildContext context,formid) async {

    int hour=0;
    var minits='';
    var session='';

    picked = (await showTimePicker(
        initialTime: selectedTime,
        context: context))!;
    if(picked != null){
      selectedTime = picked;
      // print(selectedTime.minute);
     // print(selectedTime.hour);
      // print(selectedTime.hour);
      if(selectedTime.hour>=12){
        setState(() {
          hour = int.parse(selectedTime.hour .toString()) - 12;
          minits = selectedTime.minute .toString();
          session = 'PM';
          log(hour.toString()+":"+minits.toString()+"-"+session.toString());
          if(formid==1){
          _startime.text  = hour.toString()+":"+minits.toString()+"-"+session.toString();
          }
          else{
            _endTime.text = hour.toString()+":"+minits.toString()+"-"+session.toString();
          }
        });

      }else if (selectedTime.hour<12){
        setState(() {
          hour = selectedTime.hour;
          minits = selectedTime.minute .toString();
          session = 'AM';
          log(hour.toString()+":"+minits.toString()+"-"+session.toString());
          if(formid==1){
          _startime.text  = hour.toString()+":"+minits.toString()+"-"+session.toString();
          }else{
            _endTime.text = hour.toString()+":"+minits.toString()+"-"+session.toString();
          }
        });

      }else{
        setState(() {
          _startime.text ='';
        });
      }
    }

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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Material(
                              elevation: 2.0,
                              borderRadius: BorderRadius.all(Radius.circular(height/10)),
                              child: SizedBox(
                                width: width/2.5,
                                child: TextField(
                                  controller: _startime,
                                  readOnly: true,
                                  onTap: (){
                                    _selectTime(context, 1);
                                  },
                                  cursorColor: Colors.blue,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      labelText: "Start Time",
                                      hintText: "Start Time",
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
                            Material(
                              elevation: 2.0,
                              borderRadius: BorderRadius.all(Radius.circular(height/10)),
                              child: SizedBox(
                                width: width/2.5,
                                child: TextField(
                                  controller: _endTime,
                                  readOnly: true,
                                  onTap:(){
                                    _selectTime(context, 2);
                                  },
                                  cursorColor: Colors.blue,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      labelText: "End Time",
                                      hintText: "End Time",
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
                          ],
                        ),
                      ),
                      SizedBox(height: height/100,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: height/30),
                        child: Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.all(Radius.circular(height/10)),
                          child: TextField(
                            controller: _joinedperson,
                            cursorColor: Colors.blue,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: "Joined Person",
                                hintText:"Joined Person" ,
                                prefixIcon: Material(
                                  elevation: 0,
                                  borderRadius: BorderRadius.all(Radius.circular(height/15)),
                                  child: const Icon(
                                    Icons.supervised_user_circle_sharp,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Material(
                              elevation: 2.0,
                              borderRadius: BorderRadius.all(Radius.circular(height/10)),
                              child: SizedBox(
                                width: width/2.4,
                                child: TextField(
                                  controller: _demostatus,
                                  readOnly: true,
                                  onTap: (){
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                          const Text('Choose Demo Status..'),
                                          content: SizedBox(
                                            width: double.minPositive,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: secStatusList.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                return ListTile(
                                                  title: Text(secStatusList[index].discription.toString()),
                                                  onTap: () {
                                                    setState(() {
                                                      _demostatus.text = secStatusList[index].discription.toString();


                                                    });
                                                    Navigator.pop(context,);
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  cursorColor: Colors.blue,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      labelText: "Demo Status",
                                      hintText: "Demo Status",
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
                            Material(
                              elevation: 2.0,
                              borderRadius: BorderRadius.all(Radius.circular(height/10)),
                              child: SizedBox(
                                width: width/2.3,
                                child: TextField(
                                  controller: _mettingstatus,
                                  readOnly: true,
                                  onTap:(){
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                          const Text('Choose Demo Status..'),
                                          content: SizedBox(
                                            width: double.minPositive,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: secStatusList.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                return ListTile(
                                                  title: Text(secStatusList[index].discription.toString()),
                                                  onTap: () {
                                                    setState(() {
                                                      _mettingstatus.text = secStatusList[index].discription.toString();
                                                    });
                                                    Navigator.pop(context,);
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  cursorColor: Colors.blue,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      labelText: "Metting Status",
                                      hintText: "Metting Status",
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
                          ],
                        ),
                      ),
                      SizedBox(height: height/100,),
                      SizedBox(
                        width: width/1.2,
                        child: Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.all(Radius.circular(height/10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  height: height/25,
                                  width: width/3.5,
                                  alignment: Alignment.centerLeft,

                                  child: Text('Need Sales Qute',style: TextStyle(fontSize: height/50),)
                              ),
                              Container(
                                  height: height/25,
                                  width: width/4,
                                  alignment: Alignment.centerLeft,
                                  child: IconButton(icon: Icon(demo?Icons.check_box_rounded:Icons.check_box_outline_blank,color: Colors.green,),
                                    onPressed: () {
                                      setState(() {
                                        if(demo){
                                          demo=false;
                                          demochar='N';
                                        }else{
                                          demo=true;
                                          demochar='Y';
                                        }
                                      });
                                    },
                                  )
                              ),
                            ],
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
                            controller: _nextmettingdate,
                            cursorColor: Colors.blue,
                            readOnly: true,
                            onTap: (){
                              _selectToDate(context, 1);
                            },
                            decoration: InputDecoration(
                                labelText: "Next Metting Date",
                                hintText:"Next Metting Date" ,
                                prefixIcon: Material(
                                  elevation: 0,
                                  borderRadius: BorderRadius.all(Radius.circular(height/15)),
                                  child: const Icon(
                                    Icons.supervised_user_circle_sharp,
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
                          child: TextField(
                            controller: _basicrequriment,
                            cursorColor: Colors.blue,
                            keyboardType: TextInputType.text,
                            maxLines: 4,
                            decoration: InputDecoration(
                                labelText: "Basic Requirement",
                                hintText:"Basic Eequirement Name" ,
                                prefixIcon: Material(
                                  elevation: 0,
                                  borderRadius: BorderRadius.all(Radius.circular(height/15)),
                                  child: const Icon(
                                    Icons.edit,
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
                          child: TextField(
                            controller: _remarks,
                            cursorColor: Colors.blue,
                            keyboardType: TextInputType.text,
                            maxLines: 4,
                            decoration: InputDecoration(
                                labelText: "Remarks/Joined Person Name",
                                hintText:"Joined Person Name" ,
                                prefixIcon: Material(
                                  elevation: 0,
                                  borderRadius: BorderRadius.all(Radius.circular(height/15)),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/50)),
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
                        postsave();
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
      "FromId":3,
      "CardName":"CardName",
      "MobileNo":"MobileNo",
      "ContactPerson":"ContactPerson",
      "ContactPersonPosition":"ContactPersonPosition",
      "Email":"Email",
      "StreetName":"StreetName",
      "LandMark":"LandMark",
      "District":"District",
      "State":"State",
      "OfficeNo":"OfficeNo",
      "DocDate":"DocDate",
      "CreateBy":sessionUseId.toString(),
      "CompanyGroup":"",
      "TypeOfBusiness":"",
      "Currency":"",
      "Panno":"",
      "Gstin":"",
      "GstType":"",
      "BankName":"",
      "ACno":"",
      "Branch":"",
      "IFscCode":""
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
      });

    } else {
      log("Somthing Worng Kindly Check Network...");
    }
  }



  Future postsave() async {
    setState(() {
      loading = true;
      log("Save Method.....");
    });
    var body = {
    "Fromid":1,
    "LeadNo":alterleadno.toString(),
    "LeadCardName":alterleadname.toString(),
    "MobileNo":_mobileno.text,
    "ContactPerson":_contactperson.text,
    "StartTime":_startime.text,
    "EndTime":_endTime.text,
    "JoinedPerson":_joinedperson.text,
    "DemoStatus":_demostatus.text,
    "MettingStatus":_mettingstatus.text,
    "SaleQute":demochar,
    "BasicRequriment":_basicrequriment.text,
    "Remarks":_remarks.text,
    "DocDate":"DocDate",
    "CreateBy":sessionUseId.toString(),
    "NextMettingDate":_nextmettingdate.text
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
      final decode = jsonDecode(responce.body);

      log("Saved...");
      setState(()  {
        loading = false;
        //log(decode['result'][0]['SatusMsg']);
        AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            animType: AnimType.SCALE,
            headerAnimationLoop: true,
            title: 'This Lead No is-'+alterleadno.toString(),
            desc: decode['result'][0]['SatusMsg'].toString(),
            btnOkOnPress: () {
              Navigator.pop(context);
            },
            btnOkIcon: Icons.cancel,
            btnOkColor: Colors.greenAccent)
            .show();
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


