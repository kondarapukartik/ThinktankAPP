// ignore: file_names
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class BusinessPlanPage extends StatefulWidget {
  const BusinessPlanPage({super.key});

  @override
  State<BusinessPlanPage> createState() => _BusinessPlanPageState();
}

class _BusinessPlanPageState extends State<BusinessPlanPage>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();

  bool _isLoading = false;
  String _generatedText = "";

  Future<void> _generatePlan() async {
    try {
      final model = GenerativeModel(
        model: "gemini-2.5-flash",
        apiKey: "AIzaSyDFPEosgraV0yCVzkGRcMDOPPOa2YVOOKs",
      );

      final prompt = """
Startup Idea: ${_controller.text}

Create a beginner-friendly business roadmap.

Return the result in MARKDOWN format.

Structure:

## Step 1: Idea Validation
- point
- point

## Step 2: Market Research
- point
- point

## Step 3: Branding & Marketing
- point
- point

## Step 4: Product Launch
- point
- point

## Step 5: Customer Acquisition
- point
- point

## Step 6: Revenue Growth
- point
- point

Keep the points short and easy to understand.
""";

      final response = await model.generateContent([Content.text(prompt)]);

      if (kDebugMode) {
        print(response.text);
      }

      setState(() {
        _generatedText = response.text ?? "No response generated.";
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _generatedText = "Error: $e";
        _isLoading = false;
      });
    }
  }

  void _onGeneratePressed() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _generatedText = "";
    });

    _generatePlan();
  }

  Widget _buildResultCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: MarkdownBody(
        data: _generatedText,
        styleSheet: MarkdownStyleSheet(
          h2: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          p: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            height: 1.6,
          ),
          listBullet: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Business Plan"),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// Background Image
          Image.asset(
            "images/bg1.jpg",
            fit: BoxFit.cover,
          ),

          /// Blur Effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),

          /// Main Content
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                /// Startup Idea Input
                TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter your startup idea...",
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                  ),
                ),

                const SizedBox(height: 25),

                /// Generate Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _onGeneratePressed,
                  child: const Text(
                    "Generate Plan",
                    style: TextStyle(fontSize: 16),
                  ),
                ),

                const SizedBox(height: 30),

                /// Loading
                if (_isLoading) const CircularProgressIndicator(),

                /// Result
                if (!_isLoading && _generatedText.isNotEmpty)
                  _buildResultCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
