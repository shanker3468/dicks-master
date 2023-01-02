// ignore_for_file: must_be_immutable, deprecated_member_use, unnecessary_null_comparison
import 'dart:convert';
import 'dart:developer';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dicks/AppConstants.dart';
import 'package:dicks/Include/_appbar.dart';
import 'package:dicks/Include/_loding.dart';
import 'package:dicks/Model/GetLeaddata.dart';
import 'package:dicks/Screen/_leadpage.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LeadReports extends StatefulWidget {
  LeadReports({Key? key, required this. screenName}) : super(key: key);

  var screenName='';

  @override
  State<LeadReports> createState() => _LeadReportsState();
}

class _LeadReportsState extends State<LeadReports> {



  bool loading = false;
  var sessionUseId  =   '';
  var sessionName = '';
  var sessionDeptCode = '';
  var sessionDeptName = '';
  late GetLeaddata rawGetLeaddata;
  final TextEditingController _remainderdate = TextEditingController();
  final TextEditingController _remainderTime = TextEditingController();
  DateTime dateTime = DateTime.now();
  TimeOfDay picked = TimeOfDay.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  List<Screendata> secScreendata=[];




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
          const LodingPage() :SingleChildScrollView(
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
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              sortColumnIndex: 0,
                              sortAscending: true,
                              headingRowColor: MaterialStateProperty.all(Colors.greenAccent),
                              showCheckboxColumn: false,
                              dataRowHeight: height/ 25,
                              headingRowHeight: height/ 25,
                              border: TableBorder.all(color: Colors.green.shade50),
                              columns: const <DataColumn>[
                                DataColumn(label: Text('Lead No', style: TextStyle(color: Colors.black45),),),
                                DataColumn(label: Text('CardName', style: TextStyle(color: Colors.black45),),),
                                DataColumn(label: Text('mobileNo', style: TextStyle(color: Colors.black45),),),
                                DataColumn(label: Text('ContactPerson', style: TextStyle(color: Colors.black45),),),
                                DataColumn(label: Text('Email', style: TextStyle(color: Colors.black45),),),
                                DataColumn(label: Text('StreetName', style: TextStyle(color: Colors.black45),),),
                                DataColumn(label: Text('OfficeNo', style: TextStyle(color: Colors.black45),),),
                                DataColumn(label: Text('DocDate', style: TextStyle(color: Colors.black45),),),
                                DataColumn(label: Text('State', style: TextStyle(color: Colors.black45),),),

                              ],
                              rows: secScreendata .map((list) =>
                                  DataRow(cells: [
                                    DataCell(
                                      Text(list.docNo.toString(),),
                                      showEditIcon: true,
                                      onTap: (){
                                        Navigator.pop(context);
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) =>
                                                LeadPage(
                                                    screenName:"Lead Creation",
                                                    docno:list.docNo.toString(),
                                                    formid:4
                                                ),
                                            ),
                                          );
                                        });
                                      }

                                    ),
                                    DataCell(
                                      Text(list. cardName.toString(),),

                                    ),
                                    DataCell(
                                      Text(list.mobileNo.toString(),),
                                    ),
                                    DataCell(
                                      Text(list.contactPerson.toString(),),
                                    ),
                                    DataCell(
                                      Text(list.email.toString(),),
                                    ),
                                    DataCell(
                                      Text(
                                        list.streetName.toString(),
                                      ),
                                    ),
                                    DataCell(
                                      Text(list.officeNo.toString(),),
                                    ),
                                    DataCell(
                                      Text(list.docDate.toString(),),
                                    ),
                                    DataCell(
                                      Text(list.state.toString(),),
                                    ),
                                  ],
                                  ),
                              ).toList(),
                            ),
                          ),
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),

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
          setState(() {
            loading = false;
          });
        }else{
          rawGetLeaddata = GetLeaddata.fromJson(jsonDecode(responce.body));
          for (int i = 0 ; i <rawGetLeaddata.result!.length;i++ ){
            secScreendata.add(Screendata(
                rawGetLeaddata.result![i].docNo,
                rawGetLeaddata.result![i].cardName,
                rawGetLeaddata.result![i].mobileNo,
                rawGetLeaddata.result![i].contactPerson,
                rawGetLeaddata.result![i].contactPersonPosition,
                rawGetLeaddata.result![i].email,
                rawGetLeaddata.result![i].streetName,
                rawGetLeaddata.result![i].landMark,
                rawGetLeaddata.result![i].district,
                rawGetLeaddata.result![i].state,
                rawGetLeaddata.result![i].officeNo,
                rawGetLeaddata.result![i].docDate,
                rawGetLeaddata.result![i].createBy)
            );

          }

        }

        loading = false;
      });

    } else {
      log("Somthing Worng Kindly Check Network...");
    }
  }

}


class Screendata {
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

  Screendata(
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
        this.createBy);


}


