class GetLeaddata {
  int? status;
  List<Result>? result;

  GetLeaddata({this.status, this.result});

  GetLeaddata.fromJson(Map<String, dynamic> json) {
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

  Result(
      {this.docNo,
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
        this.createBy});

  Result.fromJson(Map<String, dynamic> json) {
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    return data;
  }
}
