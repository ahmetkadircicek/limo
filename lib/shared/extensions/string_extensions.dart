extension StringExtensions on String {
  // String get locale => this.tr();

  String toImagePng() {
    // TODO: Deprecate direct path building; use ImageTokens.png(name)
    return 'assets/png/$this.png';
  }

  String toImageJpg() {
    // TODO: Deprecate direct path building; use ImageTokens.png(name)
    return 'assets/png/$this.jpg';
  }

  String toLottie() {
    // TODO: Deprecate direct path building; use ImageTokens.lottie(name)
    return 'assets/lottie/$this.json';
  }

  String toIconPng() {
    // TODO: Deprecate direct path building; use ImageTokens.png(name)
    return 'assets/png/$this.png';
  }

  String replaceSpecialCharacters() {
    return replaceAll('.', '-') // Noktaları tire ile değiştir
        .replaceAll('#', '-') // Diyez işaretlerini tire ile değiştir
        .replaceAll('\$', '-') // Dolar işaretlerini tire ile değiştir
        .replaceAll('[', '-') // Köşeli parantezleri tire ile değiştir
        .replaceAll(']', '-'); // Köşeli parantezleri tire ile değiştir
  }
}
