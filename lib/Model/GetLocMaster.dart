class GetLocMaster {
  int? status;
  List<Result>? result;

  GetLocMaster({this.status, this.result});

  GetLocMaster.fromJson(Map<String, dynamic> json) {
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
  int? code;
  String? location;

  Result({this.code, this.location});

  Result.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    location = json['Location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Code'] = this.code;
    data['Location'] = this.location;
    return data;
  }
}
