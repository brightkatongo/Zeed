import 'package:flutter/material.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({
    Key? key,
    required this.isEnglish,
    required this.customColors,
  }) : super(key: key);
  final bool isEnglish;
  final Map<String, Color> customColors;

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEnglish ? 'AI Assistant' : 'Thandizo'),
      ),
      body: Center(
        child: Text(
          widget.isEnglish 
              ? 'Welcome to Zeed AI Assistant' 
              : 'Takulandirani ku Thandizo la Zeed',
          style: TextStyle(
            color: widget.customColors['primary'],
            fontSize: 20,
            
          ),
        ),
      ),
    );
  }
}