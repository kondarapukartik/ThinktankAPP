// ignore: file_names
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class MarketAnalyzingPage extends StatefulWidget {
  const MarketAnalyzingPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MarketAnalyzingPageState createState() => _MarketAnalyzingPageState();
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

      // Trigger the prompt generation after selecting the image
      _generatePrompt();
    }
  }

  Future<void> _generatePrompt() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final model = GenerativeModel(
          model: 'gemini-1.5-flash', // Adjust model name if needed
          apiKey: 'AIzaSyAOkOh4gSDYFNP4jM_n7x5yk2DNlvALLQE');

      // Read image bytes
      final imageBytes = await _image!.readAsBytes();

      // Create a DataPart for the image
      final imagePart = DataPart('image/jpeg', imageBytes);

      // Create a prompt for the image analysis
      const predefinedPrompt = "Analyze the following market-related image:";
      const combinedPrompt = "$predefinedPrompt\n\n";

      // Send the prompt and image to the OpenAI API
      final response = await model.generateContent(
        [
          Content.multi([
            TextPart(combinedPrompt),
            imagePart, // Include the image data
          ]),
        ],
      );

      if (kDebugMode) {
        print(response.text);
      }

      setState(() {
        _generatedText = response.text!;
      });
    } catch (e) {
      setState(() {
        _generatedText = "Failed to analyze the image. Please try again.";
      });
      if (kDebugMode) {
        print("Error generating prompt: $e");
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Market Analyzing")),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            "images/bg.jpg", // Default background image
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255)
                  .withOpacity(0), // Adjust opacity as needed
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text("Upload Image"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _image != null
                      ? Container(
                          height: 250,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          _generatedText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
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
