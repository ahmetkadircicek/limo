enum LoginErrorEnum {
  invalidPhoneNumber("Please enter a valid phone number."),
  invalidPassword("Please enter a valid password."),
  emptyPassword("Please enter your password."),
  emptyPhoneNumber("Please enter your phone number."),
  invalidData("Please enter valid phone number and password."),
  userNotFound("User not found. Please check your credentials.");

  final String errorMessage;

  const LoginErrorEnum(this.errorMessage);
}
