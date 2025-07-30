enum FieldError {
  emptyFromCountry("Please fill the departure country field!"),
  emptyFromProvince("Please fill the departure province field!"),
  emptyFromDistrict("Please fill the departure district field!"),
  emptyToCountry("Please fill the destination country field!"),
  emptyToProvince("Please fill the destination province field!"),
  emptyToDistrict("Please fill the destination district field!"),
  emptyVehicleType("Please fill the vehicle type field!"),
  emptyTrailerType("Please fill the trailer type field!"),
  emptyLoadType("Please fill the load type field!"),
  emptyBrand("Please fill the brand field!"),
  emptyName("Please fill the name field!"),
  emptyPlate("Please fill the license plate field!"),
  emptyPhoneNumber("Please fill the phone number field!"),
  emptyPassword("Please fill the password field!"),
  emptyRepassword("Please fill the password confirmation field!"),
  emptyProvince("Please fill the province field!"),
  emptyDistrict("Please fill the district field!"),

  // Register specific errors
  emptyFullName("Please fill the full name field!"),
  emptyEmail("Please fill the email field!"),
  emptyEmailConfirm("Please fill the email confirmation field!"),
  invalidEmail("Please enter a valid email address!"),
  emailsNotMatch("Email addresses do not match!"),
  invalidPassword(
      "Password must be at least 8 characters with uppercase, lowercase and number!"),
  passwordsNotMatch("Passwords do not match!"),
  termsNotAccepted("You must accept the terms and conditions!"),

  // Vehicle registration specific errors
  emptyLicencePlate("Please fill the licence plate field!"),
  invalidLicencePlate("Please enter a valid licence plate!"),
  invalidBrand("Brand must be at least 2 characters!"),
  emptyModel("Please fill the model field!"),
  emptyYear("Please select the year!"),
  emptyCapacity("Please select the capacity!"),
  emptyInteriorColor("Please select the interior color!"),
  emptyExteriorColor("Please select the exterior color!"),

  // Company registration specific errors
  emptyCompanyName("Please fill the company name field!"),
  invalidCompanyName("Company name must be at least 2 characters!"),
  emptyAuthorizedPerson("Please fill the authorized person field!"),
  invalidAuthorizedPerson("Authorized person must be at least 2 characters!"),
  emptyCompanyPhone("Please fill the company phone field!"),
  invalidCompanyPhone("Please enter a valid company phone number!"),
  emptyCompanyEmail("Please fill the company email field!"),
  invalidCompanyEmail("Please enter a valid company email address!"),
  emptyTaxNumber("Please fill the tax number field!"),
  invalidTaxNumber("Please enter a valid tax number!"),
  emptyCompanyAddress("Please fill the company address field!"),
  invalidCompanyAddress("Company address must be at least 5 characters!");

  final String message;
  const FieldError(this.message);
}
