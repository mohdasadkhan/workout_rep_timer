import 'package:app_lifecycle/text_preferences.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late final TextEditingController textController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final text = TextPreferences.getText();
    textController = TextEditingController(text: text);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      return;
    }
    final isBackground = state == AppLifecycleState.paused;
    if (isBackground) {
      TextPreferences.setText(textController.text);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detect Background & App Closed')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(child: TextField(controller: textController)),
      ),
    );
  }
}
