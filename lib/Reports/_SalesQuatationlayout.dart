// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, non_constant_identifier_names
import 'dart:convert';
import 'dart:developer';
import 'package:dicks/AppConstants.dart';
import 'package:dicks/Include/_appbar.dart';
import 'package:dicks/Include/_loding.dart';
import 'package:dicks/Model/GetSaleQuotationDetails.dart';
import 'package:dicks/Model/GetSaleTaxPdf.dart';
import 'package:dicks/Model/GetSalesQuotationLayout.dart';
import 'package:dicks/Model/GetSalesQuotationNumber.dart';
import 'package:dicks/Screen/_salequeation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class SalesQuotationLayOut extends StatefulWidget {
  SalesQuotationLayOut({Key? key, required this. screenName}) : super(key: key);
  var screenName='';

  @override
  State<SalesQuotationLayOut> createState() => _SalesQuotationLayOutState();
}

class _SalesQuotationLayOutState extends State<SalesQuotationLayOut> {


  bool loading = false;
  var sessionUseId  =   '';
  var sessionName = '';
  var sessionDeptCode = '';
  var sessionDeptName = '';

  late GetSalesQuotationNumber rawGetSalesQuotationNumber;
  List<ScreenListData> secScreenListData=[];

  late GetSalesQuotationLayout rawGetSalesQuotationLayout;
  List<ScreenData> secScreenData=[];

  late GetSaleQuotationDetails rawGetSaleQuotationDetails;
  List<SalesDetails> secSalesDetails=[];

  late GetSaleTaxPdf rawGetSaleTaxPdf;
  List<SalesTax> secSalesTax=[];


  var salelayout =  true;
  var saledetailslayout=false;


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
          body: loading? const LodingPage() :SingleChildScrollView(
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
                      child: salelayout?
                      ListView.builder(
                        itemCount: secScreenListData.length,
                        itemBuilder: (BuildContext context1, int index) {
                          return Card(
                            child: ListTile(
                              title: Column(
                                children: [
                                  SizedBox(
                                    width: width,
                                    child: Text(
                                      secScreenListData[index].leadName.toString(),
                                      style: const TextStyle(color: Colors.purpleAccent,fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                  SizedBox(
                                    width: width,
                                    child: Text(
                                        "Total : "+secScreenListData[index].lineTotal.toString(),
                                        style: const TextStyle(color: Colors.black45,fontWeight: FontWeight.w500)
                                    ),
                                  ),
                                ],
                              ),
                              dense: true,
                              leading: CircleAvatar(
                                backgroundColor:Colors.blueAccent,
                                child: Text(secScreenListData[index].docNo.toString(),
                                  style: TextStyle(color: Colors.white,fontSize: height/80),),
                              ),
                              trailing: InkWell(
                                onTap: (){
                                  getPDFrecord(secScreenListData[index].docNo.toString()).then((value) => {
                                    getPDFrecordTax(secScreenListData[index].docNo.toString()).then((value) => {
                                      generatepdf(height,width),
                                    }
                                    ),
                                  });
                                },
                                child: const CircleAvatar(
                                  backgroundColor:Colors.white,
                                  child: Icon(Icons.picture_as_pdf),
                                ),
                              ),
                              onTap: (){
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) =>
                                        SaleQuation(
                                            screenName:"Sales Quotation",
                                            docno:secScreenListData[index].docNo.toString(),
                                            formid :2
                                        ),
                                    ),
                                  );
                                });
                              },
                            ),
                          );
                        },
                      ) :SingleChildScrollView(
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
                              DataColumn(label: Text('S.No', style: TextStyle(color: Colors.black45),),),
                              DataColumn(label: Text('DocNo', style: TextStyle(color: Colors.black45),),),
                              DataColumn(label: Text('CardName', style: TextStyle(color: Colors.black45),),),
                              DataColumn(label: Text('ItemName', style: TextStyle(color: Colors.black45),),),
                              DataColumn(label: Text('UOM', style: TextStyle(color: Colors.black45),),),
                              DataColumn(label: Text('Price', style: TextStyle(color: Colors.black45),),),
                              DataColumn(label: Text('Qty', style: TextStyle(color: Colors.black45),),),
                              DataColumn(label: Text('NetAmt', style: TextStyle(color: Colors.black45),),),
                              DataColumn(label: Text('TaxCode', style: TextStyle(color: Colors.black45),),),
                              DataColumn(label: Text('LineTotal', style: TextStyle(color: Colors.black45),),),

                            ],
                            rows: secSalesDetails .map((list) =>
                                DataRow(cells: [
                                  DataCell(
                                      Text(secSalesDetails.indexOf(list).toString())
                                  ),
                                  DataCell(
                                    Text(list.docNo.toString(),),
                                  ),
                                  DataCell(
                                      Text(list. leadName.toString(),),

                                  ),
                                  DataCell(
                                    Text(list.itemName.toString(),),
                                  ),
                                  DataCell(
                                      Text(list.invntryUom.toString(),),
                                  ),
                                  DataCell(
                                    Text(list.price.toString(),),
                                  ),
                                  DataCell(
                                      Text(
                                        list.qty.toString(),
                                      ),
                                  ),
                                  DataCell(
                                    Text(list.amt.toString(),),
                                  ),
                                  DataCell(
                                    Text(list.taxCode.toString(),),
                                  ),
                                  DataCell(
                                    Text(list.lineTotal.toString(),),
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
          persistentFooterButtons: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  backgroundColor: Colors.pinkAccent,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Quotation Details'),
                  onPressed: () {
                    setState(() {
                      getsalesdetails();
                    });
                  },
                ),
                const SizedBox(width: 2,),
                FloatingActionButton.extended(
                  backgroundColor: Colors.green.shade700,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Quotation'),
                  onPressed: () {
                    setState(() {
                      getallmaster();
                      //generatepdf(height,width);
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
      getallmaster();
    });
  }

  Future getallmaster() async {
    setState(() {
      loading = true;
      salelayout =  true;
      saledetailslayout=false;
      secScreenListData.clear();
      log("Masters.....");
    });
    var body = {
      "FormID":4,
      "DocNo": sessionUseId,
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
        });
      }else {
        setState(() {
          rawGetSalesQuotationNumber = GetSalesQuotationNumber.fromJson(jsonDecode(responce.body));
          for(int i = 0 ; i<rawGetSalesQuotationNumber.result!.length;i++){
            secScreenListData.add(
                ScreenListData(
                    rawGetSalesQuotationNumber.result![i].docNo,
                    rawGetSalesQuotationNumber.result![i].leadName,
                    rawGetSalesQuotationNumber.result![i].lineTotal)
            );
          }
          loading =false;
        });
      }

    } else {
      log("Somthing Worng Kindly Check Network...");
    }
  }

  Future getsalesdetails() async {
    setState(() {
      loading = true;
      salelayout = false;
      saledetailslayout=true;
      secSalesDetails.clear();
      log("Masters.....");
    });
    var body = {
      "FormID":6,
      "DocNo": sessionUseId,
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
        });
      }else {
        setState(() {
          rawGetSaleQuotationDetails = GetSaleQuotationDetails.fromJson(jsonDecode(responce.body));
          for(int i=0; i < rawGetSaleQuotationDetails.result!.length;i++){
            secSalesDetails.add(SalesDetails(
                rawGetSaleQuotationDetails.result![i].docNo,
                rawGetSaleQuotationDetails.result![i].leadName,
                rawGetSaleQuotationDetails.result![i].itemName,
                rawGetSaleQuotationDetails.result![i].invntryUom,
                rawGetSaleQuotationDetails.result![i].price,
                rawGetSaleQuotationDetails.result![i].qty,
                rawGetSaleQuotationDetails.result![i].amt,
                rawGetSaleQuotationDetails.result![i].taxCode,
                rawGetSaleQuotationDetails.result![i].taxAmt,
                rawGetSaleQuotationDetails.result![i].lineTotal
            ));
          }

          loading =false;
        });
      }

    } else {
      log("Somthing Worng Kindly Check Network...");
    }
  }

  Future getPDFrecord(DocNo) async {
    setState(() {
      loading = true;
      secScreenData.clear();
      log("Masters.....");
    });
    var body = {
      "FormID":5,
      "DocNo": DocNo,
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
        });
      }else {
        setState(() {
          rawGetSalesQuotationLayout = GetSalesQuotationLayout.fromJson(jsonDecode(responce.body));
          for(int i = 0 ; i<rawGetSalesQuotationLayout.result!.length;i++){
            secScreenData.add(ScreenData(
                rawGetSalesQuotationLayout.result![i].location,
                rawGetSalesQuotationLayout.result![i].street,
                rawGetSalesQuotationLayout.result![i].block,
                rawGetSalesQuotationLayout.result![i].zipCode,
                rawGetSalesQuotationLayout.result![i].panNo,
                rawGetSalesQuotationLayout.result![i].gSTRegnNo,
                rawGetSalesQuotationLayout.result![i].cardName,
                rawGetSalesQuotationLayout.result![i].billAddress,
                rawGetSalesQuotationLayout.result![i].billAddress3,
                rawGetSalesQuotationLayout.result![i].billStreet,
                rawGetSalesQuotationLayout.result![i].billCity,
                rawGetSalesQuotationLayout.result![i].billZipCode,
                rawGetSalesQuotationLayout.result![i].billGSTRegnNo,
                rawGetSalesQuotationLayout.result![i].billState,
                rawGetSalesQuotationLayout.result![i].shiftAddress,
                rawGetSalesQuotationLayout.result![i].shiftAddress3,
                rawGetSalesQuotationLayout.result![i].shiftStreet,
                rawGetSalesQuotationLayout.result![i].shiftCity,
                rawGetSalesQuotationLayout.result![i].shiftZipCode,
                rawGetSalesQuotationLayout.result![i].shiftGSTRegnNo,
                rawGetSalesQuotationLayout.result![i].shiftState,
                rawGetSalesQuotationLayout.result![i].mobileNo,
                rawGetSalesQuotationLayout.result![i].quotaNo,
                rawGetSalesQuotationLayout.result![i].docDate,
                rawGetSalesQuotationLayout.result![i].cusRef,
                rawGetSalesQuotationLayout.result![i].itemName,
                rawGetSalesQuotationLayout.result![i].uom,
                rawGetSalesQuotationLayout.result![i].hsnCode,
                rawGetSalesQuotationLayout.result![i].taxper,
                rawGetSalesQuotationLayout.result![i].qty,
                rawGetSalesQuotationLayout.result![i].price,
                rawGetSalesQuotationLayout.result![i].lineTotal,
                rawGetSalesQuotationLayout.result![i].frightamt,
                rawGetSalesQuotationLayout.result![i].netAmt,
                rawGetSalesQuotationLayout.result![i].totalAmt,
            ));
          }
        });
      }

    } else {
      log("Somthing Worng Kindly Check Network...");
    }
  }

  Future getPDFrecordTax(DocNo) async {
    setState(() {
      loading = true;
      log("Masters.....");
    });
    var body = {
      "FormID":8,
      "DocNo": DocNo,
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
          rawGetSaleTaxPdf = GetSaleTaxPdf.fromJson(jsonDecode(responce.body));
          for(int i=0; i < rawGetSaleTaxPdf.result!.length;i++){
            secSalesTax.add(SalesTax(
                rawGetSaleTaxPdf.result![i].docNo,
                rawGetSaleTaxPdf.result![i].taxCode,
                rawGetSaleTaxPdf.result![i].taxAmt,
                rawGetSaleTaxPdf.result![i].cGST,
                rawGetSaleTaxPdf.result![i].sGST,
                rawGetSaleTaxPdf.result![i].per)
            );
          }
          loading =false;
        });
      }

    } else {
      log("Somthing Worng Kindly Check Network...");
    }
  }

  Future<void>generatepdf(double height, double width) async{
    var assetImage = pw.MemoryImage((await rootBundle.load('assets/logo.png')).buffer.asUint8List(),);
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
        pageTheme: pw.PageTheme(
            buildBackground: (pw.Context context) =>
                pw.FullPage(
                    ignoreMargins: false /*, child: pw.Watermark.text("Sales Order")*/),
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(10.0)),
        build: (pw.Context context) {
          return [
            pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start, crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  //pw.Image(image, width: 150),
                  pw.Container(
                      height: height/40,
                      width: width*2,
                      alignment: pw.Alignment.center,
                      child: pw.Text("Sales Quotation",
                        style: pw.TextStyle(fontSize: height/60,fontWeight: pw.FontWeight.bold),),
                      decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.5))
                  ),
                  pw.Container(
                      height: height/15,
                      width: width*2,
                      decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.2,color: PdfColor.fromHex("#403d3d")),left: pw.BorderSide(width: 1,color: PdfColor.fromHex("#403d3d")),right: pw.BorderSide(width: 1,color: PdfColor.fromHex("#403d3d")))),
                      child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                          children: [
                            pw.Container(
                                height: height/18,
                                width: width/3,
                                child: pw.Image(assetImage)

                            ),
                            pw.Container(
                                height: height/15,
                                width: width*1.2,
                                child: pw.Column(
                                    children: [
                                      pw.Container(
                                        width: width*1.2,
                                        alignment: pw.Alignment.center,
                                        child: pw.Text("Digital Instruments & Control Systems",style: pw.TextStyle(
                                          //color: PdfColor.fromHex("#3a3939"),
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: height/70)),
                                      ),
                                      pw.Container(
                                        width: width*1.2,
                                        alignment: pw.Alignment.center,
                                        child: pw.Text("${secScreenData[0].street}${','}${secScreenData[0].block}${','}${secScreenData[0].location}${','}${secScreenData[0].zipCode}",style: pw.TextStyle(
                                            fontSize: height/90)),
                                      ),
                                      pw.Container(
                                        width: width*1.2,
                                        alignment: pw.Alignment.center,
                                        child: pw.Text("Phone :080-23235465/080-23232773 , Email : bangalore@dicsglobal.com, PAN No : ${secScreenData[0].panNo}",style: pw.TextStyle(
                                            fontSize: height/90)),
                                      ),
                                      pw.Container(
                                        width: width*1.2,
                                        alignment: pw.Alignment.center,
                                        child: pw.Text("GSTIN : ${secScreenData[0].gSTRegnNo}",style: pw.TextStyle(
                                            fontSize: height/90)),
                                      ),
                                    ]
                                )
                            )
                          ]
                      )

                  ),
                  pw.Row(
                    children: [
                      pw.Container(
                        width: width*0.8,
                        height: height/7.5,
                        decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.2,color: PdfColor.fromHex("#403d3d")),left: pw.BorderSide(width: 1,color: PdfColor.fromHex("#403d3d")),right: pw.BorderSide(width: 0.2,color: PdfColor.fromHex("#403d3d")))),
                        child: pw.Column(
                          children: [
                            pw.Container(
                              margin: const pw.EdgeInsets.only(left: 5),
                              alignment: pw.Alignment.centerLeft,
                              child:  pw.Text("Buyer (Bill To):",style: pw.TextStyle(
                                  color: PdfColor.fromHex("#403d3d"),
                                  fontSize: height/90)),
                            ),
                            pw.Container(
                              margin: const pw.EdgeInsets.only(left: 5),
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Text("${secScreenData[0].cardName}",style: pw.TextStyle(
                                  color: PdfColor.fromHex("#3a3939"),
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: height/85)),
                            ),
                            pw.Container(
                              margin: const pw.EdgeInsets.only(left: 5),
                              alignment: pw.Alignment.centerLeft,
                              child:  pw.Text("${secScreenData[0].billAddress3}",style: pw.TextStyle(
                                  color: PdfColor.fromHex("#403d3d"),
                                  fontSize: height/90)),
                            ),
                            pw.Container(
                              margin: const pw.EdgeInsets.only(left: 5),
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Text("${secScreenData[0].billStreet}",style: pw.TextStyle(
                                  color: PdfColor.fromHex("#403d3d"),
                                  fontSize: height/90)),
                            ),
                            pw.Container(
                              margin: const pw.EdgeInsets.only(left: 5),
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Text("${secScreenData[0].billCity}${'-'}${secScreenData[0].billZipCode}",style: pw.TextStyle(
                                  color: PdfColor.fromHex("#403d3d"),
                                  fontSize: height/90)),
                            ),
                            pw.SizedBox(height: height/75),
                            pw.Container(
                              margin: const pw.EdgeInsets.only(left: 5),
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Text("Phone: ",style: pw.TextStyle(
                                  color: PdfColor.fromHex("#403d3d"),
                                  fontSize: height/90)),
                            ),
                            pw.Container(
                              margin: const pw.EdgeInsets.only(left: 5),
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Text("GSTIN: ${secScreenData[0].billGSTRegnNo}",style: pw.TextStyle(
                                  color: PdfColor.fromHex("#403d3d"),
                                  fontSize: height/90)),
                            ),
                            pw.Container(
                              margin: const pw.EdgeInsets.only(left: 5),
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Text("State Name: ${secScreenData[0].billState}",style: pw.TextStyle(
                                  color: PdfColor.fromHex("#403d3d"),
                                  fontSize: height/90)),
                            ),
                          ],
                        ),
                      ),
                      pw.Container(
                          width: width/1.5,
                          height: height/7.5,
                          decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.2,color: PdfColor.fromHex("#403d3d")),left: pw.BorderSide(width: 0.2,color: PdfColor.fromHex("#403d3d")),right: pw.BorderSide(width: 1,color: PdfColor.fromHex("#403d3d")))),
                          child: pw.Column(
                            children: [
                              pw.Row(
                                  children: [
                                    pw.Container(
                                        width: width*0.3,
                                        height: height/30,
                                        decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.2,color: PdfColor.fromHex("#403d3d")),right: pw.BorderSide(width: 0.2,color: PdfColor.fromHex("#403d3d")))),
                                        child: pw.Column(
                                            children: [
                                              pw.Text('Quotation No'),
                                              pw.Text('${secScreenData[0].quotaNo}',style: pw.TextStyle(fontSize: height/90,fontWeight:pw.FontWeight.bold))

                                            ]
                                        )
                                    ),pw.Container(
                                        width: width/2.8,
                                        height: height/30,
                                        decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.2,color: PdfColor.fromHex("#403d3d")))),
                                        child: pw.Column(
                                            children: [
                                              pw.Text('Dated'),
                                              pw.Text('${secScreenData[0].docDate}',style: pw.TextStyle(fontSize: height/90,fontWeight:pw.FontWeight.bold))

                                            ]
                                        )
                                    )]
                              ),
                              pw.Row(
                                  children: [
                                    pw.Container(
                                        width: width*0.3,
                                        height: height/30,
                                        decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.2,color: PdfColor.fromHex("#403d3d")),right: pw.BorderSide(width: 0.2,color: PdfColor.fromHex("#403d3d")))),
                                        child: pw.Column(
                                            children: [
                                              pw.Text('Other Reference(s)',style: pw.TextStyle(fontSize: height/90)),
                                              pw.Text('',style: pw.TextStyle(fontSize: height/90,fontWeight:pw.FontWeight.bold))

                                            ]
                                        )
                                    ),pw.Container(
                                        width: width/2.8,
                                        height: height/30,
                                        decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.2,color: PdfColor.fromHex("#403d3d")))),
                                        child: pw.Column(
                                            children: [
                                              pw.Text('Mode/Terms of Payment',style: pw.TextStyle(fontSize: height/90)),
                                              pw.Text('104210',style: pw.TextStyle(fontSize: height/90,fontWeight:pw.FontWeight.bold))

                                            ]
                                        )
                                    )]
                              ),
                              pw.Row(
                                  children: [
                                    pw.Container(
                                        width: width*0.3,
                                        height: height/30,
                                        decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.2,color: PdfColor.fromHex("#403d3d")),right: pw.BorderSide(width: 0.2,color: PdfColor.fromHex("#403d3d")))),
                                        child: pw.Column(
                                            children: [
                                              pw.Text('Buyers Ref /Order No',style: pw.TextStyle(fontSize: height/90)),
                                              pw.Text('${secScreenData[0].cusRef}',style: pw.TextStyle(fontSize: height/90,fontWeight:pw.FontWeight.bold))

                                            ]
                                        )
                                    ),pw.Container(
                                        width: width/2.8,
                                        height: height/30,
                                        decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.2,color: PdfColor.fromHex("#403d3d")))),
                                        child: pw.Column(
                                            children: [
                                              pw.Text('Doc Date',style: pw.TextStyle(fontSize: height/90)),
                                              pw.Text('${secScreenData[0].docDate}',style: pw.TextStyle(fontSize: height/90,fontWeight:pw.FontWeight.bold))

                                            ]
                                        )
                                    )]
                              ),
                              pw.Row(
                                  children: [
                                    pw.Container(
                                        width: width*0.3,
                                        height: height/30,
                                        decoration: pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(width: 0.2,color: PdfColor.fromHex("#403d3d")))),
                                        child: pw.Column(
                                            children: [
                                              pw.Text('Despatched Through',style: pw.TextStyle(fontSize: height/90)),
                                              pw.Text('',style: pw.TextStyle(fontSize: height/90,fontWeight:pw.FontWeight.bold))

                                            ]
                                        )
                                    ),pw.Container(
                                        width: width/2.8,
                                        height: height/30,
                                        //decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.2,color: PdfColor.fromHex("#403d3d")))),
                                        child: pw.Column(
                                            children: [
                                              pw.Text('Destination'),
                                              pw.Text('',style: pw.TextStyle(fontSize: height/90,fontWeight:pw.FontWeight.bold))

                                            ]
                                        )
                                    )]
                              ),
                            ],
                          )
                      )

                    ],
                  ),
                  pw.Row(
                    children: [
                      pw.Container(
                        width: width*0.8,
                        height: height/7.5,
                        decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.2,color: PdfColor.fromHex("#403d3d")),right: pw.BorderSide(width: 0.2,color: PdfColor.fromHex("#403d3d")),left: pw.BorderSide(width: 1,color: PdfColor.fromHex("#403d3d")))),
                        child: pw.Column(
                          children: [
                            pw.Container(
                              margin: const pw.EdgeInsets.only(left: 5),
                              alignment: pw.Alignment.centerLeft,
                              child:  pw.Text("Consignee (Ship To):",style: pw.TextStyle(
                                  color: PdfColor.fromHex("#403d3d"),
                                  fontSize: height/90)),
                            ),
                            pw.Container(
                              margin: const pw.EdgeInsets.only(left: 5),
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Text("${secScreenData[0].cardName}",style: pw.TextStyle(
                                  color: PdfColor.fromHex("#3a3939"),
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: height/85)),
                            ),
                            pw.Container(
                              margin: const pw.EdgeInsets.only(left: 5),
                              alignment: pw.Alignment.centerLeft,
                              child:  pw.Text("${secScreenData[0].shiftAddress3}",style: pw.TextStyle(
                                  color: PdfColor.fromHex("#403d3d"),
                                  fontSize: height/90)),
                            ),
                            pw.Container(
                              margin: const pw.EdgeInsets.only(left: 5),
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Text("${secScreenData[0].shiftStreet}",style: pw.TextStyle(
                                  color: PdfColor.fromHex("#403d3d"),
                                  fontSize: height/90)),
                            ),
                            pw.Container(
                              margin: const pw.EdgeInsets.only(left: 5),
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Text("${secScreenData[0].shiftCity}-${secScreenData[0].shiftZipCode}",style: pw.TextStyle(
                                  color: PdfColor.fromHex("#403d3d"),
                                  fontSize: height/90)),
                            ),
                            pw.SizedBox(height: height/75),
                            pw.Container(
                              margin: const pw.EdgeInsets.only(left: 5),
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Text("Phone: ",style: pw.TextStyle(
                                  color: PdfColor.fromHex("#403d3d"),
                                  fontSize: height/90)),
                            ),
                            pw.Container(
                              margin: const pw.EdgeInsets.only(left: 5),
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Text("GSTIN: ${secScreenData[0].shiftGSTRegnNo}",style: pw.TextStyle(
                                  color: PdfColor.fromHex("#403d3d"),
                                  fontSize: height/90)),
                            ),
                            pw.Container(
                              margin: const pw.EdgeInsets.only(left: 5),
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Text("State Name: ${secScreenData[0].shiftState}",style: pw.TextStyle(
                                  color: PdfColor.fromHex("#403d3d"),
                                  fontSize: height/90)),
                            ),
                          ],
                        ),
                      ),
                      pw.Container(
                          width: width/1.5,
                          height: height/7.5,
                          decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.2,color: PdfColor.fromHex("#403d3d")),left: pw.BorderSide(width: 0.2,color: PdfColor.fromHex("#403d3d")),right: pw.BorderSide(width: 1,color: PdfColor.fromHex("#403d3d")))),
                          child: pw.Column(
                            children: [
                              pw.Container(
                                  width: width*0.3,
                                  height: height/30,
                                  child: pw.Column(
                                      children: [
                                        pw.Text('Terms of Delivery',style: pw.TextStyle(fontSize: height/90)),
                                        pw.Text('Delivery: Immediate.',style: pw.TextStyle(fontSize: height/90))

                                      ]
                                  )
                              ),
                            ],
                          )
                      )

                    ],
                  ),



                  pw.SizedBox(
                      height: 5
                  ),
                  pw.Text("Mobile No :",
                      style: const pw.TextStyle(fontSize: 12)),
                  // pw.SizedBox(width: 10, height: 10),
                ]),
            pw.SizedBox(
                height: 5
            ),
            pw.Table(
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              border: pw.TableBorder.all(
                  width: 1, color: PdfColor.fromHex("b5b5b5")),
              children: [
                pw.TableRow(
                    decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex("f42b1b")),
                    children: [
                      pw.Expanded(
                          flex: 1,
                          child: pw.Text(
                              "S.No",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(color: PdfColor.fromHex(
                                  "ffffff"), fontSize: 10)
                          )),

                      pw.Expanded(
                          flex: 4,
                          child: pw.Container(
                              alignment: pw.Alignment.centerLeft,
                              padding: const pw.EdgeInsets.only(left: 5),
                              child: pw.Text(
                                  "Item Name",
                                  textAlign: pw.TextAlign.left, style: pw
                                  .TextStyle(
                                  color: PdfColor.fromHex("ffffff"),
                                  fontSize: 10)
                              ))),
                      pw.Expanded(
                          flex: 2,
                          child: pw.Container(
                              alignment: pw.Alignment.center,
                              // padding: pw.EdgeInsets.only(right: 5),
                              child: pw.Text(
                                  "HSN/ SAC",
                                  textAlign: pw.TextAlign.center, style: pw
                                  .TextStyle(
                                  color: PdfColor.fromHex("ffffff"),
                                  fontSize: 10)
                              ))), pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                              alignment: pw.Alignment.center,
                              // padding: pw.EdgeInsets.only(right: 5),
                              child: pw.Text(
                                  "GST %",
                                  textAlign: pw.TextAlign.center, style: pw
                                  .TextStyle(
                                  color: PdfColor.fromHex("ffffff"),
                                  fontSize: 10)
                              ))),
                      pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                              alignment: pw.Alignment.center,
                              // padding: pw.EdgeInsets.only(right: 5),
                              child: pw.Text(
                                  "Qty",
                                  textAlign: pw.TextAlign.center, style: pw
                                  .TextStyle(
                                  color: PdfColor.fromHex("ffffff"),
                                  fontSize: 10)
                              ))),
                      pw.Expanded(
                          flex: 2,
                          child: pw.Container(
                              alignment: pw.Alignment.center,
                              // padding: pw.EdgeInsets.only(right: 5),
                              child: pw.Text(
                                  "Rate",
                                  textAlign: pw.TextAlign.center, style: pw
                                  .TextStyle(
                                  color: PdfColor.fromHex("ffffff"),
                                  fontSize: 10)
                              ))),
                       pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                              alignment: pw.Alignment.center,
                              // padding: pw.EdgeInsets.only(right: 5),
                              child: pw.Text(
                                  "Per",
                                  textAlign: pw.TextAlign.center, style: pw
                                  .TextStyle(
                                  color: PdfColor.fromHex("ffffff"),
                                  fontSize: 10)
                              ))),
                      pw.Expanded(
                          flex: 2,
                          child: pw.Container(
                              alignment: pw.Alignment.center,
                              // padding: pw.EdgeInsets.only(right: 5),
                              child: pw.Text(
                                  "Amount INR",
                                  textAlign: pw.TextAlign.center, style: pw
                                  .TextStyle(
                                  color: PdfColor.fromHex("ffffff"),
                                  fontSize: 10)
                              )))

                    ]
                ),
                //var intqty=0;
                for (int i = 0; i < secScreenData.length; i++)
                  pw.TableRow(
                      children: [
                        pw.Expanded(
                            flex: 1,
                            child: pw.Container(
                                height: height/40,
                                alignment: pw.Alignment.center,
                                child: pw.Text(
                                    (i + 1).toString(),
                                    textAlign: pw.TextAlign.center,
                                    style:  pw.TextStyle(fontSize: height/90,color: PdfColor.fromHex("#403d3d"),)
                                ))),
                        pw.Expanded(
                            flex: 4,
                            child: pw.Container(
                                alignment: pw.Alignment.centerLeft,
                                margin: const pw.EdgeInsets.only(left: 5),
                                child: pw.Text(
                                    "${secScreenData[i].itemName}"
                                        .toString(),
                                    textAlign: pw.TextAlign.center,
                                    style:  pw.TextStyle(fontSize: height/90,color: PdfColor.fromHex("#403d3d"),)
                                ))),
                        pw.Expanded(
                            flex: 2,
                            child: pw.Container(
                                alignment: pw.Alignment.centerLeft,
                                margin: const pw.EdgeInsets.only(left: 5),
                                child: pw.Text(
                                    "${secScreenData[i].hsnCode}",
                                    textAlign: pw.TextAlign.center,
                                    style:  pw.TextStyle(fontSize: height/90,color: PdfColor.fromHex("#403d3d"),)
                                ))),
                        pw.Expanded(
                            flex: 1,
                            child: pw.Container(
                                alignment: pw.Alignment.centerRight,
                                margin: const pw.EdgeInsets.only(right: 5),
                                child: pw.Text("${secScreenData[i].taxper}",
                                    textAlign: pw.TextAlign.center,
                                    style:  pw.TextStyle(fontSize: height/90,color: PdfColor.fromHex("#403d3d"),)
                                ))),
                        pw.Expanded(
                            flex: 1,
                            child: pw.Container(
                                alignment: pw.Alignment.centerRight,
                                margin: const pw.EdgeInsets.only(right: 5),
                                child: pw.Text("${secScreenData[i].qty}",
                                    textAlign: pw.TextAlign.center,
                                    style:  pw.TextStyle(fontSize: height/90,color: PdfColor.fromHex("#403d3d"),)
                                ))),
                        pw.Expanded(
                            flex: 2,
                            child: pw.Container(
                                margin: const pw.EdgeInsets.only(right: 5),
                              alignment: pw.Alignment.centerRight,
                                child: pw.Text( "${secScreenData[i].price}",
                                    textAlign: pw.TextAlign.right,
                                    style:  pw.TextStyle(fontSize: height/90,color: PdfColor.fromHex("#403d3d"),)
                                ))),
                        pw.Expanded(
                            flex: 1,
                            child: pw.Container(
                                margin: const pw.EdgeInsets.only(left: 5),
                                alignment: pw.Alignment.centerLeft,
                                child: pw.Text( "${secScreenData[i].uom}",
                                    textAlign: pw.TextAlign.right,
                                    style:  pw.TextStyle(fontSize: height/90,color: PdfColor.fromHex("#403d3d"),)
                                ))),
                        pw.Expanded(
                            flex: 2,
                            child: pw.Container(
                                margin: const pw.EdgeInsets.only(right: 5),
                                alignment: pw.Alignment.centerRight,
                                child: pw.Text( "${secScreenData[i].lineTotal}",
                                    textAlign: pw.TextAlign.right,
                                    style:  pw.TextStyle(fontSize: height/90,color: PdfColor.fromHex("#403d3d"),)
                                ))),
                      ]
                  ),

              ],

            ),





            pw.Table(
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              border: pw.TableBorder.all(
                  width: 1, color: PdfColor.fromHex("b5b5b5")),
              children: [
                  pw.TableRow(
                      children: [
                        pw.Expanded(
                            flex: 12,
                            child: pw.Container(
                                height: height/40,
                                alignment: pw.Alignment.centerRight,
                                margin: const pw.EdgeInsets.only(right: 5),
                                child: pw.Text("Fright Charge",
                                    textAlign: pw.TextAlign.center,
                                    style:  pw.TextStyle(fontSize: height/90,color: PdfColor.fromHex("#403d3d"),)
                                ))),
                        pw.Expanded(
                            flex: 2,
                            child: pw.Container(
                                alignment: pw.Alignment.centerRight,
                                margin: const pw.EdgeInsets.only(right: 5),
                                child: pw.Text(
                                    "${secScreenData[0].frightamt}"
                                        .toString(),
                                    textAlign: pw.TextAlign.center,
                                    style:  pw.TextStyle(fontSize: height/90,color: PdfColor.fromHex("#403d3d"),)
                                ))),

                      ]
                  ),
              ],
            ),



            pw.Table(
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              border: pw.TableBorder.all(
                  width: 1, color: PdfColor.fromHex("b5b5b5")),
              children: [
                pw.TableRow(
                    children: [
                      pw.Expanded(
                          flex: 12,
                          child: pw.Container(
                              height: height/40,
                              alignment: pw.Alignment.centerRight,
                              margin: const pw.EdgeInsets.only(right: 5),
                              child: pw.Text("Net Amt",
                                  textAlign: pw.TextAlign.center,
                                  style:  pw.TextStyle(fontSize: height/90,color: PdfColor.fromHex("#403d3d"),)
                              ))),
                      pw.Expanded(
                          flex: 2,
                          child: pw.Container(
                              alignment: pw.Alignment.centerRight,
                              margin: const pw.EdgeInsets.only(right: 5),
                              child: pw.Text(
                                  "${secScreenData[0].netAmt}"
                                      .toString(),
                                  textAlign: pw.TextAlign.center,
                                  style:  pw.TextStyle(fontSize: height/90,color: PdfColor.fromHex("#403d3d"),)
                              ))),

                    ]
                ),
              ],
            ),

          for(int k=0; k < secSalesTax.length;k++)
            pw.Table(
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              border: pw.TableBorder.all(
                  width: 1, color: PdfColor.fromHex("b5b5b5")),
              children: [
                pw.TableRow(
                    children: [
                      pw.Expanded(
                          flex: 9,
                          child: pw.Container(
                              alignment: pw.Alignment.centerRight,
                              margin: const pw.EdgeInsets.only(right: 5),
                              child: pw.Text(secSalesTax[k].taxCode.toString(),
                                  textAlign: pw.TextAlign.center,
                                  style:  pw.TextStyle(fontSize: height/90,color: PdfColor.fromHex("#403d3d"),)
                              ))),
                      pw.Expanded(
                          flex: 3,
                          child: pw.Container(
                              alignment: pw.Alignment.centerLeft,
                              margin: const pw.EdgeInsets.only(right: 5),
                              child: pw.Text(" CGST@ ${secSalesTax[k].per}  % \n\n"
                                  " SGST@ ${secSalesTax[k].per}  % \n\n",
                                  textAlign: pw.TextAlign.center,
                                  style:  pw.TextStyle(fontSize: height/90,color: PdfColor.fromHex("#403d3d"),)
                              ))),
                      pw.Expanded(
                          flex: 2,
                          child: pw.Container(
                              alignment: pw.Alignment.centerRight,
                              margin: const pw.EdgeInsets.only(right: 5),
                              child: pw.Text(
                                  "${secSalesTax[k].cGST} \n\n"
                                      "${secSalesTax[k].sGST} \n\n"
                                      .toString(),
                                  textAlign: pw.TextAlign.center,
                                  style:  pw.TextStyle(fontSize: height/90,color: PdfColor.fromHex("#403d3d"),)
                              ))),

                    ]
                ),
              ],
            ),




            pw.Table(
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              border: pw.TableBorder.all(
                  width: 1, color: PdfColor.fromHex("b5b5b5")),
              children: [
                pw.TableRow(
                    children: [
                      pw.Expanded(
                          flex: 12,
                          child: pw.Container(
                              height: height/40,
                              alignment: pw.Alignment.centerRight,
                              margin: const pw.EdgeInsets.only(right: 5),
                              child: pw.Text("Total Amt",
                                  textAlign: pw.TextAlign.center,
                                  style:  pw.TextStyle(fontSize: height/90,color: PdfColor.fromHex("#403d3d"),)
                              ))),
                      pw.Expanded(
                          flex: 2,
                          child: pw.Container(
                              alignment: pw.Alignment.centerRight,
                              margin: const pw.EdgeInsets.only(right: 5),
                              child: pw.Text(
                                  "${secScreenData[0].totalAmt}"
                                      .toString(),
                                  textAlign: pw.TextAlign.center,
                                  style:  pw.TextStyle(fontSize: height/90,color: PdfColor.fromHex("#403d3d"),)
                              ))),

                    ]
                ),
              ],
            ),

          ];
          // Center
        })); // Pa


    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('PDF Preview'),
            ),
            body: PdfPreview(
              initialPageFormat: PdfPageFormat.a4,
              build: (format) => pdf.save(),
            ),
          );
        }).then((value) {

    });
  }

}

class DocType {
  var id;
  var Status;
  DocType(this.id,this.Status);
}

class ScreenListData {
  int? docNo;
  String? leadName;
  var lineTotal;

  ScreenListData(this.docNo, this.leadName, this.lineTotal);

}

class ScreenData {
  String? location;
  String? street;
  String? block;
  String? zipCode;
  String? panNo;
  String? gSTRegnNo;
  String? cardName;
  String? billAddress;
  String? billAddress3;
  String? billStreet;
  String? billCity;
  String? billZipCode;
  String? billGSTRegnNo;
  String? billState;
  String? shiftAddress;
  String? shiftAddress3;
  String? shiftStreet;
  String? shiftCity;
  String? shiftZipCode;
  String? shiftGSTRegnNo;
  String? shiftState;
  String? mobileNo;
  var quotaNo;
  String? docDate;
  String? cusRef;
  String? itemName;
  String? uom;
  String? hsnCode;
  var taxper;
  var qty;
  var price;
  var lineTotal;
  var frightamt;
  var netAmt;
  var totalAmt;

  ScreenData(
      this.location,
        this.street,
        this.block,
        this.zipCode,
        this.panNo,
        this.gSTRegnNo,
        this.cardName,
        this.billAddress,
        this.billAddress3,
        this.billStreet,
        this.billCity,
        this.billZipCode,
        this.billGSTRegnNo,
        this.billState,
        this.shiftAddress,
        this.shiftAddress3,
        this.shiftStreet,
        this.shiftCity,
        this.shiftZipCode,
        this.shiftGSTRegnNo,
        this.shiftState,
        this.mobileNo,
        this.quotaNo,
        this.docDate,
        this.cusRef,
        this.itemName,
        this.uom,
        this.hsnCode,
        this.taxper,
        this.qty,
        this.price,
        this.lineTotal,this.frightamt,this.netAmt,this.totalAmt);

}

class SalesDetails {
  int? docNo;
  String? leadName;
  String? itemName;
  String? invntryUom;
  var price;
  var qty;
  var amt;
  String? taxCode;
  var taxAmt;
  var lineTotal;

  SalesDetails(
      this.docNo,
        this.leadName,
        this.itemName,
        this.invntryUom,
        this.price,
        this.qty,
        this.amt,
        this.taxCode,
        this.taxAmt,
        this.lineTotal);


}

class SalesTax {
  int? docNo;
  String? taxCode;
  var taxAmt;
  var cGST;
  var sGST;
  var per;

  SalesTax(
      this.docNo,
      this.taxCode,
      this.taxAmt,
      this.cGST,
      this.sGST,
      this.per,
     );


}