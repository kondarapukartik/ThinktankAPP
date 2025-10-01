import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class DailytargetPage extends StatefulWidget {
  const DailytargetPage({super.key});

  @override
  _DailytargetPageState createState() => _DailytargetPageState();
}

class _DailytargetPageState extends State<DailytargetPage> {
  final TextEditingController _ideaController = TextEditingController();
  final TextEditingController _problemController = TextEditingController();
  List<String> _dailyTargets = [];
  List<bool> _targetCompletion = [];
  bool _isLoading = false;

  // Call the Gemini API to generate daily targets
  Future<void> _generateDailyTargets() async {
    setState(() {
      _isLoading = true;
    });

    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey:
          'AIzaSyAOkOh4gSDYFNP4jM_n7x5yk2DNlvALLQE', // Replace with your Gemini API Key
    );

    final prompt = '''
      Based on the following business idea and problem, generate a list of daily targets for the next 7 days:
      - Business Idea: ${_ideaController.text}
      - Problem Solved: ${_problemController.text}
      
      Provide specific daily tasks that the user can do each day for a week to achieve success. Organize them by days (Day 1 to Day 7).
    ''';

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    setState(() {
      _isLoading = false;
    });

    if (response.text != null && response.text!.isNotEmpty) {
      setState(() {
        // Split the response text into a list by days (Day 1, Day 2, etc.)
        _dailyTargets = response.text!
            .split('\n')
            .where((line) => line.isNotEmpty)
            .toList();
        // Create a list of bools for checkbox states (initially all unchecked)
        _targetCompletion = List<bool>.filled(_dailyTargets.length, false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daily Targets")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your business idea to generate daily targets for the next 7 days:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _ideaController,
              decoration: const InputDecoration(
                labelText: 'Enter your Business Idea',
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateDailyTargets,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Generate Daily Targets'),
            ),
            const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator(),
            const SizedBox(height: 20),
            if (_dailyTargets.isNotEmpty) ...[
              const Text(
                'Your Daily Targets for the Week:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _dailyTargets.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text(_dailyTargets[index]),
                      value: _targetCompletion[index],
                      onChanged: (bool? value) {
                        setState(() {
                          _targetCompletion[index] = value!;
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
