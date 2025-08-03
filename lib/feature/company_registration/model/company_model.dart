class CompanyModel {
  final String companyName;
  final String authorizedPerson;
  final String companyPhone;
  final String companyEmail;
  final String taxNumber;
  final String companyAddress;

  CompanyModel({
    required this.companyName,
    required this.authorizedPerson,
    required this.companyPhone,
    required this.companyEmail,
    required this.taxNumber,
    required this.companyAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'authorizedPerson': authorizedPerson,
      'companyPhone': companyPhone,
      'companyEmail': companyEmail,
      'taxNumber': taxNumber,
      'companyAddress': companyAddress,
    };
  }

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      companyName: json['companyName'] ?? '',
      authorizedPerson: json['authorizedPerson'] ?? '',
      companyPhone: json['companyPhone'] ?? '',
      companyEmail: json['companyEmail'] ?? '',
      taxNumber: json['taxNumber'] ?? '',
      companyAddress: json['companyAddress'] ?? '',
    );
  }
}
