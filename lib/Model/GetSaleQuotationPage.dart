class GetSaleQuotationPage {
  int? status;
  List<Result>? result;

  GetSaleQuotationPage({this.status, this.result});

  GetSaleQuotationPage.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? location;
  var locationcode;
  String? docType;
  String? leadNo;
  String? leadName;
  String? contactPerson;
  String? cusRef;
  int? docNo;
  String? docDate;
  String? itemCode;
  String? itemName;
  String? hsnCode;
  var price;
  var qty;
  var amt;
  String? taxCode;
  var taxPer;
  var taxAmt;
  var lineTotal;

  Result(
      {this.location,this.locationcode,
        this.docType,
        this.leadNo,
        this.leadName,
        this.contactPerson,
        this.cusRef,
        this.docNo,
        this.docDate,
        this.itemCode,
        this.itemName,
        this.hsnCode,
        this.price,
        this.qty,
        this.amt,
        this.taxCode,
        this.taxPer,
        this.taxAmt,
        this.lineTotal});

  Result.fromJson(Map<String, dynamic> json) {
    location = json['Location'];
    locationcode = json['LocationCode'];
    docType = json['DocType'];
    leadNo = json['LeadNo'];
    leadName = json['LeadName'];
    contactPerson = json['ContactPerson'];
    cusRef = json['CusRef'];
    docNo = json['DocNo'];
    docDate = json['DocDate'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    hsnCode = json['HsnCode'];
    price = json['Price'];
    qty = json['Qty'];
    amt = json['Amt'];
    taxCode = json['TaxCode'];
    taxPer = json['TaxPer'];
    taxAmt = json['TaxAmt'];
    lineTotal = json['LineTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Location'] = location;
    data['LocationCode'] = locationcode;
    data['DocType'] = docType;
    data['LeadNo'] = leadNo;
    data['LeadName'] = leadName;
    data['ContactPerson'] = contactPerson;
    data['CusRef'] = cusRef;
    data['DocNo'] = docNo;
    data['DocDate'] = docDate;
    data['ItemCode'] = itemCode;
    data['ItemName'] = itemName;
    data['HsnCode'] = hsnCode;
    data['Price'] = this.price;
    data['Qty'] = this.qty;
    data['Amt'] = this.amt;
    data['TaxCode'] = this.taxCode;
    data['TaxPer'] = this.taxPer;
    data['TaxAmt'] = this.taxAmt;
    data['LineTotal'] = this.lineTotal;
    return data;
  }
}
