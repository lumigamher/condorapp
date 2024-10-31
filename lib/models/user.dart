class User {
  final String username;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final DateTime? birthDate;
  final String? gender;

  User({
    required this.username,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.phone = '',
    this.address = '',
    this.birthDate,
    this.gender,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
  };
}