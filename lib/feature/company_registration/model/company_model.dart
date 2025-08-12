class CompanyModel {
  final String companyName;
  final String authorizedPerson;
  final String companyPhone;
  final String companyEmail;
  final String taxNumber;
  final String companyAddress;
  final String? companyWebsite;
  final String? companyDescription;
  final String? foundedYear;
  final String? employeeCount;
  final String? companyType;
  final String? serviceAreas;

  CompanyModel({
    required this.companyName,
    required this.authorizedPerson,
    required this.companyPhone,
    required this.companyEmail,
    required this.taxNumber,
    required this.companyAddress,
    this.companyWebsite,
    this.companyDescription,
    this.foundedYear,
    this.employeeCount,
    this.companyType,
    this.serviceAreas,
  });

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'authorizedPerson': authorizedPerson,
      'companyPhone': companyPhone,
      'companyEmail': companyEmail,
      'taxNumber': taxNumber,
      'companyAddress': companyAddress,
      'companyWebsite': companyWebsite,
      'companyDescription': companyDescription,
      'foundedYear': foundedYear,
      'employeeCount': employeeCount,
      'companyType': companyType,
      'serviceAreas': serviceAreas,
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
      companyWebsite: json['companyWebsite'],
      companyDescription: json['companyDescription'],
      foundedYear: json['foundedYear'],
      employeeCount: json['employeeCount'],
      companyType: json['companyType'],
      serviceAreas: json['serviceAreas'],
    );
  }

  CompanyModel copyWith({
    String? companyName,
    String? authorizedPerson,
    String? companyPhone,
    String? companyEmail,
    String? taxNumber,
    String? companyAddress,
    String? companyWebsite,
    String? companyDescription,
    String? foundedYear,
    String? employeeCount,
    String? companyType,
    String? serviceAreas,
  }) {
    return CompanyModel(
      companyName: companyName ?? this.companyName,
      authorizedPerson: authorizedPerson ?? this.authorizedPerson,
      companyPhone: companyPhone ?? this.companyPhone,
      companyEmail: companyEmail ?? this.companyEmail,
      taxNumber: taxNumber ?? this.taxNumber,
      companyAddress: companyAddress ?? this.companyAddress,
      companyWebsite: companyWebsite ?? this.companyWebsite,
      companyDescription: companyDescription ?? this.companyDescription,
      foundedYear: foundedYear ?? this.foundedYear,
      employeeCount: employeeCount ?? this.employeeCount,
      companyType: companyType ?? this.companyType,
      serviceAreas: serviceAreas ?? this.serviceAreas,
    );
  }
}
