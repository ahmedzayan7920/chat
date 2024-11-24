abstract class UserModelKeys{
  static const id = 'id';
  static const name = 'name';
  static const email = 'email';
  static const profilePictureUrl = 'profilePictureUrl';
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String profilePictureUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePictureUrl,
  });

  UserModel copyWith({
    String? name,
    String? profilePictureUrl,
    String? bio,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      UserModelKeys.id: id,
      UserModelKeys.name: name,
      UserModelKeys.email: email,
      UserModelKeys.profilePictureUrl: profilePictureUrl,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map[UserModelKeys.id] as String,
      name: map[UserModelKeys.name] as String,
      email: map[UserModelKeys.email] as String,
      profilePictureUrl: map[UserModelKeys.profilePictureUrl] as String,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, profilePictureUrl: $profilePictureUrl)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.profilePictureUrl == profilePictureUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        profilePictureUrl.hashCode;
  }
}
