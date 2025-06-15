import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String fname;
  final String lname;
  final String email;
  final String phone;
  final String password;

  const UserEntity({
    required this.userId,
    required this.fname,
    required this.lname,
    required this.email,
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [userId, fname, lname, email, password];
}
