
class User {
  int id;
  String name;
  String email;
  String phoneNumber;
  int status;
  String token;
  String imgUrl;
  String createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.status,
    required this.token,
    required this.imgUrl,
    required this.createdAt
  });

  static fromJson(Map<dynamic, dynamic> json){
    return User(
      id: json['id'] ?? 0,
      name: (json['firstName']  + ' ' + json['lastName']) ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      status: (json['status'] is String) ? (json['status'] == 'SUCCESS' ? 1 : 0)  : 1,
      token: json['token'] ?? 0,
        imgUrl: json['imgUrl'] ?? '',
        createdAt: json['createdAt'] ?? ''
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'status': status,
      'token': token,
      'imgUrl': imgUrl,
      'createdAt': createdAt
    };
  }
}