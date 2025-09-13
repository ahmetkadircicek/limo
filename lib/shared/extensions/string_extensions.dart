extension StringExtensions on String {
  // String get locale => this.tr();

  String toImagePng() {
    return 'assets/images/$this.png';
  }

  String toImageJpg() {
    return 'assets/images/$this.jpg';
  }

  String toLottie() {
    return 'assets/lotties/$this.json';
  }

  String toIconPng() {
    return 'assets/icons/$this.png';
  }

  String replaceSpecialCharacters() {
    return replaceAll('.', '-') // Noktaları tire ile değiştir
        .replaceAll('#', '-') // Diyez işaretlerini tire ile değiştir
        .replaceAll('\$', '-') // Dolar işaretlerini tire ile değiştir
        .replaceAll('[', '-') // Köşeli parantezleri tire ile değiştir
        .replaceAll(']', '-'); // Köşeli parantezleri tire ile değiştir
  }
}
