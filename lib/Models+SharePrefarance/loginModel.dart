class loginModel {
  String? tokenType;
  int? exp;
  int? iat;
  String? jti;
  int? userId;
  String? username;
  String? name;
  bool? isStaff;
  String? email;
  String? phone;

  loginModel(
      {this.tokenType,
        this.exp,
        this.iat,
        this.jti,
        this.userId,
        this.username,
        this.name,
        this.isStaff,
        this.email,
        this.phone});

  loginModel.fromJson(Map<String, dynamic> json) {
    tokenType = json['token_type'];
    exp = json['exp'];
    iat = json['iat'];
    jti = json['jti'];
    userId = json['user_id'];
    username = json['username'];
    name = json['name'];
    isStaff = json['is_staff'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token_type'] = this.tokenType;
    data['exp'] = this.exp;
    data['iat'] = this.iat;
    data['jti'] = this.jti;
    data['user_id'] = this.userId;
    data['username'] = this.username;
    data['name'] = this.name;
    data['is_staff'] = this.isStaff;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}
