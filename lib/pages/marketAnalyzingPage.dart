// ignore: file_names
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class MarketAnalyzingPage extends StatefulWidget {
  const MarketAnalyzingPage({super.key});

  @override
  State<MarketAnalyzingPage> createState() => _MarketAnalyzingPageState();
}

class _MarketAnalyzingPageState extends State<MarketAnalyzingPage> {
  File? _image;
  bool _isLoading = false;
  String _generatedText = '';

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      _generatePrompt();
    }
  }

  Future<void> _generatePrompt() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final model = GenerativeModel(
        model: "gemini-2.5-flash",
        apiKey: "AIzaSyDFPEosgraV0yCVzkGRcMDOPPOa2YVOOKs",
      );

      final imageBytes = await _image!.readAsBytes();
      final imagePart = DataPart('image/jpeg', imageBytes);

      const prompt = '''
Analyze this business related image.

Return the explanation in MARKDOWN format.

Structure:

## What this image shows
Explain clearly what the image represents.

## Key Insight
If the image contains charts or numbers, explain the trend simply.

## Business Opportunity
Explain the opportunity in simple words.

Keep everything short and easy to understand for normal people.
''';

      final response = await model.generateContent([
        Content.multi([
          TextPart(prompt),
          imagePart,
        ])
      ]);

      if (kDebugMode) {
        print(response.text);
      }

      setState(() {
        _generatedText = response.text ?? "No analysis available.";
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      setState(() {
        _generatedText = "Failed to analyze the image.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // HEADER SAME AS YOUR PROJECT
      appBar: AppBar(
        title: const Text("Market Analyzing"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _image == null

            // BEFORE UPLOAD
            ? Center(
                child: ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.upload),
                  label: const Text("Upload Image"),
                ),
              )

            // AFTER UPLOAD
            : Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _image!,
                      height: 280,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 25),
                  if (_isLoading) const CircularProgressIndicator(),
                  if (!_isLoading && _generatedText.isNotEmpty)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Markdown(
                          data: _generatedText,
                          styleSheet: MarkdownStyleSheet(
                            p: const TextStyle(
                              fontSize: 16,
                              height: 1.5,
                            ),
                            h2: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),
      ),
    );
  }
}
