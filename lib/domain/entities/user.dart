class User {
  final String id;
  final String pw;
  final String company;
  final String name;
  final String location;
  final String phoneNum;

  User({
    required this.id,
    required this.pw,
    required this.company,
    required this.name,
    required this.location,
    required this.phoneNum,
  });

  User copyWith({
    String? id,
    String? pw,
    String? company,
    String? name,
    String? location,
    String? phoneNum,
  }) {
    return User(
      id: id ?? this.id,
      pw: pw ?? this.pw,
      company: company ?? this.company,
      name: name ?? this.name,
      location: location ?? this.location,
      phoneNum: phoneNum ?? this.phoneNum,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'pw': pw,
    'company': company,
    'name': name,
    'location': location,
    'phoneNum': phoneNum,
  };

  factory User.fromMap(Map<String, dynamic> map) => User(
    id: map['id'],
    pw: map['pw'],
    company: map['company'],
    name: map['name'],
    location: map['location'],
    phoneNum: map['phoneNum'],
  );
}