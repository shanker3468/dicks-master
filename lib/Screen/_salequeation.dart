// ignore_for_file: must_be_immutable, deprecated_member_use, unnecessary_null_comparison, prefer_typing_uninitialized_variables, non_constant_identifier_names
import 'dart:convert';
import 'dart:developer';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dicks/AppConstants.dart';
import 'package:dicks/Include/_appbar.dart';
import 'package:dicks/Include/_loding.dart';
import 'package:dicks/Model/CardCodeMaster.dart';
import 'package:dicks/Model/GetHsnMaster.dart';
import 'package:dicks/Model/GetItemMaster.dart';
import 'package:dicks/Model/GetLeaddata.dart';
import 'package:dicks/Model/GetLocMaster.dart';
import 'package:dicks/Model/GetSaleQuotationPage.dart';
import 'package:dicks/Model/getTaxCode.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SaleQuation extends StatefulWidget {
   SaleQuation({Key? key,required this.screenName, required this. docno, required this. formid}) : super(key: key);
  var screenName='';
  var docno='';
  int formid;


  @override
  State<SaleQuation> createState() => _SaleQuationState();
}

class _SaleQuationState extends State<SaleQuation> {

  bool loading = false;
  var sessionUseId  =   '';
  var sessionName = '';
  var sessionDeptCode = '';
  var sessionDeptName = '';
  DateTime dateTime = DateTime.now();
  TimeOfDay picked = TimeOfDay.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final TextEditingController _mobileno = TextEditingController();
  final TextEditingController _contactperson = TextEditingController();
  final TextEditingController _docno = TextEditingController();
  final TextEditingController _docdate = TextEditingController();
  final TextEditingController _netamt = TextEditingController(text:'0');
  final TextEditingController _totaltax = TextEditingController(text:'0');
  final TextEditingController _totalAmt = TextEditingController(text:'0');
  final TextEditingController _frightAmt = TextEditingController(text: '0');
  var alterleadno='';
  var alterleadname = '';
  var nextnumber='';
  String? alterItemcode='';
  String? alterItemName='';
  late GetLeaddata rawGetLeaddata;
  List<String> secleadlist = [];

  late GetItemMaster rawGetItemMaster;
  List<String> secitemmaster=[];

  late GetTaxCode rawGetTaxCode;
  List<TaxcodeList> secTaxcodeList=[];
  List<DataGridList> secDataGrid=[];
  List<DocType> secDocType = [];
  final TextEditingController _docStatus = TextEditingController();
  final TextEditingController _hscsearch = TextEditingController();
  final TextEditingController _location = TextEditingController();
  String? locationcode='';
  late CardCodeMaster rawCardCodeMaster;
  List<String> seccardcode=[];

  late GetHsnMaster rawGetHsnMaster;
  List<String> sechsncode=[];

  late GetLocMaster rawGetLocMaster;
  List<LocationList> secLocationList=[];
  List<SendDetailsList> sendlinelist=[];

  String saveddocno='';
  bool leadlayout=false;
  bool customerlayout = false;

  late GetSaleQuotationPage rawGetSaleQuotationPage;


  @override
  void initState() {
    // TODO: implement initState
    setState(() {

      log("From ID Is - ${widget.formid}");
      _docdate.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
       leadlayout=true;
      _docStatus.text ='Lead';
        if(widget.docno=="0"){
          secDocType.addAll([
            DocType("L","Lead"),
            DocType("C","Customer"),
          ]);
        }else{

        }

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
                      height: height/12,
                      width: width,
                      margin: EdgeInsets.all(height/200),
                      child: MyAppBar(screenName:widget.screenName),
                    ),
                     Padding(
                       padding: EdgeInsets.symmetric(horizontal: height/60),
                       child: Material(
                         elevation: 2.0,
                         borderRadius: BorderRadius.all(Radius.circular(height/10)),
                         child: SizedBox(
                           width: width/1.1,
                           child: TextField(
                             controller: _location,
                             cursorColor: Colors.blue,
                             readOnly: true,
                             keyboardType: TextInputType.text,
                             decoration: InputDecoration(
                                 labelText: "Select Location",
                                 hintText: "Select Location",
                                 prefixIcon: Material(
                                   elevation: 0,
                                   borderRadius: BorderRadius.all(Radius.circular(height/15)),
                                   child: const Icon(
                                     Icons.account_circle_outlined,
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
                                       title: TextField(
                                         controller: _hscsearch,
                                         cursorColor: Colors.blue,
                                         keyboardType: TextInputType.number,
                                         decoration: InputDecoration(
                                             labelText: "Search here...",
                                             hintText: "Search here...",
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
                                         onChanged: (vv){
                                           setState(() {
                                             sechsncode.clear();
                                             for(int i=0;i<rawGetHsnMaster.result!.length;i++){
                                               if(rawGetHsnMaster.result![i].chapter.toString().contains(vv.toString())){
                                                 sechsncode.add(rawGetHsnMaster.result![i].chapter.toString());
                                               }
                                             }
                                           });
                                         },
                                       ),
                                       content: SizedBox(
                                         width: double.minPositive,
                                         child: ListView.builder(
                                           shrinkWrap: true,
                                           itemCount: secLocationList.length,

                                           itemBuilder: (BuildContext context, int index) {
                                             return ListTile(
                                               title: Text(secLocationList[index].location.toString()),
                                               onTap: () {
                                                 setState(() {
                                                   _location.text = secLocationList[index].location.toString();
                                                   locationcode = secLocationList[index].code.toString();

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
                     ),
                     SizedBox(height: height/100,),
                     Padding(
                       padding: EdgeInsets.symmetric(horizontal: height/60),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
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
                                                      if(secDocType[index].id.toString()=="L"){
                                                        customerlayout=false;
                                                        leadlayout=true;
                                                        alterleadno = "";
                                                        alterleadname = "";
                                                        _contactperson.text='';
                                                        _mobileno.text='';

                                                      }else{
                                                        leadlayout=false;
                                                        customerlayout=true;
                                                        alterleadno = "";
                                                        alterleadname = "";
                                                        _contactperson.text='';
                                                        _mobileno.text='';

                                                      }

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
                           Visibility(
                             visible: leadlayout,
                             child: Material(
                               elevation: 2.0,
                               borderRadius: BorderRadius.all(Radius.circular(height/10)),
                               child: SizedBox(
                                 height: height/15,
                                 width: width/2.2,
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
                           Visibility(
                             visible: customerlayout,
                             child: Material(
                               elevation: 2.0,
                               borderRadius: BorderRadius.all(Radius.circular(height/10)),
                               child: SizedBox(
                                 height: height/15,
                                 width: width/2.2,
                                 child: DropdownSearch<String>(
                                   mode: Mode.DIALOG,
                                   showSearchBox: true,
                                   items: seccardcode,
                                   hint: 'Select Customer',
                                   label: 'Select Customer',
                                   dropdownSearchDecoration: InputDecoration(
                                       enabled: false,
                                       enabledBorder: InputBorder.none,
                                       contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/60)
                                   ),
                                   onChanged: (val) {
                                     log(val.toString());
                                     for (int kk = 0; kk < rawCardCodeMaster.result!.length; kk++) {
                                       setState(() {
                                         if (rawCardCodeMaster.result![kk].cardName.toString()== val) {
                                           // log(rawGetStateMaster.data![kk].docEntry.toString());
                                           alterleadno = rawCardCodeMaster.result![kk].cardCode.toString();
                                           alterleadname = rawCardCodeMaster.result![kk].cardName.toString();
                                           _mobileno.text = '';
                                           _contactperson.text = '';
                                         }
                                        // log(alterleadname);
                                       });
                                     }
                                   },
                                   selectedItem: alterleadname,
                                 ),
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                     SizedBox(height: height/100,),
                     Padding(
                       padding: EdgeInsets.symmetric(horizontal: height/80),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Material(
                             elevation: 2.0,
                             borderRadius: BorderRadius.all(Radius.circular(height/10)),
                             child: SizedBox(
                               width: width/2.2,
                               child: TextField(
                                 controller: _contactperson,
                                 readOnly: false,
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
                                     contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/70)),
                               ),
                             ),
                           ),
                           Material(
                             elevation: 2.0,
                             borderRadius: BorderRadius.all(Radius.circular(height/10)),
                             child: SizedBox(
                               width: width/2.1,
                               child: TextField(
                                 controller: _mobileno,
                                 cursorColor: Colors.blue,
                                 readOnly: false,
                                 keyboardType: TextInputType.text,
                                 decoration: InputDecoration(
                                     labelText: "Cus Ref",
                                     hintText: "Cus Ref",
                                     prefixIcon: Material(
                                       elevation: 0,
                                       borderRadius: BorderRadius.all(Radius.circular(height/15)),
                                       child: const Icon(
                                         Icons.account_circle_outlined,
                                         color: Colors.blue,
                                       ),
                                     ),
                                     border: InputBorder.none,
                                     contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/70)),
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                     SizedBox(height: height/100,),
                     Padding(
                       padding: EdgeInsets.symmetric(horizontal: height/80),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Material(
                             elevation: 2.0,
                             borderRadius: BorderRadius.all(Radius.circular(height/10)),
                             child: SizedBox(
                               width: width/2.2,
                               child: TextField(
                                 controller: _docno,
                                 readOnly: true,
                                 cursorColor: Colors.blue,
                                 keyboardType: TextInputType.text,
                                 decoration: InputDecoration(
                                     labelText: "DocNo",
                                     hintText: "DocNo",
                                     prefixIcon: Material(
                                       elevation: 0,
                                       borderRadius: BorderRadius.all(Radius.circular(height/15)),
                                       child: const Icon(
                                         Icons.account_circle_outlined,
                                         color: Colors.blue,
                                       ),
                                     ),
                                     border: InputBorder.none,
                                     contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/70)),
                               ),
                             ),
                           ),
                           Material(
                             elevation: 2.0,
                             borderRadius: BorderRadius.all(Radius.circular(height/10)),
                             child: SizedBox(
                               width: width/2.1,
                               child: TextField(
                                 controller: _docdate,
                                 readOnly: true,
                                 cursorColor: Colors.blue,
                                 keyboardType: TextInputType.text,
                                 decoration: InputDecoration(
                                     labelText: "DocDate",
                                     hintText: "DocDate",
                                     prefixIcon: Material(
                                       elevation: 0,
                                       borderRadius: BorderRadius.all(Radius.circular(height/15)),
                                       child: const Icon(
                                         Icons.account_circle_outlined,
                                         color: Colors.blue,
                                       ),
                                     ),
                                     border: InputBorder.none,
                                     contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/70)),
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                     SizedBox(height: height/100,),
                     Padding(
                       padding: EdgeInsets.symmetric(horizontal: height/60),
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
                               setState(() {
                                 for (int kk = 0; kk < rawGetItemMaster.result!.length; kk++) {
                                   //log(rawGetItemMaster.result![kk].itemCode.toString());
                                   setState(() {
                                     if (rawGetItemMaster.result![kk].itemName.toString() == val) {
                                       alterItemcode = rawGetItemMaster.result![kk].itemCode.toString();
                                       alterItemName = rawGetItemMaster.result![kk].itemName.toString();
                                     }
                                   });
                                 }
                                 log(alterItemcode.toString());
                                 addmytable(alterItemcode.toString(), alterItemName.toString(), 450, 1);
                               });
                             },
                             selectedItem: alterItemName,
                           ),
                         ),
                       ),
                     ),
                     SizedBox(height: height/100,),
                     SizedBox(
                       height: height/3,
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
                               DataColumn(label: Text('', style: TextStyle(color: Colors.black45),),),
                               DataColumn(label: Text('ItemName', style: TextStyle(color: Colors.black45),),),
                               DataColumn(label: Text('HsnCode', style: TextStyle(color: Colors.black45),),),
                               DataColumn(label: Text('Price', style: TextStyle(color: Colors.black45),),),
                               DataColumn(label: Text('Qty', style: TextStyle(color: Colors.black45),),),
                               DataColumn(label: Text('Amt', style: TextStyle(color: Colors.black45),),),
                               DataColumn(label: Text('TaxCode', style: TextStyle(color: Colors.black45),),),
                               DataColumn(label: Text('TaxAmt', style: TextStyle(color: Colors.black45),),),
                               DataColumn(label: Text('LineTotal', style: TextStyle(color: Colors.black45),),),

                             ],
                             rows: secDataGrid .map((list) =>
                                 DataRow(cells: [
                                   DataCell(
                                      const Icon(Icons.delete,color: Colors.red,),
                                      onTap: (){
                                        setState(() {
                                          if(widget.docno=="0"){
                                          secDataGrid.remove(list);
                                          }else{

                                          }
                                          count();
                                        });
                                      }
                                   ),
                                   DataCell(
                                     Text(list. itemname.toString(),),
                                   ),
                                   DataCell(
                                     Text(list. hsncode.toString(),),
                                     showEditIcon: true,
                                     onTap: (){
                                       setState(() {
                                         _hscsearch.text='';
                                         sechsncode.clear();
                                         for(int i=0; i <rawGetHsnMaster.result!.length;i++){
                                           sechsncode.add(rawGetHsnMaster.result![i].chapter.toString());
                                         }

                                       showDialog(
                                         context: context,
                                         builder: (BuildContext context) {
                                           //return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
                                             return AlertDialog(
                                               title: TextField(
                                                 controller: _hscsearch,
                                                 cursorColor: Colors.blue,
                                                 keyboardType: TextInputType.number,
                                                 decoration: InputDecoration(
                                                     labelText: "Search here...",
                                                     hintText: "Search here...",
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
                                                 onChanged: (vv){
                                                   setState(() {
                                                     sechsncode.clear();
                                                     for(int i=0;i<rawGetHsnMaster.result!.length;i++){
                                                       if(rawGetHsnMaster.result![i].chapter.toString().contains(vv.toString())){
                                                         sechsncode.add(rawGetHsnMaster.result![i].chapter.toString());
                                                       }
                                                     }
                                                   });
                                                 },
                                               ),
                                               content: SizedBox(
                                                 width: double.minPositive,
                                                 child: ListView.builder(
                                                   shrinkWrap: true,
                                                   itemCount: sechsncode.length,
                                                   itemBuilder: (BuildContext context, int index) {
                                                     return ListTile(
                                                       title: Text(sechsncode[index].toString()),
                                                       onTap: () {
                                                         setState(() {
                                                             //print(sechsncode[index].toString());
                                                             list.hsncode = sechsncode[index].toString();
                                                             Navigator.pop(context,);
                                                           });
                                                       },
                                                     );
                                                   },
                                                 ),
                                               ),
                                             );
                                           //},
                                         // );
                                         },
                                       );
                                       });
                                     }
                                   ),
                                   DataCell(
                                     Text(list.price.toString(),),
                                   ),
                                   DataCell(
                                     Text(list.qty.toString(),),
                                     showEditIcon: true,
                                     onTap: (){
                                       var enterMobileNo='';
                                       showDialog(
                                         context:context,
                                         builder: (BuildContext contex1) =>
                                             AlertDialog(
                                               content:TextFormField(
                                                 keyboardType:TextInputType.number,
                                                 maxLength:10,
                                                 autofocus:true,
                                                 onChanged:(vvv) {
                                                   setState(() {
                                                     enterMobileNo = vvv;
                                                   });
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

                                                               list.qty = enterMobileNo.toString();
                                                               linecount(secDataGrid.indexOf(list));

                                                               Navigator.pop(contex1,'Ok',);
                                                             });
                                                           },
                                                           child: const Text("Ok"),
                                                         ),
                                                         TextButton(
                                                           onPressed: () => Navigator.pop(contex1, 'Cancel'),
                                                           child: const Text('Cancel'),
                                                         ),
                                                       ],
                                                     ),
                                                   ],
                                                 )
                                               ],
                                             ),
                                       );
                                     }
                                   ),
                                   DataCell(
                                     Text(list.amt.toString(),),
                                   ),
                                   DataCell(
                                     Text(
                                       list.taxcode.toString(),
                                     ),
                                     showEditIcon: true,
                                     onTap: (){
                                       showDialog(
                                         context: context,
                                         builder: (BuildContext context) {
                                           return AlertDialog(
                                             title:
                                             const Text('Choose Tax'),
                                             content: SizedBox(
                                               width: double.minPositive,
                                               child: ListView.builder(
                                                 shrinkWrap: true,
                                                 itemCount: secTaxcodeList.length,
                                                 itemBuilder: (BuildContext context, int index) {
                                                   return ListTile(
                                                     title: Text(secTaxcodeList[index].code.toString()),
                                                     onTap: () {
                                                       setState(() {
                                                       list.taxcode = secTaxcodeList[index].code.toString();
                                                       list.taxper = secTaxcodeList[index].rate.toString();
                                                       linecount(secDataGrid.indexOf(list));
                                                       });
                                                       Navigator.pop(
                                                         context,
                                                       );
                                                     },
                                                   );
                                                 },
                                               ),
                                             ),
                                           );
                                         },
                                       );

                                     }
                                   ),
                                   DataCell(
                                     Text(list.taxamt.toString(),),
                                   ),
                                   DataCell(
                                     Text(list.linetotal.toString(),),
                                   ),
                                 ],
                                 ),
                             ).toList(),
                           ),
                         ),
                       ),
                     ),
                     SizedBox(height: height/100,),
                     Padding(
                       padding: EdgeInsets.symmetric(horizontal: height/80),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           SizedBox(
                             width: width/2.2,
                             height: height/17,
                           ),
                           Material(
                             elevation: 2.0,
                             borderRadius: BorderRadius.all(Radius.circular(height/10)),
                             child: SizedBox(
                               width: width/2.1,
                               height: height/17,
                               child: TextField(
                                 controller: _netamt,
                                 readOnly: true,
                                 cursorColor: Colors.blue,
                                 keyboardType: TextInputType.text,
                                 decoration: InputDecoration(
                                     labelText: "NetAmt",
                                     hintText: "NetAmt",
                                     prefixIcon: Material(
                                       elevation: 0,
                                       borderRadius: BorderRadius.all(Radius.circular(height/15)),
                                       child: const Icon(
                                         Icons.currency_rupee,
                                         color: Colors.blue,
                                       ),
                                     ),
                                     border: InputBorder.none,
                                     contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/70)),
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                     SizedBox(height: height/100,),
                     Padding(
                       padding: EdgeInsets.symmetric(horizontal: height/80),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           SizedBox(
                             width: width/2.2,
                             height: height/17,
                           ),
                           Material(
                             elevation: 2.0,
                             borderRadius: BorderRadius.all(Radius.circular(height/10)),
                             child: SizedBox(
                               width: width/2.1,
                               height: height/17,
                               child: TextField(
                                 controller: _totaltax,
                                 readOnly: true,
                                 cursorColor: Colors.blue,
                                 keyboardType: TextInputType.text,
                                 decoration: InputDecoration(
                                     labelText: "Total Tax",
                                     hintText: "Total Tax",
                                     prefixIcon: Material(
                                       elevation: 0,
                                       borderRadius: BorderRadius.all(Radius.circular(height/15)),
                                       child: const Icon(
                                         Icons.currency_rupee,
                                         color: Colors.blue,
                                       ),
                                     ),
                                     border: InputBorder.none,
                                     contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/70)),
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                     SizedBox(height: height/100,),
                     Padding(
                       padding: EdgeInsets.symmetric(horizontal: height/80),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           SizedBox(
                             width: width/2.2,
                             height: height/17,
                           ),
                           Material(
                             elevation: 2.0,
                             borderRadius: BorderRadius.all(Radius.circular(height/10)),
                             child: SizedBox(
                               width: width/2.1,
                               height: height/17,
                               child: TextField(
                                 controller: _frightAmt,
                                 //readOnly: true,
                                 cursorColor: Colors.blue,
                                 keyboardType: TextInputType.text,
                                 onChanged: (vvv){
                                   setState(() {
                                     _totalAmt.text = (double.parse(_totalAmt.text.toString())+double.parse(vvv.toString())).toString();
                                   });
                                 },
                                 decoration: InputDecoration(
                                     labelText: "Fright Amt",
                                     hintText: "Fright Amt",
                                     prefixIcon: Material(
                                       elevation: 0,
                                       borderRadius: BorderRadius.all(Radius.circular(height/15)),
                                     ),
                                     border: InputBorder.none,
                                     contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/70)),
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                     SizedBox(height: height/100,),
                     Padding(
                       padding: EdgeInsets.symmetric(horizontal: height/80),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           SizedBox(
                             width: width/2.2,
                             height: height/17,
                           ),
                           Material(
                             elevation: 2.0,
                             borderRadius: BorderRadius.all(Radius.circular(height/10)),
                             child: SizedBox(
                               width: width/2.1,
                               height: height/17,
                               child: TextField(
                                 controller: _totalAmt,
                                 readOnly: true,
                                 cursorColor: Colors.blue,
                                 keyboardType: TextInputType.text,
                                 decoration: InputDecoration(
                                     labelText: "Total Amt",
                                     hintText: "Total Amt",
                                     prefixIcon: Material(
                                       elevation: 0,
                                       borderRadius: BorderRadius.all(Radius.circular(height/15)),),
                                     border: InputBorder.none,
                                     contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/70)),
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                     SizedBox(height: height/100,),
                  ],
            ),
          ),
          persistentFooterButtons: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  heroTag: 'Total',
                  backgroundColor: Colors.white,
                  //icon: const Icon(Icons.refresh),
                  label: Text(_totalAmt.text.toString(),style: const TextStyle(color: Colors.black),),
                  onPressed: () {
                    setState(() {

                    });
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                FloatingActionButton.extended(
                  backgroundColor: Colors.red.shade700,
                  //icon: const Icon(Icons.refresh),
                  label: const Text('Cancel'),
                  heroTag: 'Cancel',
                  onPressed: () {
                    setState(() {

                    });
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                FloatingActionButton.extended(
                  backgroundColor: Colors.green.shade700,
                  heroTag: 'Save',
                  label: Text( widget.docno=="0"? 'Save':'Update'),
                  onPressed: () {
                    setState(() {
                      if(widget.docno=="0"){
                      postheader();
                      }else{
                        postheader();
                        Fluttertoast.showToast(msg: "Updation Developing going on...");
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        )
    );
  }



  addmytable(String alterItemcode, String alterItemName,price,qty) {
    double total =  double.parse(qty.toString()) *  double.parse(price.toString());
    int check=0;
    setState(() {
      for(int f=0;f<secDataGrid.length;f++){
        if(secDataGrid[f].itemcode==alterItemcode){
          check=100;
        }
      }
      if(check==100){
        Fluttertoast.showToast(msg: "This ItemCode Already Added...");
      }else{
        secDataGrid.add(DataGridList(
            0,
            alterItemcode,
            alterItemName,
            '',
            price,
            qty,
            total,
            '',
            '0',
            '0',
            total
        ));
      }
      count();
    });
  }

  linecount(index){
    setState(() {
      secDataGrid[index].amt = double.parse(secDataGrid[index].qty.toString()) * double.parse(secDataGrid[index].price.toString());
      secDataGrid[index].taxamt = double.parse(secDataGrid[index].amt.toString())* double.parse(secDataGrid[index].taxper.toString())/100;
      secDataGrid[index].linetotal =  double.parse(secDataGrid[index].amt.toString()) + double.parse(secDataGrid[index].taxamt.toString());
      count();
    });
  }

  count(){
    setState(() {
      _netamt.text='0';
       double netamt=0;
      _totaltax.text='0';
       double totaltax=0;
      _totalAmt.text='0';
       double totalAmt=0;
      _frightAmt.text='0';
      //double frightAmt=0;
      for(int i = 0 ; i < secDataGrid.length ; i++){
        netamt +=double.parse(secDataGrid[i].amt.toString()) ;
        totaltax +=double.parse(secDataGrid[i].taxamt.toString()) ;
        totalAmt +=double.parse(secDataGrid[i].linetotal.toString()) ;
      }
      _netamt.text =  netamt.toString();
      _totaltax.text =  totaltax.toString();
      _totalAmt.text =  totalAmt.toString();
    });
  }

  Future<void> getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sessionUseId  =   prefs.getString('UserID').toString();
      sessionName = prefs.getString('FirstName').toString();
      sessionDeptCode = prefs.getString('DeptCode').toString();
      sessionDeptName = prefs.getString('DeptName').toString();
      if(widget.docno=="0"){
        getNextNum();
      }else{
        getRocord();
      }
    });
  }

  Future getNextNum() async {
    setState(() {
      loading = true;
      log("Save Method.....");
    });
    var body = {
      "FromId":3,
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
    log('${AppConstants.LIVE_URL}getmaster');
    log(responce.body);
    if (responce.statusCode == 200) {
      final decode = jsonDecode(responce.body);
      log(decode['status'].toString());
      setState(()  {
        if(decode['status']==0){
          Fluttertoast.showToast(msg: "No Lead Data Create Lead");
        }else{
          setState(() {
            _docno.text = decode['result'][0]['SaleQute'].toString();
            log(nextnumber.toString());

            getLeadNumber();
          });

        }
        //loading = false;
      });
    } else {
      log("Somthing Worng Kindly Check Network...");
    }
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
      //log(decode['status'].toString());
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
        getItemMaster();
        //loading = false;
      });
    } else {
      log("Somthing Worng Kindly Check Network...");
    }
  }

  Future getRocord() async {
    setState(() {
      loading = true;
      log("Masters.....");
    });
    var body = {
      "FormID":7,
      "DocNo": widget.docno,
      "Status": "",
      "Type": "",
      "Leadno": ""
    };
    log(json.encode(body));
    var header = {"Content-Type": "application/json"};
    var responce = await http.post(
        Uri.parse('${AppConstants.LIVE_URL}getallmaster'),
        body: json.encode(body),
        headers: header);
    log('${AppConstants.LIVE_URL}getallmaster');
    log(responce.body);
    if (responce.statusCode == 200) {
      final decode = jsonDecode(responce.body);
      if(decode['status']==0){
        setState(() {
          Fluttertoast.showToast(msg: "No data");
          loading =false;
          getItemMaster();
        });
      }else {
        setState(() {
          rawGetSaleQuotationPage = GetSaleQuotationPage.fromJson(jsonDecode(responce.body));
          _location.text = rawGetSaleQuotationPage.result![0].location.toString();
          locationcode = rawGetSaleQuotationPage.result![0].locationcode.toString();
          _docStatus.text = rawGetSaleQuotationPage.result![0].docType.toString();
          alterleadno = rawGetSaleQuotationPage.result![0].leadNo.toString();
          alterleadname = rawGetSaleQuotationPage.result![0].leadName.toString();
          _contactperson.text = rawGetSaleQuotationPage.result![0].contactPerson.toString();
          _mobileno.text = rawGetSaleQuotationPage.result![0].cusRef.toString();
          _docno.text = rawGetSaleQuotationPage.result![0].docNo.toString();
          _docdate.text = rawGetSaleQuotationPage.result![0].docDate.toString();
          for(int i=0; i < rawGetSaleQuotationPage.result!.length; i++){
            secDataGrid.add(DataGridList(
                0,
                rawGetSaleQuotationPage.result![i].itemCode,
                rawGetSaleQuotationPage.result![i]. itemName,
                rawGetSaleQuotationPage.result![i]. hsnCode,
                rawGetSaleQuotationPage.result![i].price,
                rawGetSaleQuotationPage.result![i].qty,
                rawGetSaleQuotationPage.result![i].amt,
                rawGetSaleQuotationPage.result![i].taxCode,
                rawGetSaleQuotationPage.result![i].taxPer,
                rawGetSaleQuotationPage.result![i].taxAmt,
                rawGetSaleQuotationPage.result![i].lineTotal)
            );

          }


          loading =false;
          count();
          getItemMaster();
        });
      }

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
        getTaxCode();
        //loading = false;
        log(responce.body);
      });
    } else {
      log("Somthing Worng Kindly Check Network...");
    }
  }

  Future getTaxCode() async {
    setState(() {
      loading = true;
      log("Save Method.....");
    });
    var body = {
      "FromId":4,
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
            rawGetTaxCode =  GetTaxCode.fromJson(jsonDecode(responce.body));
            for(int i = 0 ; i < rawGetTaxCode.result!.length;i++){
              secTaxcodeList.add(
                  TaxcodeList(
                      rawGetTaxCode.result![i].code,
                      rawGetTaxCode.result![i].rate.toString()
                  ),
              );
            }
          });
        }
        if(widget.docno=="0"){
          getcardcode();
        }else{
          getHsnmaster();
        }
      });
    } else {
      log("Somthing Worng Kindly Check Network...");
    }
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
          getHsnmaster();
        });
      }
    } else {
      log("Somthing Worng Kindly Check Network...");
    }
  }

  Future getHsnmaster() async {
    setState(() {
      loading = true;
      log("Masters.....");
    });
    var body = {
      "FormID":2,
      "DocNo": "",
      "Status": "",
      "Type": "",
      "Leadno": ""
    };
    log(json.encode(body));
    var header = {"Content-Type": "application/json"};
    var responce = await http.post(
        Uri.parse('${AppConstants.LIVE_URL}getallmaster'),
        body: json.encode(body),
        headers: header);
    log('${AppConstants.LIVE_URL}getallmaster');
    log(responce.body);
    if (responce.statusCode == 200) {
      final decode = jsonDecode(responce.body);
      if(decode['status']==0){
        Fluttertoast.showToast(msg: "No data");
      }else {
        setState(() {
          rawGetHsnMaster = GetHsnMaster.fromJson(jsonDecode(responce.body));
          for(int i=0; i <rawGetHsnMaster.result!.length;i++){
            sechsncode.add(rawGetHsnMaster.result![i].chapter.toString());
          }
          if(widget.docno=="0"){
          getLocmaster();
          }else{
            setState(() {
              log("No Location Load");
              loading = false;
            });
          }
        });
      }
    } else {
      log("Somthing Worng Kindly Check Network...");
    }
  }

  Future getLocmaster() async {
    setState(() {
      loading = true;
      log("Masters.....");
    });
    var body = {
      "FormID":3,
      "DocNo": "",
      "Status": "",
      "Type": "",
      "Leadno": ""
    };
    log(json.encode(body));
    var header = {"Content-Type": "application/json"};
    var responce = await http.post(
        Uri.parse('${AppConstants.LIVE_URL}getallmaster'),
        body: json.encode(body),
        headers: header);
    log('${AppConstants.LIVE_URL}getallmaster');
    log(responce.body);
    if (responce.statusCode == 200) {
      final decode = jsonDecode(responce.body);
      if(decode['status']==0){
        Fluttertoast.showToast(msg: "No data");
      }else {
        setState(() {
          rawGetLocMaster = GetLocMaster.fromJson(jsonDecode(responce.body));
          for(int i=0; i <rawGetLocMaster.result!.length;i++){
           secLocationList.add(LocationList(
               rawGetLocMaster.result![i].code,
               rawGetLocMaster.result![i].location
           ));
          }
          loading =false;
        });
      }
    } else {
      log("Somthing Worng Kindly Check Network...");
    }
  }

  Future postheader() async {
    setState(() {
      loading = true;
      log("Masters.....");
    });
    var body = {
      "FromId":widget.formid,
      "LeadNo": alterleadno,
      "LeadName": alterleadname,
      "NetAmt": double.parse(_netamt.text.toString()),
      "TotalAmt": double.parse(_totalAmt.text.toString()),
      "CreateBy": sessionUseId,
      "Status": _totaltax.text,
      "FrightAmt": double.parse(_frightAmt.text.toString()),
      "ContactPerson": _contactperson.text,
      "CusRef": _mobileno.text,
      "DocDate": _docdate.text,
      "Createdate": widget.docno,
      "DocType": _docStatus.text,
      "Location": locationcode
    };
    log(json.encode(body));
    var header = {"Content-Type": "application/json"};
    var responce = await http.post(
        Uri.parse('${AppConstants.LIVE_URL}insertQutheader'),
        body: json.encode(body),
        headers: header);
    log('${AppConstants.LIVE_URL}insertQutheader');
    log(responce.body);
    if (responce.statusCode == 200) {
      final decode = jsonDecode(responce.body);
        setState(() {
          loading =false;
          log(decode['result'][0]['DocNo'].toString());
          saveddocno = decode['result'][0]['DocNo'].toString();

          postline(int.parse(decode['result'][0]['DocNo'].toString()));
          log("Selva msd");
        });
    } else {
      log("Somthing Worng Kindly Check Network...");
    }
  }

  Future postline(int docNo) async {
    setState(() {
      loading = true;
      log("Masters.....");
    });
    sendlinelist.clear();
    for(int i = 0 ;i < secDataGrid.length;i++){
      sendlinelist.add(
        SendDetailsList(
            1,
            docNo ,
            secDataGrid[i].itemcode,
            double.parse(secDataGrid[i].price.toString()) ,
            double.parse(secDataGrid[i].qty.toString()),
            double.parse(secDataGrid[i].amt.toString()),
            secDataGrid[i].taxcode.toString(),
            double.parse(secDataGrid[i].taxper.toString()),
            double.parse(secDataGrid[i].taxamt.toString()),
            double.parse(secDataGrid[i].linetotal.toString()),
            secDataGrid[i].hsncode.toString()
        ),);
    }
    var header = {"Content-Type": "application/json"};
    var responce = await http.post(
        Uri.parse('${AppConstants.LIVE_URL}insertQutLine'),
        body: jsonEncode(sendlinelist),
        //body: json.encode(body),
        headers: header);
    log('${AppConstants.LIVE_URL}insertQutLine');
    log(responce.body);
    if (responce.statusCode == 200) {
      setState(() {
        loading =false;
        AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            animType: AnimType.SCALE,
            headerAnimationLoop: true,
            title: docNo.toString(),
            desc: 'Sales Quotation Saved..',
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


class TaxcodeList {
  String? code;
  var  rate;
  TaxcodeList(this.code, this.rate);
}

class DocType {
  var id;
  var Status;
  DocType(this.id,this.Status);
}

class DataGridList {
  var sno;
  var itemcode;
  var itemname;
  var hsncode;
  var price;
  var qty;
  var amt;
  var taxcode;
  var taxper;
  var taxamt;
  var linetotal;
  DataGridList(this.sno,this.itemcode,this.itemname,this.hsncode,this.price,this.qty,this.amt,this.taxcode,
      this.taxper,this.taxamt,this.linetotal);
}

class LocationList {
  int? code;
  String? location;
  LocationList(this.code, this.location);
}

class SendDetailsList {
  int? FromId;
  int? DocNo;
  var ItemCode;
  double? Price;
  double? Qty;
  double? Amt;
  var TaxCode;
  double? TaxPer;
  double? TaxAmt;
  double? LineTotal;
  var HsnCode;

  SendDetailsList(
      this.FromId,
      this.DocNo,
      this.ItemCode,
      this.Price,
      this.Qty,
      this.Amt,
      this.TaxCode,
      this.TaxPer,
      this.TaxAmt,
      this.LineTotal,
      this.HsnCode,);

  SendDetailsList.fromJson(Map<String, dynamic> json) {
    FromId = json['FromId'];
    DocNo = json['DocNo'];
    ItemCode = json['ItemCode'];
    Price = json['Price'];
    Qty = json['Qty'];
    Amt = json['Amt'];
    TaxCode = json['TaxCode'];
    TaxPer = json['TaxPer'];
    TaxAmt = json['TaxAmt'];
    LineTotal = json['LineTotal'];
    HsnCode = json['HsnCode'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['FromId'] = FromId;
    data['DocNo'] = DocNo;
    data['ItemCode'] = ItemCode;
    data['Price'] = Price;
    data['Qty'] = Qty;
    data['Amt'] = Amt;
    data['TaxCode'] = TaxCode;
    data['TaxPer'] = TaxPer;
    data['TaxAmt'] = TaxAmt;
    data['LineTotal'] = LineTotal;
    data['HsnCode'] = HsnCode;

    return data;
  }
}


