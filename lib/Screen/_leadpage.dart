// ignore_for_file: must_be_immutable, deprecated_member_use
import 'dart:convert';
import 'dart:developer';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dicks/AppConstants.dart';
import 'package:dicks/Include/_appbar.dart';
import 'package:dicks/Include/_loding.dart';
import 'package:dicks/Model/LeadMasters.dart';
import 'package:dicks/Screen/_leadreports.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class LeadPage extends StatefulWidget {
   LeadPage({Key? key, required this. screenName, required this. docno, required this. formid}) : super(key: key);
   var screenName='';
   var docno='';
   int formid;

  @override
  State<LeadPage> createState() => _LeadPageState();
}

class _LeadPageState extends State<LeadPage> {


  final TextEditingController _cardname = TextEditingController(text: '');
  final TextEditingController _mobileno = TextEditingController(text: '');
  final TextEditingController _contactperson = TextEditingController(text: '');
  final TextEditingController _contactpersonposition = TextEditingController(text: '');
  final TextEditingController _email = TextEditingController(text: '');
  final TextEditingController _streetname = TextEditingController(text: '');
  final TextEditingController _landmark = TextEditingController(text: '');
  final TextEditingController _district = TextEditingController(text: '');
  final TextEditingController _state = TextEditingController(text: '');
  final TextEditingController _officeno = TextEditingController(text: '');
  final TextEditingController _pan = TextEditingController(text: '');
  final TextEditingController _gstin = TextEditingController(text: '');
  final TextEditingController _bankname = TextEditingController(text: '');
  final TextEditingController _accountno = TextEditingController(text: '');
  final TextEditingController _branch = TextEditingController(text: '');
  final TextEditingController _ifsc = TextEditingController(text: '');


  bool loading = false;
  var sessionUseId  =   '';
  var sessionName = '';
  var sessionDeptCode = '';
  var sessionDeptName = '';


  late LeadMasters rawLeadMasters;
 String? altercampanygroup='';
 List<String>campanygroup=[];

  String? altertypeofbusiness='';
  List<String>typeofbusiness=[];

  String? alterGSTIN='';
  List<String>gsttype=[];

  String? altercurrency='';
  List<String>currencytype=[];


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
                    child: TextField(
                      controller: _cardname,
                      onChanged: (String value) {

                      },
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: "Company Name",
                          prefixIcon: Material(
                            elevation: 0,
                            borderRadius: BorderRadius.all(Radius.circular(height/15)),
                            child: const Icon(
                              Icons.account_circle,
                              color: Colors.blue,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/50)),
                    ),
                  ),
                ),
                SizedBox(height: height/60,),
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
                        items: campanygroup,
                        hint: 'Company Group',
                        label: 'Company Group',
                        dropdownSearchDecoration: InputDecoration(
                            enabled: false,
                            enabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/60)
                        ),
                        onChanged: (val) {
                          log(val.toString());
                          for (int kk = 0; kk < rawLeadMasters.result!.length; kk++) {
                            setState(() {
                              if (rawLeadMasters.result![kk].name.toString() == val) {
                                altercampanygroup = rawLeadMasters.result![kk].name.toString();

                              }
                              log(altercampanygroup.toString());
                            });
                          }
                        },
                        selectedItem: altercampanygroup,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height/60,),
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
                        items: typeofbusiness,
                        hint: 'Type Of Business',
                        label: 'Type Of Business',
                        dropdownSearchDecoration: InputDecoration(
                            enabled: false,
                            enabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/60)
                        ),
                        onChanged: (val) {
                          log(val.toString());
                          for (int kk = 0; kk < rawLeadMasters.result!.length; kk++) {
                            setState(() {
                              if (rawLeadMasters.result![kk].name.toString() == val) {
                                altertypeofbusiness = rawLeadMasters.result![kk].name.toString();

                              }
                              log(altertypeofbusiness.toString());
                            });
                          }
                        },
                        selectedItem: altertypeofbusiness,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height/60,),


                Padding(
                  padding: EdgeInsets.symmetric(horizontal: height/30),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.all(Radius.circular(height/10)),
                    child: TextField(
                      controller: _mobileno,
                      onChanged: (String value) {},
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
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
                          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/50)),
                    ),
                  ),
                ),
                SizedBox(height: height/60,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: height/30),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.all(Radius.circular(height/10)),
                    child: TextField(
                      controller: _contactperson,
                      onChanged: (String value) {},
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
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
                SizedBox(height: height/60,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: height/30),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.all(Radius.circular(height/10)),
                    child: TextField(
                      controller: _contactpersonposition,
                      onChanged: (String value) {},
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: "Contact Person's Position",
                          prefixIcon: Material(
                            elevation: 0,
                            borderRadius: BorderRadius.all(Radius.circular(height/15)),
                            child: const Icon(
                              Icons.person_outline_sharp,
                              color: Colors.blue,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/50)),
                    ),
                  ),
                ),
                SizedBox(height: height/60,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: height/30),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.all(Radius.circular(height/10)),
                    child: TextField(
                      controller: _email,
                      onChanged: (String value) {},
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: Material(
                            elevation: 0,
                            borderRadius: BorderRadius.all(Radius.circular(height/15)),
                            child: const Icon(
                              Icons.mail,
                              color: Colors.blue,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/50)),
                    ),
                  ),
                ),
                SizedBox(height: height/60,),
                const Text("Office Address Detalies"),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: height/30),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.all(Radius.circular(height/10)),
                    child: TextField(
                      controller: _streetname,
                      onChanged: (String value) {},
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: "Street Name",
                          prefixIcon: Material(
                            elevation: 0,
                            borderRadius: BorderRadius.all(Radius.circular(height/15)),
                            child: const Icon(
                              Icons.streetview_outlined,
                              color: Colors.blue,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/50)),
                    ),
                  ),
                ),
                SizedBox(height: height/60,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: height/30),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.all(Radius.circular(height/10)),
                    child: TextField(
                      controller: _landmark,
                      onChanged: (String value) {},
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: "LandMark",
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
                SizedBox(height: height/60,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: height/30),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.all(Radius.circular(height/10)),
                    child: TextField(
                      controller: _district,
                      onChanged: (String value) {},
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: "District",
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
                SizedBox(height: height/60,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: height/30),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.all(Radius.circular(height/10)),
                    child: TextField(
                      controller: _state,
                      onChanged: (String value) {},
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: "State",
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
                SizedBox(height: height/60,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: height/30),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.all(Radius.circular(height/10)),
                    child: TextField(
                      controller: _officeno,
                      onChanged: (String value) {},
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: "Office No",
                          prefixIcon: Material(
                            elevation: 0,
                            borderRadius: BorderRadius.all(Radius.circular(height/15)),
                            child: const Icon(
                              Icons.local_activity,
                              color: Colors.blue,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/50)),
                    ),
                  ),
                ),
                SizedBox(height: height/60,),
                const Text("Payment terms"),
                SizedBox(height: height/60,),
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
                        items: currencytype,
                        hint: 'Currency',
                        label: 'Currency',
                        dropdownSearchDecoration: InputDecoration(
                            enabled: false,
                            enabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/60)
                        ),
                        onChanged: (val) {
                          log(val.toString());
                          for (int kk = 0; kk < rawLeadMasters.result!.length; kk++) {
                            setState(() {
                              if (rawLeadMasters.result![kk].name.toString() == val) {
                                altercurrency = rawLeadMasters.result![kk].name.toString();

                              }
                              log(altercurrency.toString());
                            });
                          }
                        },
                        selectedItem: altercurrency,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height/60,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: height/30),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.all(Radius.circular(height/10)),
                    child: TextField(
                      controller: _pan,
                      onChanged: (String value) {},
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: "Pan No",
                          prefixIcon: Material(
                            elevation: 0,
                            borderRadius: BorderRadius.all(Radius.circular(height/15)),
                            child: const Icon(
                              Icons.add_card,
                              color: Colors.blue,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/50)),
                    ),
                  ),
                ),
                SizedBox(height: height/60,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: height/30),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.all(Radius.circular(height/10)),
                    child: TextField(
                      controller: _gstin,
                      onChanged: (String value) {},
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: "GSTIN No",
                          prefixIcon: Material(
                            elevation: 0,
                            borderRadius: BorderRadius.all(Radius.circular(height/15)),
                            child: const Icon(
                              Icons.confirmation_num,
                              color: Colors.blue,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/50)),
                    ),
                  ),
                ),
                SizedBox(height: height/60,),
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
                        items: gsttype,
                        hint: 'GSTIN Type',
                        label: 'GSTIN Type ',
                        dropdownSearchDecoration: InputDecoration(
                            enabled: false,
                            enabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/60)
                        ),
                        onChanged: (val) {
                          log(val.toString());
                          for (int kk = 0; kk < rawLeadMasters.result!.length; kk++) {
                            setState(() {
                              if (rawLeadMasters.result![kk].name.toString() == val) {
                                alterGSTIN = rawLeadMasters.result![kk].name.toString();

                              }
                              log(alterGSTIN.toString());
                            });
                          }
                        },
                        selectedItem: alterGSTIN,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height/60,),


                const Text("Bank Detalies"),
                SizedBox(height: height/60,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: height/30),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.all(Radius.circular(height/10)),
                    child: TextField(
                      controller: _bankname,
                      onChanged: (String value) {},
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: "Bank Name",
                          prefixIcon: Material(
                            elevation: 0,
                            borderRadius: BorderRadius.all(Radius.circular(height/15)),
                            child: const Icon(
                              Icons.account_balance_outlined,
                              color: Colors.blue,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/50)),
                    ),
                  ),
                ),
                SizedBox(height: height/60,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: height/30),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.all(Radius.circular(height/10)),
                    child: TextField(
                      controller: _accountno,
                      onChanged: (String value) {},
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "A/C Number",
                          prefixIcon: Material(
                            elevation: 0,
                            borderRadius: BorderRadius.all(Radius.circular(height/15)),
                            child: const Icon(
                              Icons.account_balance_wallet,
                              color: Colors.blue,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/50)),
                    ),
                  ),
                ),
                SizedBox(height: height/60,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: height/30),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.all(Radius.circular(height/10)),
                    child: TextField(
                      controller: _branch,
                      onChanged: (String value) {},
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: "Branch",
                          prefixIcon: Material(
                            elevation: 0,
                            borderRadius: BorderRadius.all(Radius.circular(height/15)),
                            child: const Icon(
                              Icons.account_balance,
                              color: Colors.blue,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/50)),
                    ),
                  ),
                ),
                SizedBox(height: height/60,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: height/30),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.all(Radius.circular(height/10)),
                    child: TextField(
                      controller: _ifsc,
                      onChanged: (String value) {},
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: "IFSC Code",
                          prefixIcon: Material(
                            elevation: 0,
                            borderRadius: BorderRadius.all(Radius.circular(height/15)),
                            child: const Icon(
                              Icons.card_membership,
                              color: Colors.blue,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: height/50)),
                    ),
                  ),
                ),
                SizedBox(height: height/60,),

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
                    backgroundColor: Colors.pinkAccent,
                    icon: const Icon(Icons.folder),
                    label: const Text('Reports'),
                    onPressed: () {
                      Navigator.pop(context);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) =>
                              LeadReports(
                                  screenName:"Sales Quotation",
                              ),
                          ),
                        );
                      });
                    },
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
      getallmaster();

    });
  }

  Future getallmaster() async {
    setState(() {
      loading = true;
      log("Masters.....");
    });
    var body = {
      "FormID":1,
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
        loading =false;
      }else {
        setState(() {
          rawLeadMasters = LeadMasters.fromJson(jsonDecode(responce.body));
          for(int i=0;i<rawLeadMasters.result!.length;i++){
            if(rawLeadMasters.result![i].type=='CG'){
              campanygroup.add(rawLeadMasters.result![i].name.toString());

            }else if (rawLeadMasters.result![i].type=='TB'){
              typeofbusiness.add(rawLeadMasters.result![i].name.toString());

            }else if (rawLeadMasters.result![i].type=='GST'){
              gsttype.add(rawLeadMasters.result![i].name.toString());

            }else if (rawLeadMasters.result![i].type=='Cu'){
              currencytype.add(rawLeadMasters.result![i].name.toString());
            }
          }
          loading =false;
        });
      }

      if(widget.docno=="0"){

      }else{
        getLeadNumber();
      }

    } else {
      log("Somthing Worng Kindly Check Network...");
    }
  }


  Future getLeadNumber() async {
    setState(() {
      loading = true;
      log("Save Method.....");
    });
    var body = {
      "FromId":5,
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
      "DocDate":widget.docno,
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
    log('${AppConstants.LIVE_URL}insetleadmaster');
    log(json.encode(body));
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
          final decode = jsonDecode(responce.body);
         _cardname.text =   decode['result'][0]['CardName'].toString();
          _mobileno.text =  decode['result'][0]['MobileNo'].toString();
          _contactperson.text =  decode['result'][0]['ContactPerson'].toString();
          _contactpersonposition.text =  decode['result'][0]['ContactPersonPosition'].toString();
          _email.text =  decode['result'][0]['Email'].toString();
          _streetname.text =  decode['result'][0]['StreetName'].toString();
          _landmark.text =  decode['result'][0]['LandMark'].toString();
          _district.text =  decode['result'][0]['District'].toString();
          _state.text =  decode['result'][0]['State'].toString();
          _officeno.text =  decode['result'][0]['OfficeNo'].toString();
          altercampanygroup =  decode['result'][0]['CompanyGroup'].toString();
          altertypeofbusiness =  decode['result'][0]['TypeOfBusiness'].toString();
          _pan.text =  decode['result'][0]['Panno'].toString();
          _gstin.text =  decode['result'][0]['Gstin'].toString();
          alterGSTIN =  decode['result'][0]['GstType'].toString();
          _bankname.text =  decode['result'][0]['BankName'].toString();
          _accountno.text =  decode['result'][0]['ACno'].toString();
          _branch.text =  decode['result'][0]['Branch'].toString();
          _ifsc.text =  decode['result'][0]['IFscCode'].toString();
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
      "FromId":widget.formid,
      "CardName":_cardname.text,
      "MobileNo":_mobileno.text,
      "ContactPerson":_contactperson.text,
      "ContactPersonPosition":_contactpersonposition.text,
      "Email":_email.text,
      "StreetName":_streetname.text,
      "LandMark":_landmark.text,
      "District":_district.text,
      "State":_state.text,
      "OfficeNo":_officeno.text,
      "DocDate":widget.docno,
      "CreateBy":sessionUseId.toString(),
      "CompanyGroup":altercampanygroup.toString(),
      "TypeOfBusiness":altertypeofbusiness.toString(),
      "Currency":altercurrency.toString(),
      "Panno":_pan.text,
      "Gstin":_gstin.text,
      "GstType":alterGSTIN.toString(),
      "BankName":_bankname.text,
      "ACno":_accountno.text,
      "Branch":_branch.text,
      "IFscCode":_ifsc.text
    };
    log(json.encode(body));
    var header = {"Content-Type": "application/json"};
    var responce = await http.post(
        Uri.parse('${AppConstants.LIVE_URL}insetleadmaster'),
        body: json.encode(body),
        headers: header);
    log('${AppConstants.LIVE_URL}insetleadmaster');
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
              title: 'Your Lead No is'+decode['result'][0]['DocNo'].toString(),
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
