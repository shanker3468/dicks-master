// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'dart:developer';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dicks/AppConstants.dart';
import 'package:dicks/Include/_appbar.dart';
import 'package:dicks/Include/_loding.dart';
import 'package:dicks/Model/CardCodeMaster.dart';
import 'package:dicks/Model/LeadMasters.dart';
import 'package:dicks/Model/SalesOrdersModel.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class SalesOrdersReport extends StatefulWidget {
  SalesOrdersReport({Key? key, required this. screenName}) : super(key: key);
  var screenName='';

  @override
  State<SalesOrdersReport> createState() => _SalesOrdersReportState();
}

class _SalesOrdersReportState extends State<SalesOrdersReport> {


  bool loading = false;
  var sessionUseId  =   '';
  var sessionName = '';
  var sessionDeptCode = '';
  var sessionDeptName = '';

final TextEditingController _docStatus = TextEditingController(text: 'Open');
  final TextEditingController _fromdate = TextEditingController();
  final TextEditingController _todate = TextEditingController();
  late CardCodeMaster rawCardCodeMaster;

  List<String> seccardcode=[];

  late SalesOrdersModel rawSalesOrdersModel;
  List<ScreenData> secScreenData=[];


  var altrecardcode = '';
  var altrecardname = '';
  List<DocType> secDocType = [];

var DocStatus='O';

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      String finalDate = '';
      final now = DateTime.now();
      var date = DateTime(now.year, now.month, 1).toString();
      var dateParse = DateTime.parse(date);
      var formattedDate = "${dateParse.month}/${dateParse.day}/${dateParse.year}";
      finalDate = formattedDate.toString() ;
      _fromdate.text = finalDate;
      _todate.text = DateFormat('MM/dd/yyyy').format(DateTime.now());
      getStringValuesSF();
      secDocType.addAll([
        DocType("","All"),
        DocType("O","Open"),
      ]);
    });
    super.initState();
  }


  _selectToDate(BuildContext context,fromid) async {
    var picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        if (fromid == 1) {
          setState(() {
            _fromdate.text = DateFormat('MM/dd/yyyy').format(picked);
          });
        } else if (fromid == 2) {
          setState(() {
            _todate.text = DateFormat('MM/dd/yyyy').format(picked);
          });
        }
      });
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(height/10)),
                      child: SizedBox(
                        height: height/17,
                        width: width/2.2,
                        child: DropdownSearch<String>(
                          mode: Mode.DIALOG,
                          showSearchBox: true,
                          items: seccardcode,
                          hint: 'Search CardName',
                          label: 'Search CardName',
                          dropdownSearchDecoration: InputDecoration(
                              enabled: false,
                              enabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/60)
                          ),
                          onChanged: (val) {
                            log(val.toString());
                            for (int kk = 0; kk < rawCardCodeMaster.result!.length; kk++) {
                              setState(() {
                                if (rawCardCodeMaster.result![kk].cardName.toString() == val) {
                                   log(rawCardCodeMaster.result![kk].cardCode.toString());
                                  altrecardcode = rawCardCodeMaster.result![kk].cardCode.toString();
                                  altrecardname = rawCardCodeMaster.result![kk].cardName.toString();

                                }

                              });
                            }
                          },
                          selectedItem: altrecardname,
                        ),
                      ),
                    ),
                    Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(height/10)),
                      child: SizedBox(
                        width: width/2.2,
                        child: TextField(
                          controller: _docStatus,
                          readOnly: true,
                          cursorColor: Colors.blue,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: "DocStatus",
                              hintText: "DocStatus",
                              prefixIcon: Material(
                                elevation: 0,
                                borderRadius: BorderRadius.all(Radius.circular(height/15)),
                                child: const Icon(
                                  Icons.search,
                                  color: Colors.blue,
                                ),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/70)),
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                  const Text('Choose Status Type..'),
                                  content: SizedBox(
                                    width: double.minPositive,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: secDocType.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return ListTile(
                                          title: Text(secDocType[index].Status),
                                          onTap: () {
                                            setState(() {
                                              _docStatus.text = secDocType[index].Status.toString();
                                              DocStatus = secDocType[index].id.toString();

                                              getSalesOrderRecord(DocStatus);


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
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height/100,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(height/10)),
                      child: SizedBox(
                        width: width/2.1,
                        child: TextField(
                          controller: _fromdate,
                          readOnly: true,
                          cursorColor: Colors.blue,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: "From Date - MM/DD/YYYY",
                              hintText: "From Date - MM/DD/YYYY",
                              prefixIcon: Material(elevation: 0, borderRadius: BorderRadius.all(Radius.circular(height/15)),
                                child: const Icon(Icons.date_range, color: Colors.blue,),), border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/70)),
                          onTap: (){
                            setState(() {
                              _selectToDate(context, 1);
                            });

                          },
                        ),
                      ),
                    ),
                    Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(height/10)),
                      child: SizedBox(
                        width: width/2.1,
                        child: TextField(
                          controller: _todate,
                          readOnly: true,
                          cursorColor: Colors.blue,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: "To Date - MM/DD/YYYY",
                              hintText: "To Date - MM/DD/YYYY ",
                              prefixIcon: Material(
                                elevation: 0,
                                borderRadius: BorderRadius.all(Radius.circular(height/15)),
                                child: const Icon(Icons.date_range, color: Colors.blue,),),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/70)),
                          onTap: (){
                            setState(() {
                              _selectToDate(context, 2);
                            });

                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height/100,),
                SizedBox(
                  height: height/1.6,
                  width: width/1.1,
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
                          DataColumn(label: Text('DocDate', style: TextStyle(color: Colors.black45),),),
                          DataColumn(label: Text('CardName', style: TextStyle(color: Colors.black45),),),
                          DataColumn(label: Text('NumAtCard', style: TextStyle(color: Colors.black45),),),
                          DataColumn(label: Text('Dscription', style: TextStyle(color: Colors.black45),),),
                          DataColumn(label: Text('Quantity', style: TextStyle(color: Colors.black45),),),
                          DataColumn(label: Text('Price', style: TextStyle(color: Colors.black45),),),
                          DataColumn(label: Text('TaxCode', style: TextStyle(color: Colors.black45),),),
                          DataColumn(label: Text('DocTotal', style: TextStyle(color: Colors.black45),),),

                        ],
                        rows: secScreenData .map((list) =>
                            DataRow(cells: [

                              DataCell(
                                Text(list. docDate.toString(),),
                              ),
                              DataCell(
                                Text(list.cardName.toString(),),
                              ),
                              DataCell(
                                  Text(list.numAtCard.toString(),),

                              ),
                              DataCell(
                                Text(list.dscription.toString(),),
                              ),
                              DataCell(
                                  Text(
                                    list.quantity.toString(),
                                  ),

                              ),
                              DataCell(
                                Text(list.price.toString(),),
                              ),
                              DataCell(
                                Text(list.taxCode.toString(),),
                              ),
                              DataCell(
                                Text(list.taxCode.toString(),),
                              ),
                            ],
                            ),
                        ).toList(),
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
                Visibility(
                  child: FloatingActionButton.extended(
                    backgroundColor: Colors.green.shade700,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                    onPressed: () {
                      setState(() {
                        log(secScreenData.length.toString());
                        getSalesOrderRecord("");
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
      getcardcode();

    });
  }




  Future getcardcode() async {
    setState(() {
      loading = true;
      log("Masters.....");
    });
    var body = {
      "FromId":"1",
      "CardCode":""
    };
    log(json.encode(body));
    var header = {"Content-Type": "application/json"};
    var responce = await http.post(
        Uri.parse('${AppConstants.LIVE_URL}getcardcode'),
        body: json.encode(body),
        headers: header);
    log('${AppConstants.LIVE_URL}getcardcode');
    //log(responce.body);
    if (responce.statusCode == 200) {
      final decode = jsonDecode(responce.body);
      if(decode['status']==0){
        Fluttertoast.showToast(msg: "No data");
      }else {
        setState(() {
          rawCardCodeMaster = CardCodeMaster.fromJson(jsonDecode(responce.body));
          for(int i=0;i<rawCardCodeMaster.result!.length;i++){
            seccardcode.add(rawCardCodeMaster.result![i].cardName.toString());
          }
          loading =false;
          getSalesOrderRecord("O");
        });
      }



    } else {
      log("Somthing Worng Kindly Check Network...");
    }
  }

  Future getSalesOrderRecord(Status) async {
    setState(() {
      loading = true;
      secScreenData.clear();
      log("Masters.....");
    });
    var body = {
      "FromId":1,
      "Status":Status,
      "CardCode":altrecardcode,
      "Fromdate": _fromdate.text,
      "Todate" :_todate.text
    };
    log(json.encode(body));
    var header = {"Content-Type": "application/json"};
    var responce = await http.post(
        Uri.parse('${AppConstants.LIVE_URL}getsaleorder'),
        body: json.encode(body),
        headers: header);
    log('${AppConstants.LIVE_URL}getsaleorder');
    //log(responce.body);
    if (responce.statusCode == 200) {
      final decode = jsonDecode(responce.body);
      if(decode['status']==0){
        setState(() {
          Fluttertoast.showToast(msg: "No data");
          loading =false;
        });
      }else {
        setState(() {
          rawSalesOrdersModel = SalesOrdersModel.fromJson(jsonDecode(responce.body));
          for(int i=0;i<rawSalesOrdersModel.result!.length;i++){
            secScreenData.add(ScreenData(
                rawSalesOrdersModel.result![i].docNum,
                rawSalesOrdersModel.result![i].docStatus,
                rawSalesOrdersModel.result![i].docDate,
                rawSalesOrdersModel.result![i].cardCode,
                rawSalesOrdersModel.result![i].cardName,
                rawSalesOrdersModel.result![i].numAtCard,
                rawSalesOrdersModel.result![i].docCur,
                rawSalesOrdersModel.result![i].lineNum,
                rawSalesOrdersModel.result![i].itemCode,
                rawSalesOrdersModel.result![i].dscription,
                rawSalesOrdersModel.result![i].quantity,
                rawSalesOrdersModel.result![i].price,
                rawSalesOrdersModel.result![i].whsCode,
                rawSalesOrdersModel.result![i].acctCode,
                rawSalesOrdersModel.result![i].taxCode,
                rawSalesOrdersModel.result![i].docTotal)
            );

          }
          loading =false;
        });
      }

    } else {
      log("Somthing Worng Kindly Check Network...");
    }
  }


}

class DocType {
  var id;
  var Status;
  DocType(this.id,this.Status);
}

class ScreenData {
  var docNum;
  String? docStatus;
  String? docDate;
  String? cardCode;
  String? cardName;
  String? numAtCard;
  String? docCur;
  var lineNum;
  String? itemCode;
  String? dscription;
  var quantity;
  var price;
  String? whsCode;
  String? acctCode;
  String? taxCode;
  var docTotal;

  ScreenData(
      this.docNum,
        this.docStatus,
        this.docDate,
        this.cardCode,
        this.cardName,
        this.numAtCard,
        this.docCur,
        this.lineNum,
        this.itemCode,
        this.dscription,
        this.quantity,
        this.price,
        this.whsCode,
        this.acctCode,
        this.taxCode,
        this.docTotal);

}
