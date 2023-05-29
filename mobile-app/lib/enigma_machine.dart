import 'rotor.dart';
import 'reflector.dart';

class EnigmaMachine {
  List<Rotor> rotors;
  Reflector reflector;

  EnigmaMachine(this.rotors, this.reflector);

  void setRotorPositions(List<int> positions) {
    for (int i = 0; i < rotors.length; i++) {
      rotors[i].set_position(positions[i]);
    }
  }

  String decrypt(String message) {
    String decryptedMessage = '';
    for (int i = 0; i < message.length; i++) {
      String letter = message[i].toUpperCase();
      if (letter.codeUnitAt(0) >= 'A'.codeUnitAt(0) &&
          letter.codeUnitAt(0) <= 'Z'.codeUnitAt(0)) {
        for (Rotor rotor in rotors) {
          letter = rotor.encrypt_forward(letter);
        }
        letter = reflector.encrypt(letter);
        for (int j = rotors.length - 1; j >= 0; j--) {
          letter = rotors[j].encrypt_backward(letter);
        }
        decryptedMessage += letter;
        rotateRotors();
      }
    }
    return decryptedMessage;
  }

  void rotateRotors() {
    bool rotateNext = true;
    for (Rotor rotor in rotors) {
      if (rotateNext) {
        rotor.position = (rotor.position + 1) % 26;
        if (rotor.position != rotor.notch) {
          rotateNext = false;
        }
      } else {
        break;
      }
    }
  }
}
