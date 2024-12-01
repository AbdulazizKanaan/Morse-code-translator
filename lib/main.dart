import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MorseCodeApp());
}

class MorseCodeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MorseCodeHomeScreen(),
    );
  }
}

class MorseCodeHomeScreen extends StatefulWidget {
  @override
  _MorseCodeHomeScreenState createState() => _MorseCodeHomeScreenState();
}

class _MorseCodeHomeScreenState extends State<MorseCodeHomeScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _morseController = TextEditingController();

  String _morseCodeOutput = '';
  String _textOutput = '';

  final Map<String, String> _morseCodeMap = {
    'A': '.-', 'B': '-...', 'C': '-.-.', 'D': '-..', 'E': '.',
    'F': '..-.', 'G': '--.', 'H': '....', 'I': '..', 'J': '.---',
    'K': '-.-', 'L': '.-..', 'M': '--', 'N': '-.', 'O': '---',
    'P': '.--.', 'Q': '--.-', 'R': '.-.', 'S': '...', 'T': '-',
    'U': '..-', 'V': '...-', 'W': '.--', 'X': '-..-', 'Y': '-.--',
    'Z': '--..', '1': '.----', '2': '..---', '3': '...--', '4': '....-',
    '5': '.....', '6': '-....', '7': '--...', '8': '---..', '9': '----.',
    '0': '-----', ' ': '/'
  };
  final Map<String, String> _reverseMorseCodeMap = {};

  final List<String> _facts = [
    "Morse code was developed in the 1830s by Samuel Morse and Alfred Vail.",
    "The most well-known Morse code signal is SOS: ...---...",
    "Pilots and air traffic controllers use Morse code to identify navigational aids like VORs (VHF Omnidirectional Range) and NDBs (Non-Directional Beacons).",
    "Morse code can be transmitted by sound, light, or visual signals.",
    "Morse code was widely used in aviation and maritime industries.",
    "Morse code can be understood regardless of language, as it’s based on sound or light patterns, not words.",
    "The word LOVE in Morse code is: .-.. --- ...- .",
    "The opening of the 2000 Sydney Olympics featured the word “ETERNITY” spelled out in Morse code.",
    "Morse code was famously used in espionage during World Wars I and II. Spies used it for encrypted messages and covert operations.",
    "Morse code has been a critical tool for people with disabilities, such as those with locked-in syndrome, who can communicate by blinking their eyes.",
    "Despite its decline in practical use, many military personnel, Boy Scouts, and survival enthusiasts still learn Morse code as part of their training.",
  ];
  String _currentFact = '';

  @override
  void initState() {
    super.initState();
    _morseCodeMap.forEach((key, value) {
      _reverseMorseCodeMap[value] = key;
    });
    _showRandomFact();
  }

  void _showRandomFact() {
    setState(() {
      _currentFact = _facts[Random().nextInt(_facts.length)];
    });
  }

  String _translateToMorse(String text) {
    return text.toUpperCase().split('').map((char) {
      if (char == ' ') {
        return '/';
      } else {
        return _morseCodeMap[char] ?? '?';
      }
    }).join(' ');
  }


  String _translateToText(String morse) {
    return morse
        .split(RegExp(r'\s{2,}')) // Split by 3 or more spaces to separate words
        .map((word) => word
        .split(' ') // Split by single spaces to separate letters
        .map((code) => _reverseMorseCodeMap[code] ?? '?')
        .join('')) // Combine letters into words
        .join(' '); // Combine words with a single space
  }


  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Copied to clipboard")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Morse Code Translator',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Text to Morse Code
            TextField(
              controller: _textController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Your text",
                hintText: "Type something",
                labelStyle: TextStyle(color: Colors.white),
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _morseCodeOutput = _translateToMorse(_textController.text);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
              ),
              child: Text("Translate to Morse"),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Morse Code:",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                IconButton(
                  onPressed: () => _copyToClipboard(_morseCodeOutput),
                  icon: Icon(Icons.copy, color: Colors.white),
                ),
              ],
            ),
            Text(
              _morseCodeOutput,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Divider(color: Colors.grey[700], height: 40),

            // Morse to Text
            TextField(
              controller: _morseController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Your Morse",
                hintText: "Type something",
                labelStyle: TextStyle(color: Colors.white),
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _textOutput = _translateToText(_morseController.text);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
              ),
              child: Text("Translate to Text"),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Text:",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                IconButton(
                  onPressed: () => _copyToClipboard(_textOutput),
                  icon: Icon(Icons.copy, color: Colors.white),
                ),
              ],
            ),
            Text(
              _textOutput,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Spacer(),


            Text(
              "Did You Know?",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              _currentFact,
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _showRandomFact,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
              ),
              child: Text("Show Another Fact"),
            ),
          ],
        ),
      ),
    );
  }
}
