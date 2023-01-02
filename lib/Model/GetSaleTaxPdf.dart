class GetSaleTaxPdf {
  int? status;
  List<Result>? result;

  GetSaleTaxPdf({this.status, this.result});

  GetSaleTaxPdf.fromJson(Map<String, dynamic> json) {
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
  String? taxCode;
  var taxAmt;
  var cGST;
  var sGST;
  var per;

  Result(
      {this.docNo, this.taxCode, this.taxAmt, this.cGST, this.sGST, this.per});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    taxCode = json['TaxCode'];
    taxAmt = json['TaxAmt'];
    cGST = json['CGST'];
    sGST = json['SGST'];
    per = json['Per'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['TaxCode'] = this.taxCode;
    data['TaxAmt'] = this.taxAmt;
    data['CGST'] = this.cGST;
    data['SGST'] = this.sGST;
    data['Per'] = this.per;
    return data;
  }
}
