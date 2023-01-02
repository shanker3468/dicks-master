class SalesOrdersModel {
  int? status;
  List<Result>? result;

  SalesOrdersModel({this.status, this.result});

  SalesOrdersModel.fromJson(Map<String, dynamic> json) {
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

  Result(
      {this.docNum,
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
        this.docTotal});

  Result.fromJson(Map<String, dynamic> json) {
    docNum = json['DocNum'];
    docStatus = json['DocStatus'];
    docDate = json['DocDate'];
    cardCode = json['CardCode'];
    cardName = json['CardName'];
    numAtCard = json['NumAtCard'];
    docCur = json['DocCur'];
    lineNum = json['LineNum'];
    itemCode = json['ItemCode'];
    dscription = json['Dscription'];
    quantity = json['Quantity'];
    price = json['Price'];
    whsCode = json['WhsCode'];
    acctCode = json['AcctCode'];
    taxCode = json['TaxCode'];
    docTotal = json['DocTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNum'] = this.docNum;
    data['DocStatus'] = this.docStatus;
    data['DocDate'] = this.docDate;
    data['CardCode'] = this.cardCode;
    data['CardName'] = this.cardName;
    data['NumAtCard'] = this.numAtCard;
    data['DocCur'] = this.docCur;
    data['LineNum'] = this.lineNum;
    data['ItemCode'] = this.itemCode;
    data['Dscription'] = this.dscription;
    data['Quantity'] = this.quantity;
    data['Price'] = this.price;
    data['WhsCode'] = this.whsCode;
    data['AcctCode'] = this.acctCode;
    data['TaxCode'] = this.taxCode;
    data['DocTotal'] = this.docTotal;
    return data;
  }
}
