class User {
  final String? id;
  final String username;
  final String password;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;  
  final String? address;
  final DateTime? birthDate;
  final String? gender;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,  
    this.address,
    this.birthDate,
    this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'firstName': firstName ?? '',
      'lastName': lastName ?? '',
      'phoneNumber': phoneNumber ?? '',
      'address': address ?? '',
      'birthDate': birthDate?.toIso8601String(),
      'gender': gender ?? '',
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString(),
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      birthDate: json['birthDate'] != null 
          ? DateTime.parse(json['birthDate']) 
          : null,
      gender: json['gender'],
    );
  }
}