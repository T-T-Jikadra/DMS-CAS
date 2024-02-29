// ignore_for_file: file_names
class NGORegistration {
  final String ngoName;
  final String ngoRegNo;
  final String services;
  final String contactNumber;
  final String email;
  final String website;
  final String state;
  final String city;
  final String pinCode;
  final String fullAddress;
  final String password;
  final String confirmPassword;
  final bool termsAccepted;
  final DateTime registrationTime; // New field to store registration time
  final String userType;

  NGORegistration({
    required this.ngoName,
    required this.ngoRegNo,
    required this.services,
    required this.contactNumber,
    required this.email,
    required this.website,
    required this.state,
    required this.city,
    required this.pinCode,
    required this.fullAddress,
    required this.password,
    required this.confirmPassword,
    required this.termsAccepted,
    this.userType = "NGO",
    DateTime?
    registrationTime, // Nullable DateTime to allow automatic assignment
  }) : registrationTime =
      registrationTime ?? DateTime.now(); // Assign current time if null

  Map<String, dynamic> toJson() {
    return {
      'nameOfNGO': ngoName,
      'NGORegNo': ngoRegNo,
      'services': services,
      'contactNumber': "+91$contactNumber",
      'website': website,
      'email': email,
      'state': state,
      'city': city,
      'pinCode': pinCode,
      'fullAddress': fullAddress,
      'password': password,
      'confirmPassword': confirmPassword,
      'termsAccepted': termsAccepted,
      'registrationTime': registrationTime.toString(),
      'userType': "NGO"

    };
  }
}
