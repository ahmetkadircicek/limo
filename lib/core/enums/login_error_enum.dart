enum LoginErrorEnum {
  invalidPhoneNumber("Please enter a valid phone number."),
  invalidEmail("Please enter a valid email address."),
  invalidPassword("Password must be at least 6 characters long."),
  emptyPassword("Please enter your password."),
  emptyPhoneNumber("Please enter your phone number."),
  emptyEmail("Please enter your email address."),
  invalidData("Please enter valid email and password."),
  userNotFound("User not found. Please check your credentials.");

  final String errorMessage;

  const LoginErrorEnum(this.errorMessage);
}
