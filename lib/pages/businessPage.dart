// ignore: file_names
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class BusinessPlanPage extends StatefulWidget {
  const BusinessPlanPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BusinessPage createState() => _BusinessPage();
}

class _BusinessPage extends State<BusinessPlanPage>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  String _generatedText = '';
  final TextEditingController _controller = TextEditingController();

  Future<void> _generatePrompt() async {
    final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: 'AIzaSyAOkOh4gSDYFNP4jM_n7x5yk2DNlvALLQE');

    const predefinedPrompt = "Business mind map:\n";
    final combinedPrompt = """
$predefinedPrompt
1. Create a flow chart for the following startup idea${_controller.text} that how can they get started in the market?,How can they do branding of their startups?,How can they get more profits? etc.. according to you they will only provide the startup idea you need to guide them in your own way that can be helpful for them.
2. For the begginers and keep it less points and clear.
3.write with creativity.""";
    final content = [Content.text(combinedPrompt)];

    final response = await model.generateContent(content);

    if (kDebugMode) {
      print(response.text);
    }

    setState(() {
      _isLoading = false;
      _generatedText = response.text as String;
    });
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
      appBar: AppBar(title: const Text("Business Plan")),
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
              )),
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255)),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        labelText: 'what is your startup idea?',
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _onGenerateButtonPressed,
                    child: const Text('Create Plan'),
                  ),
                  const SizedBox(height: 30),
                  if (_isLoading) const CircularProgressIndicator(),
                  const SizedBox(height: 30),
                  if (_generatedText.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _generatedText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
