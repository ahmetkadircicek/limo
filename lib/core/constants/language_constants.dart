class LanguageConstants {
  static LanguageConstants? _instance;
  static LanguageConstants get instance {
    _instance ??= LanguageConstants._init();
    return _instance!;
  }

  LanguageConstants._init();

  List<String> supportedLanguages = [
    'Arabic',
    'Chinese',
    'Spanish',
    'English',
    'Russian',
    'Japanese',
    'Turkish'
  ];
}
