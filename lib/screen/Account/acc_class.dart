class UserAcc {
  late int userId;
  late String username, gender, email, password, address, mobile;
  UserAcc({
    required this.userId,
    required this.username,
    required this.gender,
    required this.email,
    required this.password,
    required this.address,
    required this.mobile,
  });

  factory UserAcc.fromJson(Map<String, dynamic> json) {
    return UserAcc(
      userId: int.parse(json['id'].toString()),
      username: json['username'],
      gender: json['gender'],
      email: json['email'],
      password: json['password'],
      address: json['address'],
      mobile: json['mobile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'username': username,
      'gender': gender,
      'email': email,
      'password': password,
      'address': address,
      'mobile': mobile,
    };
  }
}
