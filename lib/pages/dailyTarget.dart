import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class DailytargetPage extends StatefulWidget {
  const DailytargetPage({super.key});

  @override
  State<DailytargetPage> createState() => _DailytargetPageState();
}

class _DailytargetPageState extends State<DailytargetPage> {
  final TextEditingController _ideaController = TextEditingController();
  final TextEditingController _problemController = TextEditingController();

  List<String> _dailyTargets = [];
  List<bool> _targetCompletion = [];

  bool _isLoading = false;

  Future<void> _generateDailyTargets() async {
    setState(() {
      _isLoading = true;
    });

    final model = GenerativeModel(
      model: "gemini-2.5-flash",
      apiKey: "AIzaSyDFPEosgraV0yCVzkGRcMDOPPOa2YVOOKs",
    );

    final prompt = '''
You are a startup mentor.

Based on the business idea and problem below, create a simple 7-day customer acquisition plan.

Business Idea: ${_ideaController.text}
Problem Solved: ${_problemController.text}

Rules:
- Give exactly 7 days.
- Each day must contain only ONE short action.
- Focus on reaching real customers.
- Keep each task under 20 words.

Format strictly like this:

Day 1: Task
Day 2: Task
Day 3: Task
Day 4: Task
Day 5: Task
Day 6: Task
Day 7: Task
''';

    final response = await model.generateContent([Content.text(prompt)]);

    setState(() {
      _isLoading = false;
    });

    if (response.text != null) {
      final targets =
          response.text!.split("\n").where((e) => e.trim().isNotEmpty).toList();

      setState(() {
        _dailyTargets = targets;
        _targetCompletion = List<bool>.filled(targets.length, false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Target"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Daily Targets",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Generate a 7-day action plan for your business idea",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),
                _glassTextField(
                  controller: _ideaController,
                  hint: "Enter your Business Idea",
                ),
                const SizedBox(height: 20),
                _glassTextField(
                  controller: _problemController,
                  hint: "Problem your idea solves",
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _generateDailyTargets,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Generate Daily Targets",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                if (_dailyTargets.isNotEmpty)
                  const Text(
                    "Your Weekly Plan",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 10),
                if (_dailyTargets.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: _dailyTargets.length,
                      itemBuilder: (context, index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: _targetCompletion[index]
                                ? Colors.green.withOpacity(0.2)
                                : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ListTile(
                            leading: Checkbox(
                              value: _targetCompletion[index],
                              onChanged: (value) {
                                setState(() {
                                  _targetCompletion[index] = value!;
                                });
                              },
                              activeColor: Colors.greenAccent,
                            ),
                            title: Text(
                              _dailyTargets[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _glassTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white60),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
