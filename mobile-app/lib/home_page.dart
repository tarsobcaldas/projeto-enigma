import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'enigma_message.dart';
import 'enigma_machine.dart';
import 'reflector.dart';
import 'rotor.dart';

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
      // Create a new instance of EnigmaMachine for each decryption
      EnigmaMachine enigmaMachine = EnigmaMachine([
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
              onPressed: () {
                decryptMessage();
              },
              child: const Text('Decrypt Message'),
            ),
            if (selectedMessageIndex != -1) ...[
              const Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  'Decrypted Message:',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  decryptedMessage,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
