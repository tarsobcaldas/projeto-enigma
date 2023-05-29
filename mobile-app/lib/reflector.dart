class Reflector {
  String wiring;

  Reflector(this.wiring);

  String encrypt(String letter) {
    int offset = letter.codeUnitAt(0) - 'A'.codeUnitAt(0);
    int encryptedOffset = wiring[offset].codeUnitAt(0) - 'A'.codeUnitAt(0);
    String encryptedLetter =
        String.fromCharCode(encryptedOffset + 'A'.codeUnitAt(0));
    return encryptedLetter;
  }
}
