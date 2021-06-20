class UserAccount{
  String address;
  String backName;
  String frontName;
  String email;
  String isValidate;
  String password;
  String phoneNumber;
  String id;

  UserAccount({
    this.id,
    this.phoneNumber,
    this.email,
    this.password,
    this.isValidate,
    this.frontName,
    this.backName,
    this.address
  });

  factory UserAccount.fromJson(Map<String, dynamic> _json){
    return UserAccount(
        address : _json["address"] as String,
        frontName:_json["frontName"] as String,
        backName:_json["backName"] as String,
        email:_json["email"] as String,
        phoneNumber:_json["phoneNumber"] as String,
        id:_json["id"] as String,
        password:_json["password"] as String,
        isValidate:_json["isValidate"] as String,
    );
  }

  Map<String, dynamic> toJson() =>
      {
        "address":address,
        "frontName": frontName,
        "backName": backName,
        "email": email,
        "phoneNumber": phoneNumber,
        "id": id,
        "password": password,
        "isValidate": isValidate,
      };
}