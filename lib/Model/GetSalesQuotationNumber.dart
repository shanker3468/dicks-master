class GetSalesQuotationNumber {
  int? status;
  List<Result>? result;

  GetSalesQuotationNumber({this.status, this.result});

  GetSalesQuotationNumber.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
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
  int? docNo;
  String? leadName;
  var lineTotal;

  Result({this.docNo, this.leadName, this.lineTotal});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    leadName = json['LeadName'];
    lineTotal = json['LineTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DocNo'] = docNo;
    data['LeadName'] = leadName;
    data['LineTotal'] = lineTotal;
    return data;
  }
}
