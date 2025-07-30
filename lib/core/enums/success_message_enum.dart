enum SuccessMessageEnum {
  loginSuccess('Login successful.\nWelcome!'),
  registerSuccess('Registration successful.\nWelcome!'),
  updateProfileSuccess('Your information has been updated successfully.'),
  createAdvertSuccess('Advertisement created successfully.'),
  vehicleRegisterSuccess(
      'Vehicle registered successfully!\nYou can now use the app.'),
  companyRegisterSuccess(
      'Company registered successfully!\nYou can now use the app.');

  final String successMessage;

  const SuccessMessageEnum(this.successMessage);
}
