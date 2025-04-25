import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:rive/rive.dart';
import 'dart:async';
import 'package:thinktank/prompts/Prompt_1.dart';

class Startupaipage extends StatefulWidget {
  const Startupaipage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StartupaipageState createState() => _StartupaipageState();
}

class _StartupaipageState extends State<Startupaipage>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller_ = TextEditingController();
  bool _isLoading = false;
  late AnimationController _textAnimationController;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    _textAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _textAnimation = CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeIn,
    );

    _textAnimationController.forward();
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    super.dispose();
  }

  Future<void> _generatePrompt() async {
    final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: 'AIzaSyAOkOh4gSDYFNP4jM_n7x5yk2DNlvALLQE');

    final combinedPrompt = '''
Generate a concise and engaging startup introduction message using the following details:

Start with a centered line: "Welcome to Startup AI!"

Then, based on the inputs provided below (without including the questions themselves):

1. Startup Idea: ${_controller.text}
2. Problem it Solves: ${_controller_.text}

Summarize the startup idea and the core problem it aims to address. 

Then, guide the user on how they can kickstart their journey using design thinking principles — like empathizing with users, defining the problem, ideating solutions, prototyping, and testing.

Mention how our app can support them in each phase through dedicated sections:

- **Brainstorming**: For generating and organizing ideas.
- **Business Plan**: To structure and define their model.
- **Market Analyzing**: For validating demand and competition.
- **Daily Targets**: To set small goals and build momentum.

End the message by encouraging them to explore these sections and wishing them success. Close with a warm “Thank you for choosing Startup AI!”

Keep the message concise, supportive, and motivating.
''';
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
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Startup AI'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              FadeTransition(
                opacity: _textAnimation,
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, right: 16, left: 16),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255)
                        .withOpacity(0.9), // Slightly opaque background
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TypewriterText(
                        text: 'Hi there! I\'m your ThinkTank Manager.',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 97, 55, 168),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 250, // Adjusted height for better layout
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const RiveAnimation.asset(
                  'images/robo.riv',
                ),
              ),
              const SizedBox(height: 50),
              TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  labelText: 'Enter your Startup idea',
                  labelStyle: const TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 50),
              TextField(
                controller: _controller_,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  labelText: 'What problem does your Idea solve?',
                  labelStyle: const TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: ElevatedButton(
                  child: const Text('Solution'),
                  onPressed: _onGenerateButtonPressed,
                ),
              ),
              const SizedBox(height: 30),
              if (_isLoading) const CircularProgressIndicator(),
            ],
          ),
        ),
      );
}

class StateMachineMuscot extends StatefulWidget {
  const StateMachineMuscot({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StateMachineMuscotState createState() => _StateMachineMuscotState();
}

class _StateMachineMuscotState extends State<StateMachineMuscot> {
  Artboard? riveArtboard;
  SMIBool? isDance;
  SMITrigger? isLookUp;

  @override
  void initState() {
    super.initState();
    rootBundle.load('images/robo.riv').then(
      (data) async {
        try {
          final file = RiveFile.import(data);
          final artboard = file.mainArtboard;
          var controller =
              StateMachineController.fromArtboard(artboard, 'birb');
          if (controller != null) {
            artboard.addController(controller);
            isDance = controller.findSMI('dance');
            isLookUp = controller.findSMI('look up');
          }
          setState(() => riveArtboard = artboard);
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      },
    );
  }

  void toggleDance(bool newValue) {
    setState(() => isDance!.value = newValue);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Rive Animation'),
          centerTitle: true,
        ),
        body: riveArtboard == null
            ? const SizedBox()
            : Column(
                children: [
                  Expanded(
                    child: Rive(
                      artboard: riveArtboard!,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Dance'),
                      Switch(
                        value: isDance!.value,
                        onChanged: (value) => toggleDance(value),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    child: const Text('Look up'),
                    onPressed: () => isLookUp?.value = true,
                  ),
                  const SizedBox(height: 12),
                ],
              ),
      );
}

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 50),
  });

  @override
  // ignore: library_private_types_in_public_api
  _TypewriterTextState createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _displayedText = '';

  @override
  void initState() {
    super.initState();
    _startTypewriter();
  }

  Future<void> _startTypewriter() async {
    for (int i = 0; i < widget.text.length; i++) {
      await Future.delayed(widget.duration);
      setState(() {
        _displayedText = widget.text.substring(0, i + 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: widget.style,
    );
  }
}
