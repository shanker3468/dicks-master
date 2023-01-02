class GetHsnMaster {
  int? status;
  List<Result>? result;

  GetHsnMaster({this.status, this.result});

  GetHsnMaster.fromJson(Map<String, dynamic> json) {
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
  int? absEntry;
  String? chapter;
  String? heading;
  String? subHeading;
  var dscription;
  String? chapterID;

  Result(
      {this.absEntry,
        this.chapter,
        this.heading,
        this.subHeading,
        this.dscription,
        this.chapterID});

  Result.fromJson(Map<String, dynamic> json) {
    absEntry = json['AbsEntry'];
    chapter = json['Chapter'];
    heading = json['Heading'];
    subHeading = json['SubHeading'];
    dscription = json['Dscription'];
    chapterID = json['ChapterID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AbsEntry'] = absEntry;
    data['Chapter'] = chapter;
    data['Heading'] = heading;
    data['SubHeading'] = subHeading;
    data['Dscription'] = dscription;
    data['ChapterID'] = chapterID;
    return data;
  }
}
