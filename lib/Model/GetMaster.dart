class GetMaster {
  int? status;
  List<Result>? result;

  GetMaster({this.status, this.result});

  GetMaster.fromJson(Map<String, dynamic> json) {
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
  String? contactPersonPosition;
  String? email;
  String? streetName;
  String? landMark;
  String? district;
  String? state;
  String? officeNo;
  String? docDate;
  String? createBy;
  String? schedularStatus;
  String? mettingStatus;
  String? reqrimentStatus;
  String? queationStatus;
  String? remainderDate;
  String? schedulerTime;
  String? demo;

  Result(
      {this.systemDate,
        this.docNo,
        this.cardName,
        this.mobileNo,
        this.contactPerson,
        this.contactPersonPosition,
        this.email,
        this.streetName,
        this.landMark,
        this.district,
        this.state,
        this.officeNo,
        this.docDate,
        this.createBy,
        this.schedularStatus,
        this.mettingStatus,
        this.reqrimentStatus,
        this.queationStatus,
        this.remainderDate,
        this.schedulerTime,
        this.demo});

  Result.fromJson(Map<String, dynamic> json) {
    systemDate = json['SystemDate'];
    docNo = json['DocNo'];
    cardName = json['CardName'];
    mobileNo = json['MobileNo'];
    contactPerson = json['ContactPerson'];
    contactPersonPosition = json['ContactPersonPosition'];
    email = json['Email'];
    streetName = json['StreetName'];
    landMark = json['LandMark'];
    district = json['District'];
    state = json['State'];
    officeNo = json['OfficeNo'];
    docDate = json['DocDate'];
    createBy = json['CreateBy'];
    schedularStatus = json['SchedularStatus'];
    mettingStatus = json['MettingStatus'];
    reqrimentStatus = json['ReqrimentStatus'];
    queationStatus = json['QueationStatus'];
    remainderDate = json['RemainderDate'];
    schedulerTime = json['SchedulerTime'];
    demo = json['Demo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SystemDate'] = systemDate;
    data['DocNo'] = docNo;
    data['CardName'] = cardName;
    data['MobileNo'] = mobileNo;
    data['ContactPerson'] = contactPerson;
    data['ContactPersonPosition'] = contactPersonPosition;
    data['Email'] = email;
    data['StreetName'] = streetName;
    data['LandMark'] = landMark;
    data['District'] = district;
    data['State'] = state;
    data['OfficeNo'] = officeNo;
    data['DocDate'] = docDate;
    data['CreateBy'] = createBy;
    data['SchedularStatus'] = schedularStatus;
    data['MettingStatus'] = mettingStatus;
    data['ReqrimentStatus'] = reqrimentStatus;
    data['QueationStatus'] = queationStatus;
    data['RemainderDate'] = this.remainderDate;
    data['SchedulerTime'] = this.schedulerTime;
    data['Demo'] = this.demo;
    return data;
  }
}
