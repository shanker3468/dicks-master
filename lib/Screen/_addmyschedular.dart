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

class AddMySchedular extends StatefulWidget {
   AddMySchedular({Key? key, required this. screenName}) : super(key: key);

   var screenName='';

  @override
  State<AddMySchedular> createState() => _AddMySchedularState();
}

class _AddMySchedularState extends State<AddMySchedular> {



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
  final TextEditingController _remainderdate = TextEditingController();
  final TextEditingController _remainderTime = TextEditingController();
  final TextEditingController _landmark = TextEditingController();
  final TextEditingController _place = TextEditingController();
  final TextEditingController _remarks = TextEditingController();
  DateTime dateTime = DateTime.now();
  TimeOfDay picked = TimeOfDay.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool demo =false;
  String demochar='N';


  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      getStringValuesSF();
    });
    super.initState();
  }


  _selectToDate(BuildContext context,fromid) async {
    var picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        if (fromid == 1) {
          setState(() {
            _remainderdate.text = DateFormat('dd-MM-yyyy').format(picked);
          });
        } else if (fromid == 2) {
          setState(() {
            _remainderdate.text = DateFormat('dd-MM-yyyy').format(picked);
          });
        }
      });
    }
  }

  _selectTime(BuildContext context) async {

    int hour=0;
    var minits='';
    var session='';

    picked = (await showTimePicker(
        initialTime: selectedTime,
        context: context))!;
    if(picked != null){
      selectedTime = picked;
      if(selectedTime.hour>=12){
        setState(() {
          hour = int.parse(selectedTime.hour .toString()) - 12;
          minits = selectedTime.minute .toString();
          session = 'PM';
          log(hour.toString()+":"+minits.toString()+"-"+session.toString());
          _remainderTime.text  = hour.toString()+":"+minits.toString()+"-"+session.toString();
        });

      }else if (selectedTime.hour<12){
        setState(() {
          hour = selectedTime.hour;
          minits = selectedTime.minute .toString();
          session = 'AM';
          log(hour.toString()+":"+minits.toString()+"-"+session.toString());
          _remainderTime.text  = hour.toString()+":"+minits.toString()+"-"+session.toString();
        });

      }else{
        setState(() {
          _remainderTime.text ='';
        });
      }
    }else{

    }
  }

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
                        child: TextField(
                          controller: _remainderdate,
                          readOnly: true,
                          onTap: (){
                            setState(() {
                              _selectToDate(context, 1);
                            });
                          },
                          cursorColor: Colors.blue,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                             labelText: "Remainder Date",
                              hintText:"Remainder Date" ,
                              prefixIcon: Material(
                                elevation: 0,
                                borderRadius: BorderRadius.all(Radius.circular(height/15)),
                                child: const Icon(
                                  Icons.calendar_today,
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
                          controller: _remainderTime,
                          readOnly: true,
                          onTap: (){
                            setState(() {
                              _selectTime(context);
                            });
                          },
                          cursorColor: Colors.blue,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: "Schedule Time",
                              hintText:"Schedule Time" ,
                              prefixIcon: Material(
                                elevation: 0,
                                borderRadius: BorderRadius.all(Radius.circular(height/15)),
                                child: const Icon(
                                  Icons.timer,
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
                          controller: _landmark,
                          cursorColor: Colors.blue,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: "LandMark",
                              hintText:"LandMark" ,
                              prefixIcon: Material(
                                elevation: 0,
                                borderRadius: BorderRadius.all(Radius.circular(height/15)),
                                child: const Icon(
                                  Icons.location_on_sharp,
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
                          controller: _place,
                          cursorColor: Colors.blue,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: "Place",
                              hintText:"Place" ,
                              prefixIcon: Material(
                                elevation: 0,
                                borderRadius: BorderRadius.all(Radius.circular(height/15)),
                                child: const Icon(
                                  Icons.place_outlined,
                                  color: Colors.blue,
                                ),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/50)),
                        ),
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

                                child: Text('Need Demo',style: TextStyle(fontSize: height/50),)
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
                          controller: _remarks,
                          cursorColor: Colors.blue,
                          keyboardType: TextInputType.text,
                          maxLines: 4,
                          decoration: InputDecoration(
                              labelText: "Remarks",
                              hintText:"Remarks" ,
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
    "FromId":2,
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
      "FromId":1,
      "LeadNo":alterleadno,
      "LeadCardName":alterleadname,
      "MobileNo":_mobileno.text,
      "ContactPerson":_contactperson.text,
      "RemainderDate":_remainderdate.text,
      "SchedulerTime":_remainderTime.text,
      "LandMark":_landmark.text,
      "Place":_place.text,
      "Demo":demochar,
      "Remarks":_remarks.text,
      "DocDate":"DocDate",
      "CreateBy":sessionUseId.toString()
    };
    log(json.encode(body));
    var header = {"Content-Type": "application/json"};
    var responce = await http.post(
        Uri.parse('${AppConstants.LIVE_URL}insetschedularmaster'),
        body: json.encode(body),
        headers: header);
    log('${AppConstants.LIVE_URL}insetschedularmaster');
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


