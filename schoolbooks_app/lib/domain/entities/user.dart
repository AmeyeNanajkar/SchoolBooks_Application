import 'package:equatable/equatable.dart';

enum UserRole { family, school, vendor, admin }

class User extends Equatable {
  final String id;
  final String email;
  final String? phone;
  final String name;
  final UserRole role;
  final String? avatar;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    this.phone,
    required this.name,
    required this.role,
    this.avatar,
    this.isVerified = false,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, email, phone, name, role, avatar, isVerified, createdAt, updatedAt];
}

class Address extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String phone;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String addressType;
  final bool isDefault;
  final DateTime createdAt;

  const Address({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    this.addressType = 'home',
    this.isDefault = false,
    required this.createdAt,
  });

  String get fullAddress => '$addressLine1${addressLine2 != null ? ', $addressLine2' : ''}, $city, $state - $pincode';

  @override
  List<Object?> get props => [id, userId, name, phone, addressLine1, addressLine2, city, state, pincode, addressType, isDefault, createdAt];
}
