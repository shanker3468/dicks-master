class CardCodeMaster {
  int? status;
  List<Result>? result;

  CardCodeMaster({this.status, this.result});

  CardCodeMaster.fromJson(Map<String, dynamic> json) {
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
  String? cardCode;
  String? cardName;

  Result({this.cardCode, this.cardName});

  Result.fromJson(Map<String, dynamic> json) {
    cardCode = json['CardCode'];
    cardName = json['CardName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CardCode'] = cardCode;
    data['CardName'] = cardName;
    return data;
  }
}
