class LoginModel {
  int? status;
  List<Result>? result;

  LoginModel({this.status, this.result});

  LoginModel.fromJson(Map<String, dynamic> json) {
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
  int? empId;
  String? firstName;
  int? dept;
  String? name;

  Result({this.empId, this.firstName, this.dept, this.name});

  Result.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    firstName = json['firstName'];
    dept = json['dept'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empId'] = empId;
    data['firstName'] = firstName;
    data['dept'] = dept;
    data['Name'] = name;
    return data;
  }
}
