abstract class Captilizations {
  static String capitalize(String s) {
    if (s.isEmpty) return '';
    return s[0].toUpperCase() + (s.length > 1 ? s.substring(1) : '');
  }

  static String capitalizeFirstOfEach(String s) {
    return s.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + (word.length > 1 ? word.substring(1) : '');
    }).join(' ');
  }
}
