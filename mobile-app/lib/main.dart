import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enigma Decrypter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class EnigmaMessage {
  final int id;
  final String message;

  EnigmaMessage({
    required this.id,
    required this.message,
  });

  factory EnigmaMessage.fromJson(Map<String, dynamic> json) {
    return EnigmaMessage(
      id: json['id'],
      message: json['message'],
    );
  }
}

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
    int encryptedOffset = (wiring.indexOf(String.fromCharCode(offset + 'A'.codeUnitAt(0))) - position) % 26;
    if (encryptedOffset < 0) {
      encryptedOffset += 26;
    }
    String encryptedLetter = String.fromCharCode(encryptedOffset + 'A'.codeUnitAt(0));
    return encryptedLetter;
  }

}

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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<EnigmaMessage> enigmaMessages = [];
  String decryptedMessage = '';
  int selectedMessageIndex = -1;
  EdgeInsets padding = EdgeInsets.zero;

  TextEditingController urlController = TextEditingController();
  int selectedDropdownValue1 = 1;
  int selectedDropdownValue2 = 1;
  int selectedDropdownValue3 = 1;

  late EnigmaMachine enigmaMachine; // Add this line

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(urlController.text));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<EnigmaMessage> messages = [];
      for (var item in jsonData) {
        messages.add(EnigmaMessage.fromJson(item));
      }
      setState(() {
        enigmaMessages = messages;
        selectedMessageIndex = -1;
      });
    } else {
      setState(() {
        enigmaMessages = [];
      });
    }
  }

  Future<void> decryptMessage() async {
    if (selectedMessageIndex >= 0 &&
        selectedMessageIndex < enigmaMessages.length) {
      
      // Create an instance of EnigmaMachine with selected rotor positions
      enigmaMachine = EnigmaMachine([
        Rotor('EKMFLGDQVZNTOWYHXUSPAIBRCJ', 16),
        Rotor('AJDKSIRUXBLHWTMCQGZNPYFVOE', 4),
        Rotor('BDFHJLCPRTXVZNYEIWGAKMUSQO', 21)
      ], Reflector('YRUHQSLDPXNGOKMIEBFZCWVJAT'));

      List<int> rotorPositions = [
        selectedDropdownValue1,
        selectedDropdownValue2,
        selectedDropdownValue3
      ];

      // Set the rotor positions
      enigmaMachine.setRotorPositions(rotorPositions);

      // Decrypt the message using the EnigmaMachine
      String encryptedMessage = enigmaMessages[selectedMessageIndex].message;
      String decryptedMessage = enigmaMachine.decrypt(encryptedMessage);

      setState(() {
        this.decryptedMessage = decryptedMessage;
      });
      // final response = await http.post(
      //   Uri.parse(urlController.text),
      //   body: json
      //       .encode({'message': enigmaMessages[selectedMessageIndex].message}),
      // );

      // if (response.statusCode == 200) {
      //   final jsonData = json.decode(response.body);
      //   setState(() {
      //     decryptedMessage = jsonData['decrypted_message'];
      //   });
      // } else {
      //   setState(() {
      //     decryptedMessage = 'Failed to decrypt message.';
      //   });
      // }
    }
  }

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    urlController.text = 'http://34.175.30.196:6379/';
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enigma Decrypter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                'Enigma Messages:',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: enigmaMessages.length,
                itemBuilder: (context, index) {
                  final message = enigmaMessages[index];
                  return ListTile(
                    title: Text(message.message),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: ${message.id}'),
                      ],
                    ),
                    tileColor:
                        selectedMessageIndex == index ? Colors.blue[100] : null,
                    onTap: () {
                      setState(() {
                        selectedMessageIndex = index;
                        decryptedMessage = '';
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  enigmaMessages = [];
                  selectedMessageIndex = -1;
                });
                fetchData();
              },
              child: const Text('Refresh'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text(
                        "Rotor 1",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButton<int>(
                        value: selectedDropdownValue1,
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedDropdownValue1 = newValue!;
                          });
                        },
                        items: <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        "Rotor 2",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButton<int>(
                        value: selectedDropdownValue2,
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedDropdownValue2 = newValue!;
                          });
                        },
                        items: <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        "Rotor 3",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButton<int>(
                        value: selectedDropdownValue3,
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedDropdownValue3 = newValue!;
                          });
                        },
                        items: <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: decryptMessage,
              child: const Text('Decrypt Message'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Decrypted Message:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: padding,
              child: Text(
                decryptedMessage,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
