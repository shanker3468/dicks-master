// ignore_for_file: file_names

class GetTaxCode {
  int? status;
  List<Result>? result;

  GetTaxCode({this.status, this.result});

  GetTaxCode.fromJson(Map<String, dynamic> json) {
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
  String? code;
  var rate;

  Result({this.code, this.rate});

  Result.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    rate = json['Rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Code'] = code;
    data['Rate'] = rate;
    return data;
  }
}
