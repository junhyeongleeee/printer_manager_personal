import '../../domain/entities/user.dart';

class UserModel {
  final String id;
  final String name;
  final String company;
  final String location;
  final String phoneNum;

  UserModel({
    required this.id,
    required this.name,
    required this.company,
    required this.location,
    required this.phoneNum,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    name: json['name'],
    company: json['company'],
    location: json['location'],
    phoneNum: json['phoneNum'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'company': company,
    'location': location,
    'phoneNum': phoneNum,
  };

  User toEntity({String? existingPw}) {
    return User(
      id: id,
      name: name,
      company: company,
      location: location,
      phoneNum: phoneNum,
      pw: existingPw ?? '', // 기존 pw 유지
    );
  }
}
