class GetSaleQuotationDetails {
  int? status;
  List<Result>? result;

  GetSaleQuotationDetails({this.status, this.result});

  GetSaleQuotationDetails.fromJson(Map<String, dynamic> json) {
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

  Result(
      {this.docNo,
        this.leadName,
        this.itemName,
        this.invntryUom,
        this.price,
        this.qty,
        this.amt,
        this.taxCode,
        this.taxAmt,
        this.lineTotal});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    leadName = json['LeadName'];
    itemName = json['ItemName'];
    invntryUom = json['InvntryUom'];
    price = json['Price'];
    qty = json['Qty'];
    amt = json['Amt'];
    taxCode = json['TaxCode'];
    taxAmt = json['TaxAmt'];
    lineTotal = json['LineTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['LeadName'] = this.leadName;
    data['ItemName'] = this.itemName;
    data['InvntryUom'] = this.invntryUom;
    data['Price'] = this.price;
    data['Qty'] = this.qty;
    data['Amt'] = this.amt;
    data['TaxCode'] = this.taxCode;
    data['TaxAmt'] = this.taxAmt;
    data['LineTotal'] = this.lineTotal;
    return data;
  }
}
