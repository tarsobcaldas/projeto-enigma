class Rotor {
  String wiring;
  int notch;
  int position;

  Rotor(this.wiring, this.notch) : position = 0;

  // ignore: non_constant_identifier_names
  void set_position(int position) {
    this.position = position % wiring.length;
  }

  // ignore: non_constant_identifier_names
  String encrypt_forward(String letter) {
    int offset = (letter.codeUnitAt(0) - 'A'.codeUnitAt(0) + position) % 26;
    int encryptedOffset =
        (wiring[offset].codeUnitAt(0) - 'A'.codeUnitAt(0) - position) % 26;
    String encryptedLetter =
        String.fromCharCode(encryptedOffset + 'A'.codeUnitAt(0));
    return encryptedLetter;
  }

  // ignore: non_constant_identifier_names
  String encrypt_backward(String letter) {
    int offset = (letter.codeUnitAt(0) - 'A'.codeUnitAt(0) + position) % 26;
    int encryptedOffset =
        (wiring.indexOf(String.fromCharCode(offset + 'A'.codeUnitAt(0))) -
                position) %
            26;
    if (encryptedOffset < 0) {
      encryptedOffset += 26;
    }
    String encryptedLetter =
        String.fromCharCode(encryptedOffset + 'A'.codeUnitAt(0));
    return encryptedLetter;
  }
}
