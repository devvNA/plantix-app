import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.sub,
    required this.name,
    required this.email,
    required this.address,
    required this.hasStore,
    required this.photoUrl,
    required this.phoneNumber,
    required this.emailVerified,
    required this.phoneVerified,
  });

  final String sub;
  final String name;
  final String email;
  final String address;
  final bool hasStore;
  final String photoUrl;
  final String phoneNumber;
  final bool emailVerified;
  final bool phoneVerified;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      sub: json["sub"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      address: json["address"] ?? "",
      hasStore: json["has_store"] ?? false,
      photoUrl: json["photo_url"] ?? "",
      phoneNumber: json["phone_number"] ?? "",
      emailVerified: json["email_verified"] ?? false,
      phoneVerified: json["phone_verified"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        "sub": sub,
        "name": name,
        "email": email,
        "address": address,
        "has_store": hasStore,
        "photo_url": photoUrl,
        "phone_number": phoneNumber,
        "email_verified": emailVerified,
        "phone_verified": phoneVerified,
      };

  @override
  String toString() {
    return "$sub, $name, $email, $address, $hasStore, $photoUrl, $phoneNumber, $emailVerified, $phoneVerified, ";
  }

  @override
  List<Object?> get props => [
        sub,
        name,
        email,
        address,
        hasStore,
        photoUrl,
        phoneNumber,
        emailVerified,
        phoneVerified,
      ];
}
