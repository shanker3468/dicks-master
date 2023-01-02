
import 'package:dicks/Reports/_ArInvoicereport.dart';
import 'package:dicks/Reports/_SalesOrdersReports.dart';
import 'package:dicks/Reports/_SalesQuatationlayout.dart';
import 'package:dicks/Screen/_addmymetting.dart';
import 'package:dicks/Screen/_addmyschedular.dart';
import 'package:dicks/Screen/_leadpage.dart';
import 'package:dicks/Screen/_mettingpanelreport.dart';
import 'package:dicks/Screen/_salequeation.dart';
import 'package:dicks/Screen/_shedularreport.dart';
import 'package:dicks/Screen/_takerequriment.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {


  var sessionUseId  =   '';
  var sessionName = '';
  var sessionDeptCode = '';
  var sessionDeptName = '';



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
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Card(
                  elevation: 5,
                  child: Container(
                    height: height/5,
                    width: width,
                    //margin: EdgeInsets.all(height/50),
                    child: Stack(
                      children: [
                        Container(
                          height: height/5,
                          width: width/1.5,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(height/4.5))
                          ),
                          child: Column(
                            children: [
                              Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: width/10,
                                    height: height/20,

                                    child: Icon(Icons.account_circle,size: height/20,color: Colors.pink,),
                                  ),
                                  Container(
                                    width: width/2.5,
                                    height: height/10,
                                    margin: EdgeInsets.only(left: width/50),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("EmpName ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: height/60),),
                                            Text(sessionName.toString(),
                                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: height/60),),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Department ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: height/60),),
                                            Text(sessionDeptName.toString(),
                                              style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              )
                            ],

                          ),
                        ),
                        Container(
                            height: height/15,
                            width: width,
                            margin: EdgeInsets.only(left: width/1.5,top: height/50),
                            child: Image.asset("assets/logo.png")
                        ),
                        SizedBox(
                            height: height/30,

                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height/30,),
                Container(
                  height: height/8,
                  width: width,
                  margin: EdgeInsets.all(height/50),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap:(){
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) =>
                                      LeadPage(
                                          screenName:"Lead Creation",
                                          docno:"0",
                                          formid:1
                                      ),
                                  ),
                                );
                              });
                            },
                            child: Material(
                              elevation: 2.0,
                              child: SizedBox(
                                width: width/5,
                                height: height/11,
                                child: Lottie.asset("assets/leadsmenu.json"),
                              ),
                            ),
                          ),
                          const Text("Lead")
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap:(){
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) =>
                                      ShedularReport(
                                          screenName:"Today Scheduler"
                                      ),
                                  ),
                                );
                              });
                            },
                            child: Material(
                              elevation: 2.0,
                              child: SizedBox(
                                width: width/5,
                                height: height/11,
                                child: Lottie.asset("assets/schedules.json"),
                              ),
                            ),
                          ),

                          const Text("My Schedules")
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap:(){
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) =>
                                      MetteingPanelReport(
                                          screenName:"Metting Reports"
                                      ),
                                  ),
                                );
                              });
                            },
                            child: Material(
                              elevation: 2.0,
                              child: SizedBox(
                                width: width/5,
                                height: height/11,
                                child: Lottie.asset("assets/meeting.json"),
                              ),
                            ),
                          ),
                          const Text("Metting Reports")
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  height: height/8,
                  width: width,
                  margin: EdgeInsets.all(height/50),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap:(){
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) =>
                                      AddMySchedular(
                                          screenName:"My Scheduler Creation"
                                      ),
                                  ),
                                );
                              });
                            },
                            child: Material(
                              elevation: 2.0,
                              child: SizedBox(
                                width: width/5,
                                height: height/11,
                                child: Lottie.asset("assets/scheduleadd.json"),
                              ),
                            ),
                          ),

                          const Text("Add Scheduler")
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap:(){
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) =>
                                      AddMyMetting(
                                          screenName:"Metting Panel"
                                      ),
                                  ),
                                );
                              });
                              },
                            child: Material(
                              elevation: 2.0,
                              child: SizedBox(
                                width: width/5,
                                height: height/11,
                                child: Lottie.asset("assets/meetingpanel.json"),

                              ),
                            ),
                          ),

                          const Text("Metting Panel")
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap:(){
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) =>
                                      TakeMyRequriment(
                                          screenName:"Requriment Panel"
                                      ),
                                  ),
                                );
                              });

                           },
                            child: Material(
                              elevation: 2.0,
                              child: SizedBox(
                                width: width/5,
                                height: height/11,
                                child: Lottie.asset("assets/requrimentpanel.json"),

                              ),
                            ),
                          ),

                          const Text("Requriment Panel")
                        ],
                      )
                    ],
                  ),


                ),
                Container(
                  height: height/8,
                  width: width,
                  margin: EdgeInsets.all(height/50),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap:(){
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) =>
                                      SaleQuation(
                                          screenName:"Sales Quotation",
                                          docno:"0",
                                          formid :1
                                      ),
                                  ),
                                );
                              });

                            },
                            child: Material(
                              elevation: 2.0,
                              child: SizedBox(
                                width: width/5,
                                height: height/11,
                                child: Lottie.asset("assets/quotation.json"),

                              ),
                            ),
                          ),

                          const Text("Sales Quotation")
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Material(
                            elevation: 2.0,
                            child: InkWell(
                              onTap: (){
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) =>
                                        SalesOrdersReport(
                                            screenName:"Sales Orders"
                                        ),
                                    ),
                                  );
                                });
                              },
                              child: SizedBox(
                                width: width/5,
                                height: height/11,
                                child: Lottie.asset("assets/soreport.json"),
                              ),
                            ),
                          ),

                          const Text("SO Report")
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: width/5,
                            height: height/11,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.all(Radius.circular(height/10))
                            ),
                          ),

                          const Text("Payment Report")
                        ],
                      )
                    ],
                  ),


                ),
                Container(
                  height: height/8,
                  width: width,
                  margin: EdgeInsets.all(height/50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: (){
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) =>
                                      ARInvoiceReport(
                                          screenName:"AR Invoice Orders"
                                      ),
                                  ),
                                );
                              });

                            }
                            ,child: Container(
                              width: width/5,
                              height: height/11,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.all(Radius.circular(height/10))
                              ),
                            ),
                          ),
                          const Text("AR Report")
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: width/5,
                            height: height/11,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.all(Radius.circular(height/10))
                            ),
                          ),

                          const Text("Out standing report")
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: (){
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) =>
                                      SalesQuotationLayOut(
                                          screenName:"Quotation Layout"
                                      ),
                                  ),
                                );
                              });
                            }
                            ,child: Container(
                              width: width/5,
                              height: height/11,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.all(Radius.circular(height/10))
                              ),
                            ),
                          ),

                          const Text("Quotation Layout")
                        ],
                      ),
                    ],
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


    });
  }
}

