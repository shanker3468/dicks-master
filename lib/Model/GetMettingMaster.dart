class GetMettingMaster {
  int? status;
  List<Result>? result;

  GetMettingMaster({this.status, this.result});

  GetMettingMaster.fromJson(Map<String, dynamic> json) {
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
  String? systemDate;
  int? docNo;
  String? cardName;
  String? mobileNo;
  String? contactPerson;
  String? startTime;
  String? endTime;
  String? joinedPerson;
  String? demoStatus;
  String? mettingStatus;
  String? nextMettingDate;

  Result(
      {this.systemDate,
        this.docNo,
        this.cardName,
        this.mobileNo,
        this.contactPerson,
        this.startTime,
        this.endTime,
        this.joinedPerson,
        this.demoStatus,
        this.mettingStatus,
        this.nextMettingDate});

  Result.fromJson(Map<String, dynamic> json) {
    systemDate = json['SystemDate'];
    docNo = json['DocNo'];
    cardName = json['CardName'];
    mobileNo = json['MobileNo'];
    contactPerson = json['ContactPerson'];
    startTime = json['StartTime'];
    endTime = json['EndTime'];
    joinedPerson = json['JoinedPerson'];
    demoStatus = json['DemoStatus'];
    mettingStatus = json['MettingStatus'];
    nextMettingDate = json['NextMettingDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SystemDate'] = systemDate;
    data['DocNo'] = docNo;
    data['CardName'] = cardName;
    data['MobileNo'] = mobileNo;
    data['ContactPerson'] = contactPerson;
    data['StartTime'] = startTime;
    data['EndTime'] = endTime;
    data['JoinedPerson'] = joinedPerson;
    data['DemoStatus'] = demoStatus;
    data['MettingStatus'] = mettingStatus;
    data['NextMettingDate'] = nextMettingDate;
    return data;
  }
}
