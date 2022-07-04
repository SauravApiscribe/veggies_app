class UserDto {
  final String firstName;
  final String lastName;
  final String mobile;
  final String email;
  final bool doesHoldMembership;
  final bool isEmailVerified;
  final String token;

  UserDto({
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.email,
    required this.doesHoldMembership,
    required this.isEmailVerified,
    required this.token,
  });

  UserDto.fromJson(Map<String, dynamic> json)
      : firstName = json['firstName'],
        lastName = json['lastName'],
        mobile = json['mobile'],
        email = json['email'],
        doesHoldMembership = json['doesHoldMembership'],
        isEmailVerified = json['isEmailVerified'],
        token = json['token'];
}
