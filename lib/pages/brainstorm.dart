// ignore: file_names
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:thinktank/prompts/Prompt_1.dart';

class BrainStormPage extends StatefulWidget {
  const BrainStormPage({super.key});

  @override
  State<BrainStormPage> createState() => _BrainstormPageState();
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

  /// GEMINI API
  Future<void> _generatePrompt() async {
    final model = GenerativeModel(
      model: "gemini-2.5-flash",
      apiKey: "AIzaSyDFPEosgraV0yCVzkGRcMDOPPOa2YVOOKs",
    );

    final combinedPrompt = """
Create a brainstorming summary in MARKDOWN format.

Use the following information:

Problem:
${_controller1.text}

Target Users:
${_controller2.text}

Current Solutions:
${_controller3.text}

Unique Advantage:
${_controller4.text}

Customer Reach Strategy:
${_controller5.text}

Return the result structured like this:

# Brainstorming Summary

## Problem
Explain the problem clearly.

## Target Users
Describe who needs this solution.

## Current Solutions
Explain how people solve this problem today.

## Unique Advantage
Explain what makes this idea better or different.

## Customer Reach Strategy
Explain how the startup can reach its customers.

## Suggested Startup Ideas
- Idea suggestion
- Idea suggestion
- Idea suggestion

Keep everything clear, beginner friendly and short.
""";

    final content = [Content.text(combinedPrompt)];

    final response = await model.generateContent(content);

    if (kDebugMode) {
      print(response.text);
    }

    setState(() {
      _isLoading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PromptPage(prompt: response.text ?? ""),
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
      appBar: AppBar(
        title: const Text("Brain Storm"),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "images/bg1.jpg",
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.transparent),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTextField(
                      controller: _controller1,
                      label: "What problem do you want to solve?"),
                  _buildTextField(
                      controller: _controller2,
                      label: "Who needs this solution?"),
                  _buildTextField(
                      controller: _controller3,
                      label: "How do people currently solve this problem?"),
                  _buildTextField(
                      controller: _controller4,
                      label: "What makes your solution different/better?"),
                  _buildTextField(
                      controller: _controller5,
                      label: "How will you reach your target customers?"),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _onGenerateButtonPressed,
                    child: const Text("Generate Prompt"),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 15,
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white),
          ),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
