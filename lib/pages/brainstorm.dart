import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:thinktank/prompts/Prompt_1.dart';

class BrainStormPage extends StatefulWidget {
  const BrainStormPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BrainstormPageState createState() => _BrainstormPageState();
}

class _BrainstormPageState extends State<BrainStormPage>
    with TickerProviderStateMixin {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final TextEditingController _controller5 = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    super.dispose();
  }

//Gemini API
  Future<void> _generatePrompt() async {
    final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: 'AIzaSyAOkOh4gSDYFNP4jM_n7x5yk2DNlvALLQE');

    const predefinedPrompt = "Brainstorming Session Summary:\n";
    final combinedPrompt = """
$predefinedPrompt
1. What problem do you want to solve? ${_controller1.text}
2. Who needs this solution? ${_controller2.text}
3. How do people currently solve this problem? ${_controller3.text}
4. What makes your solution different/better? ${_controller4.text}
5. How will you reach your target customers? ${_controller5.text}
""";
    final content = [Content.text(combinedPrompt)];

    final response = await model.generateContent(content);

    if (kDebugMode) {
      print(response.text);
    }

    setState(() {
      _isLoading = false;
    });

    // Navigate to PromptPage with the generated response
    Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (context) => PromptPage(prompt: response.text as String),
      ),
    );
  }

  void _onGenerateButtonPressed() {
    setState(() {
      _isLoading = true;
    });
    _generatePrompt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Brain Storm")),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            "images/bg1.jpg",
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _controller1,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255)),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        labelText: 'What problem do you want to solve?',
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 0, right: 10, left: 10),
                    child: TextField(
                      controller: _controller2,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255)),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        labelText: 'Who needs this solution?',
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 0, right: 10, left: 10),
                    child: TextField(
                      controller: _controller3,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255)),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        labelText:
                            'How do people currently solve this problem?',
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 0, right: 10, left: 10),
                    child: TextField(
                      controller: _controller4,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255)),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        labelText: 'What makes your solution different/better?',
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 0, right: 10, left: 10),
                    child: TextField(
                      controller: _controller5,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255)),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        labelText: 'How will you reach your target customers?',
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: _onGenerateButtonPressed,
                      child: const Text('Generate Prompt'),
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (_isLoading) const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
