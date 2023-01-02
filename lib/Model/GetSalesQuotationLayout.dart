class GetSalesQuotationLayout {
  int? status;
  List<Result>? result;

  GetSalesQuotationLayout({this.status, this.result});

  GetSalesQuotationLayout.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
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

  Result(
      {this.location,
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
        this.lineTotal,this.frightamt,this.netAmt,this.totalAmt});

  Result.fromJson(Map<String, dynamic> json) {
    location = json['Location'];
    street = json['Street'];
    block = json['Block'];
    zipCode = json['ZipCode'];
    panNo = json['PanNo'];
    gSTRegnNo = json['GSTRegnNo'];
    cardName = json['CardName'];
    billAddress = json['BillAddress'];
    billAddress3 = json['BillAddress3'];
    billStreet = json['BillStreet'];
    billCity = json['BillCity'];
    billZipCode = json['BillZipCode'];
    billGSTRegnNo = json['BillGSTRegnNo'];
    billState = json['BillState'];
    shiftAddress = json['ShiftAddress'];
    shiftAddress3 = json['ShiftAddress3'];
    shiftStreet = json['ShiftStreet'];
    shiftCity = json['ShiftCity'];
    shiftZipCode = json['ShiftZipCode'];
    shiftGSTRegnNo = json['ShiftGSTRegnNo'];
    shiftState = json['ShiftState'];
    mobileNo = json['MobileNo'];
    quotaNo = json['QuotaNo'];
    docDate = json['DocDate'];
    cusRef = json['CusRef'];
    itemName = json['ItemName'];
    uom = json['Uom'];
    hsnCode = json['HsnCode'];
    taxper = json['Taxper'];
    qty = json['Qty'];
    price = json['Price'];
    lineTotal = json['LineTotal'];
    frightamt = json['FrightAmt'];
    netAmt = json['NetAmt'];
    totalAmt = json['TotalAmt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Location'] = location;
    data['Street'] = street;
    data['Block'] = block;
    data['ZipCode'] = zipCode;
    data['PanNo'] = panNo;
    data['GSTRegnNo'] = gSTRegnNo;
    data['CardName'] = cardName;
    data['BillAddress'] = billAddress;
    data['BillAddress3'] = billAddress3;
    data['BillStreet'] = billStreet;
    data['BillCity'] = billCity;
    data['BillZipCode'] = this.billZipCode;
    data['BillGSTRegnNo'] = this.billGSTRegnNo;
    data['BillState'] = this.billState;
    data['ShiftAddress'] = this.shiftAddress;
    data['ShiftAddress3'] = this.shiftAddress3;
    data['ShiftStreet'] = this.shiftStreet;
    data['ShiftCity'] = this.shiftCity;
    data['ShiftZipCode'] = this.shiftZipCode;
    data['ShiftGSTRegnNo'] = this.shiftGSTRegnNo;
    data['ShiftState'] = this.shiftState;
    data['MobileNo'] = this.mobileNo;
    data['QuotaNo'] = this.quotaNo;
    data['DocDate'] = this.docDate;
    data['CusRef'] = this.cusRef;
    data['ItemName'] = this.itemName;
    data['Uom'] = this.uom;
    data['HsnCode'] = this.hsnCode;
    data['Taxper'] = this.taxper;
    data['Qty'] = this.qty;
    data['Price'] = this.price;
    data['LineTotal'] = this.lineTotal;
    data['FrightAmt'] = this.frightamt;
    data['NetAmt'] = this.netAmt;
    data['TotalAmt'] = this.totalAmt;
    return data;
  }
}
