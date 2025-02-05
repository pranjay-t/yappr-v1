class UserModel {
  final String name;
  final String profilePic;
  final String email;
  final String phoneNumber;
  final String uid;

  UserModel({
    required this.name,
    required this.profilePic,
    required this.email,
    required this.phoneNumber,
    required this.uid,
  });

  UserModel copyWith({
    String? name,
    String? profilePic,
    String? email,
    String? phoneNumber,
    String? uid,
    bool? isAuthenticated,
  }) {
    return UserModel(
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePic': profilePic,
      'email': email,
      'phoneNumber': phoneNumber,
      'uid': uid,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String,
      uid: map['uid'] as String,
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, profilePic: $profilePic, email: $email, phoneNumber: $phoneNumber, uid: $uid)';
  }

}
